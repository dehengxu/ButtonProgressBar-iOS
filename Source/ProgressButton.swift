//
//  ProgressButton.swift
//  ButtonProgressBar-iOS
//
//  Created by NicholasXu on 2021/11/23.
//

import UIKit
//import SnapKit

fileprivate extension UIView {
	var width: CGFloat {
		get {
			return self.frame.size.width
		}
		set {
			self.frame.size.width = newValue
		}
	}

	var height: CGFloat {
		get {
			return self.frame.size.height
		}
		set {
			self.frame.size.height = newValue
		}
	}

	var x: CGFloat {
		get {
			return self.frame.origin.x
		}
		set {
			self.frame.origin.x = newValue
		}
	}

	var y: CGFloat {
		get {
			return self.frame.origin.y
		}
		set {
			self.frame.origin.y = newValue
		}
	}
}

private class ProgressView: UIView {

	var progress: CGFloat = 0.0 {
		didSet {
			self.progressMask.width = self.progress * self.width
		}
	}

	var progressColor: UIColor = .black {
		didSet {
			progressMask.backgroundColor = progressColor
		}
	}

	private var progressMask = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(progressMask)
		progressMask.width = 0
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		progressMask.x = 0
		progressMask.y = 0
		progressMask.height = self.height
		progressMask.width = self.width * progress
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

@objc(ProgressButton)
public class ProgressButton: UIButton {

    @objc dynamic private(set) public var progress: CGFloat = 0.0 {
        didSet {
			progressView.progress = progress
        }
    }

    private var progressView = ProgressView()
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.progressView.layer.cornerRadius = cornerRadius - 2.0
        }
    }

    public var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = masksToBounds
            self.progressView.layer.masksToBounds = masksToBounds
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.addSubview(progressView)
		progressView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	public override func layoutSubviews() {
		super.layoutSubviews()
		progressView.frame = CGRect(x: 2, y: 2, width: self.width - 4, height: self.height - 4)
	}

    public func resetProgress() {
        self.progress = 0.0
    }

    public func setProgress(progress: CGFloat, _ animated: Bool = false) {
        var _progress = progress
        if _progress < 0.0 {
            _progress = 0.0
        } else if _progress > 1.0 {
            _progress = 1.0
        }
        if _progress == self.progress {
            print("\(self.classForCoder) progress is not changed")
            return
        }

		if animated {
			UIView.animate(withDuration: 0.3) {
				self.progress = _progress
			}
		} else {
			self.progress = _progress
		}
    }

	public func setProgressColor(color: UIColor, negativeColor: UIColor = .clear) {
		self.backgroundColor = color
		self.progressView.progressColor = color
		self.progressView.backgroundColor = negativeColor
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
