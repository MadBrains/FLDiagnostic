//
//  SoundTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 12.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SoundTestViewController: BaseViewController {
    private var viewModel: SoundTestViewModel!
    private let disposeBag = DisposeBag()

  @IBOutlet private weak var adviceView: UIView!
  @IBOutlet private weak var testCompletedView: UIView!

    @IBOutlet private weak var playSoundAgainButton: UIButton!
    @IBOutlet private weak var noSoundButton: BorderedButton!
    @IBOutlet private weak var haveSoundButton: BorderedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()

        playSoundAgainButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.playSound()
            })
            .disposed(by: disposeBag)

        noSoundButton.rx.tap
            .subscribe(onNext: { [unowned self] in
              self.viewModel.test.isPassed = false
              self.viewModel.notWorkingDiagnostic(self.viewModel.test)
            })
            .disposed(by: disposeBag)

        haveSoundButton.rx.tap
            .subscribe(onNext: {
                self.endTest()
            })
            .disposed(by: disposeBag)
      
      viewModel.isAdviceHidden.bind(to: adviceView.rx.isHidden).disposed(by: disposeBag)
    }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.stopSound()
  }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.playSound()
    }

    func endTest() {
      viewModel.stopSound()
      self.viewModel.test.timeSpent = DiagnosticService.shared.calculateSpentTime()
      self.viewModel.test.isPassed = true
      viewModel?.showNextTestViewController()
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }
}
extension SoundTestViewController {
    static func create(_ viewModel: SoundTestViewModel) -> SoundTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "SoundTestViewController") as? SoundTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
