//
//  GradeViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 25/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class GradeViewModel: BaseControllerViewModel {
  var grade: String = ""
  
  let gradeImage = BehaviorSubject<UIImage>(value: #imageLiteral(resourceName: "grade_b"))
  let gradeTitle = BehaviorSubject<String>(value: "")
  let gradeTitleColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
  
  var endTestingButtonPressed = PublishSubject<Void>()
  var recalculateButtonPressed = PublishSubject<Void>()
  
  private var disposeBag = DisposeBag()
  
  init(grade: String) {
    self.grade = grade
  }
  override func setupModel() {
    endTestingButtonPressed.subscribe(onNext: { () in
      exit(0)
    }).disposed(by: disposeBag)
    
    switch grade {
    case "A":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_a"))
      gradeTitle.onNext("Как новый")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    case "B":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_b"))
      gradeTitle.onNext("Хорошее")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    case "C":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_c"))
      gradeTitle.onNext("Рабочий, не битый")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    case "F":
      gradeImage.onNext(#imageLiteral(resourceName: "grade_x"))
      gradeTitle.onNext("Не может быть выкуплен")
      gradeTitleColor.onNext(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    default:
      break;
    }
  }
}
