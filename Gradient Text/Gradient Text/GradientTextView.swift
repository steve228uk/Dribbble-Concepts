//
//  GradientTextView.swift
//  Gradient Text
//
//  Created by Stephen Radford on 16/03/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit

class GradientTextView: UIView, CAAnimationDelegate {

    var label: UILabel?
    var gradient: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
        label?.frame = rect
        gradient?.frame = rect
        mask = label
    }
 
    @IBInspectable
    var text: String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(red:0.29, green:0.37, blue:0.95, alpha:1.00)
        addGradient()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLabel()
    }
    
    func addLabel() {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
        
        label?.removeFromSuperview() // remove pre-existing label
        label = UILabel(frame: rect)
        label?.text = text
        label?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        label?.textColor = .black
        label?.textAlignment = .left
        mask = label
    }
    
    func addGradient() {
        let colorLeft = UIColor(red:0.91, green:0.00, blue:0.36, alpha:1.00).cgColor
        let colorRight = UIColor.clear.cgColor
        
        gradient = CAGradientLayer()
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.endPoint = CGPoint(x: 1, y: 0)
        gradient?.colors = [colorRight, colorLeft, colorRight]
        gradient?.locations = [0, -1, 1]
        gradient?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size)
        
        layer.insertSublayer(gradient!, at: 0)
        
        animate()
    }
    
    func animate() {
        
        gradient?.opacity = 0
        gradient?.removeAllAnimations()
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0, -1, 1]
        animation.toValue = [0, 2, 1]
        animation.duration = 3
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        
        gradient?.add(animation, forKey:"animateGradient")

        
        let alphaAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        alphaAnimation.duration = 1
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.fillMode = kCAFillModeForwards
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        alphaAnimation.delegate = self
            
        self.gradient?.add(alphaAnimation, forKey:"alphaIn")
        
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [unowned self] _ in
            let alphaAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            alphaAnimation2.fromValue = 1
            alphaAnimation2.toValue = 0
            alphaAnimation2.duration = 1
            alphaAnimation2.isRemovedOnCompletion = false
            alphaAnimation2.fillMode = kCAFillModeForwards
            alphaAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            alphaAnimation2.delegate = self
            
            self.gradient?.add(alphaAnimation2, forKey:"alphaOut")
        }
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim as? CABasicAnimation)?.keyPath == "locations" {
            print("CALLED")
            animate()
        }
    }
    
}
