//
//  ViewController.swift
//  colorPicerView
//
//  Created by 山口智生 on 2015/11/07.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

// 参考：http://www.minimalab.com/blog/2015/01/30/iphone-uipopovercontroller/

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var setColorButton: UIButton! = nil
    var currentColor: UIColor! {
        set{
            setColorButton.backgroundColor = newValue
        }
        get{
            return setColorButton.backgroundColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        if setColorButton == nil {
            setColorButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSizeMake(50, 50)))
            setColorButton.layer.position = CGPointMake(self.view.bounds.width - 50, self.view.bounds.height - 50)
            setColorButton.backgroundColor = UIColor.redColor()
            setColorButton.addTarget(self, action: "clicked:", forControlEvents: .TouchUpInside)
            self.view.addSubview(setColorButton)
        }
    }
    
    func clicked(sender: UIButton!) {
        let controller = ColorPickerViewController()
        controller.delegate = self
        self.presentPopver(controller, sourceView: sender)
    }
    
    func presentPopver(viewController: UIViewController!, sourceView: UIView!) {
        viewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        viewController.preferredContentSize = CGSizeMake(300,400)

        let popoverController = viewController.popoverPresentationController
        popoverController?.delegate = self
        // 向き
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection.Down
        // どこから出た感じにするか
        popoverController?.sourceView = sourceView
        popoverController?.sourceRect = sourceView.bounds
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}


extension ViewController: ColorPickerViewDelegate {
    func onColorChanged(newColor: UIColor) {
        self.setColorButton.backgroundColor = newColor
    }
}