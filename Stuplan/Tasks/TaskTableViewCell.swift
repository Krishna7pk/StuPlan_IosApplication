//
//  TaskTableViewCell.swift
//  Stuplan
//
//  Created by MobileAppDevelopment on 2022-04-12.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!

    @IBOutlet weak var date: UILabel!
  
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var courseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
