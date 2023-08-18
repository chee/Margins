//
//  MarginsApp.swift
//  Margins
//
//  Created by chee rabbits on 18/08/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import OSLog

let ws = NSWorkspace.shared
let fm = FileManager.default
let fnt = NSFontManager.shared
let app = NSApplication.shared
let console = Logger()


@main
struct MarginsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .commands {
            ToolbarCommands()
            TextEditingCommands()
            TextFormattingCommands()
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        
        Settings {
            Form {
                Section("lol") {
                    Text("lol")
                }
            }
            .padding()
        }
    }
}
