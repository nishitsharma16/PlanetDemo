//
//  PlanetModelTest.swift
//  JPMCTests
//
//  Created by B0095764 on 1/8/19.
//  Copyright © 2019 Mine. All rights reserved.
//

import XCTest
@testable import JPMC


class PlanetModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This method will be used to test Planet object initializer.
     */
    
    func testInitializer() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let jsonObject = self.getJSONObject(fromFile: "PlanetData")
        let planet : Planet? = jsonObject != nil ? Planet(withData: jsonObject!) : nil
        
        XCTAssertNotNil(planet, "Planet Found nil")
        XCTAssertNotNil(planet?.planetName, "Planet Name Found nil")
        XCTAssertNotNil(planet?.planetClimate, "Planet Climate Found nil")
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
