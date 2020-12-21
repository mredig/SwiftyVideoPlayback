import SwiftUI
import UIKit
import AVKit

struct VideoWrapper: UIViewRepresentable {
	let controller: AVPlayerController
	var gravity: AVLayerVideoGravity = .resizeAspect

	func makeUIView(context: Context) -> SwiftyUIKVideoView {
		context.coordinator.videoView
	}

	func updateUIView(_ videoView: SwiftyUIKVideoView, context: Context) {
		videoView.gravity = gravity
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(controller: controller, gravity: gravity)
	}

	class Coordinator {
		let videoView: SwiftyUIKVideoView
		let controller: AVPlayerController
		var gravity: AVLayerVideoGravity {
			get { videoView.gravity }
			set { videoView.gravity = newValue }
		}

		init(controller: AVPlayerController, gravity: AVLayerVideoGravity) {
			self.controller = controller
			self.videoView = SwiftyUIKVideoView(player: controller.player, gravity: gravity)
		}
	}
}

struct VideoPlayback_Previews: PreviewProvider {
	static var previews: some View {
		let player = AVPlayer(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!)

		let controller = AVPlayerController(player: player)
		Group {
			VideoWrapper(controller: controller, gravity: .resizeAspectFill)
				.ignoresSafeArea()
				.onAppear(perform: {
					controller.play()
			})

			VideoWrapper(controller: controller)
				.previewDevice("iPad (7th generation)")
				.ignoresSafeArea()
				.onAppear(perform: {
					controller.play()
				})
		}
	}
}


