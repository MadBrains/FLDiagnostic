//
//  BaseTableViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseTableViewViewModel: BaseControllerViewModel {
  struct TableViewOutput {
    let cellModels = BehaviorSubject<[BaseCellModel]>(value: [])
    var models = [BaseCellModel]()
  }
  
  var tableViewOutput = TableViewOutput()
  private let disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    tableViewOutput.cellModels.subscribe(onNext: { [unowned self] (cellModels) in
      self.tableViewOutput.models = cellModels
    }).disposed(by: disposeBag)
  }
  
  func createCellModels() {
    
  }

}
