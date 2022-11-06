//
//  String+Extensions.swift
//  Nanameue
//
//  Created by Stanley Lim on 26/10/2022.
//

import Foundation

extension String {
    func localized(_ lang: String = "en") -> String {
        guard let path = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            return self
        }
        guard let bundle = Bundle(path: path) else {
            return self
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
