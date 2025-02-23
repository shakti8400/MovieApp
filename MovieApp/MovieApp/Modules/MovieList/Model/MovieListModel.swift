//
//  MovieListModel.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation
import UIKit

struct MovieListModel:Decodable{
    var page:Int?
    var results:[MovieListResultModel]?
    var total_pages:Int?
    var total_results:Int?
    var success:Bool?
    var status_code:Int?
    var status_message:String?
    
}

class MovieListResultModel:Hashable,Decodable{
    static func == (lhs: MovieListResultModel, rhs: MovieListResultModel) -> Bool {
        return true
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id:Int?
    var title:String?
    var poster_path:String?
    var release_date:String?
    var isAddedInFav:Bool?
}

enum Section {
    case main
}
