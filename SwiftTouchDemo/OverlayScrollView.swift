//
//  OverlayScrollView.swift
//  SwiftTouchDemo
//
//  Created by Ali Karagoz on 09/06/14.
//  Copyright (c) 2014 Ali Karagoz. All rights reserved.
//

import UIKit

class OverlayScrollView: UIScrollView {

    init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRectZero)
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView!  {
        let hitView = super.hitTest(point, withEvent: event)
        return (hitView == self) ? nil : hitView
    }

}
