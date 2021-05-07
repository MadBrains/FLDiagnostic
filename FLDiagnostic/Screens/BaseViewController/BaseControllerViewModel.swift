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
  var showError = PublishSubject<(message: String, action: ((UIAlertAction) -> Void)?)>()
  var modalAlert = PublishSubject<UIViewController>()
  var isLoading = ActivityIndicator()
  var dismissNavigation = PublishSubject<Void>()
  
  private let isFinishing = BehaviorSubject<Bool>(value: false)
  
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
    alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
    alertController.addAction(cancelAction)
    
    let abortAction = UIAlertAction(title: "Прервать", style: .default) { (_) in
      self.saveDiagnostics()
    }
    alertController.addAction(abortAction)

    presentViewController.onNext(alertController)
  }

  //Передаем сюда вопрос только с экрана повторных ответов
  func notWorkingDiagnostic(_ test: Test?, _ question: Question? = nil) {
    if test?.canBeFailed == true {
      showNextTestViewController()
      return
    }
    
    let alertController = UIAlertController(title: "Предупреждение", message:
    "Устройству будет присвоен ценовой рейтинг \"Не может быть выкуплен\". Вы действительно хотите продолжить?", preferredStyle: .alert)
    alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    alertController.addAction(cancelAction)

    let abortAction = UIAlertAction(title: "Продолжить", style: .destructive) { (_) in
      //Меняет ответ для вопроса, если денаим диагностику из экрана повторных ответов
      if let question = question {
        if let isPassed = question.isPassed { question.isPassed = !isPassed }
      }

      self.saveDiagnostics()
    }
    alertController.addAction(abortAction)

    presentViewController.onNext(alertController)
  }
  
  func saveDiagnostics() {
    guard let id = DiagnosticService.shared.id else { return }
    let tests = DiagnosticService.shared.createTestResultParameters()
    let questions = DiagnosticService.shared.createQuestionsResultParameters()
    
    Observable<Void>
      .just(())
      .withLatestFrom(isFinishing.asObservable())
      .filter { !$0 }
      .do(
        onNext: { [weak self] _ in
          self?.isFinishing.onNext(true)
        }
      )
      .flatMapLatest { [weak self] _ -> Observable<Result<DefaultSuccessResponse, APIError>> in
        guard let self = self else {
          return .empty()
        }
        
        return APIService.shared.saveDiagnostic(id, tests, questions)
          .trackActivity(self.isLoading)
      }
      .do(
        onError: { [weak self] _ in
          self?.isFinishing.onNext(false)
        }
      )
      .subscribe(onNext: { [unowned self] (result) in
        switch result {
        case .success(let response):
          self.getGrade()
        case .failure(let error):
          self.isFinishing.onNext(false)
          self.showError.onNext((error.localizedDescription, nil))
          break;
        }
      }).disposed(by: disposeBag)
  }
  
  private func getGrade() {
    guard let id = DiagnosticService.shared.id else { return }
    APIService.shared.getDiagnoscicResult(id).trackActivity(self.isLoading)
      .do(
        onNext: { [weak self] _ in
          self?.isFinishing.onNext(false)
        },
        onError: { [weak self] _ in
          self?.isFinishing.onNext(false)
        }
      )
      .subscribe(onNext: { [weak self] (result) in
        switch result {
        case .success(let response):
          self?.showGradeViewController(response)
        case .failure(let error):
          self?.showError.onNext((error.localizedDescription, nil))
          break;
        }
      }).disposed(by: disposeBag)
  }
  
  private func showGradeViewController(_ response: ResultResponse) {
    let viewModel = GradeViewModel(grade: response.diagnostic.results?.last?.grade ?? "A")
    guard let viewController = GradeViewController.create(viewModel) else { return }
    showViewController.onNext(viewController)
  }
  
}

