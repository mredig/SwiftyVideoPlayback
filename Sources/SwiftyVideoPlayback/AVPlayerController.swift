import AVFoundation

public class AVPlayerController {
	public var isPlaying: Bool {
		player.isPlaying
	}


	public let player: AVPlayer

	public var shouldLoop = false

	private var loopMinder: NSObjectProtocol?

	public init(player: AVPlayer, withAudio: Bool = true) {
		self.player = player

		if !withAudio {
			player.volume = 0
		}

		loopMinder = NotificationCenter
			.default
			.addObserver(
				forName: .AVPlayerItemDidPlayToEndTime,
				object: nil,
				queue: nil,
				using: { [weak self] notification in
					guard let self = self else { return }
					if let notifyingPlayerItem = notification.object as? AVPlayerItem {
						if notifyingPlayerItem == self.player.currentItem {
							self.player.seek(to: .zero)
							if self.shouldLoop {
								self.play()
							}
						}
					}
				})
	}

	deinit {
		NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
		loopMinder = nil
		stop()
	}

	public func play() {
		player.play()
//		scheduleRepeat()
	}

	public func pause() {
		player.pause()
	}

	public func stop() {
		player.pause()
		player.seek(to: .zero)
	}

	/// positive for forward, negative for backward
	public func skip(time: TimeInterval) {
		let currentTime = player.currentTime().seconds
		let newTime = currentTime + time

		let cmDuration = player.currentItem?.duration ?? .zero
		let duration = cmDuration.seconds

		if newTime <= 0 {
			player.seek(to: .zero)
		} else if newTime >= duration {
			player.seek(to: cmDuration)
		} else {
			player.seek(to: .init(seconds: newTime, preferredTimescale: 600))
		}
	}


//	private func scheduleRepeat() {
//		let currentTime = player.currentTime()
//		let duration = player.currentItem?.duration ?? .zero
//
//		let remaining = duration - currentTime
//
//		let slop = 0.05
//
//		if remaining.seconds > slop {
//			DispatchQueue.main.asyncAfter(deadline: .now() + remaining.seconds - slop) { [weak self] in
//				self?.scheduleRepeat()
//			}
//		} else {
//			let timer = Timer.scheduledTimer(withTimeInterval: remaining.seconds, repeats: false) { [weak self] timer in
//				guard self?.shouldLoop == true else { return }
//				self?.player.seek(to: .zero, completionHandler: { success in
//					self?.play()
//				})
//			}
//		}
//	}
}
