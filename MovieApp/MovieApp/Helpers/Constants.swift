//
//  Constants.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation

enum Constants:String{
    case duration = "Duration"
    case tagLine = "Tag line"
    case movieDetail = "Movie detail"
    case movieListTile = "Movie List"
    case favtitle = "Favorite movie list"
    case pleaseWaitMsg = "Please wait..."
    case messageStr = "Message"
    case okBtn = "OK"
    case df_yyyy_mm_dd = "yyyy-MM-dd"
    case represenatbleDf = "MMM dd, yyyy"
    case noDataAvailable = "No data available"
    case credits = "/credits"
    case releaseDate = "Release Date"
    case movieType = "Movie type"
    case overView = "Overview"
    case rating = "Rating"
    case outOf = "out of 10"
    case status = "Status"
    case castHeaderTitle = "Top Billed Cast"
    
}


enum MovieAPIEnum:String{
    case movieList = "https://api.themoviedb.org/3/discover/movie"
    case movieDetail = "https://api.themoviedb.org/3/movie/"
    case movieSearch = "https://api.themoviedb.org/3/search/movie?"
    case originalImgUrl = "https://image.tmdb.org/t/p/original/"
    case w500ImgUrl = "https://image.tmdb.org/t/p/w500/"
}


enum CellEnum:String{
    case MovieListTVC = "MovieListTVC"
    case DetailCVC = "DetailCVC"
    case CastProfileCVC = "CastProfileCVC"
    case HeaderCollectionReusableView = "HeaderCollectionReusableView"
}
