//
//  Pixel.swift
//  CatRoadKit
//
//  Created by HAEDONG KIM on 11/22/25.
//
import SwiftUI

public struct Pixel: Hashable {
    public let x: Int
    public let y: Int
    public let color: Color

    public init(x: Int, y: Int, color: Color) {
        self.x = x
        self.y = y
        self.color = color
    }
}

// 정지(프레임1)
public let catPixelsStanding: [Pixel] = [
    // 몸통 (좀 더 길게)
    Pixel(x:2, y:3, color:.orange),
    Pixel(x:3, y:3, color:.orange),
    Pixel(x:4, y:3, color:.orange),
    Pixel(x:5, y:3, color:.orange),
    Pixel(x:6, y:3, color:.orange),
    Pixel(x:7, y:3, color:.orange),
    Pixel(x:2, y:4, color:.orange),
    Pixel(x:3, y:4, color:.orange),
    Pixel(x:4, y:4, color:.orange),
    Pixel(x:5, y:4, color:.orange),
    Pixel(x:6, y:4, color:.orange),
    Pixel(x:7, y:4, color:.orange),
    Pixel(x:3, y:5, color:.orange),
    Pixel(x:4, y:5, color:.orange),
    Pixel(x:5, y:5, color:.orange),
    Pixel(x:6, y:5, color:.orange),
    // 머리 (더 둥글고 강하게 오른쪽)
    Pixel(x:8, y:3, color:.orange),
    Pixel(x:8, y:4, color:.orange),
    Pixel(x:8, y:2, color:.orange),

    // 꼬리 (왼쪽, 약간 아래로)
    Pixel(x:1, y:5, color:.orange),
    Pixel(x:0, y:6, color:.orange),
    // 다리(정지)
    Pixel(x:4, y:6, color:.orange),
    Pixel(x:6, y:6, color:.orange)
]

// 걷기(프레임2)
public let catPixelsWalking: [Pixel] = [
    Pixel(x:2, y:3, color:.orange),
    Pixel(x:3, y:3, color:.orange),
    Pixel(x:4, y:3, color:.orange),
    Pixel(x:5, y:3, color:.orange),
    Pixel(x:6, y:3, color:.orange),
    Pixel(x:7, y:3, color:.orange),

    Pixel(x:2, y:4, color:.orange),
    Pixel(x:3, y:4, color:.orange),
    Pixel(x:4, y:4, color:.orange),
    Pixel(x:5, y:4, color:.orange),
    Pixel(x:6, y:4, color:.orange),
    Pixel(x:7, y:4, color:.orange),

    Pixel(x:3, y:5, color:.orange),
    Pixel(x:4, y:5, color:.orange),
    Pixel(x:5, y:5, color:.orange),
    Pixel(x:6, y:5, color:.orange),

    // 머리 (더 둥글고 강하게 오른쪽)
    Pixel(x:8, y:3, color:.orange),
    Pixel(x:8, y:4, color:.orange),
    Pixel(x:8, y:2, color:.orange),

    Pixel(x:1, y:5, color:.orange),
    Pixel(x:0, y:6, color:.orange),
    // 다리(움직임) - 한쪽만 위치 변형
    Pixel(x:3, y:6, color:.orange),
    Pixel(x:7, y:6, color:.orange)
]

// 장애물: 선인장(small)
public let cactusSmall: [Pixel] = [
    Pixel(x:2, y:0, color:.green),
    Pixel(x:2, y:1, color:.green),
    Pixel(x:2, y:2, color:.green),
    Pixel(x:1, y:2, color:.green),
    Pixel(x:3, y:2, color:.green),
    Pixel(x:2, y:3, color:.green)
]

// 장애물: 선인장(large)
public let cactusLarge: [Pixel] = [
    Pixel(x:2, y:0, color:.green),
    Pixel(x:2, y:1, color:.green),
    Pixel(x:2, y:2, color:.green),
    Pixel(x:2, y:3, color:.green),
    Pixel(x:1, y:1, color:.green),
    Pixel(x:3, y:1, color:.green),
    Pixel(x:1, y:3, color:.green),
    Pixel(x:3, y:3, color:.green),
    Pixel(x:2, y:4, color:.green)
]

