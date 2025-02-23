//
//  MovieDetailVM.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import Foundation

protocol ReloadMovieDetailProtocol:NSObject{
    func reloadSnapshot()
}

class MovieDetailVM{
    var movieDetailDataList:[MovieDetailTitleValueModel] = []
    var movieCastList:[MovieDetailCastListModel] = []
    lazy var movieDetailDataProvider:MovieDetailDataProvider = {
        return MovieDetailDataProvider()
    }()
    var movieDetail:MovieDetailModel?
    var movieId:Int = 0
    weak var delegate:ReloadMovieDetailProtocol?
    func prepareMovieDetailData(){
        movieDetailDataList.removeAll()
        movieCastList.removeAll()
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        movieDetailDataProvider.fetchMovieDetails(movieId: movieId) { detail in
            self.movieDetail = detail
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        movieDetailDataProvider.fetchMovieDetailsCast(movieId: movieId) { detail in
            if let cast = detail?.cast {
                self.movieCastList.append(contentsOf: cast)
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.setDetailModel()
        }
        
        


        
    }
    func setDetailModel(){
        var titleModel = MovieDetailTitleValueModel()
        titleModel.title = movieDetail?.title
        titleModel.isBold = true
        self.movieDetailDataList.append(titleModel)

        var tagModel = MovieDetailTitleValueModel()
        tagModel.title = Constants.tagLine.rawValue
        tagModel.value = movieDetail?.tagline
        self.movieDetailDataList.append(tagModel)
        
        var durationModel = MovieDetailTitleValueModel()
        durationModel.title = Constants.duration.rawValue
        durationModel.value = self.formatRuntime(minutes: movieDetail?.runtime ?? 0)
        self.movieDetailDataList.append(durationModel)

        var releaseYearModel = MovieDetailTitleValueModel()
        releaseYearModel.title = Constants.releaseDate.rawValue
        releaseYearModel.value = Utility.dateFormat(dateString: movieDetail?.release_date ?? "N/A", inFormat: Constants.df_yyyy_mm_dd.rawValue, outFormat: Constants.represenatbleDf.rawValue)
        self.movieDetailDataList.append(releaseYearModel)

        var typeModel = MovieDetailTitleValueModel()
        typeModel.title = Constants.movieType.rawValue
        typeModel.value = movieDetail?.genres?.map({$0.name ?? ""}).joined(separator: ",")
        self.movieDetailDataList.append(typeModel)

        var statusModel = MovieDetailTitleValueModel()
        statusModel.title = Constants.status.rawValue
        statusModel.value = movieDetail?.status
        self.movieDetailDataList.append(statusModel)

        var voteModel = MovieDetailTitleValueModel()
        voteModel.title = Constants.rating.rawValue
        voteModel.value = "\(movieDetail?.vote_average ?? 0) \(Constants.outOf.rawValue)"
        self.movieDetailDataList.append(voteModel)
        
        var overViewModel = MovieDetailTitleValueModel()
        overViewModel.title = Constants.overView.rawValue
        overViewModel.value = movieDetail?.overview
        self.movieDetailDataList.append(overViewModel)
        
        self.delegate?.reloadSnapshot()
    }
    func formatRuntime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        return String(format: "%02d:%02d", hours, remainingMinutes) 
    }
}
