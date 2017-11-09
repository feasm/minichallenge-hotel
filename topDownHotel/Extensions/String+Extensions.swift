//
//  String+Extensions.swift
//  gameChallenge
//
//  Created by Adonay Puszczynski on 23/10/17.
//  Copyright © 2017 Adonay Puszczynski. All rights reserved.
//

import UIKit

extension String
{
    mutating func append(_ text: String, terminator: String = "") -> Void {
        self.append(text)
        self.append(terminator)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
