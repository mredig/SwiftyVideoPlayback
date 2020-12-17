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

	let controlLayer = UIView()
	let playPauseButton = IconButton(icon: .playPauseFill)

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

		commonInit()
	}

	deinit {
		observers.forEach { $0.invalidate() }
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func commonInit() {
		setupControlLayer()

	}

	private func setupControlLayer() {
		addSubview(controlLayer)
		controlLayer.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			controlLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
			controlLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
			controlLayer.topAnchor.constraint(equalTo: topAnchor),
			controlLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
		])

		controlLayer.addSubview(playPauseButton)
		playPauseButton.translatesAutoresizingMaskIntoConstraints = false

		let multiplier: CGFloat = 0.33

		let idealHeight = playPauseButton.heightAnchor.constraint(equalTo: controlLayer.heightAnchor, multiplier: multiplier)
		idealHeight.priority = .defaultHigh
		let idealWidth = playPauseButton.widthAnchor.constraint(equalTo: controlLayer.widthAnchor, multiplier: multiplier)
		idealWidth.priority = .defaultHigh

		NSLayoutConstraint.activate([
			playPauseButton.centerYAnchor.constraint(equalTo: controlLayer.centerYAnchor),
			playPauseButton.centerXAnchor.constraint(equalTo: controlLayer.centerXAnchor),
			playPauseButton.widthAnchor.constraint(equalTo: playPauseButton.heightAnchor),
			playPauseButton.widthAnchor.constraint(lessThanOrEqualTo: controlLayer.widthAnchor, multiplier: multiplier),
			playPauseButton.heightAnchor.constraint(lessThanOrEqualTo: controlLayer.heightAnchor, multiplier: multiplier),
			idealHeight,
			idealWidth
		])

		playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		let rect = bounds
		playerLayer.frame = rect
	}

	private func attachLayer() {
		guard playerLayer.superlayer == nil else { return }
		layer.addSublayer(playerLayer)
		bringSubviewToFront(controlLayer)
	}

	@objc private func playPauseButtonPressed(_ sender: IconButton) {
		playerController.isPlaying ? playerController.pause() : playerController.play()
	}

	private func hideControls() {
		UIView.animate(withDuration: 0.5, animations: {
			self.controlLayer.alpha = 0
		}, completion: { success in
			guard success else { return }
			self.controlLayer.isHidden = true
		})
	}
}
