//
//  CoreDataManagerTest.swift
//  JPMCTests
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import JPMC

class CoreDataManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This method will be used to test initializing the core data stack.
     */
    
    func testInitializeCoreDataStack() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataStatus = false
        
        CoreDataManager.sharedInstance.initializeCoreDataStack { (status) in
            dataStatus = status
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(dataStatus, true, "DB not Initialized.")
    }
    
    /**
     This method will be used to test getting data for a given key from Core Data.
     */
    
    func testGetDataForGivenKey() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataVal : Any?
        
        CoreDataManager.sharedInstance.getData(forPath: WebEngineConstant.planetAPI) { (data) in
            dataVal = data
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(dataVal, "Data not fetched.")

    }
    
    /**
     This method will be used to test saving data for a given key to Core Data.
     */
    
    func testSaveDataForGivenKey() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let promise = expectation(description: "Completion handler invoked")
        var dataStatus = false
        
        let jsonObject = self.getJSONObject(fromFile: "PlanetDataList") as Any
        CoreDataManager.sharedInstance.saveData(withData: jsonObject, forPath: WebEngineConstant.planetAPI) { (status) in
            dataStatus = status
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(dataStatus, true, "Data not saved.")
    }
    
    /**
     This method will be used to test updating data to Core Data for a given key.
     */
    
    func testUpdateDataForGivenKey() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataStatus = false
        
        let jsonObject = self.getJSONObject(fromFile: "PlanetDataList") as Any
        CoreDataManager.sharedInstance.updateData(withData: jsonObject, forPath: WebEngineConstant.planetAPI) { (status) in
            dataStatus = status
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20, handler: nil)
        
        XCTAssertEqual(dataStatus, true, "Data not updated.")
    }
    
    private func getJSONObject(fromFile fileName : String) -> [AnyHashable : Any]? {
        guard let pathURL = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: pathURL, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [AnyHashable : Any] {
                return jsonResult
            }
            else {
                return nil
            }
        } catch {
            // handle error
            return nil
        }
    }
    
}
