//
//  ViewController.swift
//  Pomodoro Timer
//
//  Created by admin on 21/2/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var timer: CADisplayLink?
    var remainingTime: CFTimeInterval = 1 * 60  // 1 minute
    var isCountingDown = false
    var isPaused = false
    var progressLayer: CAShapeLayer!
    var circlePath: UIBezierPath!
    var lastTime: CFTimeInterval = 0
    var elapsedTime: CFTimeInterval = 0  // Stores the elapsed time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDownLabel.text = "01:00"
        
        startPauseButton.layer.cornerRadius = 10

        resetButton.layer.cornerRadius = 10
        resetButton.layer.borderColor = UIColor.white.cgColor
        resetButton.layer.borderWidth = 2.0
        
        let radius = circleView.frame.size.width / 2
        circlePath = UIBezierPath(arcCenter: CGPoint(x: circleView.frame.size.width / 2, y: circleView.frame.size.height / 2),
                                  radius: radius,
                                  startAngle: -CGFloat.pi / 2,
                                  endAngle: 2 * CGFloat.pi - CGFloat.pi / 2,
                                  clockwise: true)
        
        progressLayer = CAShapeLayer()
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor(named: "orangeColor")?.cgColor
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 1.0
        circleView.layer.addSublayer(progressLayer)
        
        updateCountDownLabel()
    }
    
    // Updates the countdown label in the format MM:SS
    func updateCountDownLabel() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        countDownLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func startPauseTapped(_ sender: UIButton) {
        if isCountingDown {
            if isPaused {
                startPauseButton.setTitle("Pause", for: .normal)
                isPaused = false
                startTimer() // Continue the countdown
            } else {
                startPauseButton.setTitle("Continue", for: .normal)
                isPaused = true
                stopTimer() // Pause the countdown
            }
        } else {
            isCountingDown = true
            startPauseButton.setTitle("Pause", for: .normal)
            startTimer() // Start the countdown
        }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        remainingTime = 1 * 60  // Reset to 1 minute
        elapsedTime = 0  // Reset the elapsed time
        
        // Reset the progress circle to full (1.0)
        progressLayer.strokeEnd = 1.0
        
        updateCountDownLabel()
        
        stopTimer()
        isCountingDown = false
        isPaused = false
        startPauseButton.setTitle("Start", for: .normal)
    }
    
    // Starts the timer and saves the current time
    func startTimer() {
        lastTime = CACurrentMediaTime()
        
        timer?.invalidate()  // Invalidate any previous timer
        timer = CADisplayLink(target: self, selector: #selector(updateCountdown))
        timer?.add(to: .main, forMode: .common)
    }
    
    // Stops the timer
    func stopTimer() {
        timer?.invalidate()  // Invalidate the timer when paused
    }
    
    @objc func updateCountdown() {
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastTime
        
        // Add the delta time to the elapsed time
        elapsedTime += deltaTime
        
        // Calculate the remaining time
        remainingTime = max(0, 1 * 60 - elapsedTime)
        
        if remainingTime <= 0 {
            remainingTime = 0
            stopTimer()
            startPauseButton.setTitle("Start", for: .normal)
            isCountingDown = false
        }
        
        updateCountDownLabel()
        
        // Update the progress smoothly
        let progress = CGFloat(remainingTime) / CGFloat(1 * 60)  // 1 minute
        progressLayer.strokeEnd = progress
        
        // Update lastTime each time the update occurs
        lastTime = currentTime
    }
}
