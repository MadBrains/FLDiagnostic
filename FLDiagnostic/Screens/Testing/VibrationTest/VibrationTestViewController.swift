//
//  VibrationTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class VibrationTestViewController: BaseViewController {
    private var viewModel: VibrationTestViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var playVibroAgainButton: UIButton!
    @IBOutlet private weak var noVibroButton: BorderedButton!
    @IBOutlet private weak var haveVibroButton: BorderedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()

        playVibroAgainButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                self.viewModel.playVibro()
            })
            .disposed(by: disposeBag)

        noVibroButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [unowned self] in
              self.viewModel.test.isPassed = false
              self.viewModel.notWorkingDiagnostic(self.viewModel.test)
            })
            .disposed(by: disposeBag)

        haveVibroButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                self.endTest()
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.playVibro()
    }

    func endTest() {
      viewModel?.startNextTest()
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }
}
extension VibrationTestViewController {
    static func create(_ viewModel: VibrationTestViewModel) -> VibrationTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "VibrationTestViewController") as? VibrationTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
