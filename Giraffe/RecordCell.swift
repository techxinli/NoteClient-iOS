//
//  RecordCell.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit


class RecordCell: UITableViewCell {
    
    var _colorArr:NSMutableArray!
    var _clicked:Bool!
    var _chooseBtn:UIButton!
    var _colorImage:UIImageView!
    var _colorImage1:UIImageView!
    var _wordLabel:UILabel!
    var _Height:CGFloat!
    var _typeLabel:UILabel!
    var _timeLabel:UILabel!
    var _notifation:UIImageView!
    var toolView:ToolView!
    var _record:Record!
       {

        didSet{

            
            let date:Date = Date()
            let hourformatter:DateFormatter = DateFormatter.init()
            hourformatter.dateFormat = "HH:mm"
        
            let hourString:NSString = hourformatter.string(from: _record!.time! as Date) as NSString
            let formatter:DateFormatter = DateFormatter.init()
            formatter.dateFormat = "MM-dd";
            let beforeDateString = formatter.string(from: _record!.time! as Date)
            let nowDateString = formatter.string(from: date)
            if(beforeDateString == nowDateString){
              _timeLabel.text = hourString as String
            
            }
            else{
            
            _timeLabel.text = beforeDateString as String
            }
            
            _wordLabel.text = _record!.word;
            _colorImage.frame = CGRect(x: 15, y: 12, width: 22, height: 22)
            _colorImage.layer.cornerRadius = _colorImage.frame.size.width/2
            
            _colorImage1.frame = CGRect(x: 18, y: 15,width: 16, height: 16)
            _colorImage1.layer.cornerRadius = _colorImage1.frame.size.width/2
            
            _chooseBtn.frame = CGRect(x: 15, y: 12, width: 22, height: 22);
            _chooseBtn.layer.cornerRadius = _chooseBtn.frame.width/2
            _chooseBtn.layer.borderWidth = 0.8
            _chooseBtn.layer.borderColor = UIColor.lightGray.cgColor

            
            
            _wordLabel.frame = CGRect(x: _colorImage.frame.maxX+10, y: 34, width: self.frame.size.width - _colorImage.frame.maxX*2-49, height: 22)
            
            _timeLabel.frame = CGRect(x: self.frame.size.width-55,y: 12 , width: 45, height: 22)
            
            _typeLabel.frame = CGRect(x: _colorImage.frame.maxX+10, y: 12, width: self.frame.size.width - _colorImage.frame.maxX*2-49, height: 22)
            _typeLabel.text = _record!.type
            
                       
            if(_record!.notification! == 1){
                
            _notifation.frame = CGRect(x: self.frame.size.width-55+11+5, y: _timeLabel.frame.maxY+6, width: 5, height: 5);
            _notifation.layer.cornerRadius = _notifation.frame.size.width/2
            _notifation.backgroundColor = UIColor.red
            _notifation.alpha = 0.5
            self.addSubview(_notifation)

            
            }
            
            else if(_record!.notification == 0){
            
                _notifation.alpha = 0
            
            }
            
            _Height = _colorImage.frame.maxY+10
            
            //switch
            
            if(AppStatus.shareInstance().rootVc._isChoose == false){
            _colorImage.backgroundColor = _colorArr[_record!.color as! Int] as? UIColor
            _colorImage1.backgroundColor = _colorImage.backgroundColor
                _colorImage.alpha = 0.5}
            

        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.bounds.height)
       
        
      self.initSubView()
       
    }
    
    
    func initSubView()
    {
        
        
        
        _clicked = false
        _colorImage = UIImageView()
        self.addSubview(_colorImage)
        
        _colorImage1 = UIImageView()
        self.addSubview(_colorImage1)
        
        _chooseBtn = UIButton(type: UIButtonType.custom)
        _chooseBtn.addTarget(self, action: #selector(RecordCell.choose(_:)), for: UIControlEvents.touchUpInside)
        _chooseBtn.alpha = 0
        self.addSubview(_chooseBtn)

        
        
        _wordLabel = UILabel()
        _wordLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50)
        _wordLabel.font = UIFont(name: "Avenir-Light", size: 18)
        self.addSubview(_wordLabel)
        
        _timeLabel = UILabel()
        _timeLabel.textColor = UIColor.lightGray
        _timeLabel.font = UIFont(name: "Avenir-Light", size: 16)
       
        self.addSubview(_timeLabel)
        
        _typeLabel = UILabel()
        _typeLabel.textColor = UIColor.darkGray
        _typeLabel.font = UIFont(name: "Symbol", size: 15)
        //Copperplate-Light
        self.addSubview(_typeLabel)
        
        _notifation = UIImageView()
        
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(RecordCell.showAdd(_:)))
        self.addGestureRecognizer(longPressGesture)
        

        //showAdd(longPressGesture)
        
