//
//  FLDiagnostic.swift
//  FLDiagnostic
//
//  Created by Данил on 26/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxSwift

public class FLDiagnostic {
  static let SDKVerison = "1.2.6"

  public typealias GradeBlock = (_ grade: String?, _ error: String?) -> Void
  
  public static func startTesting(_ diagnosticId: String, _ url: String, finalGrade: GradeBlock? = nil) {
    UIFont.loadFonts()
    
    DiagnosticService.shared.setCurrentDiagnostikID(diagnosticId, url)
    
    DiagnosticService.shared.onGetGrade = { (grade: String?, error: String?) -> Void in
      finalGrade?(grade, error)
    }
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
      
      let viewModel = IMEIViewModel()
      guard let viewController = IMEIViewController.create(viewModel) else { return }
      let navigationController = UINavigationController(rootViewController: viewController)
      navigationController.modalPresentationStyle = .fullScreen
      navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.09803921569, green: 0.02745098039, blue: 0.368627451, alpha: 1)
      navigationController.navigationBar.isTranslucent = false
      navigationController.navigationBar.titleTextAttributes = [
          NSAttributedString.Key.foregroundColor: UIColor.white,
          NSAttributedString.Key.font: UIFont.proximaNova(size: 20, weight: .regular)
          ]
      topController.present(navigationController, animated: true, completion: nil)
    }
    
    
  }
  
  
}
