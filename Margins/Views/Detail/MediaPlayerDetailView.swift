//
//  MediaPlayerDetailView.swift
//  Space
//
//  Created by chee on 2022-08-25.
//

import SwiftUI
import AVKit

class MarginsMediaPlayer : AVPlayer, ObservableObject {
	var observer: Any? = nil
	
	func addMarginsTimeObserver(seconds: Double, for binding: Binding<CMTime>) {
		let interval = CMTime(
			seconds: seconds,
			preferredTimescale: CMTimeScale(NSEC_PER_SEC)
		)
		observer = addPeriodicTimeObserver(
			forInterval: interval,			
			queue: .main) {[weak self] time in
				guard let _ = self else { return }
				binding.wrappedValue = time
			}
	}
	
	func removeMarginsTimeObserver() {
		if let observer = observer {
//			fix this because it's probably a memory leak lol
			removeTimeObserver(observer)
		}
	}
}

struct MediaPlayerDetailView: View {
    @EnvironmentObject var timekeeper: Timekeeper
	@StateObject var player: MarginsMediaPlayer
    init(url: URL) {
        let p = MarginsMediaPlayer(url: url)
		self._player = StateObject(
			wrappedValue: p
		)
	}
	var body: some View {
		VideoPlayer(player: player)
			.onChange(of: timekeeper.setMediaTime) {_ in
				if let time = self.timekeeper.setMediaTime {
					self.player.seek(to: time)
					self.player.play()
				}
			}
			.onAppear {
				player.addMarginsTimeObserver(seconds: 0.5, for: $timekeeper.playingMediaTime)
			}
			.onDisappear {
				player.removeMarginsTimeObserver()
			}
	}
}

