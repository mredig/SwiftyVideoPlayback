//
//  SwiftUIView 2.swift
//  
//
//  Created by Michael Redig on 9/9/20.
//

import SwiftUI
import AVKit

public struct SwiftyVideoView: View {
	let controller: AVPlayerController
	let player: AVPlayer
	var aspectRatio: AVLayerVideoGravity

	public typealias Action = (AVPlayerController) -> Void

	let singleTapAction: Action
	let doubleTapAction: Action

	public init(
		controller: AVPlayerController,
		aspectRatio: AVLayerVideoGravity = .resizeAspect,
		singleTapAction: @escaping Action = { _ in },
		doubleTapAction: @escaping Action = { _ in }) {

		self.controller = controller
		self.player = controller.player
		self.aspectRatio = aspectRatio
		self.singleTapAction = singleTapAction
		self.doubleTapAction = doubleTapAction
	}

    public var body: some View {
		VideoWrapper(player: player, gravity: aspectRatio)
			.onTapGesture(count: 2, perform: {
				doubleTapAction(controller)
			})
			.onTapGesture(perform: {
				singleTapAction(controller)
			})
	}

	public func onSingleTapAction(_ perform: @escaping Action) -> SwiftyVideoView {
		let action = { (avPlayerController: AVPlayerController) in
			singleTapAction(avPlayerController)
			perform(avPlayerController)
		}
		return SwiftyVideoView(controller: controller, aspectRatio: aspectRatio, singleTapAction: action, doubleTapAction: doubleTapAction)
	}

	public func onDoubleTapAction(_ perform: @escaping Action) -> SwiftyVideoView {
		let action = { (avPlayerController: AVPlayerController) in
			doubleTapAction(avPlayerController)
			perform(avPlayerController)
		}
		return SwiftyVideoView(controller: controller, aspectRatio: aspectRatio, singleTapAction: singleTapAction, doubleTapAction: action)
	}
}

struct SwiftyVideoView_Previews: PreviewProvider {
    static var previews: some View {
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))
		let controller = AVPlayerController(player: player)
		SwiftyVideoView(controller: controller, singleTapAction: { player in
			player.isPlaying ? player.pause() : player.play()
		}, doubleTapAction: { player in
			print("double tapped")
		})
		.ignoresSafeArea()
		.onAppear(perform: {
			player.play()
		})
    }
}
