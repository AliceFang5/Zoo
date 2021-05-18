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

    }
    func update(with house:House){
        nameLabel.text = house.name
        infoLabel.text = house.info
        memoLabel.text = house.memo == "" ? "無休館資訊" : house.memo
        picImageView.image = UIImage(named: "sorry")
        if let url = URL(string: house.picURL){
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            session.dataTask(with: url) { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async {
                        self.picImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    func update(with plant:Plant){
        nameLabel.text = plant.name
        infoLabel.text = plant.alsoKnown
        memoLabel.text = ""
        picImageView.image = UIImage(named: "sorry")
        if let url = URL(string: plant.picURL){
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            session.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.picImageView.image = image
                    }
                }
            }.resume()
        }
    }
}

extension listCell: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("*** received SESSION challenge...\(challenge)")
        let trust = challenge.protectionSpace.serverTrust!
        let credential = URLCredential(trust: trust)
        completionHandler(.useCredential, credential)
    }
}
