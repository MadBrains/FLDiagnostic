//
//  DeviceColorViewModel.swift
//  Forward Leasing
//
//  Created by Данил on 19/12/2019.
//  Copyright © 2019 Arcsinus. All rights reserved.
//

import RxSwift

class DeviceColorViewModel: BaseCollectionViewViewModel {
  
  var nextButtonTitle = BehaviorSubject<String>(value: "Цвет не выбран")
  var nextButtonEnabled = BehaviorSubject<Bool>(value: false)
  var nextButtonColor = BehaviorSubject<UIColor>(value: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
  var nextButtonPressed = PublishSubject<Void>()
  
  let isFLLoading = ActivityIndicator()
  
  var selectedColor: DeviceColor? = nil
  var colors: [DeviceColor] = DeviceColor.colors()
  private var disposeBag = DisposeBag()
  
  override func setupModel() {
    super.setupModel()
    
    self.nextButtonPressed.asObservable()
      .withLatestFrom(isFLLoading.asObservable()) { $1 }
      .filter { isLoading in self.selectedColor != nil && !isLoading }
      .subscribe(onNext: { [unowned self] _ in
        guard let color = self.selectedColor?.name else { return }
        APIService.shared.pathDevice(color: color)
          .trackActivity(isFLLoading)
          .subscribe(onNext: { response in
              switch response {
              case .success(_):
                DiagnosticService.shared.resetTimer()
                self.showNextTestViewController()
              case .failure(let error):
                self.showError.onNext((error.localizedDescription, nil))
              default:
                break
              }
          })
          .disposed(by: self.disposeBag)
    }).disposed(by: disposeBag)
  }
  
  override func createCellModels() {
    var models = [BaseCellModel]()
    
    for color in colors {
      
      let colorModel = DeviceColorCellModel(deviceColor: color, isSelected: color == selectedColor)
      colorModel.onClickCellBlock = { [unowned self] (cellModel: BaseCellModel) -> Void in
        if self.selectedColor?.color == color.color {
          self.selectedColor = nil
        } else {
          self.selectedColor = color
        }
        self.createCellModels()
        
        self.nextButtonTitle.onNext(self.selectedColor != nil ? color.name : "Цвет не выбран")
        self.nextButtonColor.onNext(self.selectedColor != nil ? #colorLiteral(red: 1, green: 0.4039215686, blue: 0.1960784314, alpha: 1) : #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
        self.nextButtonEnabled.onNext(self.selectedColor != nil)
      }
      models.append(colorModel)
    }
    collectionViewOutput.cellModels.onNext(models)
  }

}

struct DeviceColor: Comparable {
  var name: String
  var color: UIColor
  var checkTint: UIColor { return color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ? #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
  var borderColor: UIColor { return color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ? #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1) : color }
  
  static func colors() -> [DeviceColor] {
    let violetter = DeviceColor(name: "Фиолетовый", color: #colorLiteral(red: 0.5019607843, green: 0, blue: 0.5019607843, alpha: 1))
    let pink = DeviceColor(name: "Розовый", color: #colorLiteral(red: 1, green: 0.7529411765, blue: 0.7960784314, alpha: 1))
    let pastel = DeviceColor(name: "Бежевый", color: #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.5607843137, alpha: 1))
    let yellow = DeviceColor(name: "Желтый", color: #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1))
    let golden = DeviceColor(name: "Золотой", color: #colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1))
    let red = DeviceColor(name: "Красный", color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    let green = DeviceColor(name: "Зеленый", color: #colorLiteral(red: 0, green: 0.7529411765, blue: 0.1882352941, alpha: 1))
    let blue = DeviceColor(name: "Синий", color: #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1))
    let gray = DeviceColor(name: "Серый", color: #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))
    let black = DeviceColor(name: "Черный", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    var white = DeviceColor(name: "Белый", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    return [violetter, pink, pastel, yellow, golden, red, green, blue, gray, black, white]
  }
  
  static func < (lhs: DeviceColor, rhs: DeviceColor) -> Bool {
    return lhs.name == rhs.name
  }
}
