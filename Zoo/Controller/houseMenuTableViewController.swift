//
//  houseMenuTableViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit
import RealmSwift

class houseMenuTableViewController: UITableViewController {
    let realm = try! Realm()
    //realm results
    var houseResults : Results<House>?
    var plantResults : Results<Plant>?
    //data from api
    var houseArray = [House]()
    var plantArray = [Plant]()
    //avoid to save same item into realm
    var houseSet : Set<String> = []
    var plantSet : Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.listCellNibName, bundle: nil), forCellReuseIdentifier: K.listCellIdentifier)

        title = "台北市立動物園"
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadHouseFromRealmData()
        loadHouseFromApi()
        loadPlantFromRealmData()
        loadPlantFromApi()
        //for debug
//        deleteHouseData()
//        deletePlantData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseResults!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellIdentifier, for: indexPath) as! listCell
        if let house = houseResults?[indexPath.row]{
            cell.update(with:house)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select houseList row: \(indexPath.row)")
        performSegue(withIdentifier: K.houseDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.houseDetailSegue{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationVC = segue.destination as! houseDetailViewController
                destinationVC.house = houseResults?[indexPath.row]
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveHouseData(){
        print(#function)
        houseArray.forEach { (house) in
//            print(house)
            do{
                try realm.write{
                    realm.add(house)
                }
            }catch{
                print("Saving house err:\(error)")
            }
        }
        tableView.reloadData()
    }
    func savePlantData(){
        print(#function)
        plantArray.forEach { (plant) in
//            print(plant)
            do{
                try realm.write{
                    realm.add(plant)
                }
            }catch{
                print("Saving plant err:\(error)")
            }
        }
//        tableView.reloadData()//this view controller don't need to show plant data
    }
    func loadHouseFromRealmData(){
        houseResults = realm.objects(House.self)
//        print(houseResults)
        houseResults = houseResults?.sorted(byKeyPath: "picURL", ascending: true)
//        print(houseResults)
        houseResults?.forEach({ (house) in
            houseSet.insert(house.name)
        })
        print("houseSet:\(houseSet)")
        tableView.reloadData()
    }
    func loadPlantFromRealmData(){
        plantResults = realm.objects(Plant.self)
//        print(plantResults)
        plantResults = plantResults?.sorted(byKeyPath: "picURL", ascending: true)
//        print(plantResults)
        plantResults?.forEach({ (plant) in
            plantSet.insert(plant.name)
        })
        print("plantSet:\(plantSet)")
//        tableView.reloadData()//this view controller don't need to show plant data
    }
    func loadHouseFromApi(){
        print(#function)
        let urlStr = "https://data.taipei/api/v1/dataset/5a0e5fbb-72f8-41c6-908e-2fb25eff9b8a?scope=resourceAquire"
        if let url = URL(string: urlStr){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                if let data = data, let houseData = try? JSONDecoder().decode(HouseResult.self, from: data){
                    let houseList = houseData.result.results
                    print("load house from API done:")
                    print(houseData.result.count)
                    print(houseList[0].E_Name)
                    print(houseList[0].E_Info)
                    print(houseList[0].E_Category)
                    print(houseList[0].E_Memo)
                    print(houseList[0].E_Pic_URL)
                    print(houseList[0].E_URL)
                    self.houseArray = []
                    houseList.forEach { (house) in
                        let newItem = House()
                        newItem.name = house.E_Name
                        newItem.category = house.E_Category
                        newItem.info = house.E_Info
                        newItem.memo = house.E_Memo
                        newItem.picURL = house.E_Pic_URL
                        newItem.url = house.E_URL
                        //avoid to save same item into realm
                        if(self.houseSet.insert(newItem.name).inserted){
                            self.houseArray.append(newItem)
                        }
                    }
                    DispatchQueue.main.async {
                        //execute saveHouseData() in DispatchQueue.main.async due to runtime error: Realm accessed from incorrect thread
                        self.saveHouseData()
                    }
                }
            }
            task.resume()
        }
    }
    func loadPlantFromApi(){
        let urlStr = "https://data.taipei/api/v1/dataset/f18de02f-b6c9-47c0-8cda-50efad621c14?scope=resourceAquire&limit=230"
        if let url = URL(string: urlStr){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                if let data = data, let plantData = try? JSONDecoder().decode(PlantResult.self, from: data){
                    let plantList = plantData.result.results
                    print("load plant from API done:")
                    print(plantData.result.count)
                    print(plantList[0].F_Name_Ch)
                    print(plantList[0].F_Brief)
                    print(plantList[0].F_Name_En)
                    print(plantList[0].F_AlsoKnown)
                    print(plantList[0].F_Feature)
                    print(plantList[0].F_Pic01_URL)
                    print(plantList[0].F_Function＆Application)
                    print(plantList[0].F_Update)
                    print(plantList[0].F_Location)
                    self.plantArray = []
                    plantList.forEach { (plant) in
                        let newItem = Plant()
                        newItem.name = plant.F_Name_Ch
                        newItem.name_en = plant.F_Name_En
                        newItem.location = plant.F_Location
                        newItem.brief = plant.F_Brief
                        newItem.alsoKnown = plant.F_AlsoKnown
                        newItem.feature = plant.F_Feature
                        newItem.function = plant.F_Function＆Application
                        newItem.picURL = plant.F_Pic01_URL
                        newItem.update = plant.F_Update
                        //avoid to save same item into realm
                        if(self.plantSet.insert(newItem.name).inserted){
                            self.plantArray.append(newItem)
                        }
                    }
                    DispatchQueue.main.async {
                        //execute saveHouseData() in DispatchQueue.main.async due to runtime error: Realm accessed from incorrect thread
                        self.savePlantData()
                    }
                }
            }
            task.resume()
        }
    }
    func deleteHouseData(){
        print(#function)
        do {
            try realm.write {
                realm.delete(houseResults!)
            }
        } catch {
            print("Delete houseResults to realm failure with \(error)")
        }
    }
    func deletePlantData(){
        print(#function)
        do {
            try realm.write {
                realm.delete(plantResults!)
            }
        } catch {
            print("Delete plantResults to realm failure with \(error)")
        }
    }
}

