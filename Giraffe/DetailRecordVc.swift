//
//  DetailRecordVc.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreData

class DetailRecordVc: UIViewController,UIScrollViewDelegate {

    var _record:Record!
    var _toolBar:UIToolbar!
    var _scrollView:UIScrollView!
    var _pageControl:UIPageControl!
    var _infoArray:NSMutableArray!
    var _textView:NSMutableArray!
    var _writeWord:UITextView!
    var _index:Int!{
    
        didSet{
        
            _pageControl.currentPage = _index
            print(_index);
            self.pageControlClicked(_pageControl)
        }
    
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    init(){
    
        super.init(nibName:nil,bundle:nil)
        _infoArray = NSMutableArray()
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        let timeDesc = NSSortDescriptor(key: "time", ascending: true)
        request.sortDescriptors = [timeDesc]
        
        request.entity = NSEntityDescription.entity(forEntityName: "Record", in: AppStatus.shareInstance().context)
        
        do{
        
            try _infoArray = NSMutableArray(array:AppStatus.shareInstance().context.fetch(request))
        }
        catch let error as NSError{
            
            print("could not save \(error),\(error.localizedDescription)")
        }
        
        let sortArray:NSMutableArray = NSMutableArray()
        if _infoArray.count > 0{
        
        for i in  stride(from: _infoArray.count-1, through: 0, by: -1){
         sortArray.add(_infoArray[i])
        }
        
        }
        _infoArray = sortArray
        
        self.view.layer.cornerRadius = 12
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailRecordVc.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let frame:CGRect = self.view.frame
        
        _textView = NSMutableArray()
        
        _toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
        _toolBar.backgroundColor = UIColor.white
        self.view.addSubview(_toolBar)
        
        self.view.backgroundColor = UIColor.white
        
        let saveButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(DetailRecordVc.save))
        saveButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 17.5)], for: UIControlState())
        saveButton.tintColor = UIColor.lightGray
        
        let flexibleButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
       
        let cancelButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(DetailRecordVc.cancel))
        cancelButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 17.5)], for: UIControlState())
        cancelButton.tintColor = UIColor.lightGray
        
        let buttonArray:NSArray = [cancelButton,flexibleButton,saveButton]
        _toolBar.items = buttonArray as? [UIBarButtonItem]
        
        _scrollView = UIScrollView()
        _scrollView.frame = CGRect(x: 0, y: _toolBar.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height-_toolBar.frame.size.height)
        _scrollView.delegate = self
        
        _scrollView.isPagingEnabled = true
        
        _scrollView.showsHorizontalScrollIndicator = false
        _pageControl = UIPageControl()
        _pageControl.center = CGPoint(x: self.view.center.x, y: self.view.bounds.size.height-30.0)
        _pageControl.currentPage = 0
        _pageControl.addTarget(self, action: #selector(DetailRecordVc.pageControlClicked(_:)), for: UIControlEvents.valueChanged)
        _pageControl.defersCurrentPageDisplay = true
        self.view.addSubview(_scrollView)
        self.view.addSubview(_pageControl)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppStatus.shareInstance().selectedIndex = 0
        _scrollView.contentSize = CGSize(width: _scrollView.bounds.size.width * CGFloat(_infoArray.count), height: _scrollView.bounds.size.height)
        _pageControl.numberOfPages = _infoArray.count;
        _pageControl.currentPage = _index;
        var timeLabel:UILabel!
        var time:UILabel!
        var alertlabel:UIImageView!
        var wordView:UITextView!
     //   var backGroundImage:UIImageView!
        
        for i in 0 ..< _infoArray.count{
            let record:Record = _infoArray[i] as! Record
            
            timeLabel = UILabel()
            timeLabel.frame = CGRect(x: CGFloat(i)*_scrollView.bounds.size.width, y: 0, width: _scrollView.bounds.size.width, height: 40)
            timeLabel.font = UIFont(name: "Heiti SC", size: 16)
            timeLabel.textColor = UIColor.lightGray
            timeLabel.textAlignment = NSTextAlignment.center
            _scrollView.addSubview(timeLabel)
            
            if(record.notification == 1){
            
               // self.view.frame.width/2
                alertlabel = UIImageView()
                alertlabel.frame = CGRect(x: CGFloat(i)*_scrollView.bounds.size.width+10, y: 17.5, width: 5, height: 5)
                //alertlabel.backgroundColor = UIColor.
                alertlabel.layer.cornerRadius = alertlabel.frame.size.width/2
                alertlabel.backgroundColor = UIColor.red
                alertlabel.alpha = 0.5
                _scrollView.addSubview(alertlabel)
                
                time = UILabel()
                time.frame = CGRect(x: CGFloat(i)*_scrollView.bounds.size.width, y: 35, width: _scrollView.bounds.size.width, height: 10)
                time.font = UIFont(name: "Gill Sans", size: 10)
                time.textColor = UIColor.red
                time.alpha = 0.5
                time.textAlignment = NSTextAlignment.center
                _scrollView.addSubview(time)
                
                let formatter2:DateFormatter = DateFormatter()
                formatter2.dateFormat = "yy-MM-dd HH:mm:ss"
                let dateString2:NSString = formatter2.string(from: record.alert! as Date) as NSString
                time.text = dateString2 as String
                
            
            }
            
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "yy-MM-dd HH:mm:ss"
            let dateString:NSString = formatter.string(from: record.time! as Date) as NSString
            timeLabel.text = dateString as String
            
            
            
            
            wordView = UITextView.init(frame: CGRect(x: (CGFloat(i)*_scrollView.bounds.size.width)+5, y: timeLabel.frame.maxY+5, width: _scrollView.frame.size.width-10, height: _scrollView.frame.size.height-timeLabel.frame.size.height-5))
            wordView.font = UIFont(name: "Heiti SC", size: 18)
            wordView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            wordView.text = record.word
            wordView.tintColor = UIColor.lightGray
            wordView.showsHorizontalScrollIndicator = false
            wordView.showsVerticalScrollIndicator = false
            _textView.add(wordView)
            _scrollView.addSubview(wordView)
            
            print(record.notification);
            print(record.alert);
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = _scrollView.bounds.size.width
        let currentPage:CGFloat = _scrollView.contentOffset.x/pageWidth
        let nearestNumber:Int = Int(round(currentPage))
        
        if(_pageControl.currentPage != nearestNumber){
        
            _pageControl.currentPage = nearestNumber
            if(_scrollView.isDragging){
            _pageControl.updateCurrentPageDisplay()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _pageControl.updateCurrentPageDisplay()
        //print(_pageControl.currentPage);
        //_index = _pageControl.currentPage;
    }
    
    func pageControlClicked(_ sender:UIPageControl){
        
//        let pageControl:UIPageControl = sender
//        print(pageControl.currentPage);
        _scrollView.setContentOffset(CGPoint(x: _scrollView.bounds.size.width * CGFloat(_index), y: _scrollView.contentOffset.y), animated: true)
    
    }
    
    func save(){
        
        
        for i in 0 ..< _textView.count{
        
            let view:UITextView = _textView[i] as! UITextView
            view.resignFirstResponder()
            let record:Record = _infoArray[i] as! Record
            record.word = view.text
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: _scrollView.frame.size.height  - view.frame.origin.y);

            
            do{
            
                try AppStatus.shareInstance().context.save()
            }
            
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
        }
        
    }
    
    func cancel(){
    
        for i in 0 ..< _textView.count{
        
            let view:UITextView = _textView[i] as! UITextView
            view.resignFirstResponder()
        }
        AppStatus.shareInstance().isOpen = true
        AppStatus.shareInstance().selectedIndex = -1
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    func showKeyboard(_ notification:Notification){
    
        //print("sada");
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let aValue:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRect:CGRect = aValue.cgRectValue
        let Height:CGFloat = keyboardRect.size.height
        
        for i in 0 ..< _textView.count{
            
            let view:UITextView = _textView[i] as! UITextView
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: _scrollView.frame.size.height - Height - view.frame.origin.y);
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



