//
//  RecordVc.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreData

class RecordVc: UIViewController,UITextViewDelegate {
    
    var _toolBar:UIToolbar!
    var _scrollView:UIScrollView!
    var _recordInfo:NSDictionary!
    var _writeWord:UITextView!
    var _configureButton:UIBarButtonItem!
    
    var _cancel:UIBarButtonItem!
    var _flexibleButton:UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layer.cornerRadius = 12
        self.view.clipsToBounds = true
        let frame:CGRect = self.view.frame
        _toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 44))
        self.view.addSubview(_toolBar)
        self.view.backgroundColor = UIColor.white
        _cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target:self, action:#selector(RecordVc.cancel))
        _cancel.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 17.5)], for: UIControlState())
        _cancel.tintColor = UIColor.lightGray
        
        
        _configureButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target:self, action:#selector(RecordVc.configure))
        _configureButton.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 17.5)], for: UIControlState())
        _configureButton.tintColor = UIColor.lightGray
        
        _flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        _toolBar.setItems([_cancel,_flexibleButton,_flexibleButton,_flexibleButton,_flexibleButton,_flexibleButton,_flexibleButton,_flexibleButton,_configureButton], animated: true)
        
        _scrollView = UIScrollView(frame:CGRect(x: 0, y: 44, width: frame.size.width, height: frame.size.height-44))
        
        _scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height*5)
        
        self.view.addSubview(_scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RecordVc.tap(_:)))
        
        _scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RecordVc.showKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        _recordInfo = NSDictionary()
        
        self.initUI()
        
    }

    func initUI()
    {
        let textViewImageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 25, height: 25))
       
              textViewImageView.backgroundColor = UIColor(red:CGFloat(CGFloat(arc4random()%256)/255.0), green: CGFloat(Float(arc4random()%256)/255.0), blue: CGFloat(Float(arc4random()%256)/255.0),alpha:CGFloat(0.35))
        textViewImageView.layer.cornerRadius = textViewImageView.frame.size.width/2
        textViewImageView.clipsToBounds = true
        _scrollView.addSubview(textViewImageView);
        
        _writeWord = UITextView(frame: CGRect(x: textViewImageView.frame.maxX+10, y: textViewImageView.frame.origin.y, width: self.view.frame.size.width-20-10-textViewImageView.frame.maxX, height: self.view.frame.size.height-textViewImageView.frame.origin.y))
        _writeWord.textColor = UIColor.lightGray
        
        _writeWord.tintColor = textViewImageView.backgroundColor
        _writeWord.font = UIFont(name:"HeiTi SC", size: 17)
        _writeWord.showsVerticalScrollIndicator = false
        
        _writeWord.layer.cornerRadius = 6
        
        _writeWord.delegate = self
        
        _writeWord.text = "Please Input Word..."
        
        _scrollView.addSubview(_writeWord)
        
//        _configureButton = UIButton(type: UIButtonType.Custom)
//        _configureButton.frame = CGRectMake(20, self.view.frame.size.height-_toolBar.frame.size.height-53, self.view.frame.size.width-40, 43)
//        _configureButton.setImage(UIImage(named: "cancel"), forState:UIControlState.Normal)
//        _configureButton.addTarget(self, action: Selector("configure"), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        _scrollView.addSubview(_configureButton)
        
        _scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(_writeWord.text == "Please Input Word..."){
        
            _writeWord.text = ""
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(_writeWord.text == ""){
        
        }
    }
    
    
    
    //MARK: 收起键盘
    func tap(_ recognizer:UITapGestureRecognizer)
    {
        _writeWord.resignFirstResponder()
        _writeWord.frame = CGRect(x: _writeWord.frame.origin.x, y: _writeWord.frame.origin.y, width: _writeWord.frame.size.width, height: _scrollView.frame.height);
       
        if (_writeWord.text == ""){
            _writeWord.text = "Please Input Word"
        }
        
    
    }
    
    //MARK:保存数据并返回
    
    func configure()
    {
    
        if(_writeWord.text == "Please Input Word...")
        {
        
        }
        
        else if(_writeWord.text != "")
        {
            let date:Date = Date()
            let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: AppStatus.shareInstance().context) as! Record
            record.word = _writeWord.text
            record.time = date
            record.type = "No Define"
            record.color = 8
            record.notification = 0
            //var error:NSError? = nil
            
            do {
            
                try AppStatus.shareInstance().context.save()
             
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
        }
        
        self.cancel()
    
        
    }
    
    
    func cancel()
    {
      _writeWord.resignFirstResponder()
      self.dismiss(animated: true) { () -> Void in
        
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func showKeyboard(_ notification:Notification)
    {
        print("123124");
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let aValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRect = (aValue as AnyObject).cgRectValue
        let Height:CGFloat = (keyboardRect?.size.height)!
        _writeWord.frame = CGRect(x: _writeWord.frame.origin.x, y: _writeWord.frame.origin.y, width: _writeWord.frame.size.width, height: _scrollView.frame.size.height-Height-10)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _writeWord.resignFirstResponder()
        _writeWord.frame = CGRect(x: _writeWord.frame.origin.x, y: _writeWord.frame.origin.y, width: _writeWord.frame.size.width, height: _scrollView.frame.height);
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
