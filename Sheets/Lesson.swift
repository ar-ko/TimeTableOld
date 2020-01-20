//
//  Lesson.swift
//  Sheets
//
//  Created by ar_ko on 22/12/2019.
//  Copyright © 2019 ar_ko. All rights reserved.
//

import UIKit

struct Lesson {
    let lessonStartTime: Date
    let subgroup: Subgroup?
    let lessonTitle: String?
    let teacherName: String?
    let lessonType: LessonType?
    let lessonMainType: LessonMainType?
    let learningCampus: String?
    let learningCampusIsIncorrect: Bool?
    let lectureRoom: String?
    let lectureRoomIsIncorrect: Bool?
    let note: String?
}

enum Subgroup: String {case first = "first", second = "second", general = "general"}

enum LessonType {case standart, canceled, online}

enum LessonMainType {case lecture, practice, laboratoryWork}
