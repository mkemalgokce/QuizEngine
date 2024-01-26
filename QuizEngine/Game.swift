//
//  Game.swift
//  QuizEngine
//
//  Created by Mustafa Kemal Gökçe on 26.01.2024.
//

import Foundation

public class Game<Question: Hashable, Answer: Equatable, R: Router>
where R.Question == Question, R.Answer == Answer {
  let flow: Flow<Question, Answer, R>
  
  init(flow: Flow<Question, Answer, R>) {
    self.flow = flow
  }
  
}
public func startGame<Question: Hashable, Answer: Equatable, R: Router> (questions: [Question], router: R, correctAnswers: [Question: Answer]) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
  let flow = Flow(questions: questions, router: router, scoring: {scoring($0, correctAnswers: correctAnswers)})
  flow.start()
  return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
  answers.reduce(0) { (score, tuple) in
    score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
  }
}
