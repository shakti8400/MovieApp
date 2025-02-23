//
//  MovieListVC.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    let viewModel = MovieListVM()
    private var dataSource: UITableViewDiffableDataSource<Section, MovieListResultModel>!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.isForFavMovie ? Constants.favtitle.rawValue : Constants.movieListTile.rawValue
        self.view.backgroundColor = .systemGroupedBackground
        self.viewModel.fetchFavMovieList()
        viewModel.delegate = self
        setUpTableView()
        setupDataSource()
        applySnapshot()
        if !viewModel.isForFavMovie{
            setUpNavigationBarItem()
            viewModel.prepareDataSource()
        }

    }
    private func setUpNavigationBarItem(){
        let rightButton = UIBarButtonItem(
               image: UIImage(systemName: "heart.fill"), // Use SF Symbols or custom image
               style: .plain,
               target: self,
               action: #selector(rightButtonTapped)
           )
           
           // Add to navigation bar
           navigationItem.rightBarButtonItem = rightButton
    }
    @objc func rightButtonTapped() {
        let obj = MovieListVC()
        obj.viewModel.isForFavMovie = true
        obj.viewModel.reloadClouser = {[unowned self] data in
            self.viewModel.reloadFavMovie(data: data)
            
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    private func setUpTableView(){
        self.tableView.delegate = self
        self.tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: CellEnum.MovieListTVC.rawValue, bundle: nil), forCellReuseIdentifier: CellEnum.MovieListTVC.rawValue)
        

    }
    
    private func setupDataSource() {
           dataSource = UITableViewDiffableDataSource<Section, MovieListResultModel>(tableView: tableView) { tableView, indexPath, movie in
               let cell = tableView.dequeueReusableCell(withIdentifier: CellEnum.MovieListTVC.rawValue, for: indexPath) as! MovieListTVC
               cell.configureCell(data: movie)
               cell.favClouser = {[unowned self] in
                   self.viewModel.addMovieRemoveMovieFromFav(data: movie)
               }
               return cell
           }
       }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
          var snapshot = NSDiffableDataSourceSnapshot<Section, MovieListResultModel>()
          snapshot.appendSections([.main])
          snapshot.appendItems(self.viewModel.movieList)
          dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        if self.viewModel.movieList.isEmpty{
            tableView.backgroundView = Utility.getNoDataView(string: Constants.noDataAvailable.rawValue)
        }else{
            tableView.backgroundView = nil
        }
      }
  
    func appendItems(data:[MovieListResultModel]){
        if self.viewModel.pageNumber == 1{
            applySnapshot(animatingDifferences: false)
        }else{
            var snapshot = dataSource.snapshot()
            snapshot.appendItems(data, toSection: .main)
            dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    func deleteAllDataSnapshot(){
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot,animatingDifferences: true)
        if self.viewModel.movieList.isEmpty{
            tableView.backgroundView = Utility.getNoDataView(string: Constants.noDataAvailable.rawValue)
        }else{
            tableView.backgroundView = nil
        }
    }
    
    func reloadMovieItem(data:[MovieListResultModel]){
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(data)
        dataSource.apply(snapshot,animatingDifferences: true)
    }

}

extension MovieListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.loadMoreData && indexPath.row == (self.viewModel.movieList.count-1){
            self.viewModel.pageNumber += 1
            if let _ = self.viewModel.searchMovieTitle{
                self.viewModel.searchMovieByTitle()
            }else{
                self.viewModel.prepareDataSource()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = dataSource.itemIdentifier(for: indexPath)?.id{
            let obj = MovieDetailVC()
            obj.viewModel.movieId = id
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}

extension MovieListVC:ReloadSnapshot{
    func deleteAlldata() {
        deleteAllDataSnapshot()
    }
    
    func reloadSnapshot(_ data: [MovieListResultModel],addList:Bool) {
        if addList{
            appendItems(data: data)
        }else{
            reloadMovieItem(data: data)
        }
    }
    
    
}

extension MovieListVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewModel.isForFavMovie{
            self.viewModel.searchFavMovieByTitle(title: searchBar.text ?? "")
        }else{
            self.viewModel.searchMovie(search: searchBar.text ?? "")
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if viewModel.isForFavMovie{
            self.viewModel.searchFavMovieByTitle(title: searchBar.text ?? "")
        }else{
            self.viewModel.searchMovie(search: searchBar.text ?? "",delay: 0)
        }
    }
}
