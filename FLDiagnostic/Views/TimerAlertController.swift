//
//  TimerAlertController.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 04.02.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

class TimerAlertController: BaseViewController {

  private var viewModel: BaseControllerViewModel!

  @IBAction func okButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

}
extension TimerAlertController {
  static func create(_ viewModel: BaseControllerViewModel) -> TimerAlertController {
    let controller = TimerAlertController(nibName: "TimerAlertController", bundle: Bundle(for: FLDiagnostic.self))
    controller.viewModel = viewModel
    controller.modalTransitionStyle = .crossDissolve
    controller.modalPresentationStyle = .overFullScreen
    return controller
  }
}
