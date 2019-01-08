//
//  CacheManagerTest.swift
//  JPMCTests
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import JPMC

class CacheManagerTest: XCTestCase {
    
    var cacheManager : CacheManager!
    
    override func setUp() {
        super.setUp()
        cacheManager = CacheManager.sharedInstance
        cacheManager.dataSource = MockDataSource()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        cacheManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This method will be used to test getting cached data for a given key.
     */
    
    func testGetCacheDataForGivenKey() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataVal : Any?
        
        cacheManager.getData(forKey: WebEngineConstant.planetAPI) { (data) in
            dataVal = data
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil(dataVal, "Data not fetched.")
        
    }
    
    /**
     This method will be used to test saving data to cache for a given key.
     */
    
    func testSaveDataToCacheForGivenKey() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let promise = expectation(description: "Completion handler invoked")
        var dataStatus = false
        
        let jsonObject = self.getJSONObject(fromFile: "PlanetDataList") as Any
        cacheManager.saveData(withData: jsonObject, forKey: WebEngineConstant.planetAPI) { (status) in
            dataStatus = status
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(dataStatus, true, "Data not saved.")
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

class MockDataSource: CoreDataAccessorProtocol {
    lazy var jsonObject = self.getJSONObject(fromFile: "PlanetDataList") as Any
    lazy var dataInfo = [WebEngineConstant.planetAPI : jsonObject]
    
    func getData(forPath path : String, withCompletion completion : @escaping (Any?) -> Void) {
        completion(dataInfo[path])
    }
    
    func saveData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void) {
        dataInfo[path] = data
        completion(true)
    }
    
    func updateData(withData data : Any, forPath path : String, withCompletion completion : @escaping (Bool) -> Void) {
        dataInfo[path] = data
        completion(true)
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
