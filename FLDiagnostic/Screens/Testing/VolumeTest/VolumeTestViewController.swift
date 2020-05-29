//
//  VolumeUpTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 05.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class VolumeTestViewController: BaseViewController {
    @IBOutlet private weak var notWorkingButton: BorderedButton!
    @IBOutlet private weak var testCompletedView: UIView!

    @IBOutlet private weak var testLabel: UILabel!
    @IBOutlet private weak var testArt: UIImageView!

    private var viewModel: VolumeTestViewModel!
    private var disposeBag = DisposeBag()

    private var currentButtonTypeTest = VolumeButtonType.up

    override func viewDidLoad() {
      super.viewDidLoad()
      setupStyle()
    
      viewModel.volumeChanged.subscribe(onNext: { [weak self] buttonType in
        if self?.currentButtonTypeTest == buttonType {
          self?.buttonChecked()
        }
      })
      .disposed(by: disposeBag)

      notWorkingButton.rx.tap
      .subscribe(onNext: { [unowned self] () in
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      })
      .disposed(by: disposeBag)
      // на симуляторе нельзя проверить кнопки громкости
      #if targetEnvironment(simulator)
          self.endTest()
      #endif
    }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }

  func buttonChecked() {
    switch currentButtonTypeTest {
    case .up:
      UIView.animate(withDuration: 0.3, animations: {
        self.testLabel.text = "Нажмите кнопку \"Уменьшить громкость\""
        self.testArt.image = UIImage.FLImage("VolumeDownTestArt")
      }) { _ in
        self.currentButtonTypeTest = .down
      }
    case .down:
      endTest()
    }
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
}
extension VolumeTestViewController {
  static func create(_ viewModel: VolumeTestViewModel) -> VolumeTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "VolumeTestViewController") as? VolumeTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}
