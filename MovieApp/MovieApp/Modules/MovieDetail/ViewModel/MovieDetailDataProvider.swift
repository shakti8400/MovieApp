//
//  MovieDetailDataProvider.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import Foundation

class MovieDetailDataProvider{
    func fetchMovieDetails(movieId:Int,completionHandler:@escaping(_ detail:MovieDetailModel?)->Void){
        ServiceHandler.shared.request(url: "\(MovieAPIEnum.movieDetail.rawValue)\(movieId)") { (result: Result<MovieDetailModel, Error>) in
                switch result {
                   case .success(let movieDetail):
                        completionHandler(movieDetail)
                    
                   case .failure(let error):
                    Utility.navigationController?.topViewController?.showAlert(messsage: error.localizedDescription)
                    completionHandler(nil)
                   }
        }
    }
    func fetchMovieDetailsCast(movieId:Int,completionHandler:@escaping(_ detail:MovieDetailCastModel?)->Void){
        ServiceHandler.shared.request(url: "\(MovieAPIEnum.movieDetail.rawValue)\(movieId)\(Constants.credits.rawValue)") { (result: Result<MovieDetailCastModel, Error>) in
                switch result {
                   case .success(let movieDetailcast):
                        completionHandler(movieDetailcast)
                    
                   case .failure(let error):
                    Utility.navigationController?.topViewController?.showAlert(messsage: error.localizedDescription)
                    completionHandler(nil)
                   }
        }
    }
}
