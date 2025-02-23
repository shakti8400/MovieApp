//
//  MovieDetailVC.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import UIKit

class MovieDetailVC: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var backgroundImgView:LoadingImageView!
    @IBOutlet weak var moviePosterImgView:LoadingImageView!
    var dataSource : UICollectionViewDiffableDataSource<MovieDetailSection,AnyHashable>!
    var viewModel = MovieDetailVM()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  Constants.movieDetail.rawValue
        viewModel.delegate = self
        configureCollectionView()
        self.viewModel.prepareMovieDetailData()
        configureDataSource()
        collectionViewLayout()
        configureHeaderView()
    }
    func configureCollectionView() {
        self.collectionView.register(UINib(nibName: CellEnum.DetailCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: CellEnum.DetailCVC.rawValue)
        self.collectionView.register(UINib(nibName: CellEnum.CastProfileCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: CellEnum.CastProfileCVC.rawValue)
        self.collectionView.register(UINib(nibName: CellEnum.HeaderCollectionReusableView.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellEnum.HeaderCollectionReusableView.rawValue)
    }
    func configureHeaderView(){
        dataSource.supplementaryViewProvider = { [unowned self](collectionView, kind, indexPath) in
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier:CellEnum.HeaderCollectionReusableView.rawValue,
                for: indexPath) as! HeaderCollectionReusableView
            view.setDetail(str: Constants.castHeaderTitle.rawValue)
            return view
        }
    }
    func collectionViewLayout(){
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: {[unowned self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let size: NSCollectionLayoutSize
            if sectionIndex == 0{
                size = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)
                )
            }else{
                size = NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(300)
                )
            }
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size  , subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            if sectionIndex == 1{
                section.orthogonalScrollingBehavior = .continuous
                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(self.view.frame.width),
                    heightDimension:.absolute(40)
                )
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                sectionHeader.pinToVisibleBounds = true
                sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0)
                section.boundarySupplementaryItems = [sectionHeader]
            }
        
            return section
        })
    }
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<MovieDetailSection,AnyHashable>(collectionView: collectionView, cellProvider: {[unowned self] (collectionView, indexPath, itemIdentifier) in
            if indexPath.section == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellEnum.DetailCVC.rawValue, for: indexPath) as! DetailCVC
                cell.setDetail(data: itemIdentifier)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellEnum.CastProfileCVC.rawValue, for: indexPath) as! CastProfileCVC
            cell.setDetail(data: itemIdentifier)
            return cell

        })
    }
    func applySnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<MovieDetailSection,AnyHashable>()
        snapshot.appendSections([.detail,.cast])
        snapshot.appendItems(self.viewModel.movieDetailDataList, toSection: .detail)
        snapshot.appendItems(self.viewModel.movieCastList, toSection: .cast)

        dataSource.apply(snapshot,animatingDifferences: true)
      
        
    }
    func setBackgroundImg(){
        if let img = self.viewModel.movieDetail?.backdrop_path{
            self.backgroundImgView.loadImage(from: "\(MovieAPIEnum.originalImgUrl.rawValue)\(img)")
        }
        if let img = self.viewModel.movieDetail?.poster_path{
            self.moviePosterImgView.loadImage(from: "\(MovieAPIEnum.originalImgUrl.rawValue)\(img)")
        }
    }

}

extension MovieDetailVC:ReloadMovieDetailProtocol{
    func reloadSnapshot() {
        applySnapshot()
        setBackgroundImg()
    }
    
}
