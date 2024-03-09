//
//  UIViewController+Extensions.swift
//  CatchTheRigby
//
//  Created by İbrahim Şahan on 7.03.2024.
//

import UIKit
import AVFAudio

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, action: UIAlertAction) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func playSound(soundName: String, fileType: String, audioPlayer: inout AVAudioPlayer?) {
        
        if let url = Bundle.main.url(forResource: soundName, withExtension: fileType) {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        
    }
    
}
