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
    @IBOutlet var focusOrBreakLabel: UILabel!
    
    var pomodoroBrain = PomodoroBrain()
    
    var isStartButtonPressed: Bool = false
    var timer = Timer()
    
    var selectedLabelTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.adjustsFontSizeToFitWidth = true
        
        view.addSubview(progressView)
        progressView.center = view.center
        progressView.progressColor = hexStringToUIColor(hex: "#707CF6")
        progressView.trackColor = .lightGray
        progressView.progress = 0.0
        
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
            pomodoroBrain.setPomodoroTime(time: Int((fiveMinuteButton.titleLabel?.text)!)! * 60)
            selectedLabelTime = Int((fiveMinuteButton.titleLabel?.text!)!)!
        case tenMinuteButton:
            fiveMinuteButton.isSelected = false
            tenMinuteButton.isSelected = true
            twentyFiveMinuteButton.isSelected = false
            fiveMinuteButton.backgroundColor = .clear
            tenMinuteButton.backgroundColor = hexStringToUIColor(hex: "#707CF6")
            twentyFiveMinuteButton.backgroundColor = .clear
            pomodoroBrain.setPomodoroTime(time: Int((tenMinuteButton.titleLabel?.text)!)! * 60)
            selectedLabelTime = Int((tenMinuteButton.titleLabel?.text!)!)!
        case twentyFiveMinuteButton:
            fiveMinuteButton.isSelected = false
            tenMinuteButton.isSelected = false
            twentyFiveMinuteButton.isSelected = true
            fiveMinuteButton.backgroundColor = .clear
            tenMinuteButton.backgroundColor = .clear
            twentyFiveMinuteButton.backgroundColor = hexStringToUIColor(hex: "#707CF6")
            pomodoroBrain.setPomodoroTime(time: Int((twentyFiveMinuteButton.titleLabel?.text)!)! * 60)
            selectedLabelTime = Int((twentyFiveMinuteButton.titleLabel?.text!)!)!
        default:
            return
        }
        
        if (fiveMinuteButton.isSelected) {
            timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        } else {
            timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        }
        
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        timer.invalidate()
        pomodoroBrain.timePassed = 0
        
        setTimerTime()
        
        timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        
        if (!isStartButtonPressed) {
            startButton.setTitle("STOP", for: .normal)
            isStartButtonPressed = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
            timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        } else {
            startButton.setTitle("START", for: .normal)
            isStartButtonPressed = false
            setTimerTime()
            
            timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        }
    }
    
    @objc func startTimer() {
        
        focusOrBreakLabel.text = "Focus time!"
        
        if (pomodoroBrain.pomodoroTime > 0) {
            pomodoroBrain.pomodoroTime -= 1
            pomodoroBrain.timePassed += 1
            progressView.progress = Float(pomodoroBrain.timePassed) / Float(selectedLabelTime)
            timeLabel.text = convertSecondsToTime(timeInSeconds: pomodoroBrain.pomodoroTime)
        } else {
            timer.invalidate()
            progressView.progress = 0.0
            timeLabel.text = String(selectedLabelTime)
            focusOrBreakLabel.text = "Take a break of any time you want and start over!"
            timeLabel.text = convertSecondsToTime(timeInSeconds: selectedLabelTime * 60)
            startButton.titleLabel?.text = "START"
            isStartButtonPressed = false
        }
        
    }
    
    func convertSecondsToTime(timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func setTimerTime() {
        if (fiveMinuteButton.isSelected) {
            pomodoroBrain.setPomodoroTime(time: Int((fiveMinuteButton.titleLabel?.text)!)!)
        } else if (tenMinuteButton.isSelected) {
            pomodoroBrain.setPomodoroTime(time: Int((tenMinuteButton.titleLabel?.text)!)!)
        } else {
            pomodoroBrain.setPomodoroTime(time: Int((twentyFiveMinuteButton.titleLabel?.text)!)!)
        }
    }
    
}


