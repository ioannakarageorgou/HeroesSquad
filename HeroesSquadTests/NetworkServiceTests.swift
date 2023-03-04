//
//  NetworkServiceTests.swift
//  HeroesSquadTests
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import XCTest
import Combine
@testable import HeroesSquad

final class NetworkServiceTests: XCTestCase {
    
    var cancellabel: AnyCancellable!
    var service: NetworkService!

    override func setUpWithError() throws {
        service = NetworkService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetCharacters() throws {
        let expectation = XCTestExpectation(description: "Expecting Successful Heroes Response")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
                case .failure: ()
                case .finished: ()
            }
        }
        let valueHandler: ([Character]) -> Void = { (heroes) in
            XCTAssertEqual(heroes[0].name, "3-D Man", "3-D Man should be first hero")
            expectation.fulfill()
        }
        
        cancellabel = service.getCharacters().sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
       
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetPaginatedCharacters() throws {
        let expectation = XCTestExpectation(description: "Expecting Successful Heroes Response")
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
            switch completion {
                case .failure: ()
                case .finished: ()
            }
        }
        let valueHandler: ([Character]) -> Void = { (heroes) in
            XCTAssertEqual(heroes[0].name, "Adam Warlock", "Adam Warlock should be returned")
            expectation.fulfill()
        }
        
        cancellabel = service.getCharacters(10, 5).sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
       
        wait(for: [expectation], timeout: 5)
    }

//    func testGetCharactersFailure() throws {
//        let expectation = XCTestExpectation(description: "Expecting Mock Decoding Error")
//        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { (completion) in
//            switch completion {
//                case .failure(let error):
//                print("hello")
//                XCTAssertEqual(error, .decoder(error: DecodingError.self as! Error))
//                    expectation.fulfill()
//                case .finished: ()
//            }
//        }
//        let valueHandler: ([Character]) -> Void = { (heroes) in }
//
//        cancellabel = service.getCharacters().sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
//
//        wait(for: [expectation], timeout: 10)
//    }

}
