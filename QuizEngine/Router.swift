//
//  Router.swift
//  QuizEngine
//
//  Created by Mustafa Kemal Gökçe on 26.01.2024.
//

import Foundation

public protocol Router {
  associatedtype Question: Hashable
  associatedtype Answer: Equatable
  
  typealias ResultType = Result<Question,Answer>
  typealias AnswerCallback = (Answer) -> Void
  func route(to question: Question, answerCallback: @escaping (Answer) -> Void)
  func route(to result: ResultType)
}


