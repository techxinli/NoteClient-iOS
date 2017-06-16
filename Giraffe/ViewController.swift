//
//  ViewController.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreSpotlight
import CoreData


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIViewControllerPreviewingDelegate {
    
    var _tableView:UITableView!
    var _toolbar:UIToolbar!
    var _infoArray:NSMutableArray!
    var _cellArray:NSMutableArray!
    var _detail:DetailRecordVc!
    var _index:CSSearchableIndex!
    var _finished:Bool!
    var _store:NSPersistentStore!
    var _isChoose:Bool!
    
    
    var _store1:NSPersistentStore!

    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
        _tableView.reloadData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNotificationSettings()
       
//        let addItem:UIApplicationShortcutItem = UIApplicationShortcutItem.init(type: "one", localizedTitle: "New Project", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Add), userInfo: nil)
//        UIApplication.sharedApplication().shortcutItems = [addItem]
        
        _isChoose = false
        
        AppStatus.shareInstance().rootVc = self
        AppStatus.shareInstance().cellArray = NSMutableArray()
        
        _index = CSSearchableIndex.default()
        //self.view.layer.cornerRadius = 12
        self.view.clipsToBounds = true
        
        _infoArray = NSMutableArray()
        _cellArray = NSMutableArray()
        
        let model:NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        
        let psc:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        
        let fileManager = FileManager.default
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.Giraffe")
        let storeURL = containerURL?.appendingPathComponent("record.data");
        
        
//        let docs:NSString = NSSearchPathForDirectoriesInDomains(.DocumentationDirectory, .UserDomainMask, true)[0]
//        
//        let url:NSURL = NSURL.fileURLWithPath(docs.stringByAppendingString("record.data"))
        
        do {
            
            try _store = psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            
        
        }
        catch let error as NSError{
            
            print("could not save \(error),\(error.localizedDescription)")
        }
        
        
        let context:NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = psc
        
        AppStatus.shareInstance().context = context
        
        _tableView = UITableView.init(frame:CGRect(x: 0, y: 44, width: self.view.frame.size.width, height: self.view.frame.size.height-44) , style: UITableViewStyle.plain)
        
        _tableView.delegate = self
        
        _tableView.dataSource = self
        
        _tableView.separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        if(traitCollection.forceTouchCapability == .available){
        
        self.registerForPreviewing(with: self, sourceView: _tableView)
            
        }
        
        
        
        self.view.addSubview(_tableView)
        self.addToolBar()
        self.initData()
    
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let record:Record = _infoArray[indexPath.row] as! Record
        let indentifer:NSString = "cell"
    
        
        var cell:RecordCell? = tableView.dequeueReusableCell(withIdentifier: indentifer as String) as? RecordCell
        
        if (cell == nil) {
        
            cell = RecordCell.init(style: UITableViewCellStyle.default, reuseIdentifier: indentifer as String)
        
        }
        if(_isChoose == true){
        
            cell?._colorImage.alpha = 0
            cell?._colorImage1.alpha = 0
            cell?._chooseBtn.alpha = 1
        }
        
        else if(_isChoose == false){
        
            cell?._colorImage.alpha = 1
            cell?._colorImage1.alpha = 1
            cell?._chooseBtn.alpha = 0
        
        }
 
//        cell?._timeLabel.frame = CGRectMake(self.view.frame.size.width-55,12 , 45, 22)
    
//        cell?.selectedBackgroundView = UIView.init(frame: (cell?.frame)!)
//        cell?.selectedBackgroundView?.backgroundColor = cell?._colorImage.backgroundColor
        
        cell?._record = record
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _detail = DetailRecordVc()
        _detail._record = _infoArray[indexPath.row] as! Record
        _detail._index = indexPath.row
        self.present(_detail, animated: true) { () -> Void in
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            let record:Record = _infoArray[indexPath.row] as! Record
            AppStatus.shareInstance().context.delete(record)
            
            do {
                
                try AppStatus.shareInstance().context.save()
                
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
            self.initData()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func addToolBar(){
    
        let frame:CGRect = self.view.frame
        
        _toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
        self.view.addSubview(_toolbar)
        
        let removeButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace
            , target: self, action: nil)
        
        removeButton.tintColor = UIColor.lightGray
        
        let flexibleButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action:nil)
        
        let addButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.add))
        
        addButton.tintColor = UIColor.lightGray
        
        let buttonArray:NSArray = [removeButton,flexibleButton,addButton]
        _toolbar.items = buttonArray as? [UIBarButtonItem]
        
    
    }
    
    func remove(){
    
        print("1231");
        
        if (AppStatus.shareInstance().setTime != nil){
            AppStatus.shareInstance().setTime.cancel()}
        if (AppStatus.shareInstance().changeColor != nil){
            AppStatus.shareInstance().changeColor.cancel()}
        
        if (AppStatus.shareInstance().toolView != nil){
            AppStatus.shareInstance().toolView.alpha = 0;
        }
        

    }
    
    func add(){
    
        let record:RecordVc = RecordVc()
        self.present(record, animated: true) { () -> Void in
            
        }
    
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if(motion == UIEventSubtype.motionShake&&_infoArray.count>0){
        
            let detail:DetailRecordVc = DetailRecordVc()
            let random = arc4random()%(UInt32(_infoArray.count))
            detail._index = Int(random)
            self.present(detail, animated: true, completion: { () -> Void in
                
            })
        
        }
    }
    
    func initData(){
    
        if ((AppStatus.shareInstance().context) != nil){
        
            let model1:NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
            
            let psc1:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model1)
            
            let docs:NSString = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)[0] as NSString
            
            let storeURL1:URL = URL(fileURLWithPath: docs.appending("record.data"))
            
            do {
                
                try _store1 = psc1.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL1, options: nil)
                
                
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
            
            let context1:NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
            
            context1.persistentStoreCoordinator = psc1
            
            let request1: NSFetchRequest<Record> = Record.fetchRequest()
            let timeDesc1:NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            request1.sortDescriptors = [timeDesc1]
            request1.entity = NSEntityDescription.entity(forEntityName: "Record", in: context1)
            var infoArray:NSMutableArray! = NSMutableArray()
            do{
                infoArray = try NSMutableArray(array: context1.fetch(request1))
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
            print(infoArray)
            
            if (infoArray.count > 0){
            
                for i in stride(from: _infoArray.count-1, through: 0, by: -1){
                    
                   let record1 = infoArray[i] as! Record
                    
                   let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: AppStatus.shareInstance().context) as! Record
                    
                    record.word = record1.word
                    record.time = record1.time
                    record.type = record1.type
                    record.color = record1.color
                    record.notification = record1.notification;
                    
                    context1.delete(record1)
                    
                    
                    do {
                        
                        try context1.save()
                        
                    }
                    catch let error as NSError{
                        
                        print("could not save \(error),\(error.localizedDescription)")
                    }
                    

                    
                    do {
                        
                        try AppStatus.shareInstance().context.save()
                        
                    }
                    catch let error as NSError{
                        
                        print("could not save \(error),\(error.localizedDescription)")
                    }
                    
                }
                

            }

        
            
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
    
            
//            let userDefaults = NSUserDefaults(suiteName: "group.Giraffe")
//            userDefaults?.setValue(_infoArray, forKey: "info")
            
            _index = CSSearchableIndex.default()
            _index.deleteAllSearchableItems(completionHandler: {(error:Error?) -> Void in
                if(error == nil){
                   self.saveData()
                }
                else{
                   NSException.raise(NSExceptionName(rawValue: "查询错误"), format: "\(error?.localizedDescription)", arguments: getVaList([error! as CVarArg]))
                }
                
            })
      

        }
        
}
        func saveData(){
            _index = CSSearchableIndex.default()
            
            //MARK CSSearchableItem
            var indexArray = [CSSearchableItem]()
            
            for i in 0 ..< _infoArray.count{
            
                let attributeSet:CSSearchableItemAttributeSet = CSSearchableItemAttributeSet.init(itemContentType: "view")
                let record:Record = _infoArray[i] as! Record
                attributeSet.title = record.word
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = "yy-MM-dd HH:mm:ss"
                let dateString:NSString = formatter.string(from: record.time! as Date) as NSString
                attributeSet.contentDescription = dateString as String
                attributeSet.keywords =  [record.word! ,dateString as String,record.type!]
                let thumbImage:UIImage = UIImage(named: "icon")!
                attributeSet.thumbnailData = UIImagePNGRepresentation(thumbImage)
                let item:CSSearchableItem = CSSearchableItem.init(uniqueIdentifier:"\(i)", domainIdentifier: "com.Lee.Giraffe", attributeSet: attributeSet)
                indexArray.append(item)
                _index.indexSearchableItems(indexArray as [CSSearchableItem], completionHandler: { (error:Error?) -> Void in
                    
                    if (error == nil){
                    
                    }
                    
                })
                
            }
           
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        if (AppStatus.shareInstance().setTime != nil){
            AppStatus.shareInstance().setTime.cancel()}
        if (AppStatus.shareInstance().changeColor != nil){
            AppStatus.shareInstance().changeColor.cancel()}
        
        if (AppStatus.shareInstance().toolView != nil){
        AppStatus.shareInstance().toolView.alpha = 0;
        }
        
    }
    
    func setupNotificationSettings(){
        
        let notificationSettings:UIUserNotificationSettings! = UIApplication.shared.currentUserNotificationSettings
        
        if(notificationSettings.types == UIUserNotificationType()){
            
            
            let notificationTypes:UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.sound]
            let justInformAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            justInformAction.identifier = "justInform"
            justInformAction.title = "OK,got it"
            justInformAction.activationMode = UIUserNotificationActivationMode.background
            justInformAction.isDestructive = false
            justInformAction.isAuthenticationRequired = false
            
            let modifyListAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            modifyListAction.identifier = "editList"
            modifyListAction.title = "Edit list"
            modifyListAction.activationMode = UIUserNotificationActivationMode.foreground
            modifyListAction.isDestructive = false
            modifyListAction.isAuthenticationRequired = true
            
            let trashAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
            trashAction.identifier = "trashAction"
            trashAction.title = "Delete list"
            trashAction.activationMode = UIUserNotificationActivationMode.background
            trashAction.isDestructive = true
            trashAction.isAuthenticationRequired = true
            
            
            let actionsArray = NSArray(objects: justInformAction, modifyListAction, trashAction)
            let actionsArrayMinimal = NSArray(objects: trashAction, modifyListAction)
            
            let infoReminderCategory = UIMutableUserNotificationCategory()
            infoReminderCategory.identifier = "infoReminderCategory"
            infoReminderCategory.setActions(actionsArray as? [UIUserNotificationAction], for: UIUserNotificationActionContext.default)
            infoReminderCategory.setActions(actionsArrayMinimal as? [UIUserNotificationAction], for: UIUserNotificationActionContext.minimal)
            
            let categoriesForSetting = NSSet(object: infoReminderCategory)
            
            
            let newNotificationSetting = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSetting as? Set<UIUserNotificationCategory>)
            UIApplication.shared.registerUserNotificationSettings(newNotificationSetting)
        }
        
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = _tableView?.indexPathForRow(at: location) else {return nil}
        guard let cell = _tableView?.cellForRow(at: indexPath) else {return nil}
        guard let detailVc:DetailRecordVc = DetailRecordVc() else {return nil}
        
        detailVc._record = _infoArray[indexPath.row] as! Record
        detailVc._index = indexPath.row
        
        detailVc.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.frame
        return detailVc

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

