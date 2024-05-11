//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz

import Foundation

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func changeStateButtons(isEnabled: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}
