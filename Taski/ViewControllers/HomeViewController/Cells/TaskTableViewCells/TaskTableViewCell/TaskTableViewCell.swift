//
//  TableViewCell.swift
//  Taski
//
//  Created by Sam Kishline
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notiticationTimeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
