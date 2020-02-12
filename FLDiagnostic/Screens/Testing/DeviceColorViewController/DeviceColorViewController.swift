//
//  DeviceColorViewController.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class DeviceColorViewController: BaseCollectionViewController {
  @IBOutlet private weak var nextButton: BorderedButton!
  private var model: DeviceColorViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    nextButton.rx.tap.bind(to: model.nextButtonPressed).disposed(by: disposeBag)
    model.nextButtonTitle.bind(to: nextButton.rx.title()).disposed(by: disposeBag)
    model.nextButtonColor.bind(to: nextButton.rx.backgroundColor).disposed(by: disposeBag)
    model.nextButtonEnabled.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
  }
  
  private func setupStyle() {
    setDefaultNavigationBar(page: 0, "", info: nil, timerNeeded: false, closeButtonIsAborting: true)
    flowLayout.estimatedItemSize = CGSize(width: 64, height: 64)
  }

}


extension DeviceColorViewController {
  
  static func create(_ viewModel: DeviceColorViewModel) -> DeviceColorViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "DeviceColorViewController") as? DeviceColorViewController
    viewController?.model = viewModel
    viewController?.structureViewModel = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
