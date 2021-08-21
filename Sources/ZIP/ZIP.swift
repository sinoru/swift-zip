//
//  ZIP.swift
//  
//
//  Created by Jaehong Kang on 2021/08/21.
//

import Foundation
import CMinizip

public struct ZIP {
    private enum Source {
        case url(URL)
        case data(Data)
    }
    private var source: Source
    
    public init(url: URL) throws {
        self.source = .url(url)
    }
    
    public init(data: Data) throws {
        self.source = .data(data)
    }
}

extension ZIP {
    public func data(atPath path: String, caseSensitive: Bool = false) throws -> (data: Data, path: String)? {
        var zipReader: UnsafeMutableRawPointer? = nil
        
        mz_zip_reader_create(&zipReader)
        defer {
            mz_zip_reader_delete(&zipReader)
        }
        
        var error = MZ_OK
        switch source {
        case .url(let url):
            error = mz_zip_reader_open_file(zipReader, url.path.cString(using: .utf8))
        case .data(let data):
            error = data.withUnsafeBytes { buffer in
                mz_zip_reader_open_buffer(zipReader, UnsafeMutableRawPointer(mutating: buffer.baseAddress)?.assumingMemoryBound(to: UInt8.self), Int32(buffer.count), 1)
            }
        }
        defer {
            mz_zip_reader_close(zipReader)
        }
        
        guard error == MZ_OK else {
            throw ZIPError(minizipErrorCode: error)
        }
        
        error = mz_zip_reader_locate_entry(zipReader, path.cString(using: .utf8), caseSensitive ? 0 : 1)
        guard error == MZ_OK else {
            if error == MZ_END_OF_LIST {
                return nil
            } else {
                throw ZIPError(minizipErrorCode: error)
            }
        }
        
        var file: UnsafeMutablePointer<mz_zip_file>?

        error = mz_zip_reader_entry_get_info(zipReader, &file)
        guard error == MZ_OK else {
            throw ZIPError(minizipErrorCode: error)
        }

        let bufferLength = mz_zip_reader_entry_save_buffer_length(zipReader)

        var buffer = [UInt8](repeating: 0x00, count: Int(bufferLength))

        error = mz_zip_reader_entry_save_buffer(zipReader, &buffer, bufferLength)
        guard error == MZ_OK else {
            throw ZIPError(minizipErrorCode: error)
        }

        return (data: Data(buffer), path: file.flatMap { String(cString: $0.pointee.filename) } ?? path)
    }
}
