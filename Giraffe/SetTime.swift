//
//  SetTime.swift
//  Do
//
//  Created by 李鑫 on 15/11/11.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreData


class SetTime: UIView {

    var _backImageView:UIImageView!
    var _datePicker:UIDatePicker!
    var _underLine:UIImageView!
    var _cancelBtn:UIButton!
    var _configureBtn:UIButton!
    var _deleteBtn:UIButton!
    var _infoArray:NSMutableArray!
    
    ///func scheduleLocalNotification(){}
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
        
        _backImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        // backImageView.frame = frame
        _backImageView.image = UIImage(named: "setTime")
        self.addSubview(_backImageView)
        _backImageView.isUserInteractionEnabled = true
        
        _cancelBtn = UIButton(type: UIButtonType.custom)
        _cancelBtn.frame = CGRect(x: _backImageView.frame.width-28, y: 8, width: 20, height: 20)
        _cancelBtn.setImage(UIImage(named: "colorCancel"), for: UIControlState())
        _cancelBtn.addTarget(self, action: #selector(SetTime.cancel), for: UIControlEvents.touchUpInside)
        
        _backImageView.addSubview(_cancelBtn)

        
        _datePicker = UIDatePicker()
        _datePicker.frame = CGRect(x: 1, y: frame.size.height/5, width: frame.size.width-2, height: frame.size.height - frame.size.height/4 - frame.size.height/5)
        _datePicker.tintColor = UIColor.lightGray
        _datePicker.locale = Locale.init(identifier: "en_US")
        _backImageView.addSubview(_datePicker)
        
        _underLine = UIImageView()
        _underLine.frame = CGRect(x: 1, y: _backImageView.frame.height - _backImageView.frame.height/4, width: _backImageView.frame.width-2, height: 0.3)
        _underLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        _backImageView.addSubview(_underLine)
        
        _configureBtn = UIButton(type: UIButtonType.custom)
        _configureBtn.frame = CGRect(x: _backImageView.frame.width/2+20, y: _underLine.frame.maxY+5, width: _backImageView.frame.width/2-1, height: 22)
        _configureBtn.setTitle("OK", for: UIControlState())
        _configureBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        _configureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _configureBtn.titleLabel?.textAlignment = NSTextAlignment.right
        _configureBtn.addTarget(self, action: #selector(SetTime.configure), for: UIControlEvents.touchUpInside)
        
        _backImageView.addSubview(_configureBtn)
        
        
        _deleteBtn = UIButton(type: UIButtonType.custom)
        _deleteBtn.frame = CGRect(x: 1, y: _underLine.frame.maxY+5, width: _backImageView.frame.width/2, height: 22)
        _deleteBtn.setTitle("CANCEL", for: UIControlState())
        _deleteBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
        _deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _deleteBtn.addTarget(self, action: #selector(SetTime.deleteN), for: UIControlEvents.touchUpInside)
        
        _backImageView.addSubview(_deleteBtn)
        

        
        
        
        

    }
    
    
    
    func cancel(){
        
        
        for i in  0  ..< AppStatus.shareInstance().cellArray.count{
            
            let recordcell = AppStatus.shareInstance().cellArray[i] as! RecordCell
            
            recordcell._chooseBtn.setImage(UIImage(named: ""), for: UIControlState())
            
        }
        
        AppStatus.shareInstance().setTime.alpha = 0
        AppStatus.shareInstance().rootVc._isChoose = false
        AppStatus.shareInstance().rootVc._tableView.reloadData()
        AppStatus.shareInstance().rootVc._tableView.allowsSelection = true
        
        AppStatus.shareInstance().cellArray.removeAllObjects()
        
    }
    
    func configure(){
        
        
        //scheduleLocalNotification()
        
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [timeDesc]
        request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
        //var error:NSError?
        
        do{
            _infoArray = try NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
        }
        catch let error as NSError{
            
            print("could not save \(error),\(error.localizedDescription)")
        }
        let sortArray:NSMutableArray = NSMutableArray()
        if _infoArray.count > 0{
        
        for i in stride(from: _infoArray.count-1, through: 0, by: -1) {
            
            sortArray.add(_infoArray[i])
            
        }
        }
        
        _infoArray = sortArray;
        

        
        AppStatus.shareInstance().rootVc._isChoose = false
        print(AppStatus.shareInstance().cellArray.count)
        for i in 0  ..< AppStatus.shareInstance().cellArray.count{
            
            print(AppStatus.shareInstance().cellArray.count)
            
            let recordcell = AppStatus.shareInstance().cellArray[i] as! RecordCell
            
            recordcell._chooseBtn.setImage(UIImage(named: ""), for: UIControlState())
            
            if(recordcell._record.notification == 0){
                
            recordcell._record.notification = 1
            
            recordcell._record.alert = fixNotificationDate(_datePicker.date);
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = fixNotificationDate(_datePicker.date)
            
            localNotification.alertBody = recordcell._wordLabel.text
            localNotification.alertAction = "View List"
            
            localNotification.category = "infoReminderCategory"
            localNotification.userInfo = ["id":_infoArray.index(of: recordcell._record)]
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
            

            do{
                
                try AppStatus.shareInstance().context.save()
                
            }catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
            }
            
            
            else if(recordcell._record.notification == 1){
            
                let notifications:NSArray = UIApplication.shared.scheduledLocalNotifications! as NSArray
                
                recordcell._record.alert = fixNotificationDate(_datePicker.date);

                
                for notification in notifications{
                
                    
                    
                   
                    
                    
                    
                    let dic:NSDictionary = (notification as AnyObject).userInfo! as NSDictionary
//                    
//                    print(dic.valueForKey("id") as! Int);
//                    print(_infoArray.indexOfObject(<#T##anObject: AnyObject##AnyObject#>))
//                    print(_infoArray.count);
//                    print(recordcell.);
//                    
                    print("========")
                    
                    if (dic.value(forKey: "id") as! Int == _infoArray.index(of: recordcell)){
                    

                    UIApplication.shared.cancelLocalNotification(notification as! UILocalNotification)
                    
                    print(notification);
    
                        
                    }
                    
                
                }
                
                //UIApplication.sharedApplication().cancelLocalNotification(UILocalNotification)
                
                let localNotification = UILocalNotification()
                localNotification.fireDate = fixNotificationDate(_datePicker.date)
                
                localNotification.alertBody = recordcell._wordLabel.text
                localNotification.alertAction = "View List"
                
                localNotification.category = "infoReminderCategory"
                localNotification.userInfo = ["id":_infoArray.index(of: recordcell._record)]
                
                UIApplication.shared.scheduleLocalNotification(localNotification)
                do{
                    
                    try AppStatus.shareInstance().context.save()
                    
                }catch let error as NSError{
                    
                    print("could not save \(error),\(error.localizedDescription)")
                }
                
            }
            
        }
        
        
       AppStatus.shareInstance().rootVc._isChoose = false
        
        AppStatus.shareInstance().setTime.alpha = 0
        
       AppStatus.shareInstance().rootVc._tableView.reloadData()
        AppStatus.shareInstance().rootVc._tableView.allowsSelection = true
        
        AppStatus.shareInstance().cellArray.removeAllObjects()
        
    }
    
    
    func deleteN(){
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [timeDesc]
        request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
        //var error:NSError?
        
        do{
            _infoArray = try NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
        }
        catch let error as NSError{
            
            print("could not save \(error),\(error.localizedDescription)")
        }
        let sortArray:NSMutableArray = NSMutableArray()
        if _infoArray.count > 0{
        
        for i in stride(from: _infoArray.count-1, through: 0, by: -1){
            
            sortArray.add(_infoArray[i])
            
        }
        }
        
        _infoArray = sortArray;
        
        
        
        AppStatus.shareInstance().rootVc._isChoose = false
        
        for i in 0  ..< AppStatus.shareInstance().cellArray.count{
            
            print(AppStatus.shareInstance().cellArray.count)
            
            let recordcell = AppStatus.shareInstance().cellArray[i] as! RecordCell
            
            recordcell._chooseBtn.setImage(UIImage(named: ""), for: UIControlState())
            
            recordcell._record.notification = 0
            
            do{
                
                try AppStatus.shareInstance().context.save()
                
            }catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            

            
            let notifications:NSArray = UIApplication.shared.scheduledLocalNotifications! as NSArray
            for notification in notifications{
                
                let dic:NSDictionary = (notification as AnyObject).userInfo! as NSDictionary
                
                if (dic.value(forKey: "id") as! Int == _infoArray.index(of: recordcell._record)){
                    
                    
                    UIApplication.shared.cancelLocalNotification(notification as! UILocalNotification)
                    
                }
                
                
            }

            
            
        }
        
        AppStatus.shareInstance().rootVc._isChoose = false
        
        AppStatus.shareInstance().setTime.alpha = 0
        
        AppStatus.shareInstance().rootVc._tableView.reloadData()
        AppStatus.shareInstance().rootVc._tableView.allowsSelection = true
        
        AppStatus.shareInstance().cellArray.removeAllObjects()
    
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        func scheduleLocalNotification(){
            
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = fixNotificationDate(_datePicker.date)
            
            localNotification.alertBody = "Hey, you must go shopping, remember?"
            localNotification.alertAction = "View List"
            
            localNotification.category = "infoReminderCategory"
            localNotification.userInfo = ["id":1]
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
        
            
        
        }
        
        
        
        func fixNotificationDate(_ dateToFix: Date) -> Date {
            var dateComponets: DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year, NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: dateToFix)
            
            dateComponets.second = 0
            
            let fixedDate: Date! = Calendar.current.date(from: dateComponets)
            
            return fixedDate
        }

        

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
