//
//  BaseControllerViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 05/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseControllerViewModel: NSObject {
  var dismissNavigationController = PublishSubject<Void>()
  var dismissViewController = PublishSubject<Void>()
  var popViewController = PublishSubject<Void>()
  let presentViewController = PublishSubject<UIViewController>()
  var showViewController = PublishSubject<UIViewController>()
  var openURL = PublishSubject<URL>()
  var showError = PublishSubject<String>()
  var isLoading = ActivityIndicator()
  
  private var disposeBag = DisposeBag()
  
  override init() {
    super.init()

  }
  
  func setupModel() {
    
  }
  
  func showNextTestViewController() {
    print(String(describing: self))
    if let viewController = DiagnosticService.shared.getNextTestViewController() {
      showViewController.onNext(viewController)
    } else {
      saveDiagnostics()
    }
  }
  
  func abortDiagnostik() {
    let alertController = UIAlertController(title: "Прервать тест", message: "Устройство не получит грейд.\nВы действительно хотите \nпрервать тест?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
    let abortAction = UIAlertAction(title: "Прервать", style: .destructive) { (_) in
      self.saveDiagnostics()
    }
    alertController.addAction(abortAction)

    presentViewController.onNext(alertController)
  }
  
  func saveDiagnostics() {
    guard let id = DiagnosticService.shared.id else { return }
    let tests = DiagnosticService.shared.createTestResultParameters()
    let questions = DiagnosticService.shared.createQuestionsResultParameters()
    APIService.shared.saveDiagnostic(id, tests, questions)
      .trackActivity(self.isLoading)
      .subscribe(onNext: { [unowned self] (result) in
      switch result {
      case .success(let response):
        self.getGrade()
      case .failure(let error):
        break;
      }
    }).disposed(by: disposeBag)
  }
  
  func getGrade() {
    guard let id = DiagnosticService.shared.id else { return }
    APIService.shared.getDiagnoscicResult(id).trackActivity(self.isLoading).subscribe(onNext: { (result) in
      switch result {
      case .success(let response):
        self.showGradeViewController(response)
      case .failure(let error):
        break;
      }
      }).disposed(by: disposeBag)
  }
  
  private func showGradeViewController(_ response: ResultResponse) {
    let viewModel = GradeViewModel(grade: response.diagnostic.results?.first?.grade ?? "A")
    guard let viewController = GradeViewController.create(viewModel) else { return }
    showViewController.onNext(viewController)
  }
}

