//
//  Cat.swift
//  CatRoadKit
//
//  Created by HAEDONG KIM on 11/22/25.
//
import SwiftUI

public struct Cat {
    /// 고양이가 올라갈 수 있는 최소 Y (가상 좌표). ObstacleFactory와 공유.
    public static let topMargin: CGFloat = 3
    /// 고양이 하단 절반이 화면 밖으로 나갈 수 있는 허용량 (size.height / 2). ObstacleFactory와 공유.
    public static let bottomClearance: CGFloat = 16

    public var position: CGPoint
    public var targetY: CGFloat
    public let size: CGSize = CGSize(width: 40, height: 32)
    public let speed: CGFloat = 5.0

    public init(position: CGPoint, targetY: CGFloat) {
        self.position = position
        self.targetY = targetY
    }

    /// bounds 상단 기준 topMargin 이상으로 이동.
    public mutating func moveUp(in bounds: CGRect) {
        targetY = max(Cat.topMargin, targetY - speed)
    }

    /// bounds 하단 기준 bottomClearance 여유를 두고 이동.
    public mutating func moveDown(in bounds: CGRect) {
        targetY = min(bounds.height - Cat.bottomClearance, targetY + speed)
    }

    public mutating func update() { position.y += (targetY - position.y) * 0.15 }
    public func frame() -> CGRect { CGRect(origin: position, size: size) }
}
