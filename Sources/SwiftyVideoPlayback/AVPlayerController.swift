import AVFoundation

public class AVPlayerController {
	public var isPlaying: Bool {
		player.isPlaying
	}

	private let session = AVAudioSession.sharedInstance()

	public let player: AVPlayer

	public var shouldLoop = false

	public var currentSeconds: TimeInterval {
		player.currentTime().seconds
	}

	public var currentTime: CMTime {
		player.currentTime()
	}

	public var currentPosition: Double {
		player.currentTime().seconds / (player.currentItem?.duration.seconds ?? 1)
	}

	private var loopMinder: NSObjectProtocol?

	private var updateCallbacks: [(AVPlayerController) -> Void] = []

	public var canHideControlsWhilePaused = true

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
							self.executeUpdateCallbacks()
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


	private func config(category: AVAudioSession.Category) {
		   do {
			   try session.setCategory(category, mode: .moviePlayback, options: [])
		   } catch {
			   print("Error configuring av audio session: \(error) (\(error.localizedDescription))")
		   }
	   }

	public func play(withCategory category: AVAudioSession.Category? = nil) {
		if let category = category {
			config(category: category)
		}

		player.play()
		executeUpdateCallbacks()
	}

	public func pause() {
		player.pause()
		executeUpdateCallbacks()
	}

	public func stop() {
		player.pause()
		player.seek(to: .zero)
		executeUpdateCallbacks()
	}

	/// Skips forward or backward (negative values) relative from the current position in the video.
	public func skip(relativeSeconds time: TimeInterval) {
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
		executeUpdateCallbacks()
	}

	/// Skip to relative position in video - 0 is the beginning, 1 is the very end.
	public func skip(toPosition position: Double) {
		var position = position
		if position < 0 {
			position = 0
		} else if position > 1 {
			position = 1
		}

		let cmDuration = player.currentItem?.duration ?? .zero
		let duration = cmDuration.seconds

		player.seek(to: .init(seconds: duration * position, preferredTimescale: 600))
		executeUpdateCallbacks()
	}

	/// Skip to the nearest absolute CMTime resolution in the video
	public func skip(toTime time: CMTime) {
		player.seek(to: time)
		executeUpdateCallbacks()
	}

	/// Converts `time` to CMTime and skips to the requested absolute time in the video.
	public func skip(toTime time: TimeInterval) {
		skip(toTime: .init(seconds: time, preferredTimescale: 600))
	}

	public func addUpdateCallback(_ perform: @escaping (AVPlayerController) -> Void) {
		updateCallbacks.append(perform)
	}

	private func executeUpdateCallbacks() {
		updateCallbacks.forEach { $0(self) }
	}
}

extension AVPlayerController: SwiftyUIKVideoViewDelegate {
	public func videoViewPressedPlayPauseButton(_ videoView: SwiftyUIKVideoView) {
		isPlaying ? pause() : play(withCategory: .playback)
		videoView.hideControls()
	}

	public func videoViewShouldHideControls(_ videoView: SwiftyUIKVideoView) -> Bool {
		isPlaying || canHideControlsWhilePaused
	}
}
