//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Mustafa Kemal Gökçe on 26.01.2024.
//

import Foundation
import QuizEngine

final class RouterSpy: Router {
  
  typealias Question = String
  typealias Answer = String
  
  var routedQuestions: [Question] = []
  var routedResult: ResultType? = nil
  var answerCallback: (Answer) -> Void  = { _ in}
  
  func route(to question: Question, answerCallback: @escaping AnswerCallback) {
    routedQuestions.append(question)
    self.answerCallback = answerCallback
  }
  
  func route(to result: ResultType) {
    routedResult = result
  }
}
