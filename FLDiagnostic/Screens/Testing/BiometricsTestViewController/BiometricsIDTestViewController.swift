//
//  BiometricsTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 20.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BiometricsTestViewController: BaseViewController {
  private var viewModel: BiometricsTestViewModel!
  private let disposeBag = DisposeBag()

  @IBOutlet private weak var testCompletedView: UIView!

  @IBOutlet private weak var biometricsTestTextLabel: UILabel!
  @IBOutlet private weak var biometricsWorkingButton: BorderedButton!
  @IBOutlet private weak var biometricsNotWorkingButton: BorderedButton!

  @IBOutlet private weak var dontHaveBiometricsView: UIView!
  @IBOutlet private weak var biometricsArtDontHaveImageView: UIImageView!
  @IBOutlet private weak var biometricsArtDontHaveLabel: UILabel!
  @IBOutlet private weak var biometricsDontHaveButton: BorderedButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    if isSafeArea {
      biometricsTestTextLabel.text = "Проверьте работу face id, если face id не срабатывает, попробуйте проверить его в ручную"
      biometricsArtDontHaveImageView.image = #imageLiteral(resourceName: "FaceIDArt")
      biometricsArtDontHaveLabel.text = "Face id \nне найден"
    } else {
      biometricsTestTextLabel.text = "Прикоснитесь к сканеру отпечатка пальцев, если сканер не срабатывает, попробуйте проверить его вручную"
      biometricsArtDontHaveImageView.image = #imageLiteral(resourceName: "TouchIdArt")
      biometricsArtDontHaveLabel.text = "Сканер отпечатка пальца \nне найден"
    }

    biometricsNotWorkingButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.testFailed()
      })
      .disposed(by: disposeBag)

    biometricsDontHaveButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.startNextTest()
      })
      .disposed(by: disposeBag)

    biometricsWorkingButton.rx.tap
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)

    viewModel.startTest()
      .subscribe(onNext: {
        self.endTest()
      }, onCompleted: {
        self.showDontHaveFaceIdView()
      })
      .disposed(by: disposeBag)
  }

  func endTest() {
      DispatchQueue.main.async {
          self.testCompletedView.isHidden = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [viewModel] in
          viewModel?.startNextTest()
      }
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: viewModel.page, infoHidden: viewModel.test.infoNeeded)
  }

  func showDontHaveFaceIdView() {
    self.dontHaveBiometricsView.isHidden = false
  }
}
extension BiometricsTestViewController {
    static func create(_ viewModel: BiometricsTestViewModel) -> BiometricsTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "BiometricsTestViewController") as? BiometricsTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
