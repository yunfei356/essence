//
//  QuestionCard.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-12-04.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit

class QuestionCard: SwipeableCardViewCard, UITableViewDelegate, UITableViewDataSource {
    
    var questionId: Int!
    var numRowsSelected: Int = 0
    var selectedAnswers: Set<Int> = []
    var questionView: UITextView!
    var answersView: UITableView! {
        didSet {
            answersView.delegate = self
            answersView.dataSource = self
            answersView.allowsMultipleSelection = true
        }
    }
    
    var viewModel: QuestionCardViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }
    
    func configure(forViewModel viewModel: QuestionCardViewModel?) {
        if let viewModel = viewModel {
            let marginSpace = 10.0
            let screenWidth = Double(UIScreen.main.bounds.width)
            self.questionView = UITextView(frame: CGRect(x: marginSpace, y: marginSpace, width: screenWidth * 0.85, height: screenWidth * 0.7))
            self.answersView = UITableView(frame: CGRect(x: marginSpace, y: 2 * marginSpace + screenWidth * 0.7, width: screenWidth * 0.85, height: screenWidth))
            self.questionView.backgroundColor = UIColor.red
            self.questionView.text = viewModel.text
            self.questionView.font = UIFont(name: "Arial", size: CGFloat(18.0))
            self.addSubview(self.questionView)
            self.addSubview(self.answersView)
            self.questionId = viewModel.questionId
        }
    }
    
    // The following functions render the tableview and its contents
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(AnswerTableViewCell.self,
                           forCellReuseIdentifier: "answerCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        cell.textLabel?.text = viewModel?.answerChoices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.answerChoices.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if numRowsSelected == viewModel?.numSelectionsAllowed {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswers.insert(indexPath.row)
        numRowsSelected += 1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedAnswers.remove(indexPath.row)
        numRowsSelected -= 1
    }
}
