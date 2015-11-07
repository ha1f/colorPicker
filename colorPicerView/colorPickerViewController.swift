//
//  colorPickerViewController.swift
//  colorPicerView
//
//  Created by 山口智生 on 2015/11/07.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate {
    func onColorChanged(newColor: UIColor)
}

class ColorsView: UIView {
    // 細かさの設定
    var xCount = 15
    var yCount = 20
    
    var blockSize: CGSize! = nil
    var size: CGSize! = nil
    
    func setUp() {
        self.size = self.bounds.size
    }
    
    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
    
    func colorFromPoint(point: CGPoint) -> UIColor {
        let posX = Int(point.x * CGFloat(xCount) / size.width)
        let posY = Int(point.y * CGFloat(yCount) / size.height)
        return colorFromPos(posY, posS: posX)
    }
    
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let blockSize = CGSizeMake(size.width/CGFloat(xCount), size.height/CGFloat(yCount))
        
        for i in 0...yCount {
            for j in 0...xCount {
                let color = colorFromPos(i, posS: j)
                color.setFill()
                let blockRect = CGRect(
                    origin: CGPointMake(blockSize.width*CGFloat(j), blockSize.height*CGFloat(i)),
                    size: blockSize
                )
                CGContextFillRect(context, blockRect)
            }
        }
    }
}

class ColorPickerViewController: UIViewController {
    var delegate: ColorPickerViewDelegate! = nil
    
    var colorsView: ColorsView! = nil
    
    var currentColor: UIColor = UIColor.whiteColor()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.redColor()
        
        self.view.layer.cornerRadius = 1.0
        
        if colorsView == nil {
            colorsView = ColorsView(frame: CGRect(origin: CGPoint.zero, size: self.preferredContentSize))
            colorsView.setUp()
            self.view.addSubview(colorsView)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
        updateColor(colorsView.colorFromPoint(touch!))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
        updateColor(colorsView.colorFromPoint(touch!))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first?.locationInView(self.view)
        updateColor(colorsView.colorFromPoint(touch!))
        
        closeView()
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func updateColor(color: UIColor) {
        self.currentColor = color
        delegate?.onColorChanged(self.currentColor)
    }
}
