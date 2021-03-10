//
//  plantDetailViewController.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/10.
//

import UIKit

class plantDetailViewController: UIViewController {
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantLabel: UILabel!
    var plant:Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Welcome to plantDetail page")
        title = plant?.name
        setPlantImageView()
        setPlantLabel()
    }
    func setPlantImageView(){
        let urlStr = plant?.picURL!.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr!){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.plantImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    func setPlantLabel(){
        plantLabel.text = (plant?.name)! + "\n" +
            (plant?.name_en)! + "\n\n" + "別名\n" +
            (plant?.alsoKnown)! + "\n\n" + "簡介\n" +
            (plant?.brief)! + "\n\n" + "辨認方式\n" +
            (plant?.feature)! + "\n\n" + "功能性\n" +
            (plant?.function)! + "\n\n" + "最後更新：" +
            (plant?.update)!
    }
}
