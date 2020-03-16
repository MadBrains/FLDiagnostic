//
//  ResetQuestionsViewModel.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 30.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class ResetQuestionsViewModel: BaseTableViewViewModel {
  var isResettingQuestions: Bool
  var questions: [Question] = DiagnosticService.shared.questions
  private let disposeBag = DisposeBag()
  var recalculateButtonPressed = PublishSubject<Void>()
  var recalculateButtonTitle = BehaviorSubject<String>(value: "")
  var isNextEnabled = BehaviorSubject<Bool>(value: false)
  var nextButtonColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
  var answersChanged = BehaviorSubject<Void>(value: ())

  init(isResetting: Bool) {
    isResettingQuestions = isResetting
    super.init()
  }
  override func setupModel() {
    super.setupModel()
    recalculateButtonTitle
      .onNext(isResettingQuestions ? "Пересчитать результаты" : "Сохранить результаты")

    recalculateButtonPressed
      .subscribe(onNext: { [unowned self] in
        self.saveDiagnostics()
      })
    .disposed(by: disposeBag)

    answersChanged.subscribe(onNext: { [unowned self] () in
      self.isNextEnabled.onNext(self.questions.allSatisfy({ $0.isPassed != nil || !($0.answer ?? "").isEmpty }))
      }).disposed(by: disposeBag)
  }
  override func createCellModels() {
    var cellModels = [BaseCellModel]()
    let binaryQuestions = questions.filter({ $0.type == "general" })
    binaryQuestions.forEach { question in
      let binaryCellModel = BinaryCellModel(question: question)
      binaryCellModel.onBinaryButtonTapped = { [unowned self] (answer: Bool) -> Void in
        question.isPassed = answer
      }
      
      binaryCellModel.onAbortDiagnostic = { [unowned self] () -> Void in
        self.notWorkingDiagnostic(nil, question)
      }
      cellModels.append(binaryCellModel)
    }
    let numberQuestions = questions.filter({ $0.type == "number_from_interval" })
    numberQuestions.forEach { question in
      let numberCellModel = NumberCellModel(question: question)
      numberCellModel.onTextEdited = { [unowned self] (answer: String) -> Void in
        question.answer = answer.isEmpty ? "" : answer
        self.answersChanged.onNext(())
      }
      cellModels.append(numberCellModel)
    }
    tableViewOutput.cellModels.onNext(cellModels)
  }
  
}
