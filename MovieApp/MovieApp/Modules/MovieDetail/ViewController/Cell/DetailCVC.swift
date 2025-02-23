//
//  DetailCVC.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import UIKit

class DetailCVC: UICollectionViewCell {
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var valueLbl:UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDetail(data:AnyHashable){
        self.valueLbl.isHidden = true
        self.titleLbl.textColor = UIColor.black
        if let dta = data as? MovieDetailTitleValueModel{
            self.titleLbl.text = dta.title
            if let value = dta.value{
                self.titleLbl.textColor = UIColor.lightGray
                self.valueLbl.isHidden = false
                self.valueLbl.text = value
            }
            if dta.isBold{
                self.titleLbl.font = UIFont.boldSystemFont(ofSize: self.titleLbl.font.pointSize)

            }else{
                self.titleLbl.font = UIFont.systemFont(ofSize: self.titleLbl.font.pointSize, weight: .regular)

            }
        }
    }
    
}
