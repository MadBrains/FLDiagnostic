//
//  TitleCellModel.swift
//  FLDiagnostic
//
//  Created by Данил on 06/04/2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import Foundation

class TitleCellModel: BaseCellModel {
  var titleText: String
  
  init(title: String) {
    self.titleText = title
    super.init(cellIdentifier: TitleTableViewCell.cellIdentifier())
  }
}
