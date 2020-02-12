//
//  GradeViewController.swift
//  Forward Leasing
//
//  Created by Данил on 25/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class GradeViewController: BaseViewController {
  @IBOutlet weak var gradeImageView: UIImageView!
  @IBOutlet weak var gradeTitleLabel: UILabel!
  @IBOutlet weak var endTestButton: UIButton!
  @IBOutlet weak var recalculateButton: BorderedButton!
  
  private var model: GradeViewModel!
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRx()
    setupStyle()
  }
  
  private func setupRx() {
    model.gradeImage.bind(to: gradeImageView.rx.image).disposed(by: disposeBag)
    model.gradeTitle.bind(to: gradeTitleLabel.rx.text).disposed(by: disposeBag)
    model.gradeTitleColor.bind(to: gradeTitleLabel.rx.textColor).disposed(by: disposeBag)
    model.recalsculateHidden.bind(to: recalculateButton.rx.isHidden).disposed(by: disposeBag)
    
    endTestButton.rx.tap.bind(to: model.endTestingButtonPressed).disposed(by: disposeBag)
    recalculateButton.rx.tap.bind(to: model.recalculateButtonPressed).disposed(by: disposeBag)
    
  }
  
  private func setupStyle() {

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

    
}

extension GradeViewController {
  
  static func create(_ viewModel: GradeViewModel) -> GradeViewController? {
    let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "GradeViewController") as? GradeViewController
    viewController?.model = viewModel
    viewController?.setup(viewModel)
    return viewController
  }
  
}
