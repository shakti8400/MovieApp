//
//  Extension.swift
//  MovieApp
//
//  Created by Shakti Singh on 21/02/25.
//

import Foundation

import UIKit

extension UIViewController {
    private static var loadingViewTag = 9999
    
    func addLoader(_ message: String? = nil) {
               if view.viewWithTag(UIViewController.loadingViewTag) != nil { return }
               
               let cardView = UIView()
               cardView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
               cardView.layer.cornerRadius = 12
               cardView.clipsToBounds = true
               cardView.tag = UIViewController.loadingViewTag
               cardView.translatesAutoresizingMaskIntoConstraints = false
               
               let spinner = UIActivityIndicatorView(style: .large)
               spinner.startAnimating()
               spinner.translatesAutoresizingMaskIntoConstraints = false
               
               let label = UILabel()
               label.text = message
               label.textColor = .white
               label.textAlignment = .center
               label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
               label.translatesAutoresizingMaskIntoConstraints = false
               label.isHidden = (message == nil)
               
               cardView.addSubview(spinner)
               cardView.addSubview(label)
               view.addSubview(cardView)
               
               NSLayoutConstraint.activate([
                   cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   cardView.widthAnchor.constraint(equalToConstant: 150),
                   cardView.heightAnchor.constraint(equalToConstant: 100)
               ])
               
               NSLayoutConstraint.activate([
                   spinner.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                   spinner.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20)
               ])
               
               NSLayoutConstraint.activate([
                   label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10),
                   label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
                   label.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10)
               ])
    }
    
    func removeLoader() {
        view.viewWithTag(UIViewController.loadingViewTag)?.removeFromSuperview()
    }
    func showAlert(messsage:String){
        let alert = UIAlertController(title: Constants.messageStr.rawValue, message: messsage, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: Constants.okBtn.rawValue, style: .default)
        alert.addAction(okBtn)
        Utility.navigationController?.topViewController?.present(alert, animated: true)
    }
}

extension UIView{
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
