import SwiftUI
import AVKit

public struct SwiftyVideoView: View {

	public let controller: AVPlayerController
	public var gravity: AVLayerVideoGravity

	public init(controller: AVPlayerController, gravity: AVLayerVideoGravity = .resizeAspect) {
		self.controller = controller
		self.gravity = gravity
	}

	public var body: some View {
		VideoWrapper(controller: controller, gravity: gravity)
	}

	public func layerGravity(_ gravity: AVLayerVideoGravity) -> SwiftyVideoView {
		var newValue = self
		newValue.gravity = gravity
		return newValue
	}
}

struct SwiftyVideoView_Previews: PreviewProvider {
    static var previews: some View {
		let player = AVPlayer(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!)
		let controller = AVPlayerController(player: player)
		SwiftyVideoView(controller: controller)
			.layerGravity(.resizeAspectFill)
			.ignoresSafeArea()
			.onAppear(perform: {
				controller.play()
			})
	}
}
