import XCTest
@testable import ZIP

final class ZIPTests: XCTestCase {
    func testGetDataFromSampleZIPUsingData() throws {
        let zip = try ZIP(data: Data(contentsOf: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!))
        
        let file = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file)
        XCTAssert(file?.data.count != 0)
        XCTAssertEqual(file?.path, "sample.txt")
    }
    
    func testGetDataFromSampleZIPUsingURL() throws {
        let zip = try ZIP(url: Bundle.module.url(forResource: "sample-zip-file", withExtension: "zip")!)
        
        let file = try zip.data(atPath: "sample.txt")
        XCTAssertNotNil(file)
        XCTAssert(file?.data.count != 0)
        XCTAssertEqual(file?.path, "sample.txt")
    }
}
