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
  
  var textFieldText = BehaviorSubject<String>(value: "")
  var nextButtonPressed = PublishSubject<Void>()
  
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    titleText.onNext(question.primaryText)
    desctiptionText.onNext(question.secondaryText)
    placeholderText.onNext(question.answerEditName ?? "")
    fieldDescriptionText.onNext(question.answerEditHint ?? "")
    
    nextButtonPressed.asObserver().withLatestFrom(textFieldText).subscribe(onNext: { (text) in
      self.question.answer = text
      self.showNextTestViewController()
    }).disposed(by: disposeBag)
  }
}
