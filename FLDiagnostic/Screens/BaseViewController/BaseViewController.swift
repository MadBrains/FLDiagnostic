//
//  BaseViewController.swift
//  Forward Leasing
//
//  Created by Данил on 02/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import SVProgressHUD

class BaseViewController: UIViewController {
  var isSafeArea: Bool {
    if #available(iOS 11.0, *) {
      return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0 > 0.0
    } else {
      return false
    }
  }
  
  var bottomInset: CGFloat {
    if #available(iOS 11.0, *) {
      return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    } else {
      return 0
    }
  }
  private var timerButton: UIBarButtonItem?
  private var info: String = ""
  private var timer: Timer?
  private var model: BaseControllerViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if model != nil {
      model.setupModel()
    }
  }
  
  func setup(_ model: BaseControllerViewModel) {
    self.model = model
    model.dismissViewController.asObserver().subscribe(onNext: { [unowned self] () in
      self.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
       
    model.popViewController.asObserver().subscribe(onNext: { [unowned self] () in
      self.navigationController?.popViewController(animated: true)
    }).disposed(by: disposeBag)
       
    model.presentViewController.asObserver().subscribe(onNext: { [unowned self] (viewController) in
      self.present(viewController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
       
    model.showViewController.asObserver().subscribe(onNext: { [unowned self] (viewController) in
      self.navigationController?.show(viewController, sender: self)
    }).disposed(by: disposeBag)
       
    model.dismissNavigationController.asObserver().subscribe(onNext: { () in
      self.navigationController?.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    model.openURL.asObserver().subscribe(onNext: { (url) in
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:]) { (success) in
          print("Settings opened: \(success)")
        }
      }
    }).disposed(by: disposeBag)

    model.modalAlert
      .subscribe(onNext: { alert in
        self.present(alert, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)

    model.showError.subscribe(onNext: { (arg) in
      let alertController = UIAlertController(title: "", message: arg.message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Хорошо", style: .default, handler: arg.action)
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    model.isLoading.asObservable()
    .bind(to: SVProgressHUD.rx.isAnimating)
    .disposed(by: disposeBag)
    
    model.dismissNavigation.subscribe(onNext: { () in
      SVProgressHUD.dismiss()
      self.navigationController?.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
  
  func setDefaultNavigationBar(page: Int = 0, _ nonNumericTitle: String? = nil, info: String? = nil, timerNeeded: Bool = true, closeButtonIsAborting: Bool = true) {

    if let title = nonNumericTitle {
      navigationItem.title = title
    } else {
      let titleLabel = UILabel()
      let navTitle = NSMutableAttributedString(string: "\(page)", attributes: [
          .foregroundColor: UIColor.white,
          .font: UIFont.proximaNova(size: 20, weight: .regular)
          ])

      navTitle.append(NSMutableAttributedString(string: "/\(DiagnosticService.shared.allPages)", attributes: [
          .foregroundColor: #colorLiteral(red: 0.6552177072, green: 0.6552177072, blue: 0.6552177072, alpha: 1),
          .font: UIFont.proximaNova(size: 14, weight: .regular)
          ]))

      titleLabel.attributedText = navTitle
      titleLabel.sizeToFit()
      navigationItem.titleView = titleLabel
    }
    var closeBarButtonItem: UIBarButtonItem
    if closeButtonIsAborting {
      closeBarButtonItem = UIBarButtonItem(image: UIImage.FLImage("ic_cross"), style: .plain, target: self, action: #selector(cancelDiagnosticAlert))
      closeBarButtonItem.tintColor = .white
      navigationItem.setLeftBarButtonItems([closeBarButtonItem], animated: false)
    } else {
      closeBarButtonItem = UIBarButtonItem(image: UIImage.FLImage("arrow"), style: .plain, target: self, action: #selector(closeController))
      closeBarButtonItem.tintColor = .white
      navigationItem.setLeftBarButtonItems([closeBarButtonItem], animated: false)
    }

    if timerNeeded {
      let timerButtonItem = UIBarButtonItem(title: "14:30", style: .plain, target: self, action: #selector(nextTest))
      timerButtonItem.isEnabled = false
      timerButtonItem.tintColor = .white
      self.timerButton = timerButtonItem

      navigationItem.setLeftBarButtonItems([closeBarButtonItem, timerButtonItem], animated: false)

      updateTime()
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    if let info = info {
      if info.isBlank == false {
        setupInfo(info: info)
        let infoBarButtonItem = UIBarButtonItem(image: UIImage.FLImage("info_icon"), style: .plain, target: self, action: #selector(infoButtonPressed))
        infoBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = infoBarButtonItem
      }
    }

  }

  func setupInfo(info: String) {
    self.info = info//.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }

  @objc func infoButtonPressed() {
    showInfo()
  }

  func showInfo() {
    let infoViewModel = InfoViewModel(info: info)
    guard let infoViewController = InfoViewController.create(infoViewModel) else { return }
    model.showViewController.onNext(infoViewController)
  }

  func showInternetError() {
    let alertController = UIAlertController(title: "Отсутствует интернет-соединение", message: "Проверьте подключение к сети интернет и повторите попытку.", preferredStyle: .alert)
    alertController.view.tintColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
    alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in

    }))
    model.showViewController.onNext(alertController)
  }

  @objc func closeController() {
    model.popViewController.onNext(())
  }

  @objc func nextTest() {
    timer?.invalidate()
    model.showNextTestViewController()
  }

  @objc func updateTime() {
    let userCalendar = Calendar.current
    let timeLeft = userCalendar.dateComponents([.minute, .second], from: Date(), to: DiagnosticService.shared.testEndDate)
    if timeLeft.minute == 5, timeLeft.second == 0 {
      model.modalAlert.onNext(TimerAlertController.create(BaseControllerViewModel()))
    }
    timerButton?.title = String(format: "%02d:%02d", abs(timeLeft.minute ?? 0), abs(timeLeft.second ?? 0))
  }
  
  @objc func cancelDiagnosticAlert() {
    let alertController = UIAlertController(title: "Прервать тест", message: "Устройство не получит грейд. Вы действительно хотите прервать тест?", preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
    let stopAction = UIAlertAction(title: "Прервать", style: .destructive) { (_) in
      self.cancelDiagnostic()
    }
    alertController.addAction(stopAction)

    self.present(alertController, animated: true, completion: nil)
  }
  
  private func cancelDiagnostic() {
    guard let id = DiagnosticService.shared.id else { removeNavigationController(); return }
    timer?.invalidate()
    APIService.shared.cancelDiagnostic(id).trackActivity(model.isLoading).subscribe(onNext: { (result) in
      DiagnosticService.shared.onGetGrade?(nil, "Диагностика была отменена")
      self.removeNavigationController()
    }).disposed(by: disposeBag)
  }
  
  private func removeNavigationController() {
    model.dismissNavigation.onNext(())
  }
}
