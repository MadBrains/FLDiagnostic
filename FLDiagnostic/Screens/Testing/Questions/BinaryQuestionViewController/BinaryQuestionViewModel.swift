//
//  BinaryQuestionViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BinaryQuestionViewModel: BaseControllerViewModel {
  let question: Question
  var page: Int
  
  init(_ question: Question, _ page: Int) {
    self.question = question
    self.page = page
    super.init()
  }
  
  var titleText = BehaviorSubject<String>(value: "")
  var desctiptionText = BehaviorSubject<String>(value: "")
  
  var yesButtonPressed = PublishSubject<Void>()
  var noButtonPressed = PublishSubject<Void>()
  
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    titleText.onNext(question.primaryText)
    desctiptionText.onNext(question.secondaryText)
    
    yesButtonPressed.asObserver().subscribe(onNext: { [unowned self]() in
      self.question.isPassed = true
      self.showNextViewController()
    }).disposed(by: disposeBag)
    
    noButtonPressed.asObserver().subscribe(onNext: { [unowned self]() in
      self.question.isPassed = false
      self.showNextViewController()
    }).disposed(by: disposeBag)
  }
  
  private func showNextViewController() {
    showNextTestViewController()
  }
}
