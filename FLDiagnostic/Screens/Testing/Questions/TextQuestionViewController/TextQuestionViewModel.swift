//
//  TextQuestionViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class TextQuestionViewModel: BaseControllerViewModel {
  let question: Question
  var page: Int
  
  init(_ question: Question, _ page: Int) {
    self.question = question
    self.page = page
    super.init()
  }
  
  var titleText = BehaviorSubject<String>(value: "")
  var desctiptionText = BehaviorSubject<String>(value: "")
  var fieldDescriptionText = BehaviorSubject<String>(value: "")
  var placeholderText = BehaviorSubject<String>(value: "")
  var isNextEnabled = BehaviorSubject<Bool>(value: false)
  var nextButtonColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
  
  var textFieldText = BehaviorSubject<String>(value: "")
  var nextButtonPressed = PublishSubject<Void>()

  enum EditState {
    case editing
    case notEditing
  }

  var textInputState = BehaviorSubject<EditState>(value: .notEditing)
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    titleText.onNext(question.primaryText)
    desctiptionText.onNext(question.secondaryText)
    placeholderText.onNext(question.answerEditName ?? "")
    fieldDescriptionText.onNext(question.answerEditHint ?? "")
    textFieldText.subscribe(onNext: { text in
      self.nextButtonColor.onNext(!text.isEmpty ? #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
      }).disposed(by: disposeBag)
    nextButtonPressed.asObserver().withLatestFrom(textFieldText).subscribe(onNext: { [unowned self] (text) in
      self.question.timeSpent = DiagnosticService.shared.calculateSpentTime()
      self.question.answer = text
      self.showNextTestViewController()
    }).disposed(by: disposeBag)
  }
}
extension TextQuestionViewModel: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textInputState.onNext(.editing)
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    textInputState.onNext(.notEditing)
  }
}
