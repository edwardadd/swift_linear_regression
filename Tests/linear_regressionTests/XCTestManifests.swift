import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(linear_regressionTests.allTests),
    ]
}
#endif
