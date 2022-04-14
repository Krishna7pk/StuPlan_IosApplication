//
//  CompletedTaskViewCell.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-12.
//

import UIKit

class CompletedTaskViewCell: UITableViewCell {

    @IBOutlet weak var nameOfCours: UILabel!
    @IBOutlet weak var nameOfTask: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var notes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
