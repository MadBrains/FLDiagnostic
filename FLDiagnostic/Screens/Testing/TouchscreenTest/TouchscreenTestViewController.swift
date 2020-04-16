//
//  TouchscreenTestViewController.swift
//  Forward Leasing
//
//  Created by Kirirushi on 17.12.2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class TouchscreenTestViewController: BaseViewController {

  @IBOutlet private weak var testCompletedView: UIView!

  @IBOutlet private weak var tutorialView: RoundedView!
  @IBOutlet private weak var timeLabel: UILabel!
  @IBOutlet private weak var testCounterLabel: UILabel!
  @IBOutlet private weak var closeButton: UIButton!

  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var collectionViewFLowLayout: UICollectionViewFlowLayout!

  @IBOutlet private weak var testSettingsView: UIView!
  @IBOutlet private weak var displayNotWorkingButton: UIButton!
  @IBOutlet private weak var abortTestButton: UIButton!
  @IBOutlet private weak var cancelButton: UIButton!

    private var viewModel: TouchscreenTestViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()
      setDefaultNavigationBar(page: viewModel.page, info: viewModel.test.information)

      let width = UIScreen.main.bounds.width - 1
      collectionViewFLowLayout.estimatedItemSize = CGSize(width: width / 4, height: width / 4)

      setTestCounter()

      let doubleTapGesture = UITapGestureRecognizer()
      doubleTapGesture.numberOfTapsRequired = 2
      let tapGesture = UITapGestureRecognizer()
      let gesture = UIPanGestureRecognizer()

      view.addGestureRecognizer(gesture)
      view.addGestureRecognizer(tapGesture)
      view.addGestureRecognizer(doubleTapGesture)

      gesture.rx.event
        .bind { [unowned self] recognizer in
          if !self.viewModel.isScreenBlocked, recognizer.numberOfTouches >= 1 {
            let location = recognizer.location(ofTouch: 0, in: self.view)
            guard let cell = self.view.hitTest(location, with: .none)?.superview?.superview as? RoundCollectionViewCell else {
              return
            }
            var newValues = self.viewModel.circles.value
            newValues[cell.getIndexPath().row] = true
            self.viewModel.circles.accept(newValues)
          }
        }
        .disposed(by: disposeBag)

      tapGesture.rx.event
        .bind { _ in
          self.hideTutorialView()
          self.hideTestSettingsView()
        }
        .disposed(by: disposeBag)

      doubleTapGesture.rx.event
        .bind { _ in
          self.hideTutorialView()
          self.showTestSettingsView()
        }
        .disposed(by: disposeBag)

      viewModel.circles
        .map({ bools -> [Bool] in
          if bools.allSatisfy({ $0 }), !bools.isEmpty {
            self.endTest()
          }
          return bools
        })
        .bind(to: collectionView.rx.items(cellIdentifier: "RoundCollectionViewCell")) { index, model, cell in
          guard let cell = cell as? RoundCollectionViewCell else { return }
          cell.setConstrant(width: width / 4)
          cell.setCornerRadius(width / 8)
          if model {
            cell.hideCircle()
          } else {
            cell.showCircle()
          }
        }
        .disposed(by: disposeBag)

      displayNotWorkingButton.rx.tap
        .subscribe(onNext: { [unowned self] in
          self.viewModel.test.isPassed = false
          self.viewModel.notWorkingDiagnostic(self.viewModel.test)
        })
        .disposed(by: disposeBag)

      cancelButton.rx.tap
        .subscribe(onNext: {
          self.hideTestSettingsView()
        })
      .disposed(by: disposeBag)

      closeButton.rx.tap
        .subscribe(onNext: {
          self.hideTutorialView()
        })
      .disposed(by: disposeBag)
      
      abortTestButton.rx.tap.subscribe(onNext: {
          self.cancelDiagnosticAlert()
        })
      .disposed(by: disposeBag)
    }

  func setTestCounter() {
    let navTitle = NSMutableAttributedString(string: "\(viewModel.page)", attributes: [
          .foregroundColor: UIColor.white,
          .font: UIFont.proximaNova(size: 20, weight: .regular)
          ])

    navTitle.append(NSMutableAttributedString(string: "/\(DiagnosticService.shared.allPages)", attributes: [
          .foregroundColor: #colorLiteral(red: 0.6552177072, green: 0.6552177072, blue: 0.6552177072, alpha: 1),
          .font: UIFont.proximaNova(size: 14, weight: .regular)
          ]))
    if let info = viewModel.test.information {
      setupInfo(info: info)
    }
    testCounterLabel.attributedText = navTitle
  }

  func endTest() {
    if !viewModel.ended {
      viewModel.ended = true
      DispatchQueue.main.async {
          self.testCompletedView.isHidden = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [viewModel] in
          viewModel?.startNextTest()
      }
    }
  }

  func showTestSettingsView() {
    viewModel.isScreenBlocked = true
    testSettingsView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.testSettingsView.alpha = 1
    })
  }
  func hideTestSettingsView() {
    viewModel.isScreenBlocked = false
    UIView.animate(withDuration: 0.3, animations: {
      self.testSettingsView.alpha = 0
    }) { finished in
      if finished {
        self.testSettingsView.isHidden = true
      }
    }
  }

  func showTutorialView() {
    viewModel.isScreenBlocked = true
    tutorialView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.tutorialView.alpha = 1
    })
  }
  func hideTutorialView() {
    viewModel.isScreenBlocked = false
    UIView.animate(withDuration: 0.3, animations: {
      self.tutorialView.alpha = 0
    }) { finished in
      if finished {
        self.tutorialView.isHidden = true
      }
    }
  }
  
  override func updateTime() {
    let userCalendar = Calendar.current
    let timeLeft = userCalendar.dateComponents([.minute, .second], from: Date(), to: DiagnosticService.shared.testEndDate)
    timeLabel.text = String(format: "%02d:%02d", abs(timeLeft.minute ?? 0), abs(timeLeft.second ?? 0))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      
    let height = collectionView.frame.size.height
    let count = (height / view.frame.width * 4)
    let circlesCount = Int(exactly: count.rounded(.down) * 4) ?? 28
    viewModel.circles.accept(Array<Bool>(repeating: false, count: circlesCount))
    navigationController?.setNavigationBarHidden(true, animated: false)

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
      self?.hideTutorialView()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
}
extension TouchscreenTestViewController {
    static func create(_ viewModel: TouchscreenTestViewModel) -> TouchscreenTestViewController? {
        let storyboard = UIStoryboard(name: "Testing", bundle: Bundle(for: FLDiagnostic.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "TouchscreenTestViewController") as? TouchscreenTestViewController
        viewController?.viewModel = viewModel
        viewController?.setup(viewModel)
        return viewController
    }
}


class RoundCollectionViewCell: UICollectionViewCell {
  @IBOutlet private weak var roundView: RoundedView!
  @IBOutlet private weak var widthConstrint: NSLayoutConstraint!

  func setConstrant(width: CGFloat) {
    widthConstrint.constant = width
  }

  func hideCircle() {
    roundView.isHidden = true
  }

  func showCircle() {
    roundView.isHidden = false
  }

  func setCornerRadius(_ radius: CGFloat) {
    roundView.cornerRadius = radius
  }

  func getIndexPath() -> IndexPath {
    //swiftlint:disable:next force_cast
    return (self.superview as! UICollectionView).indexPath(for: self)!
  }
}
