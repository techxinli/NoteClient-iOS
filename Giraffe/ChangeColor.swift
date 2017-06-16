//
//  ChangeColor.swift
//  Do
//
//  Created by 李鑫 on 15/11/10.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//


import UIKit

class ChangeColor: UIView,UITextFieldDelegate {
    
    var _cancelBtn:UIButton!
    var _configureBtn:UIButton!
    var _wordText:UITextField!
    var _wordTextImageView:UIImageView!
    var _backImageView:UIImageView!
    var _underLine:UIImageView!
    
    
    
    var _color1:UIButton!
    var _color2:UIButton!
    var _color3:UIButton!
    var _color4:UIButton!
    var _color5:UIButton!
    var _color6:UIButton!
    var _color7:UIButton!
    var _color8:UIButton!
    var _color9:UIButton!
    var _color10:UIButton!
    var _color11:UIButton!
    var _color12:UIButton!
    var _color13:UIButton!
    var _color14:UIButton!
    var _color15:UIButton!
    var _color16:UIButton!
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeColor.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        self.backgroundColor = UIColor.white
        _backImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
       // backImageView.frame = frame
        _backImageView.image = UIImage(named: "color")
        self.addSubview(_backImageView)
        _backImageView.isUserInteractionEnabled = true
        
        _cancelBtn = UIButton(type: UIButtonType.custom)
        _cancelBtn.frame = CGRect(x: _backImageView.frame.width-28, y: 8, width: 20, height: 20)
        _cancelBtn.setImage(UIImage(named: "colorCancel"), for: UIControlState())
        _cancelBtn.addTarget(self, action: #selector(ChangeColor.cancel), for: UIControlEvents.touchUpInside)
        
        _backImageView.addSubview(_cancelBtn)
        
        _underLine = UIImageView()
        _underLine.frame = CGRect(x: 1, y: _backImageView.frame.height - _backImageView.frame.height/4, width: _backImageView.frame.width-2, height: 0.3)
        _underLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        _backImageView.addSubview(_underLine)
        
        _configureBtn = UIButton(type: UIButtonType.custom)
        _configureBtn.frame = CGRect(x: 1, y: _underLine.frame.maxY+5, width: _backImageView.frame.width-2, height: 22)
        //_configureBtn.setImage(UIImage(named: "congigure"), forState: UIControlState.Normal)
        _configureBtn.setTitle("CONFIGURE", for: UIControlState())
        _configureBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        _configureBtn.addTarget(self, action: #selector(ChangeColor.configure), for: UIControlEvents.touchUpInside)
        _configureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _backImageView.addSubview(_configureBtn)
        
        
        _color1 = UIButton(type: UIButtonType.custom)
        _color1.frame = CGRect(x: 15, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color1.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
        _color1.layer.cornerRadius = _color1.frame.size.width/2
        _color1.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
        _color1.tag = 100000
        _backImageView.addSubview(_color1)
        
        _color2 = UIButton(type: UIButtonType.custom)
        _color2.frame = CGRect(x: _color1.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color2.backgroundColor = UIColor(red: 96.0/255.0, green: 174.0/255.0, blue: 10.0/255.0, alpha: 0.6)
        _color2.layer.cornerRadius = _color2.frame.size.width/2
        _color2.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
        _color2.tag = 100001
        _backImageView.addSubview(_color2)
        
        _color3 = UIButton(type: UIButtonType.custom)
        _color3.frame = CGRect(x: _color2.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color3.backgroundColor = UIColor(red: 247.0/255.0, green: 176.0/255.0, blue: 59.0/255.0, alpha: 0.6)
        _color3.layer.cornerRadius = _color3.frame.size.width/2
        _color3.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color3.tag = 100002
        _backImageView.addSubview(_color3)
        
        _color4 = UIButton(type: UIButtonType.custom)
        _color4.frame = CGRect(x: _color3.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color4.backgroundColor = UIColor(red: 222.0/255.0, green: 148.0/255.0, blue: 26.0/255.0, alpha: 0.6)
        _color4.layer.cornerRadius = _color4.frame.size.width/2
        _color4.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color4.tag = 100003
        _backImageView.addSubview(_color4)

        _color5 = UIButton(type: UIButtonType.custom)
        _color5.frame = CGRect(x: _color4.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color5.backgroundColor = UIColor(red: 255.0/255.0, green: 133.0/255.0, blue: 135.0/255.0, alpha: 0.6)
        _color5.layer.cornerRadius = _color5.frame.size.width/2
        _color5.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color5.tag = 100004
        _backImageView.addSubview(_color5)
        

        _color6 = UIButton(type: UIButtonType.custom)
        _color6.frame = CGRect(x: _color5.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color6.backgroundColor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.6)
        _color6.layer.cornerRadius = _color6.frame.size.width/2
        _color6.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color6.tag = 100005
        _backImageView.addSubview(_color6)
        

        _color7 = UIButton(type: UIButtonType.custom)
        _color7.frame = CGRect(x: _color6.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color7.backgroundColor = UIColor(red: 189.0/255.0, green: 16.0/255.0, blue: 224.0/255.0, alpha: 0.6)
        _color7.layer.cornerRadius = _color7.frame.size.width/2
        _color7.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color7.tag = 100006
        _backImageView.addSubview(_color7)
        
        _color8 = UIButton(type: UIButtonType.custom)
        _color8.frame = CGRect(x: _color7.frame.maxX+8, y: _cancelBtn.frame.maxY, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color8.backgroundColor = UIColor(red: 216.0/255.0, green: 211.0/255.0, blue: 142.0/255.0, alpha: 0.6)
        _color8.layer.cornerRadius = _color8.frame.size.width/2
        _color8.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color8.tag = 100007
        _backImageView.addSubview(_color8)
        
        _color9 = UIButton(type: UIButtonType.custom)
        _color9.frame = CGRect(x: 15, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color9.backgroundColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.6)
        _color9.layer.cornerRadius = _color9.frame.size.width/2
        _color9.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color9.tag = 100008
        _backImageView.addSubview(_color9)
        
        _color10 = UIButton(type: UIButtonType.custom)
        _color10.frame = CGRect(x: _color9.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color10.backgroundColor = UIColor(red: 144.0/255.0, green: 19.0/255.0, blue: 254.0/255.0, alpha: 0.6)
        _color10.layer.cornerRadius = _color10.frame.size.width/2
        _color10.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color10.tag = 100009
        _backImageView.addSubview(_color10)
        
        _color11 = UIButton(type: UIButtonType.custom)
        _color11.frame = CGRect(x: _color10.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color11.backgroundColor = UIColor(red: 139.0/255.0, green: 87.0/255.0, blue: 42.0/255.0, alpha: 0.6)
        _color11.layer.cornerRadius = _color11.frame.size.width/2
        _color11.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color11.tag = 100010
        _backImageView.addSubview(_color11)
        
        _color12 = UIButton(type: UIButtonType.custom)
        _color12.frame = CGRect(x: _color11.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color12.backgroundColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 0.6)
        _color12.layer.cornerRadius = _color12.frame.size.width/2
        _color12.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color12.tag = 100011
        _backImageView.addSubview(_color12)
        
        _color13 = UIButton(type: UIButtonType.custom)
        _color13.frame = CGRect(x: _color12.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color13.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
        _color13.layer.cornerRadius = _color13.frame.size.width/2
        _color13.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color13.tag = 100012
        _backImageView.addSubview(_color13)

        _color14 = UIButton(type: UIButtonType.custom)
        _color14.frame = CGRect(x: _color13.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color14.backgroundColor = UIColor(red: 106.0/255.0, green: 234.0/255.0, blue: 160.0/255.0, alpha: 0.6)
        _color14.layer.cornerRadius = _color14.frame.size.width/2
        _color14.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color14.tag = 100013
        _backImageView.addSubview(_color14)
        
        _color15 = UIButton(type: UIButtonType.custom)
        _color15.frame = CGRect(x: _color14.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color15.backgroundColor = UIColor(red: 
0.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        _color15.layer.cornerRadius = _color15.frame.size.width/2
        _color15.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color15.tag = 100014
        _backImageView.addSubview(_color15)
        
        _color16 = UIButton(type: UIButtonType.custom)
        _color16.frame = CGRect(x: _color15.frame.maxX+8, y: _color1.frame.maxY+10, width: 0.06923077 * self.frame.width, height: 0.06923077 * self.frame.width)
        _color16.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.6)
        _color16.layer.cornerRadius = _color12.frame.size.width/2
        _color16.addTarget(self, action: #selector(ChangeColor.changeColor(_:)), for: UIControlEvents.touchUpInside)
         _color16.tag = 100015
        _backImageView.addSubview(_color16)

        
        _wordText = UITextField()
        _wordText.frame = CGRect(x: 15, y: _color16.frame.maxY+10, width: _backImageView.frame.width-30, height: 0.11538462 * self.frame.width)
        _wordText.layer.cornerRadius = 4
        _wordText.layer.borderWidth = 0.4
        _wordText.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        _wordText.textColor = UIColor.darkGray;
        _wordText.font = UIFont(name: "Heiti SC", size: 13)
        _wordText.text = "Please Input Word..."
        _wordText.delegate = self
        _backImageView.addSubview(_wordText)
        

        
        
    
    }
    
    
    func cancel(){
    
    AppStatus.shareInstance().changeColor.transform.ty = 0
    _wordText.resignFirstResponder()
        
        for i in 0  ..< AppStatus.shareInstance().cellArray.count{
            
            let recordcell = AppStatus.shareInstance().cellArray[i] as! RecordCell
            
            recordcell._chooseBtn.setImage(UIImage(named: ""), for: UIControlState())
            
        }
      
       AppStatus.shareInstance().changeColor.alpha = 0
       AppStatus.shareInstance().rootVc._isChoose = false
       AppStatus.shareInstance().rootVc._tableView.reloadData()
       AppStatus.shareInstance().rootVc._tableView.allowsSelection = true
        
      AppStatus.shareInstance().cellArray.removeAllObjects()
    
    }
    
    func configure(){
        
        AppStatus.shareInstance().rootVc._isChoose = false
        AppStatus.shareInstance().changeColor.transform.ty = 0
        _wordText.resignFirstResponder()
        print(AppStatus.shareInstance().cellArray.count)
        for i in 0  ..< AppStatus.shareInstance().cellArray.count{
            
            let recordcell = AppStatus.shareInstance().cellArray[i] as! RecordCell
            
            recordcell._chooseBtn.setImage(UIImage(named: ""), for: UIControlState())
            
            recordcell._record.type = _wordText.text
            recordcell._record.color = AppStatus.shareInstance().tag as NSNumber?

            do{
                
                try AppStatus.shareInstance().context.save()
                
            }catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }

            
            
        }

    
        AppStatus.shareInstance().changeColor.alpha = 0
        AppStatus.shareInstance().rootVc._isChoose = false
    
        AppStatus.shareInstance().rootVc._tableView.reloadData()
        AppStatus.shareInstance().rootVc._tableView.allowsSelection = true

        AppStatus.shareInstance().cellArray.removeAllObjects()

    }
    
    func showKeyboard(_ notification:Notification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let aValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRect = (aValue as AnyObject).cgRectValue
        let Height:CGFloat = (keyboardRect?.size.height)!

        AppStatus.shareInstance().changeColor.transform.ty =  -Height
    }

    func changeColor(_ btn:UIButton){
    
        AppStatus.shareInstance().tag = btn.tag - 100000
        _wordText.tintColor = btn.backgroundColor
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        _wordText.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
