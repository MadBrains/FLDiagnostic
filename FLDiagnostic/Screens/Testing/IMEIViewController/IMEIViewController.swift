//
//  IMEIViewController.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxOptional
import RxKeyboard

class IMEIViewController: BaseViewController {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  @IBOutlet private weak var textFieldContainerView: UIView!
  @IBOutlet private weak var imeiTextField: UITextField!
  @IBOutlet private weak var textFieldDescriptionLabel: UILabel!
  @IBOutlet private weak var nextButton: BorderedButton!
  @IBOutlet private weak var settingsButton: BorderedButton!
  @IBOutlet private weak var bottomNextConstraint: NSLayoutConstraint!
  private var model: IMEIViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    model.titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.desctiptionText.bind(to: subtitleLabel.rx.attributedText).disposed(by: disposeBag)
    model.fieldDescriptionText.bind(to: textFieldDescriptionLabel.rx.text).disposed(by: disposeBag)
    model.isNextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
    model.nextButtonColor.bind(to: nextButton.rx.backgroundColor).disposed(by: disposeBag)
    model.imeiText.bind(to: imeiTextField.rx.text).disposed(by: disposeBag)
    
    imeiTextField.rx.textChange.filterNil().bind(to: model.imeiTextChanged).disposed(by: disposeBag)
    nextButton.rx.tap.bind(to: model.nextButtonPressed).disposed(by: disposeBag)
    settingsButton.rx.tap.bind(to: model.settingsButtonPressed).disposed(by: disposeBag)
    RxKeyboard.instance.visibleHeight.skip(1)
    .drive(onNext: { [unowned self] visibleHeight in
      self.animateWorkspaceHeight(visibleHeight)
    })
    .disposed(by: disposeBag)
  }
  
  private func setupStyle() {
    imeiTextField.delegate = self
    textFieldContainerView.layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    textFieldContainerView.layer.borderWidth = 2
    textFieldContainerView.layer.cornerRadius = 10
  }

  private func animateWorkspaceHeight(_ visibleHeight: CGFloat) {
    let height = visibleHeight == 0 ? 16 : 16 + visibleHeight - bottomInset
    bottomNextConstraint.constant = height
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
  }
}

extension IMEIViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    textField.text = model.formattedIMEI(newString)
    return false
  }
  
}

extension IMEIViewController {
  
  static func create(_ viewModel: IMEIViewModel) -> IMEIViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "IMEIViewController") as? IMEIViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
