//
//  ZIPError.swift
//  
//
//  Created by Jaehong Kang on 2021/08/21.
//

import Foundation

public enum ZIPError: Error {
    case unknown
    case invalidFileURL
}

extension ZIPError {
    init(minizipErrorCode: Int32) {
        self = .unknown
    }
}
