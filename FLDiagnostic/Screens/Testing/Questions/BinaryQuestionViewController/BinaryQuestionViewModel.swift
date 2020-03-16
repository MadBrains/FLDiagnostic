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
  
  var yesGrade: GradeMapBinary?
  var noGrade:  GradeMapBinary?
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    titleText.onNext(question.primaryText)
    desctiptionText.onNext(question.secondaryText)
    
    yesGrade = question.gradeMapBinary?.first(where: { $0.value == true })
    noGrade = question.gradeMapBinary?.first(where: { $0.value == false })
    
    yesButtonPressed.asObserver().subscribe(onNext: { [unowned self]() in
      self.question.timeSpent = DiagnosticService.shared.calculateSpentTime()
      self.question.isPassed = true
      
      if self.yesGrade?.grade == "F" && self.question.affectsScore == true {
        self.notWorkingDiagnostic(nil)
      } else {
        self.showNextViewController()
      }
    }).disposed(by: disposeBag)
    
    noButtonPressed.asObserver().subscribe(onNext: { [unowned self]() in
      self.question.isPassed = false
      
      if self.noGrade?.grade == "F" && self.question.affectsScore == true {
        self.notWorkingDiagnostic(nil)
      } else {
        self.showNextViewController()
      }
    }).disposed(by: disposeBag)
  }
  
  private func showNextViewController() {
    showNextTestViewController()
  }
}
