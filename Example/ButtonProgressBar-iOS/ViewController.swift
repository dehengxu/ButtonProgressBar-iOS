//
//  ViewController.swift
//  ButtonProgressBar-iOS
//
//  Created by Pushkar Sharma on 08/04/2017.
//  Copyright © 2017 thePsguy. All rights reserved.
//

import UIKit
import ButtonProgressBar_iOS

class ViewController: UIViewController {
    
    var progressButton: ButtonProgressBar!
    var completionButton: UIButton!
    var typeSelector: UITextField!
    
    var picker: UIPickerView!
    
    var timePeriod: UITextField!
    var timePadding: UITextField!

	var downloadButton: ButtonProgressBar!
    var downloadBtn: ProgressButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progressButton = ButtonProgressBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.45, height: 44))
        progressButton.center = self.view.center
        
        progressButton.addTarget(nil, action: #selector(self.tapped), for: .touchUpInside)
        progressButton.setTitle("Download", for: .normal)
        progressButton.setCompletionImage(image: UIImage(named: "checkmark")!)
        
        completionButton = UIButton(frame: CGRect(x: 0, y: 180, width: self.view.frame.width, height: 44))
        
        completionButton.addTarget(nil, action: #selector(self.progressComplete), for: .touchUpInside)
        completionButton.setTitle("Trigger Completion", for: .normal)
        completionButton.setTitleColor(.blue, for: .normal)
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        
        typeSelector = UITextField(frame: CGRect(x: 24, y: 54, width: self.view.frame.width - 48, height: 27))
        typeSelector.textAlignment = .center
        typeSelector.inputView = picker
        typeSelector.text = "Indeterminate"
        typeSelector.borderStyle = .roundedRect
        
        timePeriod = UITextField(frame: CGRect(x: self.view.frame.width / 2 - 36, y: 120, width: 72, height: 18))
        timePeriod.textAlignment = .center
        timePeriod.keyboardType = .numberPad
        timePeriod.borderStyle = .roundedRect
        timePeriod.attributedPlaceholder = NSAttributedString(string: "Time Period", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 9)])
        
        timePadding = UITextField(frame: CGRect(x: self.view.frame.width / 2 - 36, y: 145, width: 72, height: 18))
        timePadding.textAlignment = .center
        timePadding.keyboardType = .numberPad
        timePadding.borderStyle = .roundedRect
        timePadding.attributedPlaceholder = NSAttributedString(string: "Padding Time", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8)])

		downloadButton = ButtonProgressBar(frame: CGRect(x: 0, y: 130, width: self.view.frame.width*0.45, height: 44))
		downloadButton.addTarget(self, action: #selector(tapOnTest), for: .touchUpInside)
        downloadButton.layer.cornerRadius = 22
        downloadButton.layer.masksToBounds = true
		downloadButton.center.x = self.view.center.x
		downloadButton.center.y = self.view.center.y + 100
		downloadButton.setTitle("Test", for: .normal)
        downloadButton.setProgressColor(color: .red)
        downloadButton.setProgress(progress: 0.5, false)

		self.view.addSubview(downloadButton)

        self.view.addSubview(completionButton)
        self.view.addSubview(timePadding)
        self.view.addSubview(timePeriod)
        self.view.addSubview(typeSelector)
        self.view.addSubview(progressButton)

        self.downloadBtn = ProgressButton(frame: CGRect(x: 0, y: 160, width: self.view.frame.width*0.45, height: 44))
        self.view.addSubview(downloadBtn)
        downloadBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(downloadButton.snp.bottom).offset(10)
            $0.size.equalTo(downloadButton)
        }
        downloadBtn.masksToBounds = true
        downloadBtn.cornerRadius = 22
        downloadBtn.progressNegativeColor = .black
        downloadBtn.setProgressColor(color: .red)
        downloadBtn.setTitle("Download", for: .normal)
        downloadBtn.setTitleColor(.white, for: .normal)
        downloadBtn.addTarget(self, action: #selector(tapOnTest), for: .touchUpInside)
        let prog = 0.0
        downloadBtn.setProgress(progress: prog, false)
        downloadButton.setProgress(progress: prog, false)


    }
    
    @objc func progressComplete(sender: AnyObject?) {
        progressButton.triggerCompletion()
    }

	@objc func tapOnTest() {
		//		downloadButton.setProgress(progress: 0.5, true)
		//		downloadButton.startIndeterminate(withTimePeriod: 2.0, andTimePadding: 0.4)
		//downloadButton.triggerCompletion()
        let multiplier: CGFloat = 0.05
		if let btn = downloadButton {
			if btn.progress >= 1.0 {
				btn.resetProgress()
			}
			btn.setProgressColor(color: .red)
			print("btn from \(btn.progress)")
			//btn?.setProgress(progress: btn!.progress + 0.01, false)
			// print("btn from \(btn.progress)")
			btn.setProgress(progress: btn.progress + multiplier, false)
			//btn?.triggerCompletion()
			// print("btn to \(btn.progress)")
		}
        if let btn = downloadBtn {
            if btn.progress >= 1.0 {
                btn.resetProgress()
            }
            print("btn from \(btn.progress)")
            btn.setProgress(progress: btn.progress + multiplier, false)
            //btn?.triggerCompletion()
            print("btn to \(btn.progress)")
        }
	}

	@objc func stepProgress(_ sender: Timer) {

	}
    
    @objc func tapped(){
        let time = Double(timePeriod.text != "" ? timePeriod.text! : "1")!
        let padding = Double(timePadding.text != "" ? timePadding.text! : "0.5")!
        picker.selectedRow(inComponent: 0) == 0 ? self.progressButton.startIndeterminate(withTimePeriod: time, andTimePadding: padding) : self.loadDeterminate()
    }
    
    func loadDeterminate() {
        self.progressButton.stopIndeterminate()
        self.progressButton.resetProgress()
        let timer = Timer.scheduledTimer(timeInterval: 0.03,
                                         target: self,
                                         selector: #selector(self.animateDeterminate),
                                         userInfo: time,
                                         repeats: true)
        RunLoop.current.add(timer, forMode: .default)
    }
    
    @objc func animateDeterminate(sender: Timer) {
        if self.progressButton.progress >= 1.0 {
            sender.invalidate()
        }
        else {
            self.progressButton.setProgress(progress: self.progressButton.progress + CGFloat(0.02), true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Indeterminate" : "Determinate"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeSelector.text = row == 0 ? "Indeterminate" : "Determinate"
        self.progressButton.stopIndeterminate()
        timePeriod.isHidden = row != 0
        timePadding.isHidden = row != 0
        typeSelector.resignFirstResponder()
    }
    
}
