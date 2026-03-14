//
//  ContentView.swift
//  catroad
//
//  Created by HAEDONG KIM on 11/22/25.
//
import SwiftUI
import CatRoadKit

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @State private var crownValue: Double = 50
    @State private var previousCrownValue: Double = 50
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color(red: 44/255, green: 27/255, blue: 10/255)
                .ignoresSafeArea()
            if gameManager.gameStarted {
                GameView(gameManager: gameManager, crownValue: $crownValue)
            } else {
                StartView(gameManager: gameManager, crownValue: $crownValue)
            }
        }
        .focusable()
        .focused($isFocused)
        .digitalCrownRotation($crownValue, from: 0, through: 100, by: 1, sensitivity: .low)
        .onChange(of: crownValue) { newValue in
            guard gameManager.gameStarted && !gameManager.gameOver else { return }
            if newValue > previousCrownValue {
                gameManager.moveUp()
            } else if newValue < previousCrownValue {
                gameManager.moveDown()
            }
            previousCrownValue = newValue
        }
        .onAppear {
            isFocused = true
        }
        .onChange(of: gameManager.gameStarted) { started in
            if started {
                previousCrownValue = crownValue
                isFocused = true
            }
        }
        .onChange(of: gameManager.gameOver) { isOver in
            if !isOver {
                previousCrownValue = crownValue
                isFocused = true
            }
        }
    }
}

