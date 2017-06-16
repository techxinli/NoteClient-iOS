//
//  ActionRequestHandler.swift
//  GiraffeNotes
//
//  Created by 李鑫 on 15/11/15.
//  Copyright © 2015年 Miracle Lee. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    var _store:NSPersistentStore!
    var extensionContext: NSExtensionContext?
    
    func beginRequest(with context: NSExtensionContext) {
        self.extensionContext = context
        let identifierType = NSString(format: kUTTypePropertyList, String.Encoding.utf8 as! CVarArg)
        for item: NSExtensionItem in context.inputItems  as! [NSExtensionItem]{
            for itemProvider: NSItemProvider in item.attachments as! [NSItemProvider] {
                if itemProvider.hasItemConformingToTypeIdentifier(identifierType as String) {
                    itemProvider.loadItem(forTypeIdentifier: identifierType as String, options: nil, completionHandler: {(item, error) in
                        let dictionary = item as! NSDictionary
                        DispatchQueue.main.async(execute: {
                            self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary)
                        })
                    })
                }
            }
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: NSDictionary) {
        if let text = javaScriptPreprocessingResults["args"] as? String {
            
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

            let date:Date = Date()
            let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
            record.word = text
            record.time = date
            record.type = "No Define"
            record.color = 8
            record.notification = 0
            
                        //var error:NSError? = nil
            
            do {
                
                try context.save()
                
            }
            catch let error as NSError{
                
                print("could not save \(error),\(error.localizedDescription)")
            }
            
//            let userDefaults = NSUserDefaults(suiteName: "group.name")
//            userDefaults!.setValue(text, forKey: "note")
//            userDefaults!.synchronize()
             self.doneWithResults(["message": "Successfully Add To Giraffe"])
        }
    }
    
    func doneWithResults(_ resultsForJavaScriptFinalizeArg: NSDictionary?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            let identifierType = NSString(format: kUTTypePropertyList, String.Encoding.utf8 as! CVarArg)
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.
            
            // These will be used as the arguments to the JavaScript finalize()
            // method.
            
            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            let resultsProvider = NSItemProvider(item: resultsDictionary as NSSecureCoding?, typeIdentifier: identifierType as String)
            
            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // Signal that we're complete, returning our results.
            self.extensionContext!.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        } else {
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }
}
