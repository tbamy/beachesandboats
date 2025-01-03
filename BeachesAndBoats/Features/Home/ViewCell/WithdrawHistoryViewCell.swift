//
//  WithdrawHistoryViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import UIKit

class WithdrawHistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var withdrawalSource: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(with data: WithdrawalDetail?) {
        withdrawalSource.text = "From wallet to Bank"
        timeLbl.text = data?.createdAt
        amountLbl.text = "\(GeneralFormatter.decimalToString(data?.amount ?? 0))"
    }
    
}
