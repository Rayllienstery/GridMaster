import SwiftUI
import UniformTypeIdentifiers

struct PuzzleView<ViewModel: PuzzleViewModel>: View {
    @StateObject private var viewModel: ViewModel
    @State private var draggedTileIndex: Int?
    @State private var showCompletionAlert = false
    @State private var dragOffset: CGSize = .zero
    @State private var dragLocation: CGPoint = .zero

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.tiles.isEmpty {
                Text("Correct: \(viewModel.correctTilesCount())/\(viewModel.tiles.count)")
                    .font(.headline)

                gridView

                Button("Shuffle") {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.shuffleTiles()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .task {
            await viewModel.splitImage()
        }
        .onChange(of: viewModel.correctTilesCount()) { _, _ in
            if viewModel.isPuzzleCompleted() {
                showCompletionAlert = true
            }
        }
        .alert("Puzzle Completed!", isPresented: $showCompletionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Congratulations! You've successfully completed the puzzle!")
        }
    }

    private var gridView: some View {
        GeometryReader { geometry in
            let tileSize =
                min(geometry.size.width, geometry.size.height) / CGFloat(viewModel.gridSize)
            let columns = Array(
                repeating: GridItem(.fixed(tileSize), spacing: 0), count: viewModel.gridSize)
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(Array(viewModel.tiles.enumerated()), id: \.element.hashValue) { index, tile in
                        tileView(tile: tile, index: index, size: tileSize, geometry: geometry)
                    }
                }

                if let draggedIndex = draggedTileIndex, draggedIndex < viewModel.tiles.count {
                    Image(uiImage: viewModel.tiles[draggedIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: tileSize, height: tileSize)
                        .clipped()
                        .opacity(0.8)
                        .position(
                            x: dragLocation.x,
                            y: dragLocation.y
                        )
                        .allowsHitTesting(false)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func tileView(tile: UIImage, index: Int, size: CGFloat, geometry: GeometryProxy) -> some View {
        let isCorrect = viewModel.isTileInCorrectPosition(at: index)
        let baseImage = Image(uiImage: tile)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
            .opacity(draggedTileIndex == index ? 0.3 : 1.0)

        let row = index / viewModel.gridSize
        let col = index % viewModel.gridSize
        let centerX = CGFloat(col) * size + size / 2
        let centerY = CGFloat(row) * size + size / 2

        if isCorrect {
            baseImage
                .frame(width: size, height: size)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                        }
                )
        } else {
            baseImage
                .frame(width: size, height: size)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if draggedTileIndex == nil {
                                draggedTileIndex = index
                            }
                            dragOffset = value.translation
                            dragLocation = CGPoint(
                                x: centerX + value.translation.width,
                                y: centerY + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            if let draggedIndex = draggedTileIndex {
                                let dropRow = Int((dragLocation.y) / size)
                                let dropCol = Int((dragLocation.x) / size)
                                let dropIndex = dropRow * viewModel.gridSize + dropCol

                                if dropIndex >= 0 && dropIndex < viewModel.tiles.count &&
                                   dropIndex != draggedIndex &&
                                   !viewModel.isTileInCorrectPosition(at: dropIndex) {
                                    Task { @MainActor in
                                        viewModel.swapTiles(from: draggedIndex, to: dropIndex)
                                    }
                                } else if dropIndex >= 0 && dropIndex < viewModel.tiles.count &&
                                          viewModel.isTileInCorrectPosition(at: dropIndex) {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                }
                            }

                            draggedTileIndex = nil
                            dragOffset = .zero
                        }
                )
        }
    }
}
