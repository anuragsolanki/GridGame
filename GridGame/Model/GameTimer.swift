//
//  GameTimer.swift
//  GridGame
//
//  Created by Anurag Solanki on 05/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import Foundation

final class GameTimer {
    
    // Can't init is singleton
    private init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: GameTimer = {
        let instance = GameTimer()
        
        return instance
    }()
    
    var timer: Timer!
    
    
    func startTimer(time: Double = 1.0) {
        invalidate()
        timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.TimerUpdate), object: nil)
    }
    
    func invalidate() {
        if let _ = timer {
            timer.invalidate()
        }
    }
}
