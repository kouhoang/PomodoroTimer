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
    
    var timer: Timer?
    var remainingTime = 25 * 60
    var isCountingDown = false
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startPauseButton.layer.cornerRadius = 10
        
        
        resetButton.layer.cornerRadius = 10
        resetButton.layer.borderColor = UIColor.white.cgColor
        resetButton.layer.borderWidth = 2.0
        
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
                circleView.layer.masksToBounds = true
                
                circleView.backgroundColor = .black
                
                circleView.layer.borderWidth = 5.0
        circleView.layer.borderColor = UIColor.orange.cgColor
    }
    
        func updateCountDownLabel() {
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            countDownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
        
        @IBAction func startPauseTapped(_ sender: UIButton) {
            if isCountingDown {
                if isPaused {
                    startPauseButton.setTitle("Pause", for: .normal)
                    isPaused = false
                    startTimer()
                } else {
                    startPauseButton.setTitle("Continue", for: .normal)
                    isPaused = true
                    stopTimer()
                }
            } else {
                isCountingDown = true
                startPauseButton.setTitle("Pause", for: .normal)
                startTimer()
            }
        }
        
        @IBAction func resetTapped(_ sender: UIButton) {
            remainingTime = 25 * 60
            updateCountDownLabel()
            
            stopTimer()
            isCountingDown = false
            isPaused = false
            startPauseButton.setTitle("Start", for: .normal)
        }
        
        func startTimer() {
            timer?.invalidate()  // Dừng bất kỳ timer nào đang chạy
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        }
        
        func stopTimer() {
            timer?.invalidate()
        }
        
        @objc func updateCountdown() {
            if remainingTime > 0 {
                remainingTime -= 1
                updateCountDownLabel()
            } else {
                stopTimer()
                startPauseButton.setTitle("Start", for: .normal)
                isCountingDown = false
            }
        }
}

