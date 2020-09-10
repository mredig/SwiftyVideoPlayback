import AVFoundation

extension AVPlayer {
	public var isPlaying: Bool {
		rate != 0 && error == nil
	}
}
