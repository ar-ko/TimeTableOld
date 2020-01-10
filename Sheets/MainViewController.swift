//
//  MainViewController.swift
//  Sheets
//
//  Created by ar_ko on 04/01/2020.
//  Copyright © 2020 ar_ko. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

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
        

        
        /*for day in timeTable {
            for lesson in day {
                print ("\(lesson.lessonStartTime!) \(lesson.lessonTitle ?? "--") \(lesson.teacherName ?? "--") \(lesson.lectureRoom ?? "--") \(lesson.learningCampus ?? "--")")
            }
            print ("-----------------------------")
        }*/
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
