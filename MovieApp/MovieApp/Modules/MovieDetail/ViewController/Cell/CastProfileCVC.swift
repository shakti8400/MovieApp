//
//  CastProfileCVC.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import UIKit

class CastProfileCVC: UICollectionViewCell {
    @IBOutlet weak var profileImg:LoadingImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var castingLbl:UILabel!
    @IBOutlet weak var mainView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 5
        self.nameLbl.font = UIFont.boldSystemFont(ofSize: self.nameLbl.font.pointSize)
        self.castingLbl.font = UIFont.systemFont(ofSize: self.castingLbl.font.pointSize, weight: .regular)
        // Initialization code
    }
    
    func setDetail(data:AnyHashable){
        if let dta = data as? MovieDetailCastListModel{
            self.nameLbl.text = dta.name
            self.castingLbl.text = dta.character
            if let img = dta.profile_path{
                profileImg.loadImage(from: "\(MovieAPIEnum.originalImgUrl.rawValue)\(img)")
            }
        }
    }

}
