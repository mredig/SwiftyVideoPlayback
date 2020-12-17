import UIKit

class IconButton: UIButton {

	enum Symbol: String {
		case play = "play"
		case playFill = "play.fill"
		case playSlash = "play.slash"
		case playSlashFill = "play.slash.fill"
		case playPause = "playpause"
		case playPauseFill = "playpause.fill"
		case pause = "pause"
		case pauseFill = "pause.fill"
		case backward = "backward"
		case backwardFill = "backward.fill"
		case forward = "forward"
		case forwardFill = "forward.fill"
	}

	var icon: Symbol {
		didSet {
			updateImages()
		}
	}

	private var observer: NSKeyValueObservation?

	init(icon: Symbol) {
		self.icon = icon
		super.init(frame: .zero)
		updateImages()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func updateImages() {
		let image = UIImage(systemName: icon.rawValue)
		setImage(image, for: .normal)
		contentHorizontalAlignment = .fill
		contentVerticalAlignment = .fill

		imageView?.contentMode = .scaleAspectFit
		tintColor = .secondarySystemBackground
	}
}
