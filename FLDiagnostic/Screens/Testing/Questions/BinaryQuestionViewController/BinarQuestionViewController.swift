//
//  BinarQuestionViewController.swift
//  Forward Leasing
//
//  Created by Данил on 23/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxKeyboard

class BinarQuestionViewController: BaseViewController {
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var subtitleLabel: UILabel!
  @IBOutlet private weak var yesButton: BorderedButton!
  @IBOutlet private weak var noButton: BorderedButton!

  private var model: BinaryQuestionViewModel!
  private var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    model.titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    model.desctiptionText.bind(to: subtitleLabel.rx.text).disposed(by: disposeBag)
    yesButton.rx.tap.bind(to: model.yesButtonPressed).disposed(by: disposeBag)
    noButton.rx.tap.bind(to: model.noButtonPressed).disposed(by: disposeBag)
  }
  
  private func setupStyle() {
    setDefaultNavigationBar(page: model.page, info: model.question.information)
  }

}

extension BinarQuestionViewController {
  
  static func create(_ viewModel: BinaryQuestionViewModel) -> BinarQuestionViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "BinarQuestionViewController") as? BinarQuestionViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
