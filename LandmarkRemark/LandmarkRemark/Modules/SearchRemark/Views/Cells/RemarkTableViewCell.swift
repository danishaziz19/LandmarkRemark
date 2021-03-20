//
//  RemarkTableViewCell.swift
//  LandmarkRemark
//
//  Created by Danish Aziz on 20/3/21.
//

import UIKit

class RemarkTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(remark: Remark) {
        self.lblName.text = remark.userName
        self.lblNote.text = remark.body
        self.lblDate.text = remark.dateToString
    }
    
}
