//
//  Copyright © 2018 Simon Whitty. All rights reserved.
//

@testable import DictionaryDecoder

import XCTest

final class DictionaryEncoderTests: XCTestCase {

    func testEncode() throws {

        let result = try DictionaryEncoder().encode(RequestParameters.mock)

        XCTAssertEqual(result["name"] as? String, "Peter Jones")
        XCTAssertEqual(result["age"] as? Int, 99)
        XCTAssertEqual(result["siblings"] as? [String], ["Alex", "Maxine"])
    }

    func testEncodeSingleValueThrows() {
        XCTAssertThrowsError(try DictionaryEncoder().encode(ErrorCode.invalid))
    }

    func testSimple() throws {
        let data = try JSONEncoder().encode(Simple())
        let json = String(data: data, encoding: .utf8)!
        print(json)
    }

    func testIndexKeyCannotInitializeWithStringValue() {
        XCTAssertNil([CodingKey].IndexKey(stringValue: "any"))
    }

    func testEmptyStructIsEncoded() throws {
        struct Empty: Encodable {}

        let result = try DictionaryEncoder().encode(Empty())
        XCTAssertTrue(result.isEmpty)
    }

    func testVoidEncodeMethodThrowsError() throws {
        struct ErrorStruct: Encodable {
            func encode(to encoder: Encoder) throws { }
        }

        XCTAssertThrowsError(try DictionaryEncoder().encode(ErrorStruct()))
    }

    // MARK: - KeyedContainer

