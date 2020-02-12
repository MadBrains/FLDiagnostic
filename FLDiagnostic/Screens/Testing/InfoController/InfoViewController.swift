//
//  InfoViewController.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 17.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import RxSwift
import UIKit

class InfoViewController: BaseViewController {
  private var model: InfoViewModel!
  private let disposeBag = DisposeBag()
  @IBOutlet private weak var textView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupStyle()
    setupRx()
  }

  func setupRx() {
    model.info.bind(to: textView.rx.attributedText).disposed(by: disposeBag)
  }

  func setupStyle() {
    setDefaultNavigationBar(page: 0, "Информация", info: nil, timerNeeded: false, closeButtonIsAborting: false)
  }
}
extension InfoViewController {
  static func create(_ viewModel: InfoViewModel) -> InfoViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
}
