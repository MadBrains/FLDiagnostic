//
//  String+Extensions.swift
//  FLDiagnostic
//
//  Created by Данил on 14/01/2020.
//  Copyright © 2020 Arcsinus. All rights reserved.
//

import Foundation

extension String {
  
  var isBlank: Bool {
      let trimmed = self.trimmingCharacters(in: NSCharacterSet.whitespaces)
      return trimmed.isEmpty
  }
  
}
extension String {
    var htmlToAttributedString: NSMutableAttributedString {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data,
                                                 options: [
                                                  .documentType: NSAttributedString.DocumentType.html,
                                                  .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString.string
    }
}
