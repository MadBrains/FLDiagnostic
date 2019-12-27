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
          UIApplication.shared.open(url, completionHandler: { (success) in
              print("Settings opened: \(success)")
          })
      }
    }).disposed(by: disposeBag)
    
    model.showError.subscribe(onNext: { (message) in
      let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
      alertController.addAction(okAction)
      self.present(alertController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    model.isLoading.asObservable()
    .bind(to: SVProgressHUD.rx.isAnimating)
    .disposed(by: disposeBag)
  }
  
  func setDefaultNavigationBar(page: Int = 0, _ nonNumericTitle: String? = nil, infoHidden: Bool = true) {
  
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
      navigationItem.titleView = titleLabel
    }
    
    let closeBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_cross"), style: .plain, target: self, action: #selector(cancelDiagnosticAlert))
    closeBarButtonItem.tintColor = .white
    navigationItem.leftBarButtonItem = closeBarButtonItem
    
//    let infoBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_cross"), style: .plain, target: self, action: #selector(infoButtonPressed))
//    infoBarButtonItem.tintColor = .white
//    navigationItem.rightBarButtonItem = infoBarButtonItem
  }
  
  @objc func infoButtonPressed() {
    model.showNextTestViewController()
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

    APIService.shared.cancelDiagnostic(id).trackActivity(model.isLoading).subscribe(onNext: { (result) in
      exit(0)
    }).disposed(by: disposeBag)
  }
  
  private func removeNavigationController() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
}
