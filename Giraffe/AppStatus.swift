//
//  AppStatus.swift
//  Do
//
//  Created by 李鑫 on 15/10/22.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreSpotlight
import CoreData

class AppStatus: NSObject {
    
    var cellArray:NSMutableArray!
    var selectedIndex:Int!
    var isOpen:Bool!
    var index:CSSearchableIndex!
    var context:NSManagedObjectContext!
    var toolView:ToolView!
    var rootVc:ViewController!
    var changeColor:ChangeColor!
    var setTime:SetTime!
    var tag:Int!
    
//    var Height:CGFloat!
    //var cell:RecordCell!
   
    fileprivate static let _shareInstance = AppStatus()
    class func shareInstance()->AppStatus{
    
        return _shareInstance
    }
    
    fileprivate override init() {
        
    }
    
}


