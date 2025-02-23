//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import Foundation

enum MovieDetailSection:Hashable{
    case detail
    case cast
}
struct MovieDetailTitleValueModel:Hashable{
    var id = UUID()
    var title:String?
    var value:String?
    var isBold:Bool = false
}

struct MovieDetailModel:Decodable{
    var backdrop_path,title,overview,poster_path,release_date,status,tagline:String?
    var genres:[MovieDetailGenres]?
    var id,runtime:Int?
    var vote_average:Float?
    
}
struct MovieDetailGenres:Decodable{
    var id:Int?
    var name:String?
}

struct MovieDetailCastModel:Decodable{
    var id:Int?
    var cast:[MovieDetailCastListModel]?
}
struct MovieDetailCastListModel:Decodable,Hashable{
    var id:Int?
    var name,profile_path,character:String?
}
