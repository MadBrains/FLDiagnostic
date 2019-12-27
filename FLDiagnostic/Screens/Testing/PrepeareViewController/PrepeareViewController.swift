//
//  PrepeareViewController.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class PrepeareViewController: BaseViewController {
  @IBOutlet private weak var serverContainerView: UIView!
  @IBOutlet private weak var modelContainerView: UIView!
  @IBOutlet private weak var serverImageView: UIImageView!
  @IBOutlet private weak var modelImageView: UIImageView!
  @IBOutlet private weak var modelLabel: UILabel!
  @IBOutlet private weak var serverLabel: UILabel!
  @IBOutlet private weak var nextButton: UIButton!
  private var model: PrepeareControllerViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    model.serverText.bind(to: serverLabel.rx.text).disposed(by: disposeBag)
    model.modelText.bind(to: modelLabel.rx.text).disposed(by: disposeBag)
    
    model.serverImage.bind(to: serverImageView.rx.image).disposed(by: disposeBag)
    model.modelImage.bind(to: modelImageView.rx.image).disposed(by: disposeBag)
    
    nextButton.rx.tap.bind(to: model.nextButtonPressed).disposed(by: disposeBag)
    model.nextButtonText.bind(to: nextButton.rx.title()).disposed(by: disposeBag)
    model.nextButtonHidden.bind(to: nextButton.rx.isHidden).disposed(by: disposeBag)
    model.nextButtonColor.bind(to: nextButton.rx.backgroundColor).disposed(by: disposeBag)
    model.nextButtonTitleColor.asObserver().subscribe(onNext: { [unowned self] (color) in
      self.nextButton.setTitleColor(color, for: .normal)
    }).disposed(by: disposeBag)
  }
  
  private func setupStyle() {
    setDefaultNavigationBar("Подготовка")
    
    serverContainerView.layer.shadowColor = UIColor.black.cgColor
    serverContainerView.layer.shadowOpacity = 0.0996504
    serverContainerView.layer.shadowRadius = 10.0
    serverContainerView.layer.shadowOffset = CGSize.zero
    
    modelImageView.layer.shadowColor = UIColor.black.cgColor
    modelImageView.layer.shadowOpacity = 0.0996504
    modelImageView.layer.shadowRadius = 10.0
    modelImageView.layer.shadowOffset = CGSize.zero
  }

  @IBAction private func dismissViewController(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}

extension PrepeareViewController {
  
  static func create(_ viewModel: PrepeareControllerViewModel) -> PrepeareViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "PrepeareViewController") as? PrepeareViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
