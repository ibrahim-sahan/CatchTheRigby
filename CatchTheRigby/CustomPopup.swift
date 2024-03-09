//
//  CustomPopup.swift
//  CatchTheRigby
//
//  Created by İbrahim Şahan on 8.03.2024.
//

import UIKit

class CustomPopup: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var letsRollButton: UIButton!
    
    @IBOutlet weak var continueRigby: UIImageView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
      }
       
    override init(frame: CGRect) {
         
        super.init(frame: frame)
         
        setupXib(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
         
      }
    
    func setupXib(frame: CGRect) {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0.7
        addSubview(blurEffectView)
        
        
        let view = loadXib()
        view.frame = frame
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 50
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        addSubview(view)
        
    }

    func loadXib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomPopup", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
        
    }
    
}
