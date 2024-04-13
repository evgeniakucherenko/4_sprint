import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
           guard let question = question else {
               return
           }

           currentQuestion = question
           let viewModel = convert(model: question)
            
           DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
           }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        previewImage.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        questionFactory.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        changeStateButtons(isEnabled: false)
        
        guard currentQuestion != nil else {
            return
        }
        statisticService?.updateGameStats(isCorrect: isCorrect)
        
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(resource: .yPGreen).cgColor : UIColor(resource: .yPRed).cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            guard let self = self else {return}
            self.changeStateButtons(isEnabled: true)
            self.showNextQuestionOrResults()
        }
    }
    
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var previewImage: UIImageView!
    
    private var isEnabled = true
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    private var gameStatsText: String = ""
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService 
            else {
                return
            }
            let correctAnswersCount = self.correctAnswers
            let totalQuestions = questionsAmount
            statisticService.store(correct: correctAnswersCount, total: totalQuestions)
            let correctAnswers = self.correctAnswers
            let text = "Ваш результат: \(correctAnswers)/10"
            let completedGamesCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let bestGame = statisticService.bestGame
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: bestGame.date)
            let bestGameInfo = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateString))"
            let averageAccuracy = String(format: "Средняя точность: %.2f%%", statisticService.totalAccuracy * 100)
            gameStatsText = "\(text)\n\(completedGamesCount)\n\(bestGameInfo)\n\(averageAccuracy)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let questionFactory = QuestionFactory()
            questionFactory.setup(delegate: self)
            questionFactory.requestNextQuestion()
            self.questionFactory = questionFactory
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: gameStatsText,
            buttonText: result.buttonText) { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
        alertPresenter.showAlert(model: alertModel)
    }
}

 



