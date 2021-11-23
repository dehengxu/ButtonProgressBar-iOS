//
//  ProgressButton.swift
//  ButtonProgressBar-iOS
//
//  Created by NicholasXu on 2021/11/23.
//

import UIKit
import SnapKit

public class ProgressButton: UIButton {

    private(set) public var progress: CGFloat = 0.0 {
        didSet {
            if progress > 1.0 {
                self.progressLayer.strokeEnd = 0.5
                print("A did set progress: \(progress), \(self.progressLayer.strokeEnd)")
                return
            } else if progress < 0.0 {
                self.progressLayer.strokeEnd = 0.0
                print("B did set progress: \(progress), \(self.progressLayer.strokeEnd)")
                return
            }
            self.progressLayer.strokeEnd = progress / 2
            print("did set progress: \(progress), \(self.progressLayer.strokeEnd)")
        }
    }

    private(set) public var progressColor: UIColor = .black {
        didSet {
            self.progressLayer.strokeColor = progressColor.cgColor
            self.backgroundColor = progressColor
        }
    }

    public var progressNegativeColor: UIColor = .black {
        didSet {
            self.progressView.backgroundColor = progressNegativeColor
        }
    }

    public var progressLayer: CAShapeLayer!
    public var progressView: UIView = UIView()
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.progressView.layer.cornerRadius = cornerRadius
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

        let pathHeight = frame.height
        let pathRect = CGRect(x: 0, y: 0, width: frame.width - 4, height: pathHeight)
        let bezierPath = UIBezierPath(rect: pathRect)

        self.progressLayer = CAShapeLayer()
        progressLayer.path = bezierPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.frame = CGRect(origin: .zero, size: pathRect.size)
        progressLayer.strokeEnd = 0
        progressLayer.lineWidth = pathHeight * 2
        self.progressView.layer.addSublayer(progressLayer)

        progressView.backgroundColor = .white
        self.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(2)
            $0.width.height.equalToSuperview().offset(-4)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    public override func layoutSubviews() {
        super.layoutSubviews()
        let pathHeight = progressView.frame.height
        let pathWidth = progressView.frame.width
        let pathRect = CGRect(x: 0, y: 0, width: self.progressView.frame.width, height: pathHeight)
        let bezierPath = UIBezierPath(rect: pathRect)
        self.progressLayer.path = bezierPath.cgPath
        self.progressLayer.frame = pathRect // CGRect(origin: .zero, size: pathRect.size)
        print("layout subviews: \(self.progressView.frame), \(self.progressLayer.frame), pathRect: \(pathRect)")
    }
    public func resetProgress() {
        self.progress = 0.0
    }

    public func setProgress(progress: CGFloat, _ animated: Bool = false) {
        self.progress = progress
    }

    public func setProgressColor(color: UIColor) {
        //self.progressLayer.backgroundColor = color.cgColor
        self.progressColor = color
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
