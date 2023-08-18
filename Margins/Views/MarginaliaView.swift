//
//  RichTextEditorView.swift
//  Space
//
//  Created by chee on 2022-08-16.
//

import SwiftUI
import UniformTypeIdentifiers
import RichTextKit

// lol?
// https://stackoverflow.com/questions/57021722/swiftui-optional-textfield
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
	Binding(
		get: { lhs.wrappedValue ?? rhs },
		set: { lhs.wrappedValue = $0 }
	)
}

struct MarginaliaView: View {
    @EnvironmentObject var timekeeper: Timekeeper
    @StateObject
        var context = RichTextContext()
    @Environment(\.openDocument) private var openDocument

    
    func save() {
        timekeeper.document!.save(timekeeper.text)
	}
	
    var body: some View {
        RichTextEditor(text: $timekeeper.text, context: context, format: .rtf) {editor in
			editor.textContentInset = CGSize(width: 10, height: 20)
		}
		.onDisappear {
            save()
		}
		.background()
		.toolbar {
			ToolbarItemGroup(placement: .status) {
                if timekeeper.document!.isMedia {
					Button {
                        let seconds = timekeeper.playingMediaTime.seconds
                        let cursor = context.selectedRange.location
                        let href = "margins:\(timekeeper.document!.url.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)?time=\(seconds)"
                        let attr : [ NSAttributedString.Key : Any ] = [ .link : NSURL(string: href)! ]
                        let linkText = "\(String(format: "%.2f", seconds))s"
                        let link = NSMutableAttributedString(string: .newLine, attributes: .none)
                        link.append(NSAttributedString(string: linkText, attributes: attr))
                        link.append(NSAttributedString(string: .newLine, attributes: .none))
                        let newText = NSMutableAttributedString(attributedString: timekeeper.text.attributedString)
                        newText.insert(link, at: cursor)
                        context.shouldSetAttributedString = newText
                        context.isEditingText = true
                        let newCursor = cursor + newText.string.count                        
                        context.pasteText("", at: newCursor, moveCursorToPastedContent: true)
					} label: {
						Label("Insert media time", systemImage: "video.circle")
                    }.keyboardShortcut(";")
				}
				Button {
					context.toggle(.bold)
				} label: {
					Label("Bold", systemImage: "bold")
				}.keyboardShortcut("b")

				Button(action: {
					context.toggle(.italic)
				}) {
					Label("Italic", systemImage: "italic")
				}.keyboardShortcut("i")

				Button(action: {
					context.toggle(.underlined)
				}) {
					Label("Underline", systemImage: "underline")
				}.keyboardShortcut("u")

				Button(action: {context.incrementFontSize()}) {
					Label("Increase font size", systemImage: "textformat.size.larger")
				}.keyboardShortcut("=")

				Button(action: {context.decrementFontSize()}) {
					Label("Decrease font size", systemImage: "textformat.size.smaller")
				}.keyboardShortcut("-")
                Button(action: {
                    Task {
                        do {
                            try await openDocument(at: timekeeper.document!.marginalia.url)
                            save()
                        } catch {}
                    }
                }) {
					Label("Save", systemImage: "square.and.arrow.down.fill")
				}.keyboardShortcut("s")
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

//struct RichTextEditorView_Previews: PreviewProvider {
//	static var previews: some View {
//		RichTextEditorView(file: nil)
//	}
//}
