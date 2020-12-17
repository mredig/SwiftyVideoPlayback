import UIKit
import AVKit

public class SwiftyUIKVideoView: UIView {
	public let playerController: AVPlayerController
	public var gravity: AVLayerVideoGravity {
		get {
			playerLayer.videoGravity
		}
		set {
			playerLayer.videoGravity = newValue
		}
	}

	private let playerLayer: AVPlayerLayer

	var observers: Set<NSKeyValueObservation> = []

	public init(playerController: AVPlayerController, gravity: AVLayerVideoGravity = .resizeAspect) {
		self.playerController = playerController
		self.playerLayer = AVPlayerLayer(player: playerController.player)
		super.init(frame: .zero)
		self.gravity = gravity

		let readyOb = playerLayer.observe(\.isReadyForDisplay) { [weak self] (player, change) in
			guard player.isReadyForDisplay else { return }
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

	public override func layoutSubviews() {
		super.layoutSubviews()
		let rect = bounds
		playerLayer.frame = rect
	}

	private func attachLayer() {
		guard playerLayer.superlayer == nil else { return }
		layer.addSublayer(playerLayer)
	}
}
