//
//  BackgroundTimer.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/04/24.
//

import Foundation
class BackgroundTimer {
    private var startTime: Date?
    private var endTime: Date?

    private var timer: DispatchSourceTimer?

    func start() {
        // Record the start time
        startTime = Date()

        // Create a new DispatchSourceTimer
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

        // Set up the timer to fire every second
        timer?.schedule(deadline: .now(), repeating: .seconds(1))

        // Define the task to be executed on each timer tick
        timer?.setEventHandler { [weak self] in
            // Update the end time on each tick
            self?.endTime = Date()
        }

        // Start the timer
        timer?.resume()
    }

    func stop() -> (startTime: Date?, endTime: Date?) {
        // Stop the timer
        timer?.cancel()
        
        // Return the start and end times
        return (startTime, endTime)
    }
}
