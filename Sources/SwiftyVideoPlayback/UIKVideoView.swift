//
//  UIKVideoView.swift
//  UIKit Video
//
//  Created by Michael Redig on 9/9/20.
//

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

	init(player: AVPlayer, gravity: AVLayerVideoGravity = .resizeAspect) {
		self.player = player
		self.playerLayer = AVPlayerLayer(player: player)
		super.init(frame: .zero)
		self.gravity = gravity

		layer.addSublayer(playerLayer)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = bounds
	}
}
