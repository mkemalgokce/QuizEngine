//
//  Flow.swift
//  QuizEngine
//
//  Created by Mustafa Kemal Gökçe on 24.01.2024.
//

import Foundation


class Flow <Question: Hashable, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
  private let router: R
  private let questions: [Question]
  
  private var answers: [Question: Answer] = [:]
  private var scoring: ([Question: Answer]) -> Int
  init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
    self.questions = questions
    self.router = router
    self.scoring = scoring
  }
  
  func start() {
    if let firstQuestion = questions.first {
      router.route(to: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
    }else {
      router.route(to: result())
    }
    
  }
  
  private func nextCallback(from question: Question) -> R.AnswerCallback {
    return { [weak self] in self?.routeNext(question, $0)}
  }
  
  private func routeNext(_ question: Question, _ answer: Answer) {
    if let currentQuestionIndex = questions.firstIndex(of: question) {
      answers[question] = answer
      let nextQuestionIndex = currentQuestionIndex + 1
      if questions.count > nextQuestionIndex {
        let nextQuestion = questions[nextQuestionIndex]
        router.route(to: nextQuestion, answerCallback: nextCallback(from: nextQuestion))
      }else {
        router.route(to: result())
      }
    }
  }
  
  private func result() -> Result<Question, Answer> {
    return Result(answers: answers, score: scoring(answers))
  }
  
}

