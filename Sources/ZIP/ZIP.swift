//
//  ZIP.swift
//  
//
//  Created by Jaehong Kang on 2021/08/21.
//

import Foundation
import CMinizip

#if swift(>=5.5)
public actor ZIP {
    var mzZIPReader: UnsafeMutableRawPointer? = nil

    deinit {
        mz_zip_reader_close(mzZIPReader)
        mz_zip_reader_delete(&mzZIPReader)
    }
}
#else
public class ZIP {
    var mzZIPReader: UnsafeMutableRawPointer? = nil
    
    deinit {
        mz_zip_reader_close(mzZIPReader)
        mz_zip_reader_delete(&mzZIPReader)
    }
}
#endif

extension ZIP {
    #if swift(>=5.5)
    public convenience init(url: URL) async throws {
        self.init()

        try await open(url: url)
    }
    
    public convenience init(data: Data) async throws {
        self.init()
        
        try await open(data: data)
    }
    #else
    public convenience init(url: URL) throws {
        self.init()

        try open(url: url)
    }
    
    public convenience init(data: Data) throws {
        self.init()
        
        try open(data: data)
    }
    #endif
    
    func open(url: URL) throws {
        mz_zip_reader_create(&mzZIPReader)
        
        let error = mz_zip_reader_open_file(mzZIPReader, url.path.cString(using: .utf8))
        guard error == MZ_OK else {
            mz_zip_reader_delete(&mzZIPReader)
            throw ZIPError(minizipErrorCode: error)
        }
    }
    
    func open(data: Data) throws {
        mz_zip_reader_create(&mzZIPReader)
        
        let error = data.withUnsafeBytes { buffer in
            mz_zip_reader_open_buffer(mzZIPReader, UnsafeMutableRawPointer(mutating: buffer.baseAddress)?.assumingMemoryBound(to: UInt8.self), Int32(buffer.count), 1)
        }
        guard error == MZ_OK else {
            mz_zip_reader_delete(&mzZIPReader)
            throw ZIPError(minizipErrorCode: error)
        }
    }
}

extension ZIP {
    public func data(atPath path: String, caseSensitive: Bool = false) throws -> (data: Data, path: String)? {
        var error = mz_zip_reader_locate_entry(mzZIPReader, path.cString(using: .utf8), caseSensitive ? 0 : 1)
        guard error == MZ_OK else {
            if error == MZ_END_OF_LIST {
                return nil
            } else {
                throw ZIPError(minizipErrorCode: error)
            }
        }
        
        var file: UnsafeMutablePointer<mz_zip_file>?

        error = mz_zip_reader_entry_get_info(mzZIPReader, &file)
        guard error == MZ_OK else {
            throw ZIPError(minizipErrorCode: error)
        }

        let bufferLength = mz_zip_reader_entry_save_buffer_length(mzZIPReader)

        var buffer = [UInt8](repeating: 0x00, count: Int(bufferLength))

        error = mz_zip_reader_entry_save_buffer(mzZIPReader, &buffer, bufferLength)
        guard error == MZ_OK else {
            throw ZIPError(minizipErrorCode: error)
        }

        return (data: Data(buffer), path: file.flatMap { String(cString: $0.pointee.filename) } ?? path)
    }
}
