//
//  DotView.swift
//  SwiftTouchDemo
//
//  Created by Ali Karagoz on 09/06/14.
//  Copyright (c) 2014 Ali Karagoz. All rights reserved.
//

import UIKit
import QuartzCore

class DotView: UIView {
    
    var highlightingLayer: CALayer? = nil
    
    @lazy var randomColor: UIColor = {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = (CGFloat(arc4random() % 128) / 256.0) + 0.5
        let brightness = (CGFloat(arc4random() % 128) / 256.0) + 0.55
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: CGFloat(1.0))
    }()
    
    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: DotView.randomFrame())
        self.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleBottomMargin
        
        // Circle layer
        let circleLayer: CALayer = CALayer()
        circleLayer.frame = self.frame
        circleLayer.cornerRadius = CGFloat(CGRectGetWidth(circleLayer.frame)) / CGFloat(2.0)
        circleLayer.backgroundColor = randomColor.CGColor
        
        self.layer.addSublayer(circleLayer)
        
    }
    
    class func randomFrame() -> CGRect {
        let randomSize = CGFloat(arc4random() % 100) + 10
        return CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: randomSize, height: randomSize))
    }
    
    class func randomDotView() -> UIView? {
        return DotView()
    }
    
    class func arrangeDotsRandomlyInView(view: UIView, animated: Bool) -> Void {
        for v : AnyObject in view.subviews {
            if let dotView = v as? DotView {
                
                let animationDuration = animated ? 0.3 : 0.0
                UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                    
                    let randx = CGFloat(arc4random()) % (CGRectGetWidth(view.frame) - 2 * CGRectGetWidth(dotView.frame)) + CGRectGetWidth(dotView.frame)
                    let randy = CGFloat(arc4random()) % (CGRectGetHeight(view.frame) - 2 * CGRectGetHeight(dotView.frame)) + CGRectGetHeight(dotView.frame)
                    dotView.center = CGPoint(x: randx, y: randy)
                    
                }, completion:nil)
            }
        }
    }
    
    class func arrangeDotsNeatlyInView(view: UIView, animated: Bool) -> Void {
        
        var previousFrame: CGRect? = nil

        for v : AnyObject in view.subviews {
            
            if let dotView = v as? DotView {
                
                let animationDuration = animated ? 0.3 : 0.0
                UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                    
                    // First dot
                    if !previousFrame {
                        dotView.center = CGPoint(x: 70.0, y: 650.0 + 70.0)
                        previousFrame = dotView.frame
                        return
                    }
                    
                    var randx = CGRectGetMaxX(previousFrame!) + 25.0 + CGRectGetWidth(dotView.bounds) / 2.0
                    var randy = CGRectGetMinY(previousFrame!) + CGRectGetWidth(previousFrame!) / 2.0

                    if (randx + CGRectGetWidth(dotView.frame) + 25.0 > CGRectGetWidth(view.frame)) {
                        randx = 70.0
                        randy += 120.0
                    }
                    
                    dotView.center = CGPoint(x: randx, y: randy)
                    
                }, completion:nil)
               
                previousFrame = dotView.frame
            }
        }
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent!) -> Bool  {
        
        var touchBounds = self.bounds
        if CGRectGetWidth(self.bounds) / 2.0 < 22 {
            let expansion = 22.0 - CGRectGetWidth(self.bounds) / 2.0
            touchBounds = CGRectInset(touchBounds, -expansion, -expansion)
        }
        
        return CGRectContainsPoint(touchBounds, point)
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        self.highlighted(isHighlighted: true)
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)  {
        self.highlighted(isHighlighted: false)
    }

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)  {
        self.highlighted(isHighlighted: false)
    }
    
    func highlighted(isHighlighted: Bool = true) {
        
        if isHighlighted {
            highlightingLayer = CALayer()
            highlightingLayer!.frame = self.bounds
            highlightingLayer!.cornerRadius = CGFloat(CGRectGetWidth(highlightingLayer!.frame)) / CGFloat(2.0)
            highlightingLayer!.backgroundColor = UIColor(white: 0.0, alpha: 0.3).CGColor
            self.layer.addSublayer(highlightingLayer)
        } else {
            highlightingLayer!.removeFromSuperlayer()
        }
    }
}
