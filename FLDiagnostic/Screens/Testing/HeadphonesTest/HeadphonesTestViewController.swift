//
//  HeadphonesTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 10.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HeadphonesTestViewController: BaseViewController {
    @IBOutlet private weak var notWorkingButton: BorderedButton!
    @IBOutlet private weak var testCompletedView: UIView!
    @IBOutlet private weak var headphonesPlugInImageView: UIImageView!
    @IBOutlet private weak var headphonesPlugOutImageView: UIImageView!

    private var viewModel: HeadphonesTestViewModel!
    private var disposeBag = DisposeBag()
    private var testEnded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        viewModel.startTest()
            .subscribe(onNext: { headphonesState in
                switch headphonesState {
                case .plugedIn:
                    UIView.animate(withDuration: 0.3, animations: {
                        self.headphonesPlugInImageView.alpha = 0
                    }) { _ in
                        self.headphonesPlugInImageView.isHidden = true
                        if self.headphonesPlugOutImageView.isHidden {
                            if !self.testEnded {
                                self.testEnded = true
                                self.endTest()
                            }
                        }
                    }
                case .plugedOut:
                    UIView.animate(withDuration: 0.3, animations: {
                        self.headphonesPlugOutImageView.alpha = 0
                    }) { _ in
                        self.headphonesPlugOutImageView.isHidden = true
                        if self.headphonesPlugInImageView.isHidden {
                            if !self.testEnded {
                                self.testEnded = true
                                self.endTest()
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)

        notWorkingButton.rx.tap
            .subscribe(onNext: { [weak self] () in
                self?.viewModel.notWorkingDiagnostic()
            })
            .disposed(by: disposeBag)
        #if targetEnvironment(simulator)
            self.endTest()
        #endif
    }

    private func setupStyle() {
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)
    }

    func endTest() {
        DispatchQueue.main.async {
            self.testCompletedView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
            viewModel?.startNextTest()
        }
    }
}
extension HeadphonesTestViewController {
    static func create(_ viewModel: HeadphonesTestViewModel) -> HeadphonesTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "HeadphonesTestViewController") as? HeadphonesTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}
