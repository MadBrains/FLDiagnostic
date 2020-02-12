//
//  GradeViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 25/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import SVProgressHUD

class GradeViewModel: BaseControllerViewModel {
  var grade: String = ""

  let gradeImage = BehaviorSubject<UIImage>(value: #imageLiteral(resourceName: "grade_b"))
  let gradeTitle = BehaviorSubject<String>(value: "")
  let gradeTitleColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
  var recalsculateHidden = BehaviorSubject<Bool>(value: false)
  var endTestingButtonPressed = PublishSubject<Void>()
  var recalculateButtonPressed = PublishSubject<Void>()

  private var disposeBag = DisposeBag()

  init(grade: String) {
    self.grade = grade
  }
  override func setupModel() {
    endTestingButtonPressed.subscribe(onNext: { [unowned self] () in
      self.finishDiagnostics()
    }).disposed(by: disposeBag)

    recalculateButtonPressed
      .subscribe(onNext: { [unowned self] in
        self.resetAnswers()
      }).disposed(by: disposeBag)

    switch grade {
    case "A":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_a"))
      gradeTitle.onNext("Как новый")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
      recalsculateHidden.onNext(false)
    case "B":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_b"))
      gradeTitle.onNext("Хорошее")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
      recalsculateHidden.onNext(false)
    case "C":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_c"))
      gradeTitle.onNext("Рабочий, не битый")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
      recalsculateHidden.onNext(false)
    case "F":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_x"))
      gradeTitle.onNext("Не может быть выкуплен")
      gradeTitleColor.onNext(#colorLiteral(red: 0.9176470588, green: 0, blue: 0, alpha: 1))
      recalsculateHidden.onNext(true)
    default:
      break;
    }
  }
  func resetAnswers() {
    DiagnosticService.shared.questionsResetCount += 1
    switch DiagnosticService.shared.questionsResetCount {
    case 0...2:
      let alert = UIAlertController(title: "Пересчитать результаты", message: "Вы действительно хотите пересчитать результаты тестирования?", preferredStyle: .alert)
      alert.view.tintColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
      alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Пересчитать", style: .default, handler: { [unowned self] _ in
        self.showResetController()
      }))
      modalAlert.onNext(alert)
    case 3:
      let alert = UIAlertController(title: "Предупреждение", message: "У вас осталась одна попытка пересчета, после того как попытки закончатся, изменить результат будет невозможно.", preferredStyle: .alert)
      alert.view.tintColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
      alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { [unowned self] _ in
        self.showResetController()
      }))
      modalAlert.onNext(alert)
    default:
      let alert = UIAlertController(title: "Пересчет результатов", message: "У вас не осталось попыток пересчета результатов", preferredStyle: .alert)
      alert.view.tintColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
      alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      modalAlert.onNext(alert)
    }
  }
  func showResetController() {
    let viewModel = ResetQuestionsViewModel(isResetting: true)
    guard let viewController = ResetQuestionsViewController.create(viewModel) else { return }
    self.showViewController.onNext(viewController)
  }
  func finishDiagnostics() {
    guard let id = DiagnosticService.shared.id else { return }
    APIService.shared.finishDiagnostic(id).trackActivity(isLoading)
      .subscribe(onNext: { (result) in
        DiagnosticService.shared.onGetGrade?(self.grade, nil)
        self.dismissNavigation.onNext(())
        SVProgressHUD.dismiss()
      })
      .disposed(by: disposeBag)
  }
}
