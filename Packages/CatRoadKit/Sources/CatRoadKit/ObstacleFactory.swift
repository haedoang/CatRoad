//
//  ObstacleFactory.swift
//  CatRoadKit
//
import SwiftUI

public struct ObstacleFactory {
    private let screenSize: CGSize
    public static let burstSpacing: CGFloat = 90

    public init(screenSize: CGSize) {
        self.screenSize = screenSize
    }

    public func makeObstacles(count: Int, score: Int = 0) -> [Obstacle] {
        guard count > 0 else { return [] }
        return (0..<count).map { i in
            makeObstacleAt(xOffset: CGFloat(i) * Self.burstSpacing, score: score)
        }
    }

    private func makeObstacleAt(xOffset: CGFloat, score: Int) -> Obstacle {
        let definition = pickDefinition(score: score)
        let h = screenSize.height
        // Cat의 정적 상수를 직접 참조 → 이동 범위와 자동 동기화
        let catMinY = Cat.topMargin
        let catMaxY = h - Cat.bottomClearance
        let span = catMaxY - catMinY
        let mid = catMinY + span * 0.5
        let yPositions: [CGFloat] = [
            catMinY,
            catMinY + span * 0.25,
            mid,
            catMinY + span * 0.75,
            catMaxY
        ]
        let spawnY = yPositions.randomElement() ?? mid
        return Obstacle(
            position: CGPoint(x: screenSize.width + 80 + xOffset, y: spawnY),
            size: definition.size,
            pixels: definition.pixels
        )
    }

    private func pickDefinition(score: Int) -> ObstacleDefinition {
        // score 100 이상: 25% 확률로 버스 등장
        if score >= 100 && Int.random(in: 0..<4) == 0 {
            return busDefinition
        }
        return obstacleDefinitions.randomElement() ?? obstacleDefinitions[0]
    }
}
