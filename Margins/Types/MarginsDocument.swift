//
//  MarginsFile.swift
//  Margins
//
//  Created by chee rabbits on 18/08/2023.
//

import Foundation
import AppKit
import UniformTypeIdentifiers
import RichTextKit

struct MarginsDocument: Identifiable, Hashable, Equatable, Comparable {
    static func == (lhs: MarginsDocument, rhs: MarginsDocument) -> Bool {
        lhs.url.resolvingSymlinksInPath() == rhs.url.resolvingSymlinksInPath()
    }
    
    static func < (lhs: MarginsDocument, rhs: MarginsDocument) -> Bool {
        return lhs.name.localizedCompare(rhs.name) == .orderedAscending
    }
    
    var id: Self {self}
    
    static let richTypes: [UTType] = [.rtf]
    static let htmlTypes: [UTType] = [.html]
    static let plainTypes: [UTType] = [.plainText, .text]
    static let textTypes: [UTType] = plainTypes + htmlTypes + richTypes
    static let videoTypes: [UTType] = [.movie, .audiovisualContent, .video]
    static let audioTypes: [UTType] = [.audio]
    static let mediaTypes: [UTType] = videoTypes + audioTypes
    
    var url: URL
    var isFolder: Bool { self.type == UTType.folder }
    var icon: NSImage
    var type: UTType
    var name: String
    var accessedOn: Date? = nil
    var createdOn: Date? = nil
    var modifiedOn: Date? = nil
    
    init(url: URL, type: UTType? = nil) {
        self.url = url
        self.type = type
        ?? UTType(filenameExtension: url.pathExtension)
        ?? UTType.content
        self.name = url.lastPathComponent
        self.icon = ws.icon(forFile: url.path)
        do {
            let data = try url.resourceValues(forKeys: [
                .contentAccessDateKey,
                .creationDateKey,
                .contentModificationDateKey,
            ])
            self.accessedOn = data.contentAccessDate
            self.createdOn = data.creationDate
            self.modifiedOn = data.contentModificationDate
        } catch {
            // ok
        }
    }

    init(_ path: String) {
        self.init(
            url: URL(fileURLWithPath: path)
                .resolvingSymlinksInPath()
        )
    }

    func conforms(to types: [UTType]) -> Bool {
        for foreign in types {
            if type.conforms(to: foreign) {
                return true
            }
        }
        return false
    }
    
    var attributedString = NSAttributedString(string: "")
    
    func getAttributedString() -> NSAttributedString {
        do {
            if (conforms(to: Self.richTypes)) {
                if let contents = getContents() {
                    return NSAttributedString(rtf: contents, documentAttributes: .none)!
                }
            } else if (conforms(to: Self.htmlTypes)) {
                if let contents = getContents() {
                    // TODO fancier html
                    return NSAttributedString(html: contents, documentAttributes: .none)!
                }
            } else if (conforms(to: Self.plainTypes)) {
                if let contents = getContents() {
                    return try NSAttributedString(data: contents, format: .plainText)
                }
            }
        } catch {
        }
        return NSAttributedString(string: "")
    }
    
    func getContents() -> Data? {
        fm.contents(atPath: url.path)
    }

    private var marginaliaURL: URL {
        url.appendingPathExtension("margin")
    }
    
    var exists: Bool {
        fm.fileExists(atPath: url.path)
    }
    
    private var marginaliaExists: Bool {
        fm.fileExists(atPath: marginaliaURL.path)
    }
    
    var marginalia: MarginsDocument {
        MarginsDocument(url: marginaliaURL, type: UTType.rtf)
    }
    
    var isMedia: Bool {
        self.conforms(to: Self.mediaTypes)
    }
    
    func save(_ attributedString: NSAttributedString) {
        do {
            let rtf = try attributedString.richTextData(for: .rtf)
            console.log("\(marginalia.url)")
            try rtf.write(to: marginalia.url)
        } catch {
            print("failed to write file :o")
        }
    }
}

