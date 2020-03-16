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
  @IBOutlet private weak var buttonsStackView: UIStackView!
  
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
    if let _ = model.noGrade {
      buttonsStackView.addArrangedSubview(buttonsStackView.subviews[0])
      yesButton.backgroundColor = #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1)
      yesButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
      noButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      noButton.setTitleColor(#colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1), for: .normal)

    }
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
