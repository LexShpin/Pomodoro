//
//  ViewController.swift
//  Pomodoro
//
//  Created by Alexander Shpin on 29.08.2022.
//

import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else {return}
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else {return nil}
            return UIColor(cgColor: color)
        }
    }
}



class TimerViewController: UIViewController {
    
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), lineWidth: 15, rounded: true)
    
    @IBOutlet var fiveMinuteButton: UIButton!
    @IBOutlet var tenMinuteButton: UIButton!
    @IBOutlet var twentyFiveMinuteButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    var pomodoroBrain = PomodoroBrain()
    
    var isStartButtonPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.progressColor = hexStringToUIColor(hex: "#707CF6")
        progressView.trackColor = .lightGray
        progressView.progress = 0.1
        
        twentyFiveMinuteButton.isSelected = true
        
        fiveMinuteButton.setTitleColor(.white, for: UIControl.State.selected)
        tenMinuteButton.setTitleColor(.white, for: UIControl.State.selected)
        twentyFiveMinuteButton.setTitleColor(.white, for: UIControl.State.selected)
        
        self.timeLabel.adjustsFontSizeToFitWidth = true
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func selectTimer(_ sender: UIButton) {
        switch sender {
        case fiveMinuteButton:
            fiveMinuteButton.isSelected = true
            tenMinuteButton.isSelected = false
            twentyFiveMinuteButton.isSelected = false
            fiveMinuteButton.backgroundColor = hexStringToUIColor(hex: "#707CF6")
            tenMinuteButton.backgroundColor = .clear
            twentyFiveMinuteButton.backgroundColor = .clear
            pomodoroBrain.setPomodoroTime(time: Int((fiveMinuteButton.titleLabel?.text)!)!)
        case tenMinuteButton:
            fiveMinuteButton.isSelected = false
            tenMinuteButton.isSelected = true
            twentyFiveMinuteButton.isSelected = false
            fiveMinuteButton.backgroundColor = .clear
            tenMinuteButton.backgroundColor = hexStringToUIColor(hex: "#707CF6")
            twentyFiveMinuteButton.backgroundColor = .clear
            pomodoroBrain.setPomodoroTime(time: Int((tenMinuteButton.titleLabel?.text)!)!)
        case twentyFiveMinuteButton:
            fiveMinuteButton.isSelected = false
            tenMinuteButton.isSelected = false
            twentyFiveMinuteButton.isSelected = true
            fiveMinuteButton.backgroundColor = .clear
            tenMinuteButton.backgroundColor = .clear
            twentyFiveMinuteButton.backgroundColor = hexStringToUIColor(hex: "#707CF6")
            pomodoroBrain.setPomodoroTime(time: Int((twentyFiveMinuteButton.titleLabel?.text)!)!)
        default:
            return
        }
        
        if (fiveMinuteButton.isSelected) {
            timeLabel.text = "0\(pomodoroBrain.pomodoroTime):00"
        } else {
            timeLabel.text = "\(pomodoroBrain.pomodoroTime):00"
        }
        
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if (!isStartButtonPressed) {
            startButton.setTitle("STOP", for: .normal)
            isStartButtonPressed = true
            pomodoroBrain.startTimer()
        } else {
            startButton.setTitle("START", for: .normal)
            isStartButtonPressed = false
            pomodoroBrain.stopTimer()
        }
    }
    
}

