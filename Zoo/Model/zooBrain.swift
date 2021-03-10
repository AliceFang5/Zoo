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
/*
//Using Codable with Core Data and NSManagedObject
//https://www.donnywals.com/using-codable-with-core-data-and-nsmanagedobject/
class PlantItem: NSManagedObject, Decodable{
    enum CodingKeys: CodingKey{
        case id, label, completions
    }
    required convenience init(from decoder: Decoder) throws{
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else{
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context:context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.label = try container.decode(String.self, forKey: .label)
        self.completions = try container.decode(Set<PlantCompletion>.self, forKey: .completions) as NSSet
    }
}

class PlantCompletion: NSManagedObject, Decodable{
    enum CodingKeys: CodingKey{
        case completionDate
    }
    required convenience init(from decoder: Decoder) throws{
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context:context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.completionDate = try container.decode(Date.self, forKey: .completionDate)
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue:"managedObjectContext")!
}

enum DecoderConfigurationError: Error{
    case missingManagedObjectContext
}
*/

