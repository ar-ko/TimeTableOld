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
        }
        
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
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
        

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
