//
//  HeaderCollectionReusableView.swift
//  MovieApp
//
//  Created by Shakti Singh on 22/02/25.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var headerTitle:UILabel!
    @IBOutlet weak var mainView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.backgroundColor = .systemGroupedBackground
        // Initialization code
    }
    func setDetail(str:String){
        self.headerTitle.text = str
    }
    
}
