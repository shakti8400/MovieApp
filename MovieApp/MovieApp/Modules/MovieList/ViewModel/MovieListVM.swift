//
//  MovieListVM.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation

protocol ReloadSnapshot:NSObject{
    func reloadSnapshot(_ data:[MovieListResultModel],addList:Bool)
    func deleteAlldata()
}

class MovieListVM{
    lazy var movieListDataProvider:MovieListDataProvider = {
        return MovieListDataProvider()
    }()
    var movieList:[MovieListResultModel] = []
    var pageNumber:Int = 1
    var loadMoreData:Bool = true
    weak var delegate:ReloadSnapshot?
    var dispatchWorkItem:DispatchWorkItem?
    var searchMovieTitle:String?
    var isForFavMovie:Bool = false
    var favMovieList:[MovieListResultModel] = []
    var reloadClouser:((_ data:MovieListResultModel)->Void)?
    func prepareDataSource(){
        if pageNumber == 1{
            movieList.removeAll()
        }
        movieListDataProvider.fetchMovieList(pageNumber: pageNumber, completionHandler: { data in
            if let status = data?.success,!status,let status_code = data?.status_code,status_code == 22{
                self.loadMoreData = false
            }else{
                if let dta = data?.results,!dta.isEmpty{
                    let resultData = dta.map { movie in
                        movie.isAddedInFav = false
                        if self.favMovieList.contains(where: {$0.id == movie.id}){
                            movie.isAddedInFav = true
                        }
                        return movie
                    }
                    self.movieList.append(contentsOf: resultData)
                    self.delegate?.reloadSnapshot(dta,addList: true)
                }else{
                    self.loadMoreData = false
                }
            }
        })
    }
    func searchMovie(search:String,delay:TimeInterval = 2){
        self.dispatchWorkItem?.cancel()
        if search.isEmpty{
            self.loadMoreData = true
            self.pageNumber = 1
            self.searchMovieTitle = nil
            prepareDataSource()
        }else{
            let workItem = DispatchWorkItem {
                self.loadMoreData = true
                self.pageNumber = 1
                self.searchMovieTitle = search
                self.searchMovieByTitle()
            }
            self.dispatchWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    func searchMovieByTitle(){
        guard let searchMovieTitle else {return}
        if pageNumber == 1{
            movieList.removeAll()
        }
        movieListDataProvider.fetchMovieListByTitle(pageNumber: pageNumber, searchText: searchMovieTitle, completionHandler: { data in
            if let status = data?.success,!status,let status_code = data?.status_code,status_code == 22{
                self.loadMoreData = false
            }else{
                if let dta = data?.results,!dta.isEmpty{
                    let resultData = dta.map { movie in
                        movie.isAddedInFav = false
                        if self.favMovieList.contains(where: {$0.id == movie.id}){
                            movie.isAddedInFav = true
                        }
                        return movie
                    }
                    self.movieList.append(contentsOf: resultData)
                    self.delegate?.reloadSnapshot(dta,addList: true)
                }else{
                    self.loadMoreData = false
                    if self.pageNumber == 1{
                        self.delegate?.deleteAlldata()
                    }
                }
            }
        })
    }
    func searchFavMovieByTitle(title:String){
        self.searchMovieTitle = title
        if title.isEmpty{
            self.searchMovieTitle = nil
            movieList = favMovieList.reversed()
        }else{
            let searchData = favMovieList.filter({$0.title?.localizedCaseInsensitiveContains(title) ?? false})
            movieList = searchData.reversed()
            
        }
        self.delegate?.reloadSnapshot(movieList,addList: true)
    }
    
    func fetchFavMovieList(reloadSnapshot:Bool = false){
        favMovieList.removeAll()
        do{
             let faveMovie =  try CoreDataHelper.sharedIns.context.fetch(FavMovie.fetchRequest())
            faveMovie.forEach { dta in
                let model = MovieListResultModel()
                model.id = Int(dta.id)
                model.poster_path = dta.posterImg
                model.release_date = dta.releaseYear
                model.title = dta.title
                model.isAddedInFav = true
                favMovieList.append(model)
            }
            if isForFavMovie{
                movieList.removeAll()
                movieList = favMovieList.reversed()
                loadMoreData = false
                if reloadSnapshot{
                    delegate?.reloadSnapshot(movieList, addList: true)
                }
            }
        }
        catch{
            print("Error fetching data ")
        }
    }
    
    func reloadFavMovie(data:MovieListResultModel){
        fetchFavMovieList()
        if let resultData = self.movieList.first(where: {$0.id == data.id}){
            resultData.isAddedInFav = false
            self.delegate?.reloadSnapshot([resultData],addList: false)
        }
    }
    
    func addMovieRemoveMovieFromFav(data:MovieListResultModel){
        if let isFav = data.isAddedInFav {
            if isFav{
                if let id = data.id{
                    CoreDataHelper.sharedIns.deleteRecord("FavMovie", id:id) { success in
                        if success{
                            self.fetchFavMovieList(reloadSnapshot: true)
                            self.reloadClouser?(data)
                        }
                    }
                }
               return
            }
        }
        DispatchQueue.main.async {
            let movieModel = FavMovie(context: CoreDataHelper.sharedIns.context)
            movieModel.id = Int64(data.id ?? 0)
            movieModel.title = data.title ?? ""
            movieModel.releaseYear = data.release_date ?? ""
            movieModel.posterImg = data.poster_path ?? ""
            CoreDataHelper.sharedIns.saveContext { (bool) in
                if bool{
                    print("saved")
                }
            }
            self.fetchFavMovieList()
        }
    }
}
