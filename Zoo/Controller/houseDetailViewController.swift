//
//  houseDetailTableViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit
import CoreData

class houseDetailViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    var plantArray = [Plant]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var house : House?{
        didSet{
            loadPlant(with: (house?.name)!)
        }
    }
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var houseInfo: UILabel!
    @IBOutlet weak var houseMemo: UILabel!
    @IBOutlet weak var houseCategory: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: K.listCellNibName, bundle: nil), forCellReuseIdentifier: K.listCellIdentifier)
        setTitle()
        setHouseDetail()
    }
    @IBAction func showSafariButtonPressed(_ sender: UIButton) {
        
    }
    func setTitle(){
        title = house!.name
//        let label = UILabel()
//        label.text = "Alice"
//        navigationItem.titleView = label
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: label.superview, attribute: .centerX, multiplier: 1, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: label.superview, attribute: .width, multiplier: 1, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: label.superview, attribute: .centerY, multiplier: 1, constant: 0))
//        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: label.superview, attribute: .height, multiplier: 1, constant: 0))
        
        //        navigationItem.backButtonDisplayMode = .default
        //        navigationItem.hidesBackButton = true
    }
    func setHouseDetail(){
        let urlStr = house?.picURL!.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr!){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.houseImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        houseInfo.text = house?.info
        houseMemo.text = house?.memo == "" ? "無休館資訊" : house?.memo
        houseCategory.text = house?.category
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadPlantFromCordData(with request:NSFetchRequest<Plant> = Plant.fetchRequest()){
        do{
            plantArray = try context.fetch(request)
            print(plantArray.count)
//            print(plantArray[0].name ?? "no plant data")
        }catch{
            print("Fetch context err with \(error)")
        }
    }
    func loadPlant(with location:String){
        let request:NSFetchRequest<Plant> = Plant.fetchRequest()
    //        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "location CONTAINS %@", location)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadPlantFromCordData(with: request)
    }
}

//MARK: - TableView Delegate Methods

extension houseDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plantArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellIdentifier, for: indexPath) as! listCell
//        cell.nameLabel.text = "Alice: \(indexPath.row)"
        cell.update(with: plantArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select plantList row: \(indexPath.row)")
        performSegue(withIdentifier: K.plantDetailSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.plantDetailSegue{
            if let indexPath = table.indexPathForSelectedRow{
                let destinaionVC = segue.destination as! plantDetailViewController
                destinaionVC.plant = plantArray[indexPath.row]
            }
        }
    }
}
