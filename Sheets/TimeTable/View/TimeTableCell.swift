//
//  TimeTableCell.swift
//  Sheets
//
//  Created by ar_ko on 28/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit


class TimeTableCell: UITableViewCell {
    
    @IBOutlet weak var lessonStartTimeLabel: UILabel!
    @IBOutlet weak var lessonEndTimeLabel: UILabel!
    
    func configure(with timeTable: [[Lesson]]) {
        self.lessonStartTimeLabel = timeTable.lessonStartTime
        self.lessonEndTimeLabel = timeTable.lessonEndTime
    }
}
