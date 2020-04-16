//
//  TitleTableViewCell.swift
//  FLDiagnostic
//
//  Created by Данил on 06/04/2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

class TitleTableViewCell: BaseTableViewCell {
  @IBOutlet private weak var titleLabel: UILabel!
  
  override func configureCell(_ cellModel: BaseCellModel) {
    super.configureCell(cellModel)
    guard let model = cellModel as? TitleCellModel else { return }
    titleLabel.text = model.titleText
  }
}
