//
//  Food.swift
//  test
//
//  Created by yejing zhou on 2016/11/19.
//  Copyright © 2016年 LiMengyan. All rights reserved.
//

import UIKit

struct Food {
    
    var FoodName: String
    var Quantity: String
    var BestbyDate: String
    var Category: String
    
    init(FoodName: String, Quantity: String, BestbyDate: String, Category: String) {
        self.FoodName = FoodName
        self.Quantity = Quantity
        self.BestbyDate = BestbyDate
        self.Category = Category
    }
}

