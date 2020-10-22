import SwiftUI
import UIKit
import AVKit

struct VideoWrapper: UIViewRepresentable {
	let controller: AVPlayerController
	var gravity: AVLayerVideoGravity = .resizeAspect

	func makeUIView(context: Context) -> UIKVideoView {
		context.coordinator.videoView
	}

	func updateUIView(_ videoView: UIKVideoView, context: Context) {
		videoView.gravity = gravity
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(controller: controller, gravity: gravity)
	}

	class Coordinator {
		let videoView: UIKVideoView
		let controller: AVPlayerController
		var gravity: AVLayerVideoGravity {
			get { videoView.gravity }
			set { videoView.gravity = newValue }
		}

		init(controller: AVPlayerController, gravity: AVLayerVideoGravity) {
			self.controller = controller
			self.videoView = UIKVideoView(player: controller.player, gravity: gravity)
		}
	}
}

struct VideoPlayback_Previews: PreviewProvider {
	static var previews: some View {
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))

		let controller = AVPlayerController(player: player)
		Group {
			VideoWrapper(controller: controller, gravity: .resizeAspectFill)
				.ignoresSafeArea()
				.onAppear(perform: {
					controller.play()
					print("fart")
			})

			VideoWrapper(controller: controller)
				.previewDevice("iPad (7th generation)")
				.ignoresSafeArea()
				.onAppear(perform: {
					controller.play()
					print("fart")
				})
		}
	}
}


