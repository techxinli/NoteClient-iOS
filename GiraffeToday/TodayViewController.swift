//
//  TodayViewController.swift
//  GiraffeToday
//
//  Created by 李鑫 on 15/11/18.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    
    
    struct TableViewConstants{
        static let cellIdentifier = "Cell"
    }

//    var _tableView:UITableView!
    
    var _store:NSPersistentStore!
    var _infoArray:NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _infoArray = NSMutableArray()
        
        let model:NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        
        let psc:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: model)
        
        let fileManager = FileManager.default
        let containerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.Giraffe")
        let storeURL = containerURL?.appendingPathComponent("record.data");
        do {
            
            try _store = psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            
            
        }
        catch let error as NSError{
            
            print("could not save \(error),\(error.localizedDescription)")
        }
        
        
        let context:NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = psc
        
        AppStatus.shareInstance().context = context
        
        self.initData()
        
        // Do any additional setup after loading the view from its nib.
    }
    
    func initData(){
    
    
        
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
        
    
    }
    
    func resetContentSize(){
        self.preferredContentSize = tableView.contentSize
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        resetContentSize()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetContentSize()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }



   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _infoArray.count
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    let cell:UITableViewCell = tableView.dequeueReusableCell(
        withIdentifier: TableViewConstants.cellIdentifier,for: indexPath) as UITableViewCell
    let record:Record = _infoArray[indexPath.row] as! Record
    cell.textLabel?.text = record.word
    cell.textLabel?.textColor = UIColor.white
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.textLabel?.font = UIFont(name: "Avenir-Light", size: 17)
    
    let textViewImageView = UIImageView(frame: CGRect(x: 0, y:0, width: 2.5, height: cell.frame.height))
    
    textViewImageView.backgroundColor = UIColor(red:CGFloat(CGFloat(arc4random()%256)/255.0), green: CGFloat(Float(arc4random()%256)/255.0), blue: CGFloat(Float(arc4random()%256)/255.0),alpha:CGFloat(0.6))
    
    cell.contentView.addSubview(textViewImageView)

    
    return cell
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.initData()
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            //let urlAsString = "widget://" + "\(indexPath.section)-\(indexPath.row)"
            let urlAsString = "widget://" + "com.Giraffe.Lee"
            let url = URL(string: urlAsString)
            self.extensionContext!.open(url!, completionHandler: nil)
            
            let shared:UserDefaults = UserDefaults.init(suiteName:"group.Open")!
            shared.set(indexPath.row, forKey: "Index")
            
            tableView.deselectRow(at: indexPath, animated: false)
            
    }
   
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
      

        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
