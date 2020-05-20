//
//  ChargerTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 09.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ChargerTestViewController: BaseViewController {
    @IBOutlet private weak var notWorkingButton: BorderedButton!
    @IBOutlet private weak var testCompletedView: UIView!
    @IBOutlet private weak var chargerPlugInImageView: UIImageView!
    @IBOutlet private weak var chargerPlugOutImageView: UIImageView!


    private var viewModel: ChargerTestViewModel!
    private var disposeBag = DisposeBag()
    private var testEnded = false

    override func viewDidLoad() {
      super.viewDidLoad()
      setupStyle()
      viewModel.plugState.subscribe(onNext: { [weak self] plugState in
          switch plugState {
          case .plugedIn:
            self?.animatePlugArrow(self?.chargerPlugInImageView, chargerState: plugState)
          case .plugedOut:
            self?.animatePlugArrow(self?.chargerPlugOutImageView, chargerState: plugState)
          default:
            break;
          }
      }).disposed(by: disposeBag)

      
      notWorkingButton.rx.tap.subscribe(onNext: { [unowned self] in
        self.viewModel.notWorkingDiagnostic(self.viewModel.test)
      }).disposed(by: disposeBag)

      #if targetEnvironment(simulator)
        self.endTest()
      #endif
      viewModel.startTest()
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }
  
    private func animatePlugArrow(_ imageView: UIImageView?, chargerState: ChargerTestViewModel.PlugState) {
      guard let imageView = imageView else { return }
      UIView.animate(withDuration: 0.3, animations: {
        imageView.alpha = 0
      }) { _ in
        imageView.isHidden = true
        if chargerState == .plugedOut {
          if !self.testEnded {
            self.endTest()
          }
        }
      }
    }

    func endTest() {
      self.testEnded = true
      
      DispatchQueue.main.async {
          self.testCompletedView.isHidden = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
          viewModel?.startNextTest()
      }
    }
}
extension ChargerTestViewController {
    static func create(_ viewModel: ChargerTestViewModel) -> ChargerTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "ChargerTestViewController") as? ChargerTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