    func testKeyedContainerEncodesNil() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encodeNil(forKey: "key")
        let result = try container.toAny() as? [String: String?]
        XCTAssertEqual(result, ["key": nil])
    }

    func testKeyedContainerEncodesBool() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(true, forKey: "key")
        let result = try container.toAny() as? [String: Bool]
        XCTAssertEqual(result, ["key": true])
    }

    func testKeyedContainerEncodesInt() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Int(10), forKey: "key")
        let result = try container.toAny() as? [String: Int]
        XCTAssertEqual(result, ["key": Int(10)])
    }

    func testKeyedContainerEncodesInt8() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Int8(10), forKey: "key")
        let result = try container.toAny() as? [String: Int8]
        XCTAssertEqual(result, ["key": Int8(10)])
    }

    func testKeyedContainerEncodesInt16() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Int16(10), forKey: "key")
        let result = try container.toAny() as? [String: Int16]
        XCTAssertEqual(result, ["key": Int16(10)])
    }

    func testKeyedContainerEncodesInt32() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Int32(10), forKey: "key")
        let result = try container.toAny() as? [String: Int32]
        XCTAssertEqual(result, ["key": Int32(10)])
    }

    func testKeyedContainerEncodesInt64() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Int64(10), forKey: "key")
        let result = try container.toAny() as? [String: Int64]
        XCTAssertEqual(result, ["key": Int64(10)])
    }

    func testKeyedContainerEncodesUInt() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(UInt(10), forKey: "key")
        let result = try container.toAny() as? [String: UInt]
        XCTAssertEqual(result, ["key": UInt(10)])
    }

    func testKeyedContainerEncodesUInt8() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(UInt8(10), forKey: "key")
        let result = try container.toAny() as? [String: UInt8]
        XCTAssertEqual(result, ["key": UInt8(10)])
    }

    func testKeyedContainerEncodesUInt16() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(UInt16(10), forKey: "key")
        let result = try container.toAny() as? [String: UInt16]
        XCTAssertEqual(result, ["key": UInt16(10)])
    }

    func testKeyedContainerEncodesUInt32() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(UInt32(10), forKey: "key")
        let result = try container.toAny() as? [String: UInt32]
        XCTAssertEqual(result, ["key": UInt32(10)])
    }

    func testKeyedContainerEncodesUInt64() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(UInt64(10), forKey: "key")
        let result = try container.toAny() as? [String: UInt64]
        XCTAssertEqual(result, ["key": UInt64(10)])
    }

    func testKeyedContainerEncodesFloat() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Float(10), forKey: "key")
        let result = try container.toAny() as? [String: Float]
        XCTAssertEqual(result, ["key": Float(10)])
    }

    func testKeyedContainerEncodesDouble() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(Double(10), forKey: "key")
        let result = try container.toAny() as? [String: Double]
        XCTAssertEqual(result, ["key": Double(10)])
    }

    func testKeyedContainerEncodesString() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode("test", forKey: "key")
        let result = try container.toAny() as? [String: String]
        XCTAssertEqual(result, ["key": "test"])
    }

    func testKeyedContainerEncodesNestedKeyed() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        var first = container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: "first")
        try first.encode(true, forKey: "isValid")
        let result = try container.toAny() as? [String: [String: Bool]]
        XCTAssertEqual(result, ["first": ["isValid": true]])
    }

    func testKeyedContainerEncodesNestedUnkeyed() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        var first = container.nestedUnkeyedContainer(forKey: "first")
        try first.encode(true)
        let result = try container.toAny() as? [String: [Bool]]
        XCTAssertEqual(result, ["first": [true]])
    }

    func testKeyedContainerEncodesNestedType() throws {
        let container = DictionaryEncoder.makeKeyedContainer()

        try container.encode(ErrorCode.invalid, forKey: "error")
        let result = try container.toAny() as? [String: String]
        XCTAssertEqual(result, ["error": "invalid"])
    }

    func testKeyedContainerSuperEncoder() throws {
        let container = DictionaryEncoder.makeKeyedContainer()
        var singleContainer = container.superEncoder().singleValueContainer()
        try singleContainer.encode(true)

        let result = try container.toAny() as? [String: Bool]
        XCTAssertEqual(result, ["super": true])
    }

    // MARK: - UnkeyedContainer

    func testUnkeyedContainerCountIncrements() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()
        XCTAssertEqual(container.count, 0)

        try container.encodeNil()
        XCTAssertEqual(container.count, 1)

        try container.encode(true)
        XCTAssertEqual(container.count, 2)
    }

    func testUnkeyedContainerAppendsKeypath() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()
        XCTAssertTrue(container.codingPath.isEmpty)

        let nested = container.nestedUnkeyedContainer()
        XCTAssertEqual(nested.codingPath.count, 1)
        XCTAssertEqual(nested.codingPath[0].intValue, 0)
        XCTAssertEqual(nested.codingPath[0].stringValue, "Index 0")

        var another = container.nestedUnkeyedContainer()
        XCTAssertEqual(another.codingPath.count, 1)
        XCTAssertEqual(another.codingPath[0].intValue, 1)

        let nestedNested = another.nestedUnkeyedContainer()
        XCTAssertEqual(nestedNested.codingPath.count, 2)
        XCTAssertEqual(nestedNested.codingPath[0].intValue, 1)
        XCTAssertEqual(nestedNested.codingPath[1].intValue, 0)
    }

    func testUnkeyedContainerEncodesNil() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encodeNil()
        let result = try container.toAny() as? [String?]
        XCTAssertEqual(result, [nil])
    }

    func testUnkeyedContainerEncodesBool() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(true)
        let result = try container.toAny() as? [Bool]
        XCTAssertEqual(result, [true])
    }

    func testUnkeyedContainerEncodesInt() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Int(10))
        let result = try container.toAny() as? [Int]
        XCTAssertEqual(result, [Int(10)])
    }

    func testUnkeyedContainerEncodesInt8() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Int8(10))
        let result = try container.toAny() as? [Int8]
        XCTAssertEqual(result, [Int8(10)])
    }

    func testUnkeyedContainerEncodesInt16() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Int16(10))
        let result = try container.toAny() as? [Int16]
        XCTAssertEqual(result, [Int16(10)])
    }

    func testUnkeyedContainerEncodesInt32() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Int32(10))
        let result = try container.toAny() as? [Int32]
        XCTAssertEqual(result, [Int32(10)])
    }

    func testUnkeyedContainerEncodesInt64() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Int64(10))
        let result = try container.toAny() as? [Int64]
        XCTAssertEqual(result, [Int64(10)])
    }

    func testUnkeyedContainerEncodesUInt() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(UInt(10))
        let result = try container.toAny() as? [UInt]
        XCTAssertEqual(result, [UInt(10)])
    }

    func testUnkeyedContainerEncodesUInt8() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(UInt8(10))
        let result = try container.toAny() as? [UInt8]
        XCTAssertEqual(result, [UInt8(10)])
    }

    func testUnkeyedContainerEncodesUInt16() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(UInt16(10))
        let result = try container.toAny() as? [UInt16]
        XCTAssertEqual(result, [UInt16(10)])
    }

    func testUnkeyedContainerEncodesUInt32() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(UInt32(10))
        let result = try container.toAny() as? [UInt32]
        XCTAssertEqual(result, [UInt32(10)])
    }

    func testUnkeyedContainerEncodesUInt64() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(UInt64(10))
        let result = try container.toAny() as? [UInt64]
        XCTAssertEqual(result, [UInt64(10)])
    }

    func testUnkeyedContainerEncodesFloat() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Float(10))
        let result = try container.toAny() as? [Float]
        XCTAssertEqual(result, [Float(10)])
    }

    func testUnkeyedContainerEncodesDouble() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(Double(10))
        let result = try container.toAny() as? [Double]
        XCTAssertEqual(result, [Double(10)])
    }

    func testUnkeyedContainerEncodesString() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode("test")
        let result = try container.toAny() as? [String]
        XCTAssertEqual(result, ["test"])
    }

    func testUnkeyedContainerEncodesNestedKeyed() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        var first = container.nestedContainer(keyedBy: AnyCodingKey.self)
        try first.encode(true, forKey: "isValid")
        let result = try container.toAny() as? [[String: Bool]]
        XCTAssertEqual(result, [["isValid": true]])
    }

    func testUnkeyedContainerEncodesNestedUnkeyed() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        var first = container.nestedUnkeyedContainer()
        try first.encode(true)
        let result = try container.toAny() as? [[Bool]]
        XCTAssertEqual(result, [[true]])
    }

    func testUnkeyedContainerEncodesNestedType() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()

        try container.encode(ErrorCode.invalid)
        let result = try container.toAny() as? [String]
        XCTAssertEqual(result, ["invalid"])
    }

    func testUnkeyedContainerSuperEncoder() throws {
        let container = DictionaryEncoder.makeUnkeyedContainer()
        var singleContainer = container.superEncoder().singleValueContainer()
        try singleContainer.encode(true)

        let result = try container.toAny() as? [Bool]
        XCTAssertEqual(result, [true])
    }

    // MARK: - SingleContainer

    func testSingleContainerThrowsWhenEmpty() throws {
        let container = DictionaryEncoder.makeSingleContainer()
        XCTAssertThrowsError(try container.toAny())
    }

    func testSingleContainerEncodesNil() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encodeNil()
        let val: Any = [try container.toAny()]
        XCTAssertEqual(val as? [String?], [nil])
    }

    func testSingleContainerEncodesBool() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(true)
        XCTAssertEqual(try container.toAny() as? Bool, true)
    }

    func testSingleContainerEncodesInt() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Int(10))
        XCTAssertEqual(try container.toAny() as? Int, Int(10))
    }

    func testSingleContainerEncodesInt8() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Int8(10))
        XCTAssertEqual(try container.toAny() as? Int8, Int8(10))
    }

    func testSingleContainerEncodesInt16() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Int16(10))
        XCTAssertEqual(try container.toAny() as? Int16, Int16(10))
    }

    func testSingleContainerEncodesInt32() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Int32(10))
        XCTAssertEqual(try container.toAny() as? Int32, Int32(10))
    }

    func testSingleContainerEncodesInt64() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Int64(10))
        XCTAssertEqual(try container.toAny() as? Int64, Int64(10))
    }

    func testSingleContainerEncodesUInt() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(UInt(10))
        XCTAssertEqual(try container.toAny() as? UInt, UInt(10))
    }

    func testSingleContainerEncodesUInt8() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(UInt8(10))
        XCTAssertEqual(try container.toAny() as? UInt8, UInt8(10))
    }

    func testSingleContainerEncodesUInt16() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(UInt16(10))
        XCTAssertEqual(try container.toAny() as? UInt16, UInt16(10))
    }

    func testSingleContainerEncodesUInt32() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(UInt32(10))
        XCTAssertEqual(try container.toAny() as? UInt32, UInt32(10))
    }

    func testSingleContainerEncodesUInt64() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(UInt64(10))
        XCTAssertEqual(try container.toAny() as? UInt64, UInt64(10))
    }

    func testSingleContainerEncodesFloat() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Float(10))
        XCTAssertEqual(try container.toAny() as? Float, Float(10))
    }

    func testSingleContainerEncodesDouble() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(Double(10))
        XCTAssertEqual(try container.toAny() as? Double, Double(10))
    }

    func testSingleContainerEncodesType() throws {
        let container = DictionaryEncoder.makeSingleContainer()

        try container.encode(ErrorCode.invalid)
        XCTAssertEqual(try container.toAny() as? String, "invalid")
    }
}

