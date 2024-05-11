//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func changeStateButtons(isEnabled: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
