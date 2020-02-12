//
//  BinaryCellModel.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 09.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import UIKit

class BinaryCellModel: BaseCellModel {
  typealias OnBinaryTapped = (_ answer: Bool) -> Void

  var question: Question!
  var onBinaryButtonTapped: OnBinaryTapped?

  init(question: Question) {
    super.init(cellIdentifier: BinaryTableViewCell.cellIdentifier())

    self.question = question
  }
}
