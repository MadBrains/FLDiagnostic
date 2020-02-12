//
//  TextQuestionViewController.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxOptional
import RxKeyboard

class TextQuestionViewController: BaseViewController {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  @IBOutlet private weak var textFieldContainerView: UIView!
  @IBOutlet private weak var answerTextField: UITextField!
  @IBOutlet private weak var textFieldDescriptionLabel: UILabel!
  @IBOutlet private weak var nextButton: BorderedButton!
  @IBOutlet private weak var hintLabel: UILabel!
  @IBOutlet private weak var bottomNextConstraint: NSLayoutConstraint!

  private var model: TextQuestionViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }

  @IBAction func onTextChanged(_ sender: UITextField) {
    if sender.text?.first == "0", sender.text?.count != 1 {
      sender.text?.removeFirst()
    }
    if (sender.text?.count ?? 0) > 2 {
      sender.text?.removeLast()
    }
    model.isNextEnabled.onNext(!(sender.text ?? "").isEmpty)
  }

  private func setupRx() {
    model.isNextEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
    model.titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.desctiptionText.bind(to: subtitleLabel.rx.text).disposed(by: disposeBag)
    model.fieldDescriptionText.bind(to: textFieldDescriptionLabel.rx.text).disposed(by: disposeBag)
    model.placeholderText.bind(to: answerTextField.rx.placeholder).disposed(by: disposeBag)
    model.placeholderText.subscribe(onNext: { [hintLabel] text in
      hintLabel?.text = " " + text + " "
    })
      .disposed(by: disposeBag)
    answerTextField.delegate = model
    model.nextButtonColor.subscribe(onNext: { color in
      self.nextButton.backgroundColor = color
      self.nextButton.borderColor = color
      }).disposed(by: disposeBag)
    model.textInputState
      .subscribe(onNext: { [unowned self] state in
        switch state {
        case .editing:
          self.setStyleFocused()
        case .notEditing:
          self.setStyleUnfocused()
        }
      })
      .disposed(by: disposeBag)

    answerTextField.rx.textChange.filterNil().bind(to: model.textFieldText).disposed(by: disposeBag)

    answerTextField.rx.textChange
      .subscribe(onNext: { [hintLabel] text in
        hintLabel?.isHidden = (text ?? "").isEmpty
      })
      .disposed(by: disposeBag
    )
    nextButton.rx.tap.bind(to: model.nextButtonPressed).disposed(by: disposeBag)
    RxKeyboard.instance.visibleHeight.skip(1)
    .drive(onNext: { [unowned self] visibleHeight in
      self.animateWorkspaceHeight(visibleHeight)
    })
    .disposed(by: disposeBag)
  }

  private func setStyleFocused() {
    textFieldContainerView.layer.borderColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
    textFieldContainerView.layer.borderWidth = 2
    textFieldContainerView.layer.cornerRadius = 10
    textFieldDescriptionLabel.textColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
    hintLabel.textColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
  }

  private func setStyleUnfocused() {
    textFieldContainerView.layer.borderColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    textFieldContainerView.layer.borderWidth = 2
    textFieldContainerView.layer.cornerRadius = 10
    textFieldDescriptionLabel.textColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
    hintLabel.textColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
  }

  private func setupStyle() {
    setDefaultNavigationBar(page: model.page, info: model.question.information)
    answerTextField.tintColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
    setStyleUnfocused()
  }

  private func animateWorkspaceHeight(_ visibleHeight: CGFloat) {
    let height = visibleHeight == 0 ? 16 : 16 + visibleHeight - bottomInset
    bottomNextConstraint.constant = height
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
  }
}

extension TextQuestionViewController {
  
  static func create(_ viewModel: TextQuestionViewModel) -> TextQuestionViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "TextQuestionViewController") as? TextQuestionViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
