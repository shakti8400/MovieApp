//
//  MovieListDataProvider.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation

class MovieListDataProvider{
    func fetchMovieList(pageNumber:Int,completionHandler:@escaping(_ data:MovieListModel?)->Void){
            ServiceHandler.shared.request(url: MovieAPIEnum.movieList.rawValue,parameters: ["page":"\(pageNumber)"]) { (result: Result<MovieListModel, Error>) in
                    switch result {
                       case .success(let movieList):
                            completionHandler(movieList)
                        
                       case .failure(let error):
                        Utility.navigationController?.topViewController?.showAlert(messsage: error.localizedDescription)
                        completionHandler(nil)
                       }
            }
    }
    func fetchMovieListByTitle(pageNumber:Int,searchText:String,completionHandler:@escaping(_ data:MovieListModel?)->Void){
        ServiceHandler.shared.request(url: MovieAPIEnum.movieSearch.rawValue,parameters: ["page":"\(pageNumber)","query":searchText]) { (result: Result<MovieListModel, Error>) in
                    switch result {
                       case .success(let movieList):
                            completionHandler(movieList)
                        
                       case .failure(let error):
                        Utility.navigationController?.topViewController?.showAlert(messsage: error.localizedDescription)
                        completionHandler(nil)
                       }
            }
    }
}
