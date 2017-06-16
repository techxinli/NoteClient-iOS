//
//  AppStatus.swift
//  Giraffe
//
//  Created by 李鑫 on 15/11/19.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import CoreData

class AppStatus: NSObject {
    
   
    var context:NSManagedObjectContext!

    
    fileprivate static let _shareInstance = AppStatus()
    class func shareInstance()->AppStatus{
        
        return _shareInstance
    }
    
    fileprivate override init() {
        
    }


}
