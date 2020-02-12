//
//  BaseTableViewController.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseTableViewController: BaseViewController {
  @IBOutlet weak var tableView: UITableView!
    
  var structureViewModel: BaseTableViewViewModel!
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = nil
    tableView.delegate = nil
    
    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    structureViewModel.tableViewOutput.cellModels.asObservable()
      .bind(to: tableView.rx.items) { [unowned self] tableView, _, model in
        self.registerNib(tableView, cellName: model.cellIdentifier)
        if let cell = tableView.dequeueReusableCell(withIdentifier: model.cellIdentifier) as? BaseTableViewCell {
          cell.configureCell(model)
          return cell
        } else {
          fatalError()
        }
      }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(BaseCellModel.self).subscribe(onNext: { (cellModel) in
      if let closure = cellModel.onClickCellBlock {
        closure(cellModel)
      }
    }).disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    structureViewModel.createCellModels()
  }
    
  func scrollToTop() {
    if tableView == nil { return }
    if tableView.numberOfRows(inSection: 0) > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
  }
    
  func registerNib(_ tableView: UITableView, cellName: String) {
    tableView.register(UINib(nibName: cellName, bundle: Bundle(for: FLDiagnostic.self)), forCellReuseIdentifier: cellName)
  }
}

extension BaseTableViewController: UITableViewDelegate {
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if let height = structureViewModel.tableViewOutput.models[indexPath.row].cellHeight {
      return height
    }
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let height = structureViewModel.tableViewOutput.models[indexPath.row].cellHeight {
      return height
    }
    if #available(iOS 13.0, *) {
      return 500
    } else {
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    let cellModel = structureViewModel.tableViewOutput.models[indexPath.row]
    if cellModel.animationOnTap == false { return }
    guard let cell = cellModel.tableViewCell else { return }
    cell.animateOnSelect()
  }
  
  func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    let cellModel = structureViewModel.tableViewOutput.models[indexPath.row]
    if cellModel.animationOnTap == false { return }
    guard let cell = cellModel.tableViewCell else { return }
    cell.animateOnDeselect()
  }
    
}
