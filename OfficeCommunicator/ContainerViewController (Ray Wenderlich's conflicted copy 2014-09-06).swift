//
//  ContainerViewController.swift
//  OfficeCommunicator
//
//  Created by David Grandinetti on 8/8/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {

  let menuWidth: CGFloat = 80.0
  let animationTime: NSTimeInterval = 0.5

  let menuViewController: UIViewController!
  let centerViewController: UIViewController!
  
  var isOpening = false
  
  init(sideMenu: UIViewController, center: UIViewController) {
    menuViewController = sideMenu
    centerViewController = center
    super.init(nibName: nil, bundle: nil)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    view.backgroundColor = UIColor.blackColor()
    
    addChildViewController(centerViewController)
    view.addSubview(centerViewController.view)
    centerViewController.didMoveToParentViewController(self)
    
    addChildViewController(menuViewController)
    view.addSubview(menuViewController.view)
    menuViewController.didMoveToParentViewController(self)
    
    menuViewController.view.frame = CGRect(x: -menuWidth, y: 0,
      width: menuWidth, height: view.frame.height)
    
    var panGesture = UIPanGestureRecognizer(target:self, action:Selector("handleGesture:"))
    view.addGestureRecognizer(panGesture)
  }
  
  func handleGesture(recognizer:UIPanGestureRecognizer) {

    let translation = recognizer.translationInView(recognizer.view!.superview!)
    
    var progress = translation.x / menuWidth * (isOpening ? 1.0 : -1.0)
    progress = min(max(progress, 0.0), 1.0)
    
    switch recognizer.state {
    case .Began:
      let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
      isOpening = isOpen == 1.0 ? false: true

    case .Changed:
      self.setToPercent(isOpening ? progress: (1.0 - progress))
      
    case .Ended: fallthrough
    case .Cancelled: fallthrough
    case .Failed:
      
      var targetProgress: CGFloat
      if (isOpening) {
        targetProgress = progress < 0.5 ? 0.0 : 1.0
      } else {
        targetProgress = progress < 0.5 ? 1.0 : 0.0
      }
      
      UIView.animateWithDuration(animationTime, animations: {
        self.setToPercent(targetProgress)
      }, completion: { _ in
        //
      })
      
    default: break
    }
  }
  
  func toggleSideMenu() {
    let isOpen = floor(centerViewController.view.frame.origin.x/menuWidth)
    let targetProgress: CGFloat = isOpen == 1.0 ? 0.0: 1.0

    UIView.animateWithDuration(animationTime, animations: {
      self.setToPercent(targetProgress)
    }, completion: { _ in
      self.menuViewController.view.layer.shouldRasterize = false
    })
  }
  
  func setToPercent(percent: CGFloat) {
    centerViewController.view.frame.origin.x = menuWidth * CGFloat(percent)
    menuViewController.view.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
  }
  
}