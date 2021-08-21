import XCTest
@testable import ZIP

final class ZIPTests: XCTestCase {
    #if swift(>=5.5)
    func testGetDataFromSampleZIPUsingData() async throws {
        let zip = try await ZIP(data: Data(contentsOf: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!))
        
        let file1 = try await zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file1)
        XCTAssert(file1?.data.count != 0)
        XCTAssertEqual(file1?.path, "sample.txt")
        
        let file2 = try await zip.data(atPath: "sample-mpg-file.mpg")
        XCTAssertNotNil(file2)
        XCTAssert(file2?.data.count != 0)
        XCTAssertEqual(file2?.path, "sample-mpg-file.mpg")
        
        let file3 = try await zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file3)
        XCTAssert(file3?.data.count != 0)
        XCTAssertEqual(file3?.path, "sample.txt")
    }
    
    func testGetDataFromSampleZIPUsingURL() async throws {
        let zip = try await ZIP(url: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!)
        
        let file1 = try await zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file1)
        XCTAssert(file1?.data.count != 0)
        XCTAssertEqual(file1?.path, "sample.txt")
        
        let file2 = try await zip.data(atPath: "sample-mpg-file.mpg")
        XCTAssertNotNil(file2)
        XCTAssert(file2?.data.count != 0)
        XCTAssertEqual(file2?.path, "sample-mpg-file.mpg")
        
        let file3 = try await zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file3)
        XCTAssert(file3?.data.count != 0)
        XCTAssertEqual(file3?.path, "sample.txt")
    }
    #else
    func testGetDataFromSampleZIPUsingData() throws {
        let zip = try ZIP(data: Data(contentsOf: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!))
        
        let file1 = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file1)
        XCTAssert(file1?.data.count != 0)
        XCTAssertEqual(file1?.path, "sample.txt")
        
        let file2 = try zip.data(atPath: "sample-mpg-file.mpg")
        XCTAssertNotNil(file2)
        XCTAssert(file2?.data.count != 0)
        XCTAssertEqual(file2?.path, "sample-mpg-file.mpg")
        
        let file3 = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file3)
        XCTAssert(file3?.data.count != 0)
        XCTAssertEqual(file3?.path, "sample.txt")
    }
    
    func testGetDataFromSampleZIPUsingURL() throws {
        let zip = try ZIP(url: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!)
        
        let file1 = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file1)
        XCTAssert(file1?.data.count != 0)
        XCTAssertEqual(file1?.path, "sample.txt")
        
        let file2 = try zip.data(atPath: "sample-mpg-file.mpg")
        XCTAssertNotNil(file2)
        XCTAssert(file2?.data.count != 0)
        XCTAssertEqual(file2?.path, "sample-mpg-file.mpg")
        
        let file3 = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file3)
        XCTAssert(file3?.data.count != 0)
        XCTAssertEqual(file3?.path, "sample.txt")
    }
    #endif
}
