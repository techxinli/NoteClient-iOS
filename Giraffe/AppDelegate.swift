
//
//  AppDelegate.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//



import UIKit
import CoreSpotlight
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _viewVc:ViewController!
    var _infoArray:NSMutableArray!
    var shortcutItem:UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        

        var preformShortcutDelegate = true
        
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            print("Application launched via shortcut")
            self.shortcutItem = shortcutItem
            
            preformShortcutDelegate = false
        }
        
        
        
        //AppStatus.shareInstance().color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        AppStatus.shareInstance().selectedIndex = -1
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        //self.window?.layer.cornerRadius = 12
        self.window?.clipsToBounds = true
        //_root = RootViewController()
        _viewVc = ViewController()
        self.window?.rootViewController = _viewVc
        self.window?.makeKeyAndVisible()
        
        let shared:UserDefaults = UserDefaults.init(suiteName:"group.Open")!
        
        if (shared.value(forKey: "Index") != nil){
            
            let Index:Int =  shared.value(forKey: "Index") as! Int
            let request:NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [timeDesc]
            
            request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
            
            do{
                
                try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
                
            }
                
            catch let error as NSError{
                
                print( "the error is \(error)")
                
            }
            
            let sortArray:NSMutableArray = NSMutableArray()
            if _infoArray.count > 0{
            for  i in stride(from: _infoArray.count-1, through: 0, by: -1){
                
                sortArray.add(_infoArray[i])
            }
            }
            _infoArray = sortArray
            
            
            if(AppStatus.shareInstance().selectedIndex == -1){
                
                _viewVc._detail = DetailRecordVc()
                _viewVc._detail._record = _infoArray[Index] as! Record
                _viewVc._detail._index = Index
                _viewVc.present(_viewVc._detail, animated: true, completion: { () -> Void in
                    AppStatus.shareInstance().selectedIndex = 0
                    
                    shared.set(nil, forKey: "Index")
                })
                
            }
                
            else if(AppStatus.shareInstance().selectedIndex==0 && _viewVc._detail._index != Index){
                
                if(_viewVc._detail._index != Index){
                    
                    _viewVc._detail._index = Index
                    shared.set(nil, forKey: "Index")
                }
                
            }
            
        }

        
        // Override point for customization after application launch.
        return preformShortcutDelegate
       // return true
    }
    
    

    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        
        let dic:NSDictionary = notification.userInfo! as NSDictionary
        
        print(dic.value(forKey: "id")!)
        
        let request:NSFetchRequest<Record> = Record.fetchRequest()
        let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [timeDesc]
        
        request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
        
        do{
            
            try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
            
        }
            
        catch let error as NSError{
            
            print( "the error is \(error)")
            
        }
        
        let sortArray:NSMutableArray = NSMutableArray()
        if _infoArray.count > 0{
        for i in stride(from: _infoArray.count-1, through: 0, by: -1){
            
            sortArray.add(_infoArray[i])
        }
        }
        
        _infoArray = sortArray
        
        if(AppStatus.shareInstance().selectedIndex == -1){
            
            _viewVc._detail = DetailRecordVc()
            let index:Int = dic.value(forKey: "id")! as! Int
            _viewVc._detail._record = _infoArray[index] as! Record
            _viewVc._detail._index = index
            _viewVc.present(_viewVc._detail, animated: true, completion: { () -> Void in
                AppStatus.shareInstance().selectedIndex = 0
            })
            
        }
            
        else if(AppStatus.shareInstance().selectedIndex==0 && _viewVc._detail._index != dic.value(forKey: "id")! as! Int){
            
            if(_viewVc._detail._index != dic.value(forKey: "id")! as! Int){
                
                _viewVc._detail._index = dic.value(forKey: "id")! as! Int
            }
            
        }
        
        _viewVc._detail._record.notification = 0
        
        do{
            
            try AppStatus.shareInstance().context.save()
            
        }catch let error as NSError{
            
            print("the error is \(error)")
            
        }
        
        UIApplication.shared.cancelLocalNotification(notification)
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    
        
        if identifier == "editList"{
        
            let dic:NSDictionary = notification.userInfo! as NSDictionary
            
            print(dic.value(forKey: "id")!)
            
            let request:NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [timeDesc]
            
            request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
            
            do{
                
                try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
                
            }
                
            catch let error as NSError{
                
                print( "the error is \(error)")
                
            }
            
            let sortArray:NSMutableArray = NSMutableArray()
            if _infoArray.count > 0{
            for i in stride(from: _infoArray.count-1, through: 0, by: -1){
                
                sortArray.add(_infoArray[i])
            }
            }
            
            _infoArray = sortArray
            
            if(AppStatus.shareInstance().selectedIndex == -1){
                
                _viewVc._detail = DetailRecordVc()
                let index:Int = dic.value(forKey: "id")! as! Int
                _viewVc._detail._record = _infoArray[index] as! Record
                _viewVc._detail._index = index
                _viewVc.present(_viewVc._detail, animated: true, completion: { () -> Void in
                    AppStatus.shareInstance().selectedIndex = 0
                })
                
            }
                
            else if(AppStatus.shareInstance().selectedIndex==0 && _viewVc._detail._index != dic.value(forKey: "id")! as! Int){
                
                if(_viewVc._detail._index != dic.value(forKey: "id")! as! Int){
                    
                    _viewVc._detail._index = dic.value(forKey: "id")! as! Int
                }
                
            }
            
            _viewVc._detail._record.notification = 0
            
            do{
            
               try AppStatus.shareInstance().context.save()
            
            }catch let error as NSError{
            
                print("the error is \(error)")
            
            }

            UIApplication.shared.cancelLocalNotification(notification)
            
        }
        
        else if identifier == "trashAction"{
            
            let dic:NSDictionary = notification.userInfo! as NSDictionary
            
            print(dic.value(forKey: "id")!)
            
            let request:NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [timeDesc]
            
            request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
            
            do{
                
                try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
                
            }
                
            catch let error as NSError{
                
                print( "the error is \(error)")
                
            }
            
            let sortArray:NSMutableArray = NSMutableArray()
            if _infoArray.count > 0{
            for i in stride(from: _infoArray.count-1, through: 0, by: -1){
                
                sortArray.add(_infoArray[i])
            }
            }
            
            _infoArray = sortArray
            let index:Int = dic.value(forKey: "id")! as! Int
            let record:Record = _infoArray[index] as! Record
            
            AppStatus.shareInstance().context.delete(record)
            
            do {
                
                try AppStatus.shareInstance().context.save()
                
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
           UIApplication.shared.cancelLocalNotification(notification)
            
            AppStatus.shareInstance().rootVc.initData()
            AppStatus.shareInstance().rootVc._tableView.reloadData()

            
        }
        
        completionHandler()
    }
    
    
    // 3D Touch
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleShortcut(shortcutItem))
        
    }
    
    func handleShortcut(_ shortcutItem:UIApplicationShortcutItem) -> Bool{
    
        
        var succeeded = false
        if (shortcutItem.type == "com.Giraffe.com"){
        
            _viewVc.add()
            succeeded = true
        
        }
        
        return succeeded
    
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if (AppStatus.shareInstance().toolView != nil){
            AppStatus.shareInstance().toolView.alpha = 0}
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
         let shared:UserDefaults = UserDefaults.init(suiteName:"group.Open")!
        
        if (shared.value(forKey: "Index") != nil){
            
         let Index:Int =  shared.value(forKey: "Index") as! Int
            let request:NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [timeDesc]
            
            request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
            
            do{
                
                try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
                
            }
                
            catch let error as NSError{
                
                print( "the error is \(error)")
                
            }
            
            let sortArray:NSMutableArray = NSMutableArray()
            if _infoArray.count > 0{
            for i in stride(from: _infoArray.count-1, through: 0, by: -1){
                
                sortArray.add(_infoArray[i])
            }
            }
            
            _infoArray = sortArray

            
            if(AppStatus.shareInstance().selectedIndex == -1){
                
                _viewVc._detail = DetailRecordVc()
                _viewVc._detail._record = _infoArray[Index] as! Record
                _viewVc._detail._index = Index
                _viewVc.present(_viewVc._detail, animated: true, completion: { () -> Void in
                    AppStatus.shareInstance().selectedIndex = 0
                    
                    shared.set(nil, forKey: "Index")
                })
                
            }
                
            else if(AppStatus.shareInstance().selectedIndex==0 && _viewVc._detail._index != Index){
                
                if(_viewVc._detail._index != Index){
                    
                    _viewVc._detail._index = Index
                    shared.set(nil, forKey: "Index")
                }
                
            }

        }
        AppStatus.shareInstance().rootVc.initData()
        AppStatus.shareInstance().rootVc._tableView.reloadData()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        handleShortcut(shortcut)
        
        self.shortcutItem = nil
        
//        AppStatus.shareInstance().rootVc.initData()
//        AppStatus.shareInstance().rootVc._tableView.reloadData()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if(userActivity.activityType == CSSearchableItemActionType){
        
            
            let uniqueIdentifier:NSString = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as! NSString
            let request:NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [timeDesc]
            
            print(uniqueIdentifier.integerValue)
            
            request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
            
            do{
                
            try _infoArray = NSMutableArray(array: AppStatus.shareInstance().context.fetch(request))
            
            }
            
            catch let error as NSError{
            
                print( "the error is \(error)")
                
            }
            
            let sortArray:NSMutableArray = NSMutableArray()
            if _infoArray.count > 0{
            for  i in stride(from: _infoArray.count-1, through: 0, by: -1){
            
                sortArray.add(_infoArray[i])
            }
            }
            
            _infoArray = sortArray
            
            if(AppStatus.shareInstance().selectedIndex == -1){
            
                _viewVc._detail = DetailRecordVc()
                let index:Int = uniqueIdentifier.integerValue
                _viewVc._detail._record = _infoArray[index] as! Record
                _viewVc._detail._index = index
                _viewVc.present(_viewVc._detail, animated: true, completion: { () -> Void in
                    AppStatus.shareInstance().selectedIndex = 0
                })
                
            }
            
            else if(AppStatus.shareInstance().selectedIndex==0 && _viewVc._detail._index != uniqueIdentifier.integerValue){
            
                if(_viewVc._detail._index != uniqueIdentifier.integerValue){
                
                    _viewVc._detail._index = uniqueIdentifier.integerValue
                }
                
            }
        }
        return true
    }
}

