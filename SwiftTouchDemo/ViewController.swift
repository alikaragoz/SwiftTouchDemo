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
        scrollView.contentSize = CGSize(width: CGRectGetWidth(self.view.bounds), height: CGRectGetHeight(self.view.bounds) + CGRectGetHeight(self.drawerView.bounds))
        scrollView.contentOffset = CGPoint(x:0.0, y:CGRectGetHeight(self.drawerView.bounds))
        scrollView.autoresizingMask = .FlexibleWidth
        return scrollView
        }()
    
    @lazy var drawerView: UIVisualEffectView = {
        let drawerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        drawerView.frame = CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(self.view.bounds), height: 650.0)
        drawerView.autoresizingMask = .FlexibleWidth
        
        self.addDots(30, view: drawerView.contentView)
        DotView.arrangeDotsNeatlyInView(drawerView.contentView, animated: false)
        
        return drawerView
        }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvasView)
        
        // Dot view
        self.addDots(25, view: self.view)
        DotView.arrangeDotsRandomlyInView(self.view, animated: false)
        
        view.addSubview(scrollView)
        scrollView.addSubview(drawerView)
        
        
        view.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        let toucheDelayGestureRecognizer = TouchDelayGestureRecognizer(target: nil, action: nil)
        canvasView.addGestureRecognizer(toucheDelayGestureRecognizer)
        
    }
    
    func addDots(count: Int, view: UIView) -> Void {
        for _ in 0..count {
            let dotView = DotView.randomDotView()
            let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongGestureRecognizer:")
            longGestureRecognizer.delegate = self
            dotView!.center = self.view.center
            dotView!.addGestureRecognizer(longGestureRecognizer)
            view.addSubview(dotView)
        }
    }
    
    func handleLongGestureRecognizer(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {

        case .Began:
            self.grabDot(sender.view as DotView, gesture: sender)
            
        case .Changed:
            self.moveDot(sender.view as DotView, gesture: sender)
            
        case .Ended, .Cancelled :
            self.dropDot(sender.view as DotView, gesture: sender)
            
        default:
            self.dropDot(sender.view as DotView, gesture: sender)
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
     
        dotView.center =  view.convertPoint(dotView.center, fromView: dotView.superview)
        DotView.arrangeDotsNeatlyInView(drawerView.contentView, animated: true)
    }

    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
}
