//
//  BaseCollectionViewCell.swift
//  fsk
//
//  Created by Данил on 20/09/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
  var disposeBag = DisposeBag()
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  static func cellIdentifier() -> String {
    return String(describing: self)
  }
  
  func configureCell(_ cellModel: BaseCellModel) {
    cellModel.collectionViewCell = self
  }
  
  func animateOnSelect() {
    let originalTransform = self.transform
    let scaledTransform = originalTransform.scaledBy(x: 0.9, y: 0.9)
    UIView.animate(withDuration: 0.2, animations: {
      self.transform = scaledTransform
    })
  }
  
  func animateOnDeselect() {
    let originalTransform = self.transform
    let scaledTransform = originalTransform.scaledBy(x: 1.111111111111111, y: 1.111111111111111)
    UIView.animate(withDuration: 0.2, animations: {
      self.transform = scaledTransform
    })
  }
  
  func registerNib(_ tableView: UITableView, cellName: String) {
    tableView.register(UINib(nibName: cellName, bundle: Bundle.main), forCellReuseIdentifier: cellName)
  }
  
}
