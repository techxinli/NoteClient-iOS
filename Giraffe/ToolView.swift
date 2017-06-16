//
//  ToolView.swift
//  Do
//
//  Created by 李鑫 on 15/11/10.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit

class ToolView: UIView {
    
    
    var _colorButton:UIButton!
    var _clockButton:UIButton!
   // var _hideButton:UIButton!
    
    override init(frame:CGRect){
    
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
        
        _colorButton = UIButton(type: UIButtonType.custom)
        _colorButton.frame = CGRect(x: 15, y: frame.size.height/2-20, width: 40, height: 40)
        _colorButton.setImage(UIImage(named: "colorB"), for:UIControlState())
        
        _clockButton = UIButton(type: UIButtonType.custom)
        _clockButton.frame = CGRect(x: frame.size.width-15-40, y: frame.size.height/2-20, width: 40, height: 40)
        _clockButton.setImage(UIImage(named: "clockB"), for:UIControlState())
        
//        _hideButton = UIButton(type: UIButtonType.Custom)
//        _hideButton.frame = CGRectMake(frame.size.width-15-40, frame.size.height/2-20, 40, 40)
//        _hideButton.setImage(UIImage(named: "hide"), forState:UIControlState.Normal)
        
        self.addSubview(_clockButton)
        self.addSubview(_colorButton)
      //  self.addSubview(_hideButton)
        
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
