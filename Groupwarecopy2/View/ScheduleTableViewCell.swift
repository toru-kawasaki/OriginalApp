//
//  ScheduleTableViewCell.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/11.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLabelOutlet: UILabel!
    @IBOutlet weak var endDateLabelOutlet: UILabel!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var contentsLabelOutlet: UILabel!
    @IBOutlet weak var updateButtonOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setSchedule(_ scheduleData: ScheduleData){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        self.startDateLabelOutlet.text = df.string(from: scheduleData.startDateTime!)
        self.endDateLabelOutlet.text = df.string(from: scheduleData.endDateTime!)
        self.titleLabelOutlet.text = scheduleData.title
        self.contentsLabelOutlet.text = scheduleData.contents
    }
}
