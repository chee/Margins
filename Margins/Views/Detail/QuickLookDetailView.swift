//
//  Space
//
//  Created by chee on 2022-08-16.
//

import Foundation
import SwiftUI
import AppKit
import Quartz
import QuickLookUI

struct QuickLookDetailView: NSViewRepresentable {
	var url: URL
	
	func makeNSView(context: NSViewRepresentableContext<QuickLookDetailView>) -> QLPreviewView {
		let preview = QLPreviewView(frame: .zero, style: .normal)
		preview?.autostarts = false
		preview?.previewItem = url as QLPreviewItem
		preview?.shouldCloseWithWindow = false
		
		return preview ?? QLPreviewView()
	}
	
	func updateNSView(
		_ qlview: QLPreviewView,
		context: NSViewRepresentableContext<QuickLookDetailView>
	) {
		qlview.previewItem = url as QLPreviewItem
	}
	
	typealias NSViewType = QLPreviewView
}
