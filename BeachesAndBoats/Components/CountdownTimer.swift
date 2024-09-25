//
//  CountdownTimer.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/09/2024.
//

import Foundation

public class CountdownTimer {
    private var timer: DispatchSourceTimer?
    private var remainingTime: Int // time in seconds

    public init(minutes: Int) {
        self.remainingTime = minutes * 60
    }

    public func start(updateHandler: @escaping (String) -> Void, completion: @escaping () -> Void) {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }

        let queue = DispatchQueue(label: "com.timer.queue", attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1))

        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }

            if self.remainingTime > 0 {
                self.remainingTime -= 1
                let timeString = self.timeFormatted(self.remainingTime)
                DispatchQueue.main.async {
                    updateHandler(timeString)
                }
            } else {
                self.timer?.cancel()
                self.timer = nil
                DispatchQueue.main.async {
                    completion()
                }
            }
        }

        timer?.resume()
    }

    public func stop() {
        timer?.cancel()
        timer = nil
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
