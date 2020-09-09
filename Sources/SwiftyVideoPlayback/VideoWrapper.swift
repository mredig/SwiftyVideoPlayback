import SwiftUI
import UIKit
import AVKit

struct VideoWrapper: UIViewRepresentable {

	let player: AVPlayer
	var gravity: AVLayerVideoGravity = .resizeAspect

	func makeUIView(context: Context) -> UIKVideoView {
		let videoView = UIKVideoView(player: player, gravity: gravity)
		return videoView
	}

	func updateUIView(_ videoView: UIKVideoView, context: Context) {
		videoView.gravity = gravity
	}
}

struct VideoPlayback_Previews: PreviewProvider {
	static var previews: some View {
		let player = AVPlayer(url: URL(fileURLWithPath: "/Users/mredig/Downloads/VID_20200603_103616.mp4"))
		Group {
			VideoWrapper(player: player, gravity: .resizeAspectFill)
				.ignoresSafeArea()
				.onAppear(perform: {
					player.play()
					print("fart")
			})

			VideoWrapper(player: player, gravity: .resizeAspect)
				.previewDevice("iPad (7th generation)")
				.ignoresSafeArea()
				.onAppear(perform: {
					player.play()
					print("fart")
				})
		}
	}
}


