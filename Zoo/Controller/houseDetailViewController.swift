//
//  houseDetailTableViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit
import RealmSwift
import SafariServices

class houseDetailViewController: loadImageViewController, SFSafariViewControllerDelegate, UIScrollViewDelegate {
    let realm = try! Realm()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var plantResults : Results<Plant>?

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
//        print(tableView.rowHeight)//value = -1
        tableHeight.constant = CGFloat(plantResults!.count) * 120//rowHeight = 120
        tableView.isScrollEnabled = false
        scrollView.bounces = false
        
        setHouseDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
//        print(#function)
//        print(tableView.rowHeight)//value = -1
    }
    @IBAction func showSafariButtonPressed(_ sender: UIButton) {
        let urlStr = house?.url.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr!){
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            present(safari, animated: true, completion: nil)
        }
    }
    func setHouseDetail(){
        title = house!.name
        houseInfo.text = house?.info
        houseMemo.text = house?.memo == "" ? "無休館資訊" : house?.memo
        houseCategory.text = house?.category
        
        if let url = URL(string: house!.picURL){
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            session.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.houseImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadPlant(with location:String){
        plantResults = realm.objects(Plant.self)
        plantResults = plantResults?.filter(NSPredicate(format: "location CONTAINS %@", location))
        plantResults = plantResults?.sorted(byKeyPath: "picURL", ascending: true)
//        print(plantResults)
    }
}

//MARK: - TableView Delegate Methods

extension houseDetailViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plantResults!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.listCellIdentifier, for: indexPath) as! listCell
        if let row = plantResults?[indexPath.row]{
            cell.update(with: row)
        }
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
                destinaionVC.plant = plantResults?[indexPath.row]
            }
        }
    }
}

