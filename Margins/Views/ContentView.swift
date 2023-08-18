//
//  ContentView.swift
//  Margins
//
//  Created by chee rabbits on 18/08/2023.
//

import SwiftUI
import RichTextKit

struct ContentView: View {
    @ObservedObject var timekeeper = Timekeeper()
    @Environment(\.openDocument) private var openDocument
    @State var showFileChooser = false

    var body: some View {
        
        NavigationView {
            if let document = timekeeper.document {
                DetailView()
                    .environmentObject(timekeeper)
                MarginaliaView()
                    .environmentObject(timekeeper)
            } else {
                Button("Open a file") {
                    Task {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        if panel.runModal() == .OK {
                            self.timekeeper.setTargetURL(panel.url!)
                        }
                    }
                }
            }
        }
        .handlesExternalEvents(preferring: Set(arrayLiteral: "*"), allowing: Set(arrayLiteral: "*"))
        .onOpenURL {url in
                timekeeper.setTargetURL(url)
            }
    
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
