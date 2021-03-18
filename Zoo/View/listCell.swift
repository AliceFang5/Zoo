//
//  houseMenuCell.swift
//  Zoo
//
//  Created by 方芸萱 on 2021/3/3.
//

import UIKit

class listCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func update(with house:House){
        nameLabel.text = house.name
        infoLabel.text = house.info
        memoLabel.text = house.memo == "" ? "無休館資訊" : house.memo
        let urlStr = house.picURL!.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.picImageView.image = image
                    }
                }
            }.resume()
        }
    }
    func update(with plant:Plant){
        nameLabel.text = plant.name
        infoLabel.text = plant.alsoKnown
        memoLabel.text = ""
        let urlStr = plant.picURL!.replacingOccurrences(of: "http:", with: "https:")
        if let url = URL(string: urlStr){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.picImageView.image = image
                    }
                }else{
                    DispatchQueue.main.async {
                        self.picImageView.image = UIImage(named: "sorry")
                    }
                }
            }.resume()
        }
    }
}
