//
//  ParsingData.swift
//  Sheets
//
//  Created by ar_ko on 22/12/2019.
//  Copyright © 2019 ar_ko. All rights reserved.
//

import Foundation

func getTimetable(urlString: String, rangeIndexes: (startColumnIndex: Int, startRowIndex: Int, endColumnIndex: Int, endRowIndex: Int), completion: @escaping ([[Lesson]]) -> Void) {
    var timeTable = [[Lesson]]()
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard let data = data else { return }
        guard error == nil else { return }
    
        do {
            let sheet = try JSONDecoder().decode(Sheets.self, from: data)
            
            let numberOfLessons = getNumberOfLessons(sheet: sheet, rangeIndexes: (startColumnIndex: rangeIndexes.startColumnIndex, startRowIndex: rangeIndexes.startRowIndex))
            
            timeTable = parsingSheets(sheets: sheet, numberOfLessons: numberOfLessons, rangeIndexes: (startColumnIndex: rangeIndexes.startColumnIndex, startRowIndex: rangeIndexes.startRowIndex))
            
            completion (timeTable)
        } catch let error {
            print(error)
        }
    }.resume()
}

func getNumberOfLessons(sheet: Sheets, rangeIndexes: (startColumnIndex: Int, startRowIndex: Int)) -> [Int] {
    var merges = [GridRange]()
    
    for sheet in sheet.sheets {
        merges = sheet.merges
    }
    
    merges = merges.filter { $0.startColumnIndex == rangeIndexes.startColumnIndex && $0.endColumnIndex == rangeIndexes.startColumnIndex + 1}
    merges.sort { $0.startRowIndex < $1.startRowIndex }
    
    var index = rangeIndexes.startRowIndex
    var count = 0
    var numberOfLessons = [Int]()
    
    for merge in merges {
        if merge.startRowIndex == index {
            count += 4
            index = merge.endRowIndex
        }
        else {
            numberOfLessons.append((numberOfLessons.last ?? 0) + count)
            count = 5
            index = merge.endRowIndex
        }
    }
    return numberOfLessons
}

