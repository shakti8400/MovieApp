//
//  NoDataView.swift
//  SMW
//
//  Created by Shakti Singh on 10/07/23.
//  Copyright © 2023 Smart Utility Systems. All rights reserved.
//

import Foundation
import UIKit

class NoDataView:UIView{
    @IBOutlet weak var noDataViewLbl: UILabel!
    
    func setNoDataViewString(str:String){
        noDataViewLbl.text = str
    }

}
