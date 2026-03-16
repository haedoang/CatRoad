import Testing
import SwiftUI
@testable import CatRoadKit

@Suite("GameManager Tests")
struct GameManagerTests {

    @Test("Initial state has correct defaults")
    func initialState() {
        let manager = GameManager()
        #expect(manager.score == 0)
        #expect(manager.gameOver == false)
        #expect(manager.gameStarted == false)
        #expect(manager.obstacles.isEmpty)
        #expect(manager.screenSize == CGSize(width: 184, height: 224))
    }

    @Test("startGame sets gameStarted to true and resets state")
    func startGame() {
        let manager = GameManager()
        manager.startGame()
        #expect(manager.gameStarted == true)
        #expect(manager.gameOver == false)
        #expect(manager.score == 0)
        #expect(manager.obstacles.isEmpty)
        manager.stopGame()
    }

    @Test("stopGame sets gameOver to true")
    func stopGame() {
        let manager = GameManager()
        manager.startGame()
        manager.stopGame()
        #expect(manager.gameOver == true)
    }

    @Test("moveUp and moveDown do nothing before game starts")
    func moveBeforeStart() {
        let manager = GameManager()
        let initialY = manager.cat.targetY
        manager.moveUp()
        #expect(manager.cat.targetY == initialY)
        manager.moveDown()
        #expect(manager.cat.targetY == initialY)
    }

    @Test("moveUp decreases cat targetY during game")
    func moveUpDuringGame() {
        let manager = GameManager()
        manager.startGame()
        let initialY = manager.cat.targetY
        manager.moveUp()
        #expect(manager.cat.targetY < initialY)
        manager.stopGame()
    }

    @Test("moveDown increases cat targetY during game")
    func moveDownDuringGame() {
        let manager = GameManager()
        manager.startGame()
        let initialY = manager.cat.targetY
        manager.moveDown()
        #expect(manager.cat.targetY > initialY)
        manager.stopGame()
    }
}

@Suite("Cat Model Tests")
struct CatTests {

    @Test("Cat frame returns correct rect")
    func catFrame() {
        let cat = Cat(position: CGPoint(x: 10, y: 20), targetY: 20)
        let frame = cat.frame()
        #expect(frame.origin.x == 10)
        #expect(frame.origin.y == 20)
        #expect(frame.size.width == 40)
        #expect(frame.size.height == 32)
    }

    @Test("Cat moveUp clamps to minimum")
    func moveUpClamp() {
        var cat = Cat(position: CGPoint(x: 10, y: 5), targetY: 5)
        let bounds = CGRect(x: 0, y: 0, width: 184, height: 224)
        cat.moveUp(in: bounds)
        #expect(cat.targetY >= 3)
    }

    @Test("Cat update interpolates position toward target")
    func updateInterpolation() {
        var cat = Cat(position: CGPoint(x: 10, y: 100), targetY: 50)
        cat.update()
        #expect(cat.position.y < 100)
        #expect(cat.position.y > 50)
    }
}

@Suite("Obstacle Tests")
struct ObstacleTests {

    @Test("Obstacle intersects with overlapping cat")
    func intersectsTrue() {
        let obstacle = Obstacle(
            position: CGPoint(x: 30, y: 100),
            size: CGSize(width: 16, height: 20),
            pixels: cactusSmall
        )
        let cat = Cat(position: CGPoint(x: 30, y: 100), targetY: 100)
        #expect(obstacle.intersects(with: cat) == true)
    }

    @Test("Obstacle does not intersect with distant cat")
    func intersectsFalse() {
        let obstacle = Obstacle(
            position: CGPoint(x: 150, y: 10),
            size: CGSize(width: 16, height: 20),
            pixels: cactusSmall
        )
        let cat = Cat(position: CGPoint(x: 30, y: 180), targetY: 180)
        #expect(obstacle.intersects(with: cat) == false)
    }
}

@Suite("Pixel Sprite Data Tests")
struct PixelSpriteTests {

    @Test("catPixelsStanding has correct count")
    func standingPixelCount() {
        #expect(catPixelsStanding.count == 23)
    }

    @Test("catPixelsWalking has correct count")
    func walkingPixelCount() {
        #expect(catPixelsWalking.count == 23)
    }

    @Test("cactusSmall has correct count")
    func cactusSmallCount() {
        #expect(cactusSmall.count == 6)
    }

    @Test("cactusLarge has correct count")
    func cactusLargeCount() {
        #expect(cactusLarge.count == 9)
    }

    @Test("rock has correct count")
    func rockCount() {
        #expect(rock.count == 8)
    }
}