func parsingSheets(sheets: Sheets, numberOfLessons: [Int], rangeIndexes: (startColumnIndex: Int, startRowIndex: Int)) -> [[Lesson]] {
    var whiteWeakTimetable = [[Lesson]]()
    var blueWeakTimetable = [[Lesson]]()
    
    for sheet in sheets.sheets {
        for data in sheet.data {
            var whiteWeakDay = [Lesson]()
            var blueWeakDay = [Lesson]()
            
            var correctionIndex = 0
            
            var lessonStartTime: String?
            
            var whiteWeekLessonTitle: String?
            var whiteWeekSubgroup: Subgroup?
            var whiteWeekTeacherName: String?
            var whiteWeekLessonType: LessonType?
            var whiteWeekLessonMainType: LessonMainType?
            var whiteWeekLearningCampus: String?
            var whiteWeekLearningCampusIsIncorrect: Bool?
            var whiteWeekLectureRoom: String?
            var whiteWeekLectureRoomIsIncorrect: Bool?
            var whiteWeekNote: String?
            
            var blueWeekLessonTitle: String?
            var blueWeekSubgroup: Subgroup?
            var blueWeekTeacherName: String?
            var blueWeekLessonType: LessonType?
            var blueWeekLessonMainType: LessonMainType?
            var blueWeekLearningCampus: String?
            var blueWeekLearningCampusIsIncorrect: Bool?
            var blueWeekLectureRoom: String?
            var blueWeekLectureRoomIsIncorrect: Bool?
            var blueWeekNote: String?
            
            for (rowIndex, rowData) in data.rowData.enumerated(){

                if numberOfLessons.contains(rowIndex) {
                    
                    whiteWeakTimetable.append(whiteWeakDay)
                    blueWeakTimetable.append(blueWeakDay)
                    
                    whiteWeakDay = []
                    blueWeakDay = []
                    
                    correctionIndex += 1
                    continue
                }
                
                if rowData.values != nil {
                    for (columnIndex, value) in rowData.values!.enumerated() {
                        
                        switch (rowIndex - correctionIndex) % 4 {
                        case 0:
                            switch columnIndex % 4 {
                            case 0: lessonStartTime = value.formattedValue
                            case 1: if value.formattedValue != nil {
                                if cellIsMerged(in: sheets, columnIndex: rangeIndexes.startColumnIndex + columnIndex,
                                                rowIndex: rangeIndexes.startRowIndex + rowIndex){
                                    whiteWeekSubgroup = .general
                                }
                                else {
                                    whiteWeekSubgroup = .first
                                }
                                whiteWeekLessonTitle = value.formattedValue
                                whiteWeekLessonType = getLessonType(effectiveFormat: value.effectiveFormat!)
                                whiteWeekNote = value.note
                                }
                            case 2: if value.formattedValue != nil {
                                whiteWeekLessonTitle = value.formattedValue
                                whiteWeekSubgroup = .second
                                whiteWeekNote = value.note
                                whiteWeekLessonType = getLessonType(effectiveFormat: value.effectiveFormat!)
                                }
                            case 3: if value.formattedValue != nil {
                                whiteWeekLectureRoom = value.formattedValue
                                
                                whiteWeekLectureRoomIsIncorrect = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        case 1:
                            switch columnIndex % 4 {
                            case 0: lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1: whiteWeekTeacherName = value.formattedValue
                            case 2: whiteWeekTeacherName = whiteWeekTeacherName == nil ? value.formattedValue: whiteWeekTeacherName
                            case 3: if value.formattedValue != nil {
                                whiteWeekLearningCampus = value.formattedValue
                                
                                whiteWeekLearningCampusIsIncorrect = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                            
                        case 2:
                            switch columnIndex % 4 {
                            case 0: lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1:if value.formattedValue != nil {
                                if cellIsMerged(in: sheets, columnIndex: rangeIndexes.startColumnIndex + columnIndex,
                                                rowIndex: rangeIndexes.startRowIndex + rowIndex){
                                    blueWeekSubgroup = .general
                                }
                                else {
                                    blueWeekSubgroup = .first
                                }
                                blueWeekLessonTitle = value.formattedValue
                                blueWeekNote = value.note
                                blueWeekLessonType = getLessonType(effectiveFormat: value.effectiveFormat!)
                                }
                            case 2: if value.formattedValue != nil {
                                blueWeekLessonTitle = value.formattedValue
                                blueWeekSubgroup = .second
                                blueWeekNote = value.note
                                blueWeekLessonType = getLessonType(effectiveFormat: value.effectiveFormat!)
                                }
                                
                            case 3: if value.formattedValue != nil {
                                blueWeekLectureRoom = value.formattedValue
                                
                                blueWeekLectureRoomIsIncorrect = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                        case 3:
                            switch columnIndex % 4 {
                            case 0: lessonStartTime = lessonStartTime == nil ? value.formattedValue: lessonStartTime
                            case 1: blueWeekTeacherName = value.formattedValue
                            case 2: blueWeekTeacherName = blueWeekTeacherName == nil ? value.formattedValue: blueWeekTeacherName
                            case 3: if value.formattedValue != nil {
                                blueWeekLearningCampus = value.formattedValue
                                
                                blueWeekLearningCampusIsIncorrect = locationIsBroken(effectiveFormat: value.effectiveFormat!)
                                }
                            default: print ("cell out of range")
                            }
                        default: print ("rowNumber out of range")
                        }
                    }
                }
                if ((rowIndex - correctionIndex) % 4 == 3) || (rowIndex == data.rowData.count - 1) {
                    
                    if whiteWeekLessonTitle != nil {
                        let buf = getLessonMainType(lessonTitle: whiteWeekLessonTitle!)
                        whiteWeekLessonMainType = buf.mainType
                        whiteWeekLessonTitle = buf.title
                    }
                    
                    
                    let whiteWeekLesson = Lesson(lessonStartTime: lessonStartTime, subgroup: whiteWeekSubgroup, lessonTitle: whiteWeekLessonTitle, teacherName: whiteWeekTeacherName, lessonType: whiteWeekLessonType, lessonMainType: whiteWeekLessonMainType, learningCampus: whiteWeekLearningCampus, learningCampusIsIncorrect: whiteWeekLearningCampusIsIncorrect, lectureRoom: whiteWeekLectureRoom, lectureRoomIsIncorrect: whiteWeekLectureRoomIsIncorrect, note: whiteWeekNote)
                    let blueWeekLesson = Lesson(lessonStartTime: lessonStartTime, subgroup: blueWeekSubgroup, lessonTitle: blueWeekLessonTitle, teacherName: blueWeekTeacherName, lessonType: blueWeekLessonType, lessonMainType: blueWeekLessonMainType, learningCampus: blueWeekLearningCampus, learningCampusIsIncorrect: blueWeekLearningCampusIsIncorrect, lectureRoom: blueWeekLectureRoom, lectureRoomIsIncorrect: blueWeekLectureRoomIsIncorrect, note: blueWeekNote)
                    
                    whiteWeakDay.append(whiteWeekLesson)
                    blueWeakDay.append(blueWeekLesson)
                    
                    lessonStartTime = nil
                    
                    whiteWeekLessonTitle = nil
                    whiteWeekSubgroup = nil
                    whiteWeekTeacherName = nil
                    whiteWeekLessonType = nil
                    whiteWeekLessonMainType = nil
                    whiteWeekLearningCampus = nil
                    whiteWeekLearningCampusIsIncorrect = nil
                    whiteWeekLectureRoom = nil
                    whiteWeekLectureRoomIsIncorrect = nil
                    whiteWeekNote = nil
                    
                    blueWeekLessonTitle = nil
                    blueWeekSubgroup = nil
                    blueWeekTeacherName = nil
                    blueWeekLessonType = nil
                    blueWeekLessonMainType = nil
                    blueWeekLearningCampus = nil
                    blueWeekLearningCampusIsIncorrect = nil
                    blueWeekLectureRoom = nil
                    blueWeekLectureRoomIsIncorrect = nil
                    blueWeekNote = nil
                    
                }
            }
            whiteWeakTimetable.append(whiteWeakDay)
            blueWeakTimetable.append(blueWeakDay)
        }
    }
    return whiteWeakTimetable + blueWeakTimetable
}


func timeDecompile(time: String) {
    var hours = ""
    var minutes = ""
    let numbers = "0123456789"
    var timeIsNotChange = true
    
    for s in time {
        if numbers.contains(s) && timeIsNotChange {
            hours += String(s)
        }
        if numbers.contains(s) && !timeIsNotChange {
            minutes += String(s)
        }
        if !numbers.contains(s){
            timeIsChange = false
        }
    }
}


func titleFormatting (lessonTitle: String, lessonType: String) -> String {
    var findStringindex = 0
    var lessonTypeIndex: String.Index
    var startIndex = lessonTitle.count
    var lessonTitle = lessonTitle.lowercased()
    
    for (index, char) in lessonTitle.enumerated() {
        lessonTypeIndex = lessonType.index(lessonType.startIndex, offsetBy: findStringindex)
        
        if char == lessonType[lessonTypeIndex] {
            if lessonTypeIndex == lessonType.startIndex {
                startIndex = index
            }
            if findStringindex == lessonType.count - 1 {
                break
            }
            
            findStringindex += 1
        }
        else {
            findStringindex = 0
            startIndex = lessonTitle.count
        }
    }
    
    let index = lessonTitle.index(lessonType.startIndex, offsetBy: startIndex)
    
    lessonTitle = String(lessonTitle[..<index])
    lessonTitle = lessonTitle.prefix(1).capitalized + lessonTitle.dropFirst()
    
    return lessonTitle
}


func locationIsBroken (effectiveFormat: EffectiveFormat) -> Bool {
    if effectiveFormat.backgroundColor.red == 1 &&
        effectiveFormat.backgroundColor.green == nil &&
        effectiveFormat.backgroundColor.blue == nil {
        return true
    }
    else {
        return false
    }
}


func getLessonType(effectiveFormat: EffectiveFormat) -> LessonType {
    switch (effectiveFormat.textFormat.foregroundColor.red, effectiveFormat.textFormat.foregroundColor.green, effectiveFormat.textFormat.foregroundColor.blue) {
    case (0.6, nil, 1):
        return .online
    case (1, nil, nil):
        return .canceled
    default: return .standart
    }
}


func getLessonMainType(lessonTitle: String) -> (mainType: LessonMainType?, title: String) {
    if lessonTitle.contains("(ЛБ)") {
        return (.laboratoryWork, titleFormatting(lessonTitle: lessonTitle, lessonType: "(лб)"))
    }
    
    if lessonTitle.contains("(ЛК)") {
        return (.lecture, titleFormatting(lessonTitle: lessonTitle, lessonType: "(лк)"))
    }
    
    if lessonTitle.contains("(ПР)") {
        return (.practice, titleFormatting(lessonTitle: lessonTitle, lessonType: "(пр)"))
    }
    return (.none, lessonTitle)
}


func cellIsMerged(in sheets: Sheets, columnIndex:Int, rowIndex:Int ) -> Bool {
    for sheet in sheets.sheets {
        for merge in sheet.merges {
            if merge.startColumnIndex == columnIndex && merge.startRowIndex == rowIndex {
                return true
            }
        }
    }
    return false
}


func letterToIndex(letter: String) -> Int {
    let letter = String(letter.reversed())
    var index = 0
    
    for (ind, character) in letter.enumerated() {
        index += characterToNum(character: character) * Int(pow(26, Double(ind)))
    }
    return (index - 1)
}


func characterToNum(character: Character) -> Int {
    switch character {
    case "A": return 1
    case "B": return 2
    case "C": return 3
    case "D": return 4
    case "E": return 5
    case "F": return 6
    case "G": return 7
    case "H": return 8
    case "I": return 9
    case "J": return 10
    case "K": return 11
    case "L": return 12
    case "M": return 13
    case "N": return 14
    case "O": return 15
    case "P": return 16
    case "Q": return 17
    case "R": return 18
    case "S": return 19
    case "T": return 20
    case "U": return 21
    case "V": return 22
    case "W": return 23
    case "X": return 24
    case "Y": return 25
    case "Z": return 26
    default:
        print ("ERROR")
        return 0
    }
}
