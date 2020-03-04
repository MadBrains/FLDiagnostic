//
//  TestController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 03.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class AccelerometerTestViewController: BaseViewController {

    @IBOutlet private weak var testCompletedView: UIView!

    @IBOutlet private weak var xCheck: AccelerometerCheckView!
    @IBOutlet private weak var yCheck: AccelerometerCheckView!
    @IBOutlet private weak var zCheck: AccelerometerCheckView!
    @IBOutlet private weak var notWorkingButton: BorderedButton!

    private var viewModel: AccelerometerTestViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()

      setupStyle()

      viewModel.startTest().subscribe(onNext: { [weak self] axisCheck in
            self?.xCheck.isChecked = axisCheck.xCheck
            self?.yCheck.isChecked = axisCheck.yCheck
            self?.zCheck.isChecked = axisCheck.zCheck

            if axisCheck.testCompleted {
                self?.endTest()
            }
            }, onError: { [weak self] _ in
                self?.viewModel.testFailed()
            }).disposed(by: disposeBag)

        notWorkingButton.rx.tap
            .subscribe(onNext: { [unowned self] in
              self.viewModel.notWorkingDiagnostic(self.viewModel.test)
            })
            .disposed(by: disposeBag)
        // на симуляторе нельзя проверить акселерометер
        #if targetEnvironment(simulator)
            self.endTest()
        #endif
    }

    func endTest() {
      if viewModel.completed == true { return }
      viewModel.completed = true
      
      DispatchQueue.main.async {
        self.testCompletedView.isHidden = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
        viewModel?.startNextTest()
      }
    }
  
  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }
}

extension AccelerometerTestViewController {
  
  static func create(_ viewModel: AccelerometerTestViewModel) -> AccelerometerTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "AccelerometerTestViewController") as? AccelerometerTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
