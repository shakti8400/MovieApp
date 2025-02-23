//
//  Utility.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation
import UIKit

class Utility{
    static var navigationController:UINavigationController?
    static func dateFormat(dateString:String,inFormat:String,outFormat:String)-> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = inFormat
        if let date = dateformatter.date(from: dateString) {
            dateformatter.timeZone = TimeZone.current
            dateformatter.dateFormat = outFormat
            return dateformatter.string(from: date)
        }
        return dateString
        
    }
    static func getNoDataView(string:String)->UIView{
        let view:NoDataView = UIView.fromNib()
        view.setNoDataViewString(str: string)
        return view
        
    }
}
