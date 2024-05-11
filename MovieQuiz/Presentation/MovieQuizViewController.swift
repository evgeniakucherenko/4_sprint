import UIKit

    class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IB Outlets
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet private var previewImage: UIImageView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var statisticService: StatisticService?
    private var currentQuestionIndex: Int = 0
    private var gameStatsText: String = ""
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImage.layer.cornerRadius = 20
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
        
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        
        changeStateButtons(isEnabled: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
        
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func changeStateButtons(isEnabled: Bool) {
           
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // MARK: - Private Methods
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        hideLoadingIndicator() // нужно ли это?
        changeStateButtons(isEnabled: true)
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
                  title: result.title,
                  message: message,
                  preferredStyle: .alert)
                  
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in guard let self = self else { return }
                      
            self.presenter.restartGame()
        }
              
        alert.addAction(action)
              
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor(resource: .yPGreen).cgColor : UIColor(resource: .yPRed).cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() { //
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

        // MARK: - Обработка Ошибки
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorModel = AlertModel(
                title:"Ошибка",
                message: message,
                buttonText:  "Попробовать еще раз") { [weak self] in
                    guard let self = self else {return}

                    self.presenter.restartGame()
                }
        alertPresenter.showAlert(model: errorModel)
    }
}
    
