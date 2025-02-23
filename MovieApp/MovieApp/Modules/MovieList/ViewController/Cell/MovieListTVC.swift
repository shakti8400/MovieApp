//
//  MovieListTVC.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import UIKit

class MovieListTVC: UITableViewCell {
    @IBOutlet weak var movieImgView:LoadingImageView!
    @IBOutlet weak var movieTitle:UILabel!
    @IBOutlet weak var releaseYear:UILabel!
    @IBOutlet weak var favBtn:UIButton!
    @IBOutlet weak var mainView:UIView!
    var favClouser:(()->Void)?
    var movieData:MovieListResultModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.mainView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureCell(data:MovieListResultModel){
        self.movieData = data
        movieTitle.text = data.title
        releaseYear.text = Utility.dateFormat(dateString: data.release_date ?? "N/A", inFormat: Constants.df_yyyy_mm_dd.rawValue, outFormat: Constants.represenatbleDf.rawValue)
            if let imgUrl = data.poster_path{
                    self.movieImgView.loadImage(from: "\(MovieAPIEnum.w500ImgUrl.rawValue)\(imgUrl)")
            }
        favBtn.isSelected = data.isAddedInFav ?? false
        
    
    }
    @IBAction func favBtn(_ sender:UIButton){
        if let movieData{
            favClouser?()
            movieData.isAddedInFav = !(movieData.isAddedInFav ?? false)
            favBtn.isSelected = movieData.isAddedInFav ?? false
        }
    }
    
}
