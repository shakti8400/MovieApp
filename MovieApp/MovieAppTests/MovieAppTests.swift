//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Shakti Singh on 21/02/25.
//

import XCTest
@testable import MovieApp



final class MovieAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchMovieList_Success() {
           let expectation = self.expectation(description: "Fetch Movie List Success")
           
           MovieListDataProvider().fetchMovieList(pageNumber: 1) { data in
               XCTAssertNotNil(data, "Data should not be nil")
               XCTAssertEqual(data?.results?.count, 20, "Should return movie")
               XCTAssertEqual(data?.results?.first?.title, "The Gorge", "Movie title should match")
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 2)
       }
 
    func testFetchMovieListByTitle_Success() {
           let expectation = self.expectation(description: "Fetch Movie List Success")
           
        MovieListDataProvider().fetchMovieListByTitle(pageNumber: 1, searchText: "Jack", completionHandler: { data in
            XCTAssertNotNil(data, "Data should not be nil")
            XCTAssertEqual(data?.results?.count, 20, "Should return movie")
            XCTAssertEqual(data?.results?.first?.title, "Jack", "Movie title should match")
            expectation.fulfill()
        })
           
           waitForExpectations(timeout: 2)
       }
    
    
    func testPrepareDataSource_Success() {
            let mockMovie = MovieListResultModel()
            mockMovie.id = 1
            mockMovie.title = "Mock Movie"
           let viewModel = MovieListVM()
            viewModel.prepareDataSource()
        viewModel.movieList.append(mockMovie)
            XCTAssertFalse(viewModel.movieList.isEmpty, "Movie list should not be empty")
            XCTAssertEqual(viewModel.movieList.first?.title, "Mock Movie", "First movie should be 'Mock Movie'")
        }

}
