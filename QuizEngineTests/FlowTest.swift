//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Mustafa Kemal Gökçe on 24.01.2024.
//

import Foundation
import XCTest
@testable import QuizEngine

final class FlowTest: XCTestCase {
  
  let router = RouterSpy()
  
  func test_start_withNoQuestions_doesNotRouteToQuestion() {
    makeSUT(questions: []).start() // Sut means: System under test
    XCTAssertTrue(router.routedQuestions.isEmpty)
  }
  
  func test_start_withOneQuestion_routesToCorrectQuestion() {
    let question = "Q1"
    makeSUT(questions: [question]).start()
    XCTAssertEqual(router.routedQuestions, [question])
  }
  
  func test_start_withOneQuestion_routesToCorrectQuestion_2() {
    let question2 = "Q2"
    makeSUT(questions: [question2]).start()
    XCTAssertEqual(router.routedQuestions, [question2])
  }
  
  func test_start_withTwoQuestions_routesToFirstQuestion() {
    let question1 = "Q1"
    let question2 = "Q2"
    makeSUT(questions: [question1, question2]).start()
    XCTAssertEqual(router.routedQuestions, [question1])
  }
  
  func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
    let question1 = "Q1"
    let question2 = "Q2"
    let sut = makeSUT(questions: [question1, question2])
    sut.start()
    sut.start()
    XCTAssertEqual(router.routedQuestions, [question1, question1])
  }
  
  func test_startAndAnswerFirstQuestion_withTwoQuestions_routesToSecondQuestion() {
    let question1 = "Q1"
    let question2 = "Q2"
    let questions = [question1, question2]
    let sut = makeSUT(questions: questions)
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedQuestions, [question1, question2])
  }
  
  func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThirdQuestion() {
    let question1 = "Q1"
    let question2 = "Q2"
    let question3 = "Q3"
    let questions = [question1, question2, question3]
    let sut = makeSUT(questions: questions)
    sut.start()
    
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedQuestions, questions)
  }
  
  func test_startAndAnswerFirstQuestion_withOneQuestions_doesNotRouteToAnotherQuestion() {
    let question1 = "Q1"
    let questions = [question1]
    let sut = makeSUT(questions: questions)
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedQuestions, [question1])
  }
  
  func test_startAndAnswerFirstQuestion_withNoQuestion_routesToResult() {
    makeSUT(questions: []).start()
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedResult!.answers, [:])
  }
  
  func test_start_withOneQuestion_doesNotRouteToResult() {
    makeSUT(questions: ["Q1"]).start()
    
    XCTAssertNil(router.routedResult)
  }
  
  func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
    let question1 = "Q1"
    let sut = makeSUT(questions: [question1])
    sut.start()
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedResult!.answers, [question1: "A1"])
  }
  
  func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
    let question1 = "Q1"
    let question2 = "Q2"
    let sut = makeSUT(questions: [question1, question2])
    sut.start()
    router.answerCallback("A1")
    
    XCTAssertNil(router.routedResult)
  }
  
  func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
    let question1 = "Q1"
    let question2 = "Q2"
    let sut = makeSUT(questions: [question1, question2])
    sut.start()
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedResult!.answers, [question1: "A1", question2: "A2"])
  }
  
  func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scores() {
    let question1 = "Q1"
    let question2 = "Q2"
    let sut = makeSUT(questions: [question1, question2]) { score in
      print(score)
      return 50
    }
    sut.start()
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedResult!.score, 50)
  }
  
  func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_scoresWithRightAnswers() {
    var receivedAnswers: [String: String] = [:]
    let question1 = "Q1"
    let question2 = "Q2"
    let sut = makeSUT(questions: [question1, question2]) { answers in
      receivedAnswers = answers
      return 50
    }
    sut.start()
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedResult!.score, 50)
    XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
  }
  
  // MARK: Helpers
  
  func makeSUT(questions: [String], scoring: @escaping (([String: String]) -> Int) = { _ in  0 } ) -> Flow<String, String, RouterSpy> {
    Flow(questions: questions, router: router, scoring: scoring)
  }

  
}

