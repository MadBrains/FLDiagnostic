//
//  BaseCellModel.swift
//  fsk
//
//  Created by Данил on 12/09/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit

class BaseCellModel {
  typealias ClickCellBlock = (_ cellModel: BaseCellModel) -> Void
  typealias ClickCellButton = () -> Void
  
  var cellHeight: CGFloat?
  var tableViewCell: BaseTableViewCell?
  var collectionViewCell: BaseCollectionViewCell?
  
  var onClickCellBlock: ClickCellBlock?
  var cellIdentifier: String = ""
  var animationOnTap: Bool { return false }

  init(cellIdentifier: String) {
    self.cellIdentifier = cellIdentifier
  }
  
  init() {
    self.cellIdentifier = BaseTableViewCell.cellIdentifier()
  }
}
