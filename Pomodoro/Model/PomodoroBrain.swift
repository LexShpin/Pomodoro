//
//  PomodoroBrain.swift
//  Pomodoro
//
//  Created by Alexander Shpin on 31.08.2022.
//

import Foundation

struct PomodoroBrain {
    var pomodoroTime: Int = 0
    var timePassed: Int = 0
    
    mutating func setPomodoroTime(time: Int) {
        pomodoroTime = time
    }
    
    func getPomodoroTime() -> Int {
        return pomodoroTime
    }
    
    func startTimer() {
        
    }
    
    func stopTimer() {
        
    }
}
