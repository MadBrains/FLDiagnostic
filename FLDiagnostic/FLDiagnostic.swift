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
  
  public static func startTesting(_ diagnosticId: String, _ imei: String) {
    DiagnosticService.shared.setCurrentDiagnostikID(diagnosticId, imei)
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
      
      let viewModel = PrepeareControllerViewModel()
      guard let viewController = PrepeareViewController.create(viewModel) else { return }
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
