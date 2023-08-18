//
//  Timekeeper.swift
//  Margins
//
//  Created by chee rabbits on 18/08/2023.
//

import Foundation
import AVKit


final class Timekeeper: ObservableObject {
    @Published var setMediaTime: CMTime? = nil
    @Published var playingMediaTime: CMTime = CMTime()
    @Published var document: MarginsDocument?
    @Published var text = NSAttributedString.empty
    
    func setTargetURL(_ url: URL) {
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if var comps = comps {
            let query = comps.queryItems ?? []
            comps.query = ""
            comps.scheme = "file"
            let u = comps.url!.resolvingSymlinksInPath()
            var time: CMTime? = nil
            for q in query {
                if q.name == "time" {
                    if let value = q.value {
                        let seconds = Double(value)
                        if let seconds = seconds {
                            time = CMTime(
                                seconds: seconds,
                                preferredTimescale: .max
                            )
                        }
                    }
                }
            }
            setMediaTime = nil
            document = MarginsDocument(url: u)
            text = document!.marginalia.exists
                ? document!.marginalia.getAttributedString()
                : NSAttributedString.empty
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.setMediaTime = time
                }
            }
        }
    }
}

