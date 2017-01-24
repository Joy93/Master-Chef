//
//  Item.swift
//  MasterChef1.1
//
//  Created by yejing zhou on 2016/12/7.
//  Copyright © 2016年 yejing zhou. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Item {
    
    //  let key: String
    let Name: String
    let Completed: Bool
    let ref: FIRDatabaseReference?
    
    
    init(Name: String, Completed: Bool) {
        // self.key = key
        self.Name = Name
        self.Completed = false
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        // key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        Completed = snapshotValue["Completed"] as! Bool
        Name = snapshotValue["Name"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "Name": Name,
            "Completed": Completed
        ]
    }
    
}
