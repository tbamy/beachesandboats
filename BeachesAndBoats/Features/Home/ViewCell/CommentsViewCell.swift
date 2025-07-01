//
//  CommentsViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/02/2025.
//

import UIKit

class CommentsViewCell: BaseXib {
    
    let nibName = "CommentsViewCell"
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!

    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }

    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    public var model: CommentsViewCellModel = CommentsViewCellModel(){
        didSet {
            setup()
        }
        
    }
    
    func setup(){
        nameLabel.text = model.name
        ratingLabel.text = model.rating
        commentsLabel.text = model.comment
    }

}

struct CommentsViewCellModel{
    public var name: String = ""
    public var comment: String = ""
    public var rating: String = ""
}
