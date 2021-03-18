//
//  houseMenuTableViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit
import CoreData

class houseMenuTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var houseArray = [House]()
    var houseSet : Set<String> = []
    var plantArray = [Plant]()
    var plantSet : Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.listCellNibName, bundle: nil), forCellReuseIdentifier: K.listCellIdentifier)

        title = "台北市立動物園"
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadHouseFromCoreData()
        loadHouseFromApi()
//        deleteHouseCoreData()//for demo, need execute loadHouseFromCoreData first
        loadPlantFromCordData()
        loadPlantFromApi()
//        deletePlantCoreData()//for demo, need execute loadPlantFromCordData first
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellIdentifier, for: indexPath) as! listCell
        let house = houseArray[indexPath.row]
        cell.update(with:house)
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
                destinationVC.house = houseArray[indexPath.row]
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveHouseCoreData(){
        print(#function)
        do{
            try context.save()
        }catch{
            print("Saving house err:\(error)")
        }
    }
    func savePlantCoreData(){
        print(#function)
        do {
            try context.save()
        }catch{
            print("Saving plant err:\(error)")
        }
    }
    func loadHouseFromCoreData(){
        do {
            let request:NSFetchRequest<House> = House.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            houseArray = try context.fetch(request)
            print("Core data houseArray.count:\(houseArray.count)")
            tableView.reloadData()
            
            for house in houseArray{
                houseSet.insert(house.name!)
            }
            print("houseSet:\(houseSet)")
        } catch {
            print("Fetching house err:\(error)")
        }
    }
    func loadPlantFromCordData(){
        do{
            let request:NSFetchRequest<Plant> = Plant.fetchRequest()
            plantArray = try context.fetch(request)
            print("Core data plantArray.count:\(plantArray.count)")
            
            for plant in plantArray{
                plantSet.insert(plant.name!)
            }
            print("plantSet:\(plantSet)")
        }catch{
            print("Fetch context err with \(error)")
        }
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
                    houseList.forEach { (house) in
                        let newItem = House(context: self.context)
                        newItem.name = house.E_Name
                        newItem.category = house.E_Category
                        newItem.info = house.E_Info
                        newItem.memo = house.E_Memo
                        newItem.picURL = house.E_Pic_URL
                        newItem.url = house.E_URL
                        
                        if(self.houseSet.insert(newItem.name!).inserted){
                            self.houseArray.append(newItem)
//                            print("houseSet insert return true")
                        }else{
//                            print("houseSet insert return false")
                            self.context.delete(newItem)
                        }
                    }
                    self.saveHouseCoreData()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
                    plantList.forEach { (plant) in
                        let newItem = Plant(context: self.context)
                        newItem.name = plant.F_Name_Ch
                        newItem.name_en = plant.F_Name_En
                        newItem.location = plant.F_Location
                        newItem.brief = plant.F_Brief
                        newItem.alsoKnown = plant.F_AlsoKnown
                        newItem.feature = plant.F_Feature
                        newItem.function = plant.F_Function＆Application
                        newItem.picURL = plant.F_Pic01_URL
                        newItem.update = plant.F_Update
                        
                        if(self.plantSet.insert(newItem.name!).inserted){
                            self.plantArray.append(newItem)
//                            print("plantSet insert return true")
                        }else{
//                            print("plantSet insert return false")
                            self.context.delete(newItem)
                        }
                    }
                    self.savePlantCoreData()
                }
            }
            task.resume()
        }
    }
    func deleteHouseCoreData(){
        print(#function)
        for house in houseArray as [House]{
            context.delete(house)
        }
        do {
            try context.save()
        }catch{
            print("Deleting house failure with err:\(error)")
        }
    }
    func deletePlantCoreData(){
        print(#function)
        for plant in plantArray as [Plant]{
            context.delete(plant)
        }
        do {
            try context.save()
        }catch{
            print("Deleting plant failure with err:\(error)")
        }
    }
}
//Core Data Demo
//C:Create
//        let newItem = PlantItem(context: context)
//        newItem.name = "Sun Flower"
//        newItem.detail = "Yellow"
//        do {
//            try context.save()
//        }catch{
//            print("Saving failure with err:\(error)")
//        }

//R:Read
//        let request : NSFetchRequest<Plant> = Plant.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        do{
//            itemArray = try context.fetch(request)
//            print(itemArray[1].name)
//        }catch{
//            print("Fetch context err with \(error)")
//        }