private extension DictionaryEncoder {

    static func makeKeyedContainer() -> DictionaryEncoder.KeyedContainer<AnyCodingKey> {
        return DictionaryEncoder.KeyedContainer<AnyCodingKey>(codingPath: [])
    }

    static func makeUnkeyedContainer() -> DictionaryEncoder.UnkeyedContainer {
        return DictionaryEncoder.UnkeyedContainer(codingPath: [])
    }

    static func makeSingleContainer() -> DictionaryEncoder.SingleContainer {
        return DictionaryEncoder.SingleContainer(codingPath: [])
    }

    //    static func makeUnkeyedContainer(_ storage: [Any]) -> UnkeyedDecodingContainer {
    //        return DictionaryDecoder.UnkeyedContainer(storage: storage, codingPath: [], currentIndex: 0)
    //    }
    //
    //    static func makeSingleContainer(_ value: Any) -> SingleValueDecodingContainer {
    //        return DictionaryDecoder.SingleContainer(value: value, codingPath: [])
    //    }
}

private extension DictionaryEncoderTests {

    struct RequestParameters: Encodable {
        var name: String
        var age: Int
        var siblings: [String]

        static var mock: RequestParameters {
            return RequestParameters(name: "Peter Jones",
                                     age: 99,
                                     siblings: ["Alex", "Maxine"])
        }
    }

    struct Simple: Encodable {
        var name: String = "Simon"
        var age: Int = 5
    }

    enum ErrorCode: String, Encodable {
        case invalid
        case unknown
    }
}
