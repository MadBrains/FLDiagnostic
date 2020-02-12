//
//  ResetQuestionsViewController.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 30.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxKeyboard
import RxSwift

class ResetQuestionsViewController: BaseTableViewController {
  private var viewModel: ResetQuestionsViewModel!
  private let disposeBag = DisposeBag()

  @IBOutlet private weak var recountQuestions: BorderedButton!
  @IBOutlet private weak var bottomNextConstraint: NSLayoutConstraint!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.isNextEnabled.bind(to: recountQuestions.rx.isEnabled).disposed(by: disposeBag)
    viewModel.isNextEnabled
      .subscribe(onNext: { isEnabled in
        self.recountQuestions.backgroundColor = isEnabled ? #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        self.recountQuestions.borderColor = isEnabled ? #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
      })
      .disposed(by: disposeBag)
    
    viewModel.recalculateButtonTitle
      .bind(to: recountQuestions.rx.title())
      .disposed(by: disposeBag)

    recountQuestions.rx.tap
      .bind(to: viewModel.recalculateButtonPressed)
      .disposed(by: disposeBag)

    RxKeyboard.instance.visibleHeight.skip(1)
      .drive(onNext: { [unowned self] visibleHeight in
        self.animateWorkspaceHeight(visibleHeight)
      })
      .disposed(by: disposeBag)

    setupStyle()
  }

  private func setupStyle() {
    setDefaultNavigationBar("", info: nil, timerNeeded: !viewModel.isResettingQuestions)
  }

  private func animateWorkspaceHeight(_ visibleHeight: CGFloat) {
    let height = visibleHeight == 0 ? 16 : 16 + visibleHeight - bottomInset
    bottomNextConstraint.constant = height
    UIView.animate(withDuration: 1) {
      self.view.layoutIfNeeded()
    }
  }
}
extension ResetQuestionsViewController {
    static func create(_ viewModel: ResetQuestionsViewModel) -> ResetQuestionsViewController? {
      let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
      let viewController = storyboard.instantiateViewController(withIdentifier: "ResetQuestionsViewController") as? ResetQuestionsViewController
      viewController?.viewModel = viewModel
      viewController?.structureViewModel = viewModel
      viewController?.setup(viewModel)
      return viewController
    }
}

