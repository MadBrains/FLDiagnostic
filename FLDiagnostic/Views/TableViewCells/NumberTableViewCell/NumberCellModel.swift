//
//  NumberCellModel.swift
//  FLDiagnostic
//
//  Created by Kirirushi on 09.01.2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//
import RxSwift
import UIKit

class NumberCellModel: BaseCellModel {
  typealias OnTextEdited = (_ answer: String) -> Void

  var question: Question!
  var onTextEdited: OnTextEdited?
  var isTextEntered = BehaviorSubject<Bool>(value: false)

  init(question: Question) {
    super.init(cellIdentifier: NumberTableViewCell.cellIdentifier())

    self.question = question
  }
}
