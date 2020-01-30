//
//  OriginalSheets.swift
//  Sheets
//
//  Created by ar_ko on 22/12/2019.
//  Copyright © 2019 ar_ko. All rights reserved.
//

import Foundation


struct Sheets: Decodable {
    var sheets: [Data]
    
    struct Data: Decodable {
        var data: [RowData]
        var merges: [GridRange]
                
        struct RowData: Decodable {
            var rowData: [Values]
            
            struct Values: Decodable {
                var values: [CellData]?
                
                struct CellData: Decodable {
                    var formattedValue: String?
                    var note: String?
                    var effectiveFormat: EffectiveFormat?
                    
                }
            }
        }
    }
}

struct GridRange: Decodable {
     let sheetId: Int
     let startRowIndex: Int
     let endRowIndex: Int
     let startColumnIndex: Int
     let endColumnIndex: Int
 }

struct EffectiveFormat: Decodable {
    var backgroundColor: color
    var textFormat: ForegroundColor
    
    struct ForegroundColor: Decodable {
        var foregroundColor: color
    }
    
    struct color: Decodable {
        var red: Double?
        var green: Double?
        var blue: Double?
    }
}
