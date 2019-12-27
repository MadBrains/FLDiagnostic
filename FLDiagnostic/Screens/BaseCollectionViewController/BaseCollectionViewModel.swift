//
//  BaseCollectionViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseCollectionViewViewModel: BaseControllerViewModel {
  struct CollectionViewOutput {
    let cellModels = BehaviorSubject<[BaseCellModel]>(value: [])
    var models = [BaseCellModel]()
  }
  
  var collectionViewOutput = CollectionViewOutput()
  private let disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    collectionViewOutput.cellModels.subscribe(onNext: { [unowned self] (cellModels) in
      self.collectionViewOutput.models = cellModels
    }).disposed(by: disposeBag)
  }
  
  func createCellModels() {
    
  }

}
