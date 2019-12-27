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
  @IBOutlet private weak var testCounterLabel: UILabel!
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var collectionViewFLowLayout: UICollectionViewFlowLayout!

  private var circles = BehaviorRelay<[Bool]>(value: [])
  private var ended = false

    private var viewModel: TouchscreenTestViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()

      let width = UIScreen.main.bounds.width - 1
      collectionViewFLowLayout.estimatedItemSize = CGSize(width: width / 4, height: width / 4)

      setTestCounter()

      let swipeGesture = UISwipeGestureRecognizer()
      swipeGesture.direction = .left
      let tapGesture = UITapGestureRecognizer()
      let gesture = UIPanGestureRecognizer()

      view.addGestureRecognizer(gesture)
      view.addGestureRecognizer(tapGesture)
      view.addGestureRecognizer(swipeGesture)

      gesture.rx.event
        .bind { recognizer in
          if recognizer.numberOfTouches >= 1 {
            let location = recognizer.location(ofTouch: 0, in: self.view)
            guard let cell = self.view.hitTest(location, with: .none)?.superview?.superview as? RoundCollectionViewCell else {
              return
            }
            var newValues = self.circles.value
            newValues[cell.getIndexPath().row] = true
            self.circles.accept(newValues)
          }
        }
        .disposed(by: disposeBag)

      tapGesture.rx.event
        .bind { _ in
          self.hideTutorialView()
        }
        .disposed(by: disposeBag)

      swipeGesture.rx.event
        .bind { _ in
          self.showTutorialView()
        }
        .disposed(by: disposeBag)

      circles
        .map({ bools -> [Bool] in
          if bools.allSatisfy({ $0 }), !bools.isEmpty {
            self.endTest()
          }
          return bools
        })
        .bind(to: collectionView.rx.items(cellIdentifier: "RoundCollectionViewCell")) { index, model, cell in
          guard let cell = cell as? RoundCollectionViewCell else { return }
          cell.frame.size = CGSize(width: width / 4, height: width / 4)
          cell.setCornerRadius(width / 8)
          if model {
            cell.hideCircle()
          } else {
            cell.showCircle()
          }
        }
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

        testCounterLabel.attributedText = navTitle
    }

  func endTest() {
    if !ended {
      ended = true
      DispatchQueue.main.async {
          self.testCompletedView.isHidden = false
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [viewModel] in
          viewModel?.startNextTest()
      }
    }
  }

  func showTutorialView() {
    tutorialView.isHidden = false
    UIView.animate(withDuration: 0.3, animations: {
      self.tutorialView.alpha = 1
    })
  }
  func hideTutorialView() {
    UIView.animate(withDuration: 0.3, animations: {
      self.tutorialView.alpha = 0
    }) { finished in
      if finished {
        self.tutorialView.isHidden = true
      }
    }
  }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      let height = collectionView.frame.size.height
      let count = (height / view.frame.width * 4)

      let circlesCount = Int(exactly: count.rounded(.down) * 4) ?? 28
      circles.accept(Array<Bool>(repeating: false, count: circlesCount))

        navigationController?.setNavigationBarHidden(true, animated: false)
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
