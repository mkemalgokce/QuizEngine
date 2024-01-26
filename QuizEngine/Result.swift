//
//  Result.swift
//  QuizEngine
//
//  Created by Mustafa Kemal Gökçe on 26.01.2024.
//

import Foundation

public struct Result<Question: Hashable, Answer: Equatable> {
  public let answers: [Question: Answer]
  public let score: Int
}
