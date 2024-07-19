//
//  ViewController+.swift
//  MeaningOutProject
//
//  Created by 박성민 on 6/14/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, okButton: String, completionHandler: @escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let ok = UIAlertAction(title: okButton, style: .default, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
    
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func simpleShowAlert(title: String, message: String?, okButton: String) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let ok = UIAlertAction(title: okButton, style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    func errorAlert(message: String) {
        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
