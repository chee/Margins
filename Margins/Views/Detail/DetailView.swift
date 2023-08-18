//
//  FileView.swift
//  Margins
//
//  Created by chee rabbits on 18/08/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DetailView: View {
    @EnvironmentObject var timekeeper: Timekeeper

    var body: some View {
        HSplitView {
            if let doc = timekeeper.document {
                if doc.isMedia {
                    MediaPlayerDetailView(url: doc.url)
                } else {
                    QuickLookDetailView(url: doc.url)
                        .background()
                }
            }

        }
    }
}
