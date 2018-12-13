//
//  BasicQuestionsViewController.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-11-05.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import UIKit
import AWSAppSync

class BasicQuestionsViewController: UIViewController, SwipeableCardViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var cardDeck: SwipeableCardViewContainer!
  
    var appSyncClient: AWSAppSyncClient?
    private var personId: String = "fa1db430-705f-47c2-9b84-1f18ddd64ce6"
    var answers : [AnswerObj] = []
    
    var viewModels: [QuestionCardViewModel] {
        
      let questionOne = QuestionCardViewModel(questionId: 0, lang: "en", text: "What is your favorite song?", type: "basic", numSelectionsAllowed: 1, answerChoices: ["Belle", "My Heart Will Go On", "A Whole New World"])
      let questionTwo = QuestionCardViewModel(questionId: 1, lang: "en", text: "What is your favorite word?", type: "basic", numSelectionsAllowed: 1, answerChoices: ["Dream", "Serendipity", "World"])
      return [questionOne, questionTwo]
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
      
        cardDeck.dataSource = self
      
        //getQuestionsFromAPI()
    }
  
    /*func getQuestionsFromAPI() {
      let getQuestionsInput = GetQuestionsInput(personId: self.personId, lang: "en", type: "basic")
      appSyncClient?.fetch(query: GetUnansweredQuestionsQuery(input: getQuestionsInput)) { (result, error) in
        if error != nil {
          print(error?.localizedDescription ?? "")
          return
        }
      print("result: ", result?.data ?? "No data")
    }
  }*/
        
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
        
    func numberOfCards() -> Int {
        return viewModels.count
    }
        
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = QuestionCard()
        cardView.viewModel = viewModel
        return cardView
    }
        
    func viewForEmptyCards() -> UIView? {
        return nil
    }
  
    func saveData(cardView card: SwipeableCardViewCard) {
      let currCard = card as! QuestionCard
        let theAnswer = AnswerObj(questionId: currCard.questionId, selectedAnswers: Array(currCard.selectedAnswers))
        answers.append(theAnswer)
        print(answers)
    }
}
