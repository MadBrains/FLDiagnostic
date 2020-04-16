//
//  IMEIViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxAppState

class IMEIViewModel: BaseControllerViewModel {
  let imeiMask = "XX XXXXXX XXXXXX X"
  
  var titleText = BehaviorSubject<String>(value: "")
  var imeiText = BehaviorSubject<String>(value: "")
  var desctiptionText = BehaviorSubject<NSAttributedString>(value: NSAttributedString(string: ""))
  var fieldDescriptionText = BehaviorSubject<String>(value: "")
  var isNextEnabled = BehaviorSubject<Bool>(value: false)
  var nextButtonColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
  
  var imeiTextChanged = BehaviorSubject<String>(value: "")
  var nextButtonPressed = PublishSubject<Void>()
  var settingsButtonPressed = PublishSubject<Void>()
  
  private var imei: String = ""
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    let mutableAttributedString = NSMutableAttributedString()
    let firstDesctiption = NSAttributedString(string: "Для получения IMEI перейдите в настройки и скопируйте его или наберите номер", attributes: [
      .font: UIFont.proximaNova(size: 18, weight: .regular),
      .foregroundColor: UIColor.black])
    mutableAttributedString.append(firstDesctiption)

    let secondDesctiption = NSAttributedString(string: " *#06#", attributes: [
    .font: UIFont.proximaNova(size: 18, weight: .semibold),
    .foregroundColor: UIColor.black])
    mutableAttributedString.append(secondDesctiption)

    titleText.onNext("IMEI первого SIM-слота")
    desctiptionText.onNext(mutableAttributedString)
    fieldDescriptionText.onNext("При возврате на экран номер автоматически будет введен в поле")
    
    nextButtonPressed.asObserver().subscribe(onNext: { [weak self] () in
      guard let imei = self?.imei else { return }
      DiagnosticService.shared.imei = imei
      self?.showPrepareViewController()
    }).disposed(by: disposeBag)
    
    settingsButtonPressed.asObserver().subscribe(onNext: { [unowned self] () in
      guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
      self.openURL.onNext(url)
    }).disposed(by: disposeBag)
    
    imeiTextChanged.asObserver().subscribe(onNext: { [weak self] (imei) in
      let propperImei = imei.filter("0123456789".contains).count == 15
      self?.imei = imei.filter("0123456789".contains)
      self?.isNextEnabled.onNext(propperImei)
      self?.nextButtonColor.onNext(propperImei ? #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
    }).disposed(by: disposeBag)
    
    checkPasteboard()
    
    UIApplication.shared.rx.didOpenApp
    .subscribe(onNext: { [unowned self] _ in
      self.checkPasteboard()
    })
    .disposed(by: disposeBag)
  }
  
  private func checkPasteboard() {
    guard let imei = UIPasteboard.general.string else { return }
    let filteredImei = imei.filter("0123456789".contains)
    if filteredImei.count == 15 {
      imeiText.onNext(imei)
    }
  }
  
  private func showPrepareViewController() {
    let viewModel = PrepeareControllerViewModel()
    guard let viewController = PrepeareViewController.create(viewModel) else { return }
    showViewController.onNext(viewController)
  }
  
  func formattedIMEI(_ string: String) -> String {
    let cleanPhoneNumber = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    let mask = imeiMask

    var result = ""
    var index = cleanPhoneNumber.startIndex
    for ch in mask where index < cleanPhoneNumber.endIndex {
      if ch == "X" {
        result.append(cleanPhoneNumber[index])
        index = cleanPhoneNumber.index(after: index)
      } else {
        result.append(ch)
      }
    }
    return result
  }
}

