//
//  Pig_Dice_GameTests.swift
//  Pig Dice GameTests
//
//  Created by Denis Goloborodko on 18.02.21.
//

import XCTest
@testable import Pig_Dice

class Player_Class_Tests: XCTestCase {
    
    // MARK: - Test(s) Lifecycle
    
    var sut: Player!
    
    override func setUp() {
        super.setUp()
        
        sut = Player(name: "TestPlayer", isAI: false)
        sut.rollDice()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Test(s)
    
    func testDiceAreRolledForTheFirstThrow() {
        XCTAssertNil(sut.previousDice, "Previous dice is not nil after the first throw of the round")
        
        XCTAssertNotNil(sut.dice1, "Dice 1 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice1!, 1, "Dice 1 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice1!, 6, "Dice 1 is greater than 6")
        
        XCTAssertNotNil(sut.dice2, "Dice 2 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice2!, 1, "Dice 2 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice2!, 6, "Dice 2 is greater than 6")
    }
    
    func testDiceAreRolledForTheNextThrows() {
        let previousDice = sut.dice1
        
        sut.rollDice()
        
        XCTAssertNotNil(sut.previousDice, "Previous dice is nil after the second throw of the round")
        XCTAssertEqual(sut.previousDice, previousDice, "Previous dice is wrong")
        
        XCTAssertNotNil(sut.dice1, "Dice 1 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice1!, 1, "Dice 1 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice1!, 6, "Dice 1 is greater than 6")
        
        XCTAssertNotNil(sut.dice2, "Dice 2 is nil after the first throw")
        XCTAssertGreaterThanOrEqual(sut.dice2!, 1, "Dice 2 is smaller than 1")
        XCTAssertLessThanOrEqual(sut.dice2!, 6, "Dice 2 is greater than 6")
    }
    
    func testPlayersStateIsClearedAfterRound() {
        sut.clearStateAfterRound()

        XCTAssertNil(sut.dice1, "Dice 1 is not nil after clearing player's state")
        XCTAssertNil(sut.dice2, "Previous dice is not nil after clearing player's state")
        XCTAssertNil(sut.previousDice, "Previous dice is not nil after clearing player's state")
        
        XCTAssertEqual(sut.roundScore, 0, "Round score is not nil after clearing player's state")
        XCTAssertEqual(sut.totalScore, 0, "Total score is not nil after clearing player's state without holding any scores")
    }
    
    func testPlayersScoresFlow() {
        sut.addRoundScore(sut.dice1! + sut.dice2!)
        sut.holdRoundScore()
        
        XCTAssertGreaterThan(sut.totalScore, 0, "Total score is 0 after holding round score")
        XCTAssertEqual(sut.roundScore, 0, "Round score is not 0 after holding round score")
    }
}


class Pig_1Dice_GameTests: XCTestCase {

    // MARK: - Test(s) Lifecycle
    
    var sut: Game!
    
    override func setUp() {
        super.setUp()
        
        Options.gameType = .PigGame1Dice
        sut = Game()
        // sut.initNewGame()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Test(s)
                
    func testCalculateScoreOneDice1() throws {
        sut.calculateScores(1)
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round score is not 0 after 1 is thrown")
        XCTAssertEqual(sut.activePlayer.totalScore, 0, "Round score is not 0 after 1 is thrown")
    }
    
    func testCalculateScoreOneDiceRandom() throws {
        let randomDiceExcept1 = Int.random(in: 2...6)
        
        sut.calculateScores(randomDiceExcept1)
        
        XCTAssertEqual(sut.activePlayer.roundScore, randomDiceExcept1, "Scores were not added to the Round Score")
        
        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round Score were not cleared")
        XCTAssertEqual(sut.activePlayer.totalScore, randomDiceExcept1, "Total Score were not updated")
    }

    func testCalculateScoreOneDice6Twice() throws {
        // Making Total score not zero
        sut.activePlayer.rollDice()
        sut.activePlayer.addRoundScore(sut.activePlayer.dice1!)
        sut.activePlayer.holdRoundScore()
        
        while sut.activePlayer.totalScore != 0 {
            sut.activePlayer.rollDice()
            sut.calculateScores(sut.activePlayer.dice1!)
        }
        
        XCTAssertEqual(sut.activePlayer.previousDice, sut.activePlayer.dice1, "Failed a condition for clearing total score")
        XCTAssertEqual(sut.activePlayer.previousDice, 6, "Total score was cleared for a wrong reason")
    }
}


class Pig_2Dice_GameTests: XCTestCase {

    // MARK: - Test(s) Lifecycle
    
    var sut: Game!
    
    override func setUp() {
        super.setUp()
        
        Options.gameType = .PigGame2Dice
        sut = Game()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Test(s)
                
    func testCalculateScoreOneOfDice1() throws {
        sut.calculateScores(1, Int.random(in: 2...6))
        sut.calculateScores(Int.random(in: 2...6), 1)
        sut.calculateScores(1, 1)
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round score is not 0 after 1 is thrown")
        XCTAssertEqual(sut.activePlayer.totalScore, 0, "Round score is not 0 after 1 is thrown")
    }
    
    func testCalculateScoreTwoRandomDice() throws {
        let randomDiceExcept1 = Int.random(in: 2...6)
        let randomDiceExcept1and6 = Int.random(in: 2...5) // Not to trigger 6x2 (total and round scores go to zero)
        
        sut.calculateScores(randomDiceExcept1, randomDiceExcept1and6)
        
        XCTAssertEqual(sut.activePlayer.roundScore, randomDiceExcept1 + randomDiceExcept1and6, "Scores were not properly added to the Round Score")
        
        sut.activePlayer.holdRoundScore()
        
        XCTAssertEqual(sut.activePlayer.roundScore, 0, "Round Score were not cleared")
        XCTAssertEqual(sut.activePlayer.totalScore, randomDiceExcept1 + randomDiceExcept1and6, "Total Score were not updated")
    }

    func testCalculateScoreTwoDiceDouble6() throws {
        // Making Total score not zero
        sut.activePlayer.rollDice()
        sut.activePlayer.addRoundScore(sut.activePlayer.dice1!)
        sut.activePlayer.holdRoundScore()
        
        while sut.activePlayer.totalScore != 0 {
            sut.activePlayer.rollDice()
            sut.calculateScores(sut.activePlayer.dice1!, sut.activePlayer.dice2!)
        }
        
        XCTAssertEqual(sut.activePlayer.dice1, sut.activePlayer.dice2, "Failed a condition for clearing total score")
        XCTAssertEqual(sut.activePlayer.dice1, 6, "Total score was cleared for a wrong reason")
    }
}
