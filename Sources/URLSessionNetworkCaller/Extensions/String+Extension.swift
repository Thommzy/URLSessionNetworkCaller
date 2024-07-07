//
//  File.swift
//  
//
//  Created by Timothy Obeisun on 7/6/24.
//

import Foundation

extension String {
    var asUrl: URL? {
        URL(string: self)
    }
}
