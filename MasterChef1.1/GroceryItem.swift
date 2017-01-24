//
//  GroceryItem.swift
//  MasterChef
//
//  Created by yejing zhou on 2016/12/2.
//  Copyright © 2016年 yejing zhou. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct GroceryItem {
    
  //  let key: String
    let BestbyDate: String
    let Quantity: String
    let Name: String
    let ref: FIRDatabaseReference?
    
    
    init(Name: String, BestbyDate: String, Quantity: String/*, ref: FIRDatabaseReference*/) {
       // self.key = key
        self.Name = Name
        self.BestbyDate = BestbyDate
        self.Quantity = Quantity
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
       // key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        Name = snapshotValue["Name"] as! String
        BestbyDate = snapshotValue["BestbyDate"] as! String
        Quantity = snapshotValue["Quantity"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "Name": Name,
            "BestbyDate": BestbyDate,
            "Quantity":  Quantity
        ]
    }
    
}
