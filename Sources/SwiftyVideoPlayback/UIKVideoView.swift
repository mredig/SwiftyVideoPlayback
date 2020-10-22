import UIKit
import AVKit

class UIKVideoView: UIView {
	var player: AVPlayer
	var gravity: AVLayerVideoGravity {
		get {
			playerLayer.videoGravity
		}
		set {
			playerLayer.videoGravity = newValue
		}
	}

	private let playerLayer: AVPlayerLayer

	var observers: Set<NSKeyValueObservation> = []

	init(player: AVPlayer, gravity: AVLayerVideoGravity = .resizeAspect) {
		self.player = player
		self.playerLayer = AVPlayerLayer(player: player)
		super.init(frame: .zero)
		self.gravity = gravity

		let readyOb = playerLayer.observe(\.isReadyForDisplay) { [weak self] (player, change) in
			self?.attachLayer()
		}
		observers.insert(readyOb)
	}

	deinit {
		observers.forEach { $0.invalidate() }
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let rect = bounds
		playerLayer.frame = rect
	}

	private func attachLayer() {
		guard playerLayer.superlayer == nil else { return }
		layer.addSublayer(playerLayer)
	}
}
