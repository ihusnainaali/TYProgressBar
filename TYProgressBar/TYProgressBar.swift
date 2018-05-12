//
//  TYProgressBar.swift
//  
//
//  Created by Yash Thaker on 08/05/18.
//  Copyright © 2018 Yash Thaker. All rights reserved.
//

import UIKit

class TYProgressBar: UIView {
    
    var gradients: [UIColor] = [#colorLiteral(red: 0.7843137255, green: 0.4274509804, blue: 0.8431372549, alpha: 1), #colorLiteral(red: 0.1882352941, green: 0.137254902, blue: 0.6823529412, alpha: 1)] {
        didSet {
            let gradientColors = gradients.map { $0.cgColor }
            pulsingGradientLayer.colors = gradientColors
            shapeGradientLayer.colors = gradientColors
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            progressLbl.textColor = textColor
        }
    }
    
    var font: UIFont = UIFont(name: "HelveticaNeue-Medium", size: 22)! {
        didSet {
          progressLbl.font = font
        }
    }
    
    var progress: Double = 0 {
        didSet {
            updateDraw()
        }
    }
    
    var pulsingGradientLayer: CAGradientLayer!  // Masking layer
    var pulsingLayer: CAShapeLayer!
    
    var trackLayer: CAShapeLayer!
    
    var shapeGradientLayer: CAGradientLayer!    // masking layer
    var shapeLayer: CAShapeLayer!
    
    lazy var progressLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = textColor
        lbl.font = font
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pulsingGradientLayer = createGradientLayer()    // Masking layer
        self.layer.addSublayer(pulsingGradientLayer)
        
        pulsingLayer = createShapeLayer(strokeColor: UIColor(white: 0, alpha: 0.2), fillColor: .clear)
        pulsingLayer.lineWidth = 0
        pulsingLayer.lineDashPattern = nil
        self.layer.addSublayer(pulsingLayer)
        
        pulsingGradientLayer.mask = pulsingLayer
        
        trackLayer = createShapeLayer(strokeColor: UIColor(white: 0.2, alpha: 0.5), fillColor: .clear)
        trackLayer.strokeEnd = 1
        self.layer.addSublayer(trackLayer)
        
        shapeGradientLayer = createGradientLayer()  // Masking layer
        self.layer.addSublayer(shapeGradientLayer)
        
        shapeLayer = createShapeLayer(strokeColor: .black, fillColor: .clear)
        shapeLayer.strokeEnd = CGFloat(progress)
        self.layer.addSublayer(shapeLayer)
        
        shapeGradientLayer.mask = shapeLayer
        
        self.addSubview(progressLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pulsingGradientLayer.frame = self.bounds
        shapeGradientLayer.frame = self.bounds
        
        let cx = self.bounds.width / 2
        let cy = self.bounds.height / 2
        let viewCenter = CGPoint(x: cx, y: cy)
        
        let path = UIBezierPath(arcCenter: .zero, radius: cx - 22, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        pulsingLayer.path = path.cgPath
        trackLayer.path = path.cgPath
        shapeLayer.path = path.cgPath
        
        pulsingLayer.position = viewCenter
        trackLayer.position = viewCenter
        shapeLayer.position = viewCenter
        
        trackLayer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        shapeLayer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        
        progressLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        progressLbl.center = viewCenter
    }
    
    func updateDraw() {
        shapeLayer.strokeEnd = CGFloat(progress)
        
        let intProgress = Int(progress*100)
        
        if intProgress <= 100 {
            progressLbl.text = "\(intProgress)%"
        }
        
        if intProgress == 100 {
            startPulseAnimation()
        } else {
            stopPulseAnimation()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.progressLbl.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        }) { (_) in
            self.progressLbl.transform = .identity
        }
    }
    
    func startPulseAnimation() {
        pulsingLayer.lineWidth = 15
        
        let animation =  CABasicAnimation(keyPath: "transform.scale.xy")
        animation.toValue = 1.1
        animation.duration = 0.8
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        pulsingLayer.add(animation, forKey: "TYPulsing")
    }
    
    func stopPulseAnimation() {
        pulsingLayer.lineWidth = 0
        pulsingLayer.removeAnimation(forKey: "TYPulsing")
    }
    
    private func createShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = 10
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineDashPattern = [4, 2]
        return layer
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        let defaultColors = gradients.map { $0.cgColor }
        gradientLayer.colors = defaultColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return gradientLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
