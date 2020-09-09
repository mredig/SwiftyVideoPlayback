import AVFoundation

extension AVPlayer {
	var isPlaying: Bool {
		rate != 0 && error == nil
	}
}
