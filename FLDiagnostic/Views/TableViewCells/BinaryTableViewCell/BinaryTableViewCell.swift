//
//  BinaryTableViewCell.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 09.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

class BinaryTableViewCell: BaseTableViewCell {
  @IBOutlet private weak var primaryLabel: UILabel!
  @IBOutlet private weak var secondaryLabel: UILabel!

  @IBOutlet private weak var buttonsStackView: UIStackView!
  @IBOutlet private weak var yesButton: BorderedButton!
  @IBOutlet private weak var noButton: BorderedButton!
  
  private var model: BinaryCellModel!

  override func configureCell(_ cellModel: BaseCellModel) {
    super.configureCell(cellModel)
    guard let model = cellModel as? BinaryCellModel else { return }
    self.model = model
    
    if let _ = model.noGrade {
      buttonsStackView.addArrangedSubview(buttonsStackView.subviews[0])
    }
    
    setupTitles()
  }

  func setupTitles() {
    primaryLabel.text = model.question.primaryText
    secondaryLabel.text = model.question.secondaryText
    changeButton(buttonType: model.question.isPassed ?? false)
  }

  func changeButton(buttonType: Bool) {
    guard
      let button = buttonType ? yesButton : noButton,
      let anotherButton = buttonType ? noButton : yesButton else { return }
    button.isSelected = true
    
    if let _ = model.noGrade {
      button.backgroundColor = buttonType ? #colorLiteral(red: 0, green: 0.7529411765, blue: 0.1882352941, alpha: 1) : #colorLiteral(red: 0.9176470588, green: 0, blue: 0, alpha: 1)
    } else {
      button.backgroundColor = buttonType ? #colorLiteral(red: 0.9176470588, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0, green: 0.7529411765, blue: 0.1882352941, alpha: 1)
    }
    button.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    anotherButton.isSelected = false
    anotherButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    anotherButton.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
  }

  @IBAction func onYesButtonTapped(_ sender: Any) {
    if model.yesGrade?.grade == "F" && model.question.affectsScore == true {
      model.onAbortDiagnostic?()
    } else {
      model.onBinaryButtonTapped?(true)
      changeButton(buttonType: true)
    }
  }
  
  @IBAction func onNoButtonTapped(_ sender: Any) {
    if model.noGrade?.grade == "F" && model.question.affectsScore == true {
      model.onAbortDiagnostic?()
    } else {
      model.onBinaryButtonTapped?(false)
      changeButton(buttonType: false)
    }
  }
}
