//
//  ConversationsViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/02/2025.
//

import UIKit

class ConversationsViewCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: BoldLabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with: GetConversationsData){
//        if let url = URL(string: with.userImg.replacingOccurrences(of: "http://", with: "https://")) {
//            userImg.kf.setImage(
//                with: url,
//                placeholder: UIImage(named: "dummy"),
//                options: nil,
//                completionHandler: { result in
//                    switch result {
//                    case .success(let value):
//                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
//                    case .failure(let error):
//                        print("Failed to load image: \(error.localizedDescription)")
//                        self.userImg.image = UIImage(named: "dummy")
//                    }
//                }
//            )
//        } else {
//            userImg.image = UIImage(named: "dummy")
//        }
        
        userName.text = with.otherUser.firstName
        locationLbl.text = ""
        messageLbl.text = with.lastMessage
    }
    
}
