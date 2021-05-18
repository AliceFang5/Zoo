//
//  Plant.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/5/10.
//

import Foundation
import RealmSwift

class Plant: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var name_en:String = ""
    @objc dynamic var brief:String = ""
    @objc dynamic var alsoKnown:String = ""
    @objc dynamic var feature:String = ""
    @objc dynamic var function:String = ""
    @objc dynamic var location:String = ""
    @objc dynamic var picURL:String = ""
    @objc dynamic var update:String = ""
}
