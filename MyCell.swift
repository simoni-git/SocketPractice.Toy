//
//  MyCell.swift
//  SocketPractice
//
//  Created by 시모니 on 7/8/24.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var chatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
