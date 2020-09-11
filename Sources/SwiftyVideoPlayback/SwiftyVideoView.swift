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
	var gravity: AVLayerVideoGravity = .resizeAspect

	public typealias Action = (AVPlayerController) -> Void

	var singleTapActions: [Action] = []
	var doubleTapActions: [Action] = []
	var appearActions: [Action] = []
	var disappearActions: [Action] = []

	public init(controller: AVPlayerController) {

		self.controller = controller
		self.player = controller.player
	}

    public var body: some View {
		VideoWrapper(player: player, gravity: gravity)
			.onTapGesture(count: 2, perform: {
				doubleTapActions.forEach { $0(controller) }
			})
			.onTapGesture(perform: {
				singleTapActions.forEach { $0(controller) }
			})
			.onAppear(perform: {
				appearActions.forEach { $0(controller) }
			})
			.onDisappear(perform: {
				disappearActions.forEach { $0(controller) }
			})
	}

	public func onSingleTapAction(_ perform: @escaping Action) -> SwiftyVideoView {
		var newView = self
		newView.singleTapActions.append(perform)
		return newView
	}

	public func onDoubleTapAction(_ perform: @escaping Action) -> SwiftyVideoView {
		var newView = self
		newView.doubleTapActions.append(perform)
		return newView
	}

	public func layerGravity(_ gravity: AVLayerVideoGravity) -> SwiftyVideoView {
		var newValue = self
		newValue.gravity = gravity
		return newValue
	}

	public func onAppear(_ perform: @escaping Action) -> SwiftyVideoView {
		var newValue = self
		newValue.appearActions.append(perform)
		return newValue
	}

	public func onDisappear(_ perform: @escaping Action) -> SwiftyVideoView {
		var newValue = self
		newValue.disappearActions.append(perform)
		return newValue
	}
}

struct SwiftyVideoView_Previews: PreviewProvider {
    static var previews: some View {
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))
		let controller = AVPlayerController(player: player)
		SwiftyVideoView(controller: controller)
			.onSingleTapAction({ (controller) in
				controller.isPlaying ? controller.pause() : controller.play()
			})
		.ignoresSafeArea()
		.onAppear(perform: {
			player.play()
		})
    }
}
