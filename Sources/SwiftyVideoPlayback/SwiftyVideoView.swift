//
//  SwiftUIView 2.swift
//  
//
//  Created by Michael Redig on 9/9/20.
//

import SwiftUI
import AVKit

public struct SwiftyVideoView: View {
	let player: AVPlayer
	var aspectRatio: AVLayerVideoGravity

	public typealias Action = (AVPlayer) -> Void

	let singleTapAction: Action
	let doubleTapAction: Action

	public init(
		player: AVPlayer,
		aspectRatio: AVLayerVideoGravity = .resizeAspect,
		singleTapAction: @escaping Action = { _ in },
		doubleTapAction: @escaping Action = { _ in }) {

		self.player = player
		self.aspectRatio = aspectRatio
		self.singleTapAction = singleTapAction
		self.doubleTapAction = doubleTapAction
	}

    public var body: some View {
		VideoWrapper(player: player, gravity: aspectRatio)
			.onTapGesture(perform: {
				singleTapAction(player)
			})
			.onTapGesture(count: 2, perform: {
				doubleTapAction(player)
			})
	}
}

struct SwiftyVideoView_Previews: PreviewProvider {
    static var previews: some View {
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))
		SwiftyVideoView(player: player, singleTapAction: { player in
			player.timeControlStatus == .paused ? player.play() : player.pause()
		}, doubleTapAction: { player in
			print("double tapped")
		})
		.ignoresSafeArea()
    }
}
