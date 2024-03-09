//
//  ViewController.swift
//  CatchTheRigby
//
//  Created by İbrahim Şahan on 6.03.2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var rigby: UIImageView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var countdownInitLabel: UILabel!
    
    // MARK: Proporties
    var popup: CustomPopup!
    var audioPlayer: AVAudioPlayer?
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var score = 0
    var stepControl = 0
    var countdownInit = 3
    var countdown = 10
    var currentSpeed = 2.0
    var isRigbyTapped = false
    var timer: Timer?
    var bestScore = UserDefaults.standard.integer(forKey: "BestScore")

    
    // MARK: Life cyles methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rigbyTapped(_:)))
        rigby.addGestureRecognizer(tapGesture)
        rigby.isUserInteractionEnabled = true
        
        bestScoreLabel.text = "Best: \(bestScore)"
        countdownLabel.isHidden = true
        
        screenWidth = view.bounds.width
        screenHeight = view.bounds.height
        let rigbyRatio: CGFloat = 0.27
        let rigbyWidth = screenWidth * rigbyRatio
        let rigbyHeight = screenHeight * rigbyRatio
        rigby.frame.size = CGSize(width: rigbyWidth, height: rigbyHeight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
   
        
        startGame()
        isRigbyTapped = true
    }
    
    // MARK: Game methods
    func startGame() {
        
        let startGameAction = UIAlertAction(title: "Start Game", style: .default) {_ in
            self.startCountdownAnimation()
        }
        
        presentAlert(title: "Catch the Rigby", message: "Welcome to Catch the Rigby! You've got 10 seconds per round and one chance to miss Rigby. Let the fun begin!", action: startGameAction)

    }
    
    func startCountdownAnimation() {
        
        stepControl = score + Int(floor((10.0 / currentSpeed))) - 1
        
        playSound(soundName: "countdownInit", fileType: "mp3", audioPlayer: &audioPlayer)
        
        countdownTimer()
        
    }
    
    func countdownTimer() {
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            
            guard let self else {
                return
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.countdownInitLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.countdownInitLabel.alpha = 0
                
            }) { _ in
                
                    self.countdownInitLabel.transform = .identity
                    self.countdownInitLabel.alpha = 1
                
                    if self.countdownInit > 0 {
                   
                    self.countdownInit -= 1
                    
                    }
               }
            
            if self.countdownInit == 0 {
                
                timer.invalidate()
                self.isRigbyTapped = false
                self.countdownInitLabel.isHidden = true
                self.countdownLabel.isHidden = false
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    
                    self.countdown -= 1
                    self.countdownLabel.text = "\(self.countdown)"
                    
                    if self.countdown == 0 {
                        
                        timer.invalidate()
                        self.endGame()
                        
                    }
                }
                
                self.startMovingRigby(intervalSecond: self.currentSpeed)
                
            } else {
                
                self.countdownInitLabel.text = "\(self.countdownInit)"
                
            }
        }
    }
    
    func startMovingRigby(intervalSecond : Double) {
        
        let rigbyWidthMargin = rigby.frame.width * 0.5
        let rigbyHeightMargin = rigby.frame.height * 0.5
        let margin: CGFloat = 30
        let scoreLabelHeight = scoreLabel.frame.maxY
        let startX = margin + rigbyWidthMargin
        let endX = screenWidth - margin - rigbyWidthMargin
        let startY = scoreLabelHeight + margin
        let endY = screenHeight - (bestScoreLabel.frame.height) - margin - rigbyHeightMargin
                
        timer = Timer.scheduledTimer(withTimeInterval: intervalSecond, repeats: true) { [weak self] timer in
            
            guard let self else {
                return
            }
            
            if (countdown > 0 && countdownInit == 0) {
                
                let randomX = CGFloat.random(in: startX...endX)
                let randomY = CGFloat.random(in: startY...endY)
                
                UIView.animate(withDuration: 0.5) {
                    
                    self.rigby.center = CGPoint(x: randomX, y: randomY)
    
                }
                
                self.isRigbyTapped = false
                
            } else {
                
                timer.invalidate()
    
            }
        }
    }
    
    @IBAction func rigbyTapped(_ sender: UITapGestureRecognizer) {
        
        if !isRigbyTapped {
            
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            if score > bestScore {
                
                bestScore = score
                bestScoreLabel.text = "Best: \(bestScore)"
                UserDefaults.standard.set(bestScore, forKey: "BestScore")
                
            }
            
            isRigbyTapped = true
            
        }
    }
    
    func endGame() {
        
        
        if score >= (stepControl) {
            
            playSound(soundName: "yeahya", fileType: "mp3", audioPlayer: &audioPlayer)
            
            popup = CustomPopup(frame: self.view.frame)
            view.addSubview(popup)
            
            popup.letsRollButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
            
        } else {
            
            playSound(soundName: "gameover", fileType: "mp3", audioPlayer: &audioPlayer)
            
            let restartAction = UIAlertAction(title: "Restart Game", style: .default) { _ in
                
                self.restartGame()
                
            }
            
            presentAlert(title: "Game Over", message: "Your score: \(score)", action: restartAction)
            
        }
    }
    
    @objc func continueGame() {
        
        popup.removeFromSuperview()
        countdownInitLabel.text = "3"
        currentSpeed -= 0.2
        
        gameSetup()
        startCountdownAnimation()
        
    }
    
    func restartGame() {
        
        playSound(soundName: "restartRigby", fileType: "mp3", audioPlayer: &self.audioPlayer)
        score = 0
        scoreLabel.text = "Score: \(score)"
        currentSpeed = 2.0
        countdownInitLabel.text = ""
        
        gameSetup()
        startGame()
        
    }
    
    func gameSetup() {
        
        countdownInitLabel.isHidden = false
        countdownLabel.isHidden = true
        isRigbyTapped = true
        countdownInit = 3
        countdown = 10
        countdownLabel.text = "10"

    }
}
