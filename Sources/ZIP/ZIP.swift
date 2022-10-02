//
//  ZIP.swift
//  
//
//  Created by Jaehong Kang on 2021/08/21.
//

import Foundation
import Cminizip_ng

#if swift(>=5.5)
public actor ZIP {
    var mzZIPReader: UnsafeMutableRawPointer? = nil

    public init(url: URL) async throws {
        try open(url: url)
    }

    public init(data: Data) async throws {
        try open(data: data)
    }

    deinit {
        mz_zip_reader_close(mzZIPReader)
        mz_zip_reader_delete(&mzZIPReader)
    }
}
#else
public class ZIP {
    var mzZIPReader: UnsafeMutableRawPointer? = nil

    public init(url: URL) throws {
        try open(url: url)
    }

    public init(data: Data) throws {
        try open(data: data)
    }
    
    deinit {
        mz_zip_reader_close(mzZIPReader)
        mz_zip_reader_delete(&mzZIPReader)
    }
}
#endif

extension ZIP {
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

extension ZIP {
    public func extract(to url: URL) throws {
        guard url.isFileURL else {
            throw ZIPError.invalidFileURL
        }

        try extract(toPath: url.path)
    }
    
    public func extract(toPath path: String, progressHandler: ((Double) -> Void)? = nil) throws {
        var progressHandler = progressHandler

        let progressCallback: @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UnsafeMutablePointer<mz_zip_file>?, Int64) -> Int32 = { (handle, userData, fileInfo, position) in
            var raw = UInt8(0)
            mz_zip_reader_get_raw(handle, &raw)

            guard let fileInfo = fileInfo?.pointee else {
                fatalError()
            }

            let progress: Double
            if (raw > 0 && fileInfo.compressed_size > 0) {
                progress = Double(position) / Double(fileInfo.compressed_size) * 100
            } else if (raw == 0 && fileInfo.uncompressed_size > 0) {
                progress = Double(position) / Double(fileInfo.uncompressed_size) * 100
            } else {
                progress = -1
            }

            userData?.assumingMemoryBound(to: ((Double) -> Void)?.self).pointee?(progress)

            return MZ_OK
        }

        mz_zip_reader_set_progress_cb(mzZIPReader, &progressHandler, progressCallback)
        defer {
            mz_zip_reader_set_progress_cb(mzZIPReader, nil, nil)
        }

        let error = mz_zip_reader_save_all(mzZIPReader, path.cString(using: .utf8))
        guard error == MZ_OK || error == MZ_END_OF_LIST else {
            throw ZIPError(minizipErrorCode: error)
        }
    }
}
