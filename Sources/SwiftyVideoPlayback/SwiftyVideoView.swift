import SwiftUI
import AVKit

public struct SwiftyVideoView: View {

	public let controller: AVPlayerController
	public var gravity: AVLayerVideoGravity = .resizeAspect

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
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))
		let controller = AVPlayerController(player: player)
		SwiftyVideoView(controller: controller)
			.layerGravity(.resizeAspect)
			.ignoresSafeArea()
			.onAppear(perform: {
				controller.play()
			})
	}
}
