//
//  zooBrain.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import Foundation
import CoreData

struct HouseResult:Decodable {
    var result:HouseList
}
struct HouseList:Decodable {
    let count:Int
    var results:[HouseDetail]
}
struct HouseDetail:Decodable {
    let E_Name:String
    let E_Info:String
    let E_Category:String
    let E_Memo:String
    let E_Pic_URL:String
    let E_URL:String
}

struct PlantResult:Decodable {
    var result:PlantList
}
struct PlantList:Decodable {
    let count:Int
    var results:[PlantDetail]
}
struct PlantDetail:Decodable {
    let F_Name_Ch:String
    let F_Name_En:String
    let F_Brief:String
    let F_Location:String
    let F_AlsoKnown:String
    let F_Pic01_URL:String
    let F_Feature:String
    let F_Function＆Application:String
    let F_Update:String
}
