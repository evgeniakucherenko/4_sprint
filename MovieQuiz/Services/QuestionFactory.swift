//
//  QuestionFactory.swift
//  MovieQuiz

import Foundation

final class QuestionFactory: QuestionFactoryProtocol  {
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
       if movies.count > 0 {
           requestNextQuestion()
                return
        }
        moviesLoader.loadMovies { [weak self] result in
        DispatchQueue.main.async {
            guard let self else { return }
            switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                    DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.didFailToLoadData(with: error)}
              }
                
                let rating = Float(movie.rating) ?? 0
                let randomRating = Int.random(in: 5...9)
                let textRating: String
                let correctAnswer: Bool
                
                if rating > Float(randomRating) {
                    textRating = "больше"
                    correctAnswer = true
                } else {
                    textRating = "меньше"
                    correctAnswer = true
                }
                let text = "Рейтинг этого фильма \(textRating) \(randomRating)?"
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
        }
}

    
    //  private let questions: [QuizQuestion] = [
    //     QuizQuestion(
    //         image: "The Godfather",
    //         text: "Рейтинг этого фильма больше чем 6?",
    //         correctAnswer: true),
    //     QuizQuestion(
    //        image: "The Dark Knight",
    //       text: "Рейтинг этого фильма больше чем 6?",
    //      correctAnswer: true),
    //  QuizQuestion(
    //     image: "Kill Bill",
    //    text: "Рейтинг этого фильма больше чем 6?",
    //    correctAnswer: true),
    // QuizQuestion(
    //    image: "The Avengers",
    //  text: "Рейтинг этого фильма больше чем 6?",
    //  correctAnswer: true),
    //  QuizQuestion(
    //    image: "Deadpool",
    //    text: "Рейтинг этого фильма больше чем 6?",
    //  correctAnswer: true),
    // QuizQuestion(
    // image: "The Green Knight",
    //  text: "Рейтинг этого фильма больше чем 6?",
    //  correctAnswer: true),
    //  QuizQuestion(
    //     image: "Old",
    //  text: "Рейтинг этого фильма больше чем 6?",
    //   correctAnswer: false),
    // QuizQuestion(
    //     image: "The Ice Age Adventures of Buck Wild",
    //    text: "Рейтинг этого фильма больше чем 6?",
    //    correctAnswer: false),
    //   QuizQuestion(
    //    image: "Tesla",
    //     text: "Рейтинг этого фильма больше чем 6?",
    //    correctAnswer: false),
    //  QuizQuestion(
    //    image: "Vivarium",
    //   text: "Рейтинг этого фильма больше чем 6?",
    //    correctAnswer: false)
    //  ]
    
    
    
    
    

