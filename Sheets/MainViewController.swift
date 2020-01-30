//
//  MainViewController.swift
//  Sheets
//
//  Created by ar_ko on 04/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var timeTable = [[Lesson]]()
    var currentDayIndex = 0
    
    @IBAction func incrementDay(_ sender: Any) {
        currentDayIndex += 1
        if currentDayIndex == timeTable.count {
            currentDayIndex = 0
        }
        navigationBar.topItem?.title = getWeekName(currentDayIndex: currentDayIndex)
        
        self.tableView.reloadData()
    }
    
    @IBAction func decrementDay(_ sender: Any) {
        currentDayIndex -= 1
        if currentDayIndex == -1 {
            currentDayIndex = timeTable.count - 1
        }
        navigationBar.topItem?.title = getWeekName(currentDayIndex: currentDayIndex)
        
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spreadsheetId = "1CrVXpFRuvS4iq8nvGpd27-CeUcnzsRmbNc9nh2CWcWw"//"1JMzfHOcOvImZPV5zfO4im2BWIW4LllN42uxvPdpQKaQ"
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
        
        
        getTimetable(urlString: urlString, rangeIndexes: (startColumnIndex: startColumnIndex, startRowIndex: startRowIndex, endColumnIndex: endColumnIndex, endRowIndex: endRowIndex)) {(timeTable) in
            DispatchQueue.main.async{
                self.timeTable = timeTable
                self.tableView.reloadData()
                self.tableView.estimatedRowHeight = 50
                self.tableView.rowHeight = UITableView.automaticDimension
            }
        }
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        
        currentDayIndex = findWeekIndex(from: getStartDate())
        navigationBar.topItem?.title = getWeekName(currentDayIndex: currentDayIndex)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return timeTable.isEmpty ? 0:timeTable[currentDayIndex].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LessonCell
        
        if !timeTable.isEmpty {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H:mm"
            
            cell.startTimeLabel.text = dateFormatter.string(from: timeTable[currentDayIndex][indexPath.row].lessonStartTime)
            cell.endTimeLabel.text = dateFormatter.string(from: timeTable[currentDayIndex][indexPath.row].lessonStartTime.addingTimeInterval(90.0 * 60.0))
            cell.placeLabel.text = String(timeTable[currentDayIndex][indexPath.row].learningCampus ?? "") + "\n" + String(timeTable[currentDayIndex][indexPath.row].lectureRoom ?? "")
            cell.teacherName.text = timeTable[currentDayIndex][indexPath.row].teacherName
            cell.title.text = timeTable[currentDayIndex][indexPath.row].lessonTitle
            
            
            switch timeTable[currentDayIndex][indexPath.row].lessonMainType {
            case .laboratoryWork: cell.lessonType.text = "Лабораторная работа"               
            case .lecture: cell.lessonType.text = "Лекция"
            case .practice: cell.lessonType.text = "Практика"
            default: cell.lessonType.text = ""
            }
            
        }
        
        return cell
    }
    
    func getWeekName(currentDayIndex: Int) -> String {
        switch currentDayIndex {
        case 0:
            return "Понедельник, белая"
        case 1:
            return "Вторник, белая"
        case 2:
            return "Среда, белая"
        case 3:
            return "Четверг, белая"
        case 4:
            return "Пятница, белая"
        case 5:
            return "Суббота, белая"
        case 6:
            return "Понедельник, синяя"
        case 7:
            return "Вторник, синяя"
        case 8:
            return "Среда, синяя"
        case 9:
            return "Четверг, синяя"
        case 10:
            return "Пятница, синяя"
        case 11:
            return "Суббота, синяя"
        default:
            return "Расписание"
        }
    }
    
    
    func dateToString(date:Date, in format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    
    func findWeekIndex(from startDate: Date) -> Int {
        let currentDate = Date()
        
        let diffInDays = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day
        
        guard let days: Int = diffInDays else {
            return 0
        }
        
        // Коррекция даты, находим начало недели
        let calendar = Calendar.current
        var dateCorrection = calendar.component(.weekday, from: startDate) - 2
        if calendar.component(.weekday, from: startDate) == 1 {
            dateCorrection += 7
        }
        
        let numberOfWeek = (days + dateCorrection) / 7
        
        print (calendar.component(.weekday, from: currentDate))
        
        switch numberOfWeek.isMultiple(of: 2){
        case true:
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 6
            }
            else {
            return calendar.component(.weekday, from: currentDate) - 2
            }
        case false:
            if calendar.component(.weekday, from: currentDate) == 1 {
                return 0
            }
            return 6 + calendar.component(.weekday, from: startDate) - 2
        }
    }
    
    func getStartDate() -> Date {
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        
        dateComponents.day = 13
        dateComponents.month = 01
        dateComponents.year = 2020
        return userCalendar.date(from: dateComponents)!
    }
}
