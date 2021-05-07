//
//  BluetoothTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 10.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BluetoothTestViewController: BaseViewController {
    @IBOutlet private weak var openBluetoothSettings: UIButton!
    @IBOutlet private weak var notWorkingButton: BorderedButton!

    @IBOutlet private weak var testCompletedView: UIView!

    @IBOutlet private weak var searchingView: LoadingView!

    @IBOutlet private weak var testFailedView: UIView!
    @IBOutlet private weak var trySearchAgainButton: UIButton!
    @IBOutlet private weak var manualWorkingButton: BorderedButton!
    @IBOutlet private weak var notWorkingButtonFailed: BorderedButton!

    private var viewModel: BluetoothTestViewModel!
    private var disposeBag = DisposeBag()
  
  private var isFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoadingView()

        notWorkingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.testFailed()
            })
            .disposed(by: disposeBag)

        notWorkingButtonFailed.rx.tap
            .subscribe(onNext: { [unowned self] in
              self.viewModel.notWorkingDiagnostic(self.viewModel.test)
            })
            .disposed(by: disposeBag)

        manualWorkingButton.rx.tap
            .subscribe(onNext: { [weak self] in
              guard let self = self, !self.isFinished else {
                return
              }
              
              self.isFinished = true
              
              self.viewModel.startNextTest()
            })
            .disposed(by: disposeBag)

        trySearchAgainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.checkBluetooth()
            })
            .disposed(by: disposeBag)

        openBluetoothSettings.rx.tap
            .subscribe(onNext: {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)

        setupStyle()

        viewModel.canStartTest()
            .flatMap({ state -> Observable<BluetoothTestViewModel.SearchState> in
                switch state {
                case .on:
                    return self.viewModel.startTest()
                case .off:
                    self.hideLoadingView()
                }
                return .just(.anotherState)
            })
            .subscribe(onNext: { searchState in
                switch searchState {
                case .devicesFound:
                    self.endTest()
                case .notFound:
                    self.showTestFailedView()
                case .anotherState:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }

    func showLoadingView() {
        testCompletedView.isHidden = true
        testFailedView.isHidden = true
        searchingView.isHidden = false
        searchingView.startAnimating()
    }

    func hideLoadingView() {
        searchingView.isHidden = true
        searchingView.stopAnimating()
    }

    func showTestFailedView() {
        testCompletedView.isHidden = true
        hideLoadingView()
        testFailedView.isHidden = false
    }

    func endTest() {
      guard !self.isFinished else {
        return
      }
      
      self.isFinished = true
      
        DispatchQueue.main.async {
            self.testCompletedView.isHidden = false
            self.hideLoadingView()
            self.testFailedView.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
            viewModel?.startNextTest()
        }
    }
}
extension BluetoothTestViewController {
    static func create(_ viewModel: BluetoothTestViewModel) -> BluetoothTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "BluetoothTestViewController") as? BluetoothTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
