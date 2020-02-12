//
//  NFCTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 25.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

@available(iOS 11.0, *)
class NFCTestViewController: BaseViewController {
  private var viewModel: NFCTestViewModel!
  private let disposeBag = DisposeBag()

  @IBOutlet private weak var turnOnNFCLabel: UILabel!
  @IBOutlet private weak var goToSettingsButton: UIButton!
  @IBOutlet private weak var dontWorkButton: BorderedButton!

  @IBOutlet private weak var testView: UIView!
  @IBOutlet private weak var bringPhoneToRFIDLabel: UILabel!
  @IBOutlet private weak var workingButton: BorderedButton!
  @IBOutlet private weak var dontWorkingButton: BorderedButton!

  @IBOutlet private weak var testCompletedView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()

    dontWorkButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.testFailed()
      })
      .disposed(by: disposeBag)

    dontWorkingButton.rx.tap
      .subscribe(onNext: {
        self.viewModel.test.isPassed = false
        self.viewModel.notWorkingDiagnostic()
      })
      .disposed(by: disposeBag)

    workingButton.rx.tap
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: disposeBag)

    self.viewModel.startTest()
      .subscribe(onNext: {
        self.endTest()
      })
      .disposed(by: self.disposeBag)

  }

  func endTest() {
    DispatchQueue.main.async {
      self.testCompletedView.isHidden = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
      viewModel?.startNextTest()
    }
  }

  private func setupStyle() {
    let turnOnNFCAttributedString = NSMutableAttributedString(string:"Включите NFC ")
    let nfcIconAttachment = NSTextAttachment()
    nfcIconAttachment.image = #imageLiteral(resourceName: "nfcIcon")
    nfcIconAttachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
    let nfcIconString = NSAttributedString(attachment: nfcIconAttachment)
    turnOnNFCAttributedString.append(nfcIconString)
    turnOnNFCAttributedString.append(NSAttributedString(string:" в настройках телефона"))
    turnOnNFCLabel.attributedText = turnOnNFCAttributedString

    let bringPhoneToRFIDAttributedString = NSMutableAttributedString(string:"Приложите смартфон к карточке с RFID-меткой ")
    let rfidIconAttachment = NSTextAttachment()
    rfidIconAttachment.image = #imageLiteral(resourceName: "RFIDIcon")
    rfidIconAttachment.bounds = CGRect(x: 0, y: -6, width: 28, height: 28)
    let rfidIconString = NSAttributedString(attachment: rfidIconAttachment)
    bringPhoneToRFIDAttributedString.append(rfidIconString)
    bringPhoneToRFIDLabel.attributedText = bringPhoneToRFIDAttributedString

    setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
  }
}
@available(iOS 11.0, *)
extension NFCTestViewController {
  static func create(_ viewModel: NFCTestViewModel) -> NFCTestViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "NFCTestViewController") as? NFCTestViewController
    viewController?.viewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}
