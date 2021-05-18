//
//  File.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/5/10.
//

import Foundation
import RealmSwift

class House: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var category:String = ""
    @objc dynamic var info:String = ""
    @objc dynamic var memo:String = ""
    @objc dynamic var picURL:String = ""
    @objc dynamic var url:String = ""
}
