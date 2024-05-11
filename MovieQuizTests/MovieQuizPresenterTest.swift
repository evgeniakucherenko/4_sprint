//
//  MovieQuizPresenterTest.swift
//  MovieQuizTests

import Foundation
@testable import MovieQuiz
import XCTest

    class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    
    func show(quiz result: QuizResultsViewModel) {}
    
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    
    func changeStateButtons(isEnabled: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String) {}
}
    
    class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
            
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
            
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

