//
//  MessageTableViewCell.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/04.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageContents: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setMessage(_ messageData: MessageData){
        self.messageTitle.text = messageData.title
        self.messageContents.text = messageData.contents
    }
}
