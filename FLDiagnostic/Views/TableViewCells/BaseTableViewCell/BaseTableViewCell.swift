//
//  BaseTableViewCell.swift
//  fsk
//
//  Created by Данил on 22/10/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseTableViewCell: UITableViewCell {
  var disposeBag = DisposeBag()
   var cellHeight: Int?
   
   override func prepareForReuse() {
     super.prepareForReuse()
     disposeBag = DisposeBag()
   }
   
   static func cellIdentifier() -> String {
     return String(describing: self)
   }
   
   func configureCell(_ cellModel: BaseCellModel) {
     cellModel.tableViewCell = self
   }
   
   func setSelectedCell() {
     
   }
   
   func deselectCell() {
     
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
   
   func registerNib(_ collectionView: UICollectionView, cellName: String) {
     collectionView.register(UINib(nibName: cellName, bundle: Bundle.main), forCellWithReuseIdentifier: cellName)
   }
}
