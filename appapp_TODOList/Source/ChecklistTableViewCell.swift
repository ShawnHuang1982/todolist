//
//  ChecklistTableViewCell.swift
//  appapp_TODOList
//
//  Created by  shawn on 23/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

protocol ChecklistTableViewCellDelegate {
    func pressCheckBox(cell:ChecklistTableViewCell)
}

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTodoList: UILabel!
    @IBOutlet weak var labelIndicator: UILabel!
    @IBOutlet weak var labelItemName: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var labelDueDate: UILabel!
    var delegate: ChecklistTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonCheckBox(_ sender: Any) {
        delegate?.pressCheckBox(cell:self)
    }

}
