//
//  PomodoroBrain.swift
//  Pomodoro
//
//  Created by Alexander Shpin on 31.08.2022.
//

import Foundation
import UIKit

struct PomodoroBrain {
    
    var pomodoroTime: Int = 0
    var breakTime: Int = 5
    var timePassed: Int = 0
    
    mutating func setPomodoroTime(time: Int) {
        pomodoroTime = time * 60
    }
    
    func getPomodoroTime() -> Int {
        return pomodoroTime
    }
}
