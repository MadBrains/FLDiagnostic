//
//  NumberTableViewCell.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 09.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

class NumberTableViewCell: BaseTableViewCell {
  @IBOutlet private weak var primaryLabel: UILabel!
  @IBOutlet private weak var secondaryLabel: UILabel!

  @IBOutlet private weak var aboutLabel: UILabel!
  @IBOutlet private weak var textInput: UITextField!

  private var model: NumberCellModel!

  override func configureCell(_ cellModel: BaseCellModel) {
    super.configureCell(cellModel)
    guard let model = cellModel as? NumberCellModel else { return }
    self.model = model
    setupTitles()
  }

  func setupTitles() {
    primaryLabel.text = model.question.primaryText
    secondaryLabel.text = model.question.secondaryText
    aboutLabel.text = model.question.answerEditName
    textInput.placeholder = model.question.answerEditHint
    textInput.text = model.question.answer ?? ""
  }
  @IBAction func onTextChanged(_ sender: UITextField) {
    if sender.text?.first == "0", sender.text?.count != 1 {
      sender.text?.removeFirst()
    }
    if (sender.text?.count ?? 0) > 2 {
      sender.text?.removeLast()
    }
    let text = (sender.text ?? "")
    model.isTextEntered.onNext(text.isEmpty)
    model.onTextEdited?(text)
  }
}
