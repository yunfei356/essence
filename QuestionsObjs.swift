//
//  QuestionCardViewModel.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-12-04.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

struct QuestionCardViewModel {
    let questionId: Int
    let lang: String
    let text: String
    let type: String
    let numSelectionsAllowed: Int
    let answerChoices: [String]
}

struct AnswerObj {
    let questionId: Int
    let selectedAnswers: [Int]
}
