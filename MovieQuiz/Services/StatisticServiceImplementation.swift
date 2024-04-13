//
//  StatisticServiceImplementation.swift
//  MovieQuiz

import Foundation

final class StatisticServiceImplementation: StatisticService {
    func updateGameStats(isCorrect: Bool) {
        if isCorrect {
                correct += 1
        }
        total += 1
        if total % 10 == 0 {
                gamesCount += 1
        }
    }
    
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy
    }
    
    private var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
        
    private var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
        
    internal var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
        
        
    internal var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue)
            else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
            
    internal var totalAccuracy: Double {
        if total == 0 {
            return 0
        } else {
            return Double(correct) / Double(total)
        }
    }
            
    internal func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        let newGameRecord = GameRecord(correct: count, total: amount, date: Date())
        var currentBestGame = bestGame
        if newGameRecord.isBetterThan(currentBestGame) {
            currentBestGame = newGameRecord
            bestGame = currentBestGame
            userDefaults.set(try? JSONEncoder().encode(currentBestGame), forKey: Keys.bestGame.rawValue)
        }
   }
}

