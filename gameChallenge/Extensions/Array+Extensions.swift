//
//  Array+Extensions.swift
//  gameChallenge
//
//  Created by Felipe Melo on 10/30/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

extension Array where Element:Player {
    func findByName(name: String) -> Player? {
        for element in self {
            if element.name == name {
                return element
            }
        }
        
        return nil
    }
}
