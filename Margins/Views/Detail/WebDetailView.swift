//
//  WebView.swift
//  Space
//
//  Created by chee on 2022-08-16.
//

import Foundation
import WebKit
import AppKit
import SwiftUI

struct WebDetailView: NSViewRepresentable {
	let data: Data
	let contentType: String
	
	func makeNSView(context: Context) -> WKWebView {
		let webView = WKWebView(frame: .zero, configuration: .init())
		webView.load(
			data,
			mimeType: contentType,
			characterEncodingName: "UTF8",
			baseURL: FileManager.default.temporaryDirectory
		)
		return webView
	}
	
	func updateNSView(_ nsView: WKWebView, context: Context) {
		// Do nothing
	}
}