        _colorArr = NSMutableArray()
        _colorArr = [UIColor(red: 1, green: 0, blue: 0, alpha: 0.6),UIColor(red: 96.0/255.0, green: 174.0/255.0, blue: 10.0/255.0, alpha: 0.6),UIColor(red: 247.0/255.0, green: 176.0/255.0, blue: 59.0/255.0, alpha: 0.6),UIColor(red: 222.0/255.0, green: 148.0/255.0, blue: 26.0/255.0, alpha: 0.6),UIColor(red: 255.0/255.0, green: 133.0/255.0, blue: 135.0/255.0, alpha: 0.6),UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 226.0/255.0, alpha: 0.6),UIColor(red: 189.0/255.0, green: 16.0/255.0, blue: 224.0/255.0, alpha: 0.6),UIColor(red: 216.0/255.0, green: 211.0/255.0, blue: 142.0/255.0, alpha: 0.6),UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 0.6),UIColor(red: 144.0/255.0, green: 19.0/255.0, blue: 254.0/255.0, alpha: 0.6),UIColor(red: 139.0/255.0, green: 87.0/255.0, blue: 42.0/255.0, alpha: 0.6),UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 0.6),UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6),UIColor(red: 106.0/255.0, green: 234.0/255.0, blue: 160.0/255.0, alpha: 0.6),UIColor(red:
            0.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 0.6),UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.6)]
        
        
       
    
    }
    
    func showAdd(_ sender:UIGestureRecognizer){

        
//        AppStatus.shareInstance().cell = sender.view as! RecordCell
//        print(AppStatus.shareInstance().cell._timeLabel.text!)
        if(AppStatus.shareInstance().toolView == nil){
        
            
        AppStatus.shareInstance().toolView = ToolView.init(frame: CGRect(x: 0, y: (self.superview?.superview!.frame.height)!, width: (self.superview?.superview!.frame.width)!, height: 44))
            AppStatus.shareInstance().toolView._clockButton.addTarget(self, action: #selector(RecordCell.clock), for: UIControlEvents.touchUpInside)
            AppStatus.shareInstance().toolView._colorButton.addTarget(self, action: #selector(getter: Record.color), for: UIControlEvents.touchUpInside)
            AppStatus.shareInstance().toolView.alpha = 0
    
           AppStatus.shareInstance().rootVc.view.addSubview(AppStatus.shareInstance().toolView)

            
           UIView.animate(withDuration: 0.1, animations: { () -> Void in
            AppStatus.shareInstance().toolView.alpha = 1
            
            }, completion: { (bool:Bool) -> Void in
                
           })
            
        }
        
        else if(AppStatus.shareInstance().toolView != nil)
        {
            
            choose(_chooseBtn)

            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                AppStatus.shareInstance().toolView.alpha = 1
                
                }, completion: { (bool:Bool) -> Void in
                    
            })

        
        }
        
        
    }
    
    func color(){
        
        if(AppStatus.shareInstance().changeColor == nil){
            
            AppStatus.shareInstance().rootVc._isChoose = true
            AppStatus.shareInstance().rootVc._tableView.allowsSelection = false
         AppStatus.shareInstance().rootVc._tableView.reloadData()
            
         AppStatus.shareInstance().changeColor = ChangeColor.init(frame: CGRect(x: 44, y: (self.superview?.superview!.frame.height)!-0.53125 * (self.superview?.frame.width)!, width: 0.8125 * (self.superview?.frame.width)!, height: 0.53125 * (self.superview?.frame.width)!))
            
            if(AppStatus.shareInstance().setTime != nil){
                AppStatus.shareInstance().setTime.alpha = 0
            }
            
            AppStatus.shareInstance().changeColor.alpha = 0
            
            AppStatus.shareInstance().rootVc.view.addSubview(AppStatus.shareInstance().changeColor)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                AppStatus.shareInstance().changeColor.alpha = 1
                
                }, completion: { (bool:Bool) -> Void in
                    
            })

        }
        
        else{
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                
                AppStatus.shareInstance().rootVc._isChoose = true
                AppStatus.shareInstance().rootVc._tableView.allowsSelection = false
                AppStatus.shareInstance().rootVc._tableView.reloadData()

                AppStatus.shareInstance().changeColor.alpha = 1
                if(AppStatus.shareInstance().setTime != nil){
                AppStatus.shareInstance().setTime.alpha = 0
                }
                
                }, completion: { (bool:Bool) -> Void in
                    
            })
        }
    }
    
    func clock(){
        
        if(AppStatus.shareInstance().setTime == nil){
            
            
            AppStatus.shareInstance().rootVc._isChoose = true
            AppStatus.shareInstance().rootVc._tableView.allowsSelection = false
            AppStatus.shareInstance().rootVc._tableView.reloadData()
            
            AppStatus.shareInstance().setTime = SetTime.init(frame: CGRect(x: 44, y: (self.superview?.superview!.frame.height)!-0.53125 * (self.superview?.frame.width)!, width: 0.8125 * (self.superview?.frame.width)!, height: 0.53125 * (self.superview?.frame.width)!))
            
            AppStatus.shareInstance().setTime.alpha = 0
            if(AppStatus.shareInstance().changeColor != nil){
            AppStatus.shareInstance().changeColor.alpha = 0
            }
            
            AppStatus.shareInstance().rootVc.view.addSubview(AppStatus.shareInstance().setTime)
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                AppStatus.shareInstance().setTime.alpha = 1
                
                }, completion: { (bool:Bool) -> Void in
                    
            })
            
        }
            
        else{
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                AppStatus.shareInstance().rootVc._isChoose = true
                AppStatus.shareInstance().rootVc._tableView.allowsSelection = false
                AppStatus.shareInstance().rootVc._tableView.reloadData()
                
                AppStatus.shareInstance().setTime.alpha = 1
                AppStatus.shareInstance().setTime._datePicker.date = Date()
                
                if(AppStatus.shareInstance().changeColor != nil){
                AppStatus.shareInstance().changeColor.alpha = 0
                }
                }, completion: { (bool:Bool) -> Void in
                    
            })
        }

        
    
    
    }
    
    
    func choose(_ btn:UIButton){
    
        if(_clicked == false){
           
            AppStatus.shareInstance().cellArray.add(btn.superview!)
            btn.setImage(UIImage(named: "ok"), for: UIControlState())
            _clicked = true
            
            print(AppStatus.shareInstance().cellArray)
        }
        
        else if(_clicked == true){
        
            AppStatus.shareInstance().cellArray.remove(btn.superview!)
            btn.backgroundColor = UIColor.white
            btn.setImage(UIImage(named: ""), for:UIControlState())
            _clicked = false
        
        }
        
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
