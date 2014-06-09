//
//  ViewController.swift
//  SwiftTouchDemo
//
//  Created by Ali Karagoz on 09/06/14.
//  Copyright (c) 2014 Ali Karagoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @lazy var canvasView: UIView = {
        let canvasView = UIView(frame: self.view.frame)
        canvasView.backgroundColor = UIColor.darkGrayColor()
        canvasView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return canvasView
    }()
    
    @lazy var scrollView: OverlayScrollView = {
        let scrollView = OverlayScrollView()
        scrollView.frame = self.view.bounds
        
        scrollView.contentSize = CGSize(
            width: CGRectGetWidth(self.view.bounds),
            height: CGRectGetHeight(self.view.bounds) + 650.0
        )
        
        scrollView.contentOffset = CGPoint(x:0.0, y:650.0)
        scrollView.autoresizingMask = .FlexibleWidth
        return scrollView
    }()
    
    @lazy var drawerView: UIVisualEffectView = {
        let drawerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        drawerView.frame = CGRect(x: 0.0, y: -650.0, width: CGRectGetWidth(self.view.bounds), height: 1300.0)
        drawerView.autoresizingMask = .FlexibleWidth
        return drawerView
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Canvas view configuration
        self.addDots(25, view: canvasView)
        DotView.arrangeDotsRandomlyInView(canvasView, animated: false)
        
        // Drawer view configuration
        self.addDots(30, view: drawerView.contentView)
        DotView.arrangeDotsNeatlyInView(drawerView.contentView, animated: false)

        view.addSubview(canvasView)
        view.addSubview(scrollView)
        scrollView.addSubview(drawerView)
        
        view.addGestureRecognizer(scrollView.panGestureRecognizer)
        view.addGestureRecognizer(TouchDelayGestureRecognizer(target: nil, action: nil))
        
    }
    
    func addDots(count: Int, view: UIView) -> Void {
        for _ in 0..count {
            let dotView = DotView.randomDotView()
            let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongGestureRecognizer:")
            longGestureRecognizer.delegate = self
            longGestureRecognizer.cancelsTouchesInView = false
            dotView!.center = self.view.center
            dotView!.addGestureRecognizer(longGestureRecognizer)
            view.addSubview(dotView)
        }
    }
    
    func handleLongGestureRecognizer(sender: UILongPressGestureRecognizer) {
        
        let dot = sender.view as DotView
        
        switch sender.state {

        case .Began:
            self.grabDot(dot, gesture: sender)
            
        case .Changed:
            self.moveDot(dot, gesture: sender)
            
        case .Ended, .Cancelled :
            self.dropDot(dot, gesture: sender)
            
        default:
            self.dropDot(dot, gesture: sender)
        }
        
    }
    
    func grabDot(dotView: DotView, gesture: UIGestureRecognizer) {
        
        dotView.center =  view.convertPoint(dotView.center, fromView: dotView.superview)
        view.addSubview(dotView)
        
        UIView.animateWithDuration(0.2, animations: {
            dotView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            dotView.alpha = 0.8
            self.moveDot(dotView, gesture: gesture)
        })
        
        scrollView.panGestureRecognizer.enabled = false
        scrollView.panGestureRecognizer.enabled = true
        
        DotView.arrangeDotsNeatlyInView(drawerView.contentView, animated: true)
    }
    
    func moveDot(dotView: DotView, gesture: UIGestureRecognizer) {
        dotView.center = gesture.locationInView(view)
    }
    
    func dropDot(dotView: DotView, gesture: UIGestureRecognizer) {
        
        UIView.animateWithDuration(0.2  , animations: {
            dotView.transform = CGAffineTransformIdentity
            dotView.alpha = 1.0
        })
        
        let locationInDrawer = gesture.locationInView(drawerView)
        if CGRectContainsPoint(drawerView.bounds, locationInDrawer) {
            drawerView.contentView.addSubview(dotView)
        } else {
            canvasView.addSubview(dotView)
        }
     
        dotView.center =  view.convertPoint(dotView.center, toView: dotView.superview)
        DotView.arrangeDotsNeatlyInView(drawerView.contentView, animated: true)
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
}