// 장애물: 바위
public let rock: [Pixel] = [
    Pixel(x:1, y:2, color:.gray),
    Pixel(x:2, y:2, color:.gray),
    Pixel(x:0, y:3, color:.gray), Pixel(x:1, y:3, color:.gray), Pixel(x:2, y:3, color:.gray), Pixel(x:3, y:3, color:.gray),
    Pixel(x:1, y:4, color:.gray), Pixel(x:2, y:4, color:.gray)
]

// 장애물: 버스 (12x6 그리드, 고난이도 전용)
private let busBody = Color.orange
private let busWindow = Color(red: 0.55, green: 0.82, blue: 1.0)
private let busWheel = Color(red: 0.65, green: 0.65, blue: 0.65)
private let busLight = Color.red

public let bus: [Pixel] = [
    // 지붕 (row 0)
    Pixel(x:2, y:0, color:busBody), Pixel(x:3, y:0, color:busBody),
    Pixel(x:4, y:0, color:busBody), Pixel(x:5, y:0, color:busBody),
    Pixel(x:6, y:0, color:busBody), Pixel(x:7, y:0, color:busBody),
    Pixel(x:8, y:0, color:busBody), Pixel(x:9, y:0, color:busBody),
    // 창문 + 몸체 (row 1)
    Pixel(x:1, y:1, color:busBody),  Pixel(x:2, y:1, color:busBody),
    Pixel(x:3, y:1, color:busWindow), Pixel(x:4, y:1, color:busBody),
    Pixel(x:5, y:1, color:busWindow), Pixel(x:6, y:1, color:busBody),
    Pixel(x:7, y:1, color:busWindow), Pixel(x:8, y:1, color:busBody),
    Pixel(x:9, y:1, color:busBody),  Pixel(x:10, y:1, color:busBody),
    // 몸체 중간 (row 2)
    Pixel(x:0, y:2, color:busLight), Pixel(x:1, y:2, color:busBody),
    Pixel(x:2, y:2, color:busBody), Pixel(x:3, y:2, color:busBody),
    Pixel(x:4, y:2, color:busBody), Pixel(x:5, y:2, color:busBody),
    Pixel(x:6, y:2, color:busBody), Pixel(x:7, y:2, color:busBody),
    Pixel(x:8, y:2, color:busBody), Pixel(x:9, y:2, color:busBody),
    Pixel(x:10, y:2, color:busBody), Pixel(x:11, y:2, color:busLight),
    // 몸체 하단 (row 3)
    Pixel(x:0, y:3, color:busLight), Pixel(x:1, y:3, color:busBody),
    Pixel(x:2, y:3, color:busBody), Pixel(x:3, y:3, color:busBody),
    Pixel(x:4, y:3, color:busBody), Pixel(x:5, y:3, color:busBody),
    Pixel(x:6, y:3, color:busBody), Pixel(x:7, y:3, color:busBody),
    Pixel(x:8, y:3, color:busBody), Pixel(x:9, y:3, color:busBody),
    Pixel(x:10, y:3, color:busBody), Pixel(x:11, y:3, color:busLight),
    // 하단 프레임 (row 4)
    Pixel(x:1, y:4, color:busBody), Pixel(x:2, y:4, color:busBody),
    Pixel(x:3, y:4, color:busBody), Pixel(x:4, y:4, color:busBody),
    Pixel(x:5, y:4, color:busBody), Pixel(x:6, y:4, color:busBody),
    Pixel(x:7, y:4, color:busBody), Pixel(x:8, y:4, color:busBody),
    Pixel(x:9, y:4, color:busBody), Pixel(x:10, y:4, color:busBody),
    // 바퀴 (row 5)
    Pixel(x:2, y:5, color:busWheel), Pixel(x:3, y:5, color:busWheel),
    Pixel(x:8, y:5, color:busWheel), Pixel(x:9, y:5, color:busWheel),
]
