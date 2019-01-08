//
//  WebServiceManagerTest.swift
//  JPMCTests
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import JPMC

class WebServiceManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This method will be used to test fetching data from the server for a given end point.
     */
    
    func testGetDataForGivenRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataVal : Any?
        var errorVal : DataError?

        WebServiceManager.sharedInstance.createDataRequest(withPath:  WebEngineConstant.planetAPI, withParam: nil, withCustomHeader: nil, withRequestType: .GET) { (data, error) in
            dataVal = data
            errorVal = error
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertNotNil(dataVal, "Data not fetched.")
        XCTAssertNil(errorVal, "Data error coming \(errorVal?.errorMessage ?? "")")
    }
}
