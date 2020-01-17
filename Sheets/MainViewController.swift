//
//  MainViewController.swift
//  Sheets
//
//  Created by ar_ko on 04/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var timeTable = [[Lesson]]()
    let currentDayIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spreadsheetId = "1JMzfHOcOvImZPV5zfO4im2BWIW4LllN42uxvPdpQKaQ"
        let sheetId = "%D0%BF%D1%80%D0%BE%D1%84%D1%8B" // профы
        
        let startColumn = "B"
        let startRow = 11
        let endColumn = "E"
        let endRow = 175
        
        let range = startColumn + String(startRow) + ":" + endColumn + String(endRow)
        
        let startColumnIndex = letterToIndex(letter: startColumn)
        let startRowIndex = startRow - 1
        let endColumnIndex = letterToIndex(letter: endColumn)
        let endRowIndex = endRow - 1
        
        let apiKey = "AIzaSyBg-JW7nhA-be4jnfy-UKFVXcfefkjofVw"
        let fields = "sheets(merges,data(rowData(values(formattedValue,note,effectiveFormat(backgroundColor,textFormat(foregroundColor))))))"
        
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)?ranges=\(sheetId)!\(range)&fields=\(fields)&key=\(apiKey)"
        
        getTimetable(urlString: urlString, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex, endColumnIndex: endColumnIndex, endRowIndex: endRowIndex)) {(kek) in
            self.timeTable = kek
            self.tableView.reloadData()
            self.tableView.estimatedRowHeight = 50
            self.tableView.rowHeight = UITableView.automaticDimension
        }
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return timeTable.isEmpty ? 0:timeTable[currentDayIndex].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LessonCell
        
        if !timeTable.isEmpty {
            cell.startTimeLabel.text = timeTable[currentDayIndex][indexPath.row].lessonStartTime
            cell.placeLabel.text = String(timeTable[currentDayIndex][indexPath.row].learningCampus ?? "") + "\n" + String(timeTable[currentDayIndex][indexPath.row].lectureRoom ?? "")
            cell.teacherName.text = timeTable[currentDayIndex][indexPath.row].teacherName
            cell.title.text = timeTable[currentDayIndex][indexPath.row].lessonTitle
            
            
            switch timeTable[currentDayIndex][indexPath.row].lessonMainType {
            case .laboratoryWork: cell.lessonType.text = "Лабораторная работа"
                                cell.lessonTypeIndicator.backgroundColor = .black
                cell.lessonType.textColor = .black
            case .lecture: cell.lessonType.text = "Лекция"
            cell.lessonType.textColor = .green
                cell.lessonTypeIndicator.backgroundColor = .green
            case .practice: cell.lessonType.text = "Практическое занятие"
            cell.lessonType.textColor = .brown
            cell.lessonTypeIndicator.backgroundColor = .brown
            default: cell.lessonType.text = ""
            }
            
        }
        
        return cell
    }
    
}