struct StartView: View {
    @ObservedObject var gameManager: GameManager
    @Binding var crownValue: Double
    var body: some View {
        VStack(spacing: 8) {
            Text("CatRoad")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.orange)
            PixelCat(pixelSize: 4.0, pixels: catPixelsStanding)
                .frame(width: 40, height: 32)
            if gameManager.highScore > 0 {
                Text("High Score: \(gameManager.highScore)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.orange)
            }
            Button(action: { crownValue = 50; gameManager.startGame() }) {
                Text("Start")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            Text("Spin the Crown\nto move your cat!")
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @Binding var crownValue: Double
    @State private var walkFrame: Int = 0
    @State private var walkTimer: Timer?

    var body: some View {
        GeometryReader { geometry in
            let layout = GameLayout(screenSize: geometry.size, virtualSize: gameManager.screenSize)
            ZStack {
                GameBackgroundCanvas(pixelSize: layout.pixelSize)
                gameWorldLayer(layout: layout)
                scoreOverlay
                if gameManager.gameOver {
                    GameOverView(score: gameManager.score, gameManager: gameManager, crownValue: $crownValue)
                }
            }
            .gesture(dragGesture)
            .onAppear { startWalkTimer() }
            .onChange(of: gameManager.gameOver) { isOver in
                isOver ? stopWalkTimer() : startWalkTimer()
            }
            .onDisappear { stopWalkTimer() }
        }
    }

    private func gameWorldLayer(layout: GameLayout) -> some View {
        ZStack {
            ForEach(gameManager.obstacles) { obstacle in
                PixelObstacle(pixelSize: layout.pixelSize, pixels: obstacle.pixels)
                    .frame(
                        width: obstacle.size.width * layout.scale,
                        height: obstacle.size.height * layout.scale
                    )
                    .position(layout.screenPosition(of: obstacle.position))
            }
            PixelCat(
                pixelSize: layout.pixelSize,
                pixels: walkFrame == 0 ? catPixelsStanding : catPixelsWalking
            )
            .frame(
                width: gameManager.cat.size.width * layout.scale,
                height: gameManager.cat.size.height * layout.scale
            )
            .position(layout.screenPosition(of: gameManager.cat.position))
        }
        .frame(width: layout.finalWidth, height: layout.finalHeight)
        .offset(y: -5)
    }

    private var scoreOverlay: some View {
        VStack {
            HStack {
                Text("\(gameManager.score)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(gameManager.chaosMode ? .red : .orange)
                if gameManager.chaosMode {
                    Text("CHAOS")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding(8)
            .onTapGesture(count: 3) { gameManager.activateChaosMode() }
            Spacer()
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                if value.translation.height < 0 { gameManager.moveUp() }
                else if value.translation.height > 0 { gameManager.moveDown() }
            }
    }

    private func startWalkTimer() {
        walkTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            walkFrame = (walkFrame + 1) % 2
        }
    }

    private func stopWalkTimer() {
        walkTimer?.invalidate()
        walkTimer = nil
    }
}

// MARK: - GameLayout

/// 가상 좌표(virtual) → 화면 좌표(screen) 변환을 담당하는 값 타입
private struct GameLayout {
    let finalWidth: CGFloat
    let finalHeight: CGFloat
    let pixelSize: CGFloat
    private let virtualSize: CGSize

    init(screenSize: CGSize, virtualSize: CGSize) {
        self.virtualSize = virtualSize
        let aspectRatio = virtualSize.width / virtualSize.height
        let gameWorldWidth = screenSize.width * 0.95
        let gameWorldHeight = screenSize.height * 0.85
        let calculatedWidth = gameWorldHeight * aspectRatio
        finalWidth = min(calculatedWidth, gameWorldWidth)
        finalHeight = finalWidth / aspectRatio
        pixelSize = finalWidth / 46.0
    }

    var scale: CGFloat { pixelSize / 4.0 }

    func screenPosition(of virtualPoint: CGPoint) -> CGPoint {
        CGPoint(
            x: (virtualPoint.x / virtualSize.width) * finalWidth,
            y: (virtualPoint.y / virtualSize.height) * finalHeight
        )
    }
}

// MARK: - GameBackgroundCanvas

private struct GameBackgroundCanvas: View {
    let pixelSize: CGFloat

    var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(Color(red: 44/255, green: 27/255, blue: 10/255))
            )
            drawGridLines(context: context, size: size)
            drawDots(context: context, size: size)
        }
    }

    private func drawGridLines(context: GraphicsContext, size: CGSize) {
        let lineSpacing = pixelSize * 4
        for y in stride(from: lineSpacing, to: size.height, by: lineSpacing) {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(
                path,
                with: .color(Color(red: 100/255, green: 65/255, blue: 28/255).opacity(0.10)),
                lineWidth: 1
            )
        }
    }

    private func drawDots(context: GraphicsContext, size: CGSize) {
        let dotSize = max(1.5, pixelSize * 0.4)
        let dotColors: [Color] = [
            Color(red: 75/255, green: 50/255, blue: 22/255).opacity(0.5),
            Color(red: 95/255, green: 62/255, blue: 26/255).opacity(0.35),
            Color(red: 60/255, green: 38/255, blue: 14/255).opacity(0.45),
        ]
        var rng = SeededRNG(seed: 42)
        for _ in 0..<120 {
            let x = rng.nextDouble() * size.width
            let y = rng.nextDouble() * size.height
            let colorIdx = Int(rng.nextDouble() * Double(dotColors.count))
            context.fill(
                Path(CGRect(x: x, y: y, width: dotSize, height: dotSize)),
                with: .color(dotColors[colorIdx])
            )
        }
    }
}

struct GameOverView: View {
    let score: Int
    @ObservedObject var gameManager: GameManager
    @Binding var crownValue: Double
    var body: some View {
        VStack(spacing: 8) {
            Text("GAME OVER")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(red: 255/255, green: 84/255, blue: 89/255))
            Text("Score: \(score)")
                .font(.system(size: 14))
                .foregroundColor(.white)
            if gameManager.highScore > 0 {
                Text("Best: \(gameManager.highScore)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.orange)
            }
            Button(action: { crownValue = 50; gameManager.startGame() }) {
                Text("Play Again!")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(red: 28/255, green: 17/255, blue: 7/255).opacity(0.95))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 255/255, green: 84/255, blue: 89/255), lineWidth: 2)
        )
    }
}

// 고정 시드 의사난수 생성기 (Canvas 재렌더링 시 동일한 패턴 유지)
private struct SeededRNG {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func nextDouble() -> Double {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return Double(state >> 33) / Double(UInt64(1) << 31)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
