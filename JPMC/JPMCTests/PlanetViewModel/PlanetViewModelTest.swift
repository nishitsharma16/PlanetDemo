//
//  PlanetViewModelTest.swift
//  JPMCTests
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import JPMC

class PlanetViewModelTest: XCTestCase {
    
    var homeVM : PlanetViewModel!

    override func setUp() {
        super.setUp()
        homeVM = PlanetViewModel()
        var list : [Planet]?
        
        let jsonObject = self.getJSONObject(fromFile: "PlanetDataList")
        if let dataObjectInfo = jsonObject , let dataList = dataObjectInfo["results"] as? [Any] {
            let builder = DataBuilder<Planet>()
            list = builder.getParsedDataList(withData: dataList)
            list?.sort(by: { (first, second) -> Bool in
                return first.planetName > second.planetName
            })
        }
        
        homeVM.dataList = list
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        homeVM = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This method will be used to test getting Planet Data from server or cache.
     */
    
    func testGetPlanetData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let promise = expectation(description: "Completion handler invoked")
        var dataStatus = false
        
        // when
        homeVM.getPlanetData { (status) in
            dataStatus = status
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        // then
        XCTAssertEqual(dataStatus, true)
    }
    
    /**
     This method will be used to test getting row count from data list in view model object.
     */
    
    func testGetRowCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.        
        let rowCount = homeVM.numberOfRows(section: 0)
        XCTAssert(rowCount > 0 , "Planet Data count Found Empty.")
    }
    
    /**
     This method will be used to test getting section count for data list in view model object.
     */
    
    func testGetSectionCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let sectionCount = homeVM.numberOfSections()
        XCTAssert(sectionCount > 0 , "Planet Data Section Count found empty.")
    }
    
    /**
     This method will be used to test getting object for data list in view model object.
     */
    
    func testObjectAtIndex() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let object = homeVM[0]
        XCTAssertNotNil(object, "Planet Found nil")
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
