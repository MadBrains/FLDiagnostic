//
//  BaseCollectionViewController.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class BaseCollectionViewController: BaseViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  var flowLayout: UICollectionViewFlowLayout {
    //swiftlint:disable:next force_cast
    return self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
  }
  
  var structureViewModel: BaseCollectionViewViewModel!
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    structureViewModel.collectionViewOutput.cellModels.asObservable()
    .bind(to: collectionView.rx.items) { collectionView, row, model in
      self.registerNib(self.collectionView, cellName: model.cellIdentifier)
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.cellIdentifier, for: IndexPath(row: row, section: 0)) as? BaseCollectionViewCell {
        cell.configureCell(model)
        return cell
      } else {
        fatalError()
      }
    }.disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(BaseCellModel.self).subscribe(onNext: { (model) in
      if let closure = model.onClickCellBlock {
        closure(model)
      }
    }).disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    structureViewModel.createCellModels()
  }
    
  func registerNib(_ collectionView: UICollectionView, cellName: String) {
    collectionView.register(UINib(nibName: cellName, bundle: Bundle(for: FLDiagnostic.self)), forCellWithReuseIdentifier: cellName)
  }
  
}
