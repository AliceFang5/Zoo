//
//  houseDetailTableViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit
import CoreData
import SafariServices

class houseDetailViewController: UIViewController, SFSafariViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var plantArray = [Plant]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var house : House?{
        didSet{
            loadPlant(with: (house?.name)!)
            print("house detail didSet")
        }
    }
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var houseInfo: UILabel!
    @IBOutlet weak var houseMemo: UILabel!
    @IBOutlet weak var houseCategory: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.listCellNibName, bundle: nil), forCellReuseIdentifier: K.listCellIdentifier)

        //Set table height to cover entire view
        print(tableView.rowHeight)
        tableHeight.constant = CGFloat(plantArray.count) * 120//rowHeight = 120
        tableView.isScrollEnabled = false
        scrollView.bounces = false
        
        setHouseDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
//        print(tableView.rowHeight)
    }
    @IBAction func showSafariButtonPressed(_ sender: UIButton) {
        let urlStr = house?.url?.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr!){
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            present(safari, animated: true, completion: nil)
        }
    }
    func setHouseDetail(){
        title = house!.name
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
    
    func loadPlant(with location:String){
        let request:NSFetchRequest<Plant> = Plant.fetchRequest()
    //        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "location CONTAINS %@", location)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do{
            plantArray = try context.fetch(request)
            print("plantCount:\(plantArray.count)")
        }catch{
            print("Fetch context err with \(error)")
        }
    }
}

//MARK: - TableView Delegate Methods

extension houseDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plantArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellIdentifier, for: indexPath) as! listCell
        cell.update(with: plantArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select plantList row: \(indexPath.row)")
        performSegue(withIdentifier: K.plantDetailSegue, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.plantDetailSegue{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinaionVC = segue.destination as! plantDetailViewController
                destinaionVC.plant = plantArray[indexPath.row]
            }
        }
    }
}
