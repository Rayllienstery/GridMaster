# GridMaster

A 3x3 grid puzzle game with drag-and-drop tile swapping. Built with SwiftUI following Clean Architecture principles based on [TMArchitecture](https://github.com/Rayllienstery/TMArchitecture).

## Features

- 3x3 / 4x4 / 5x5 grid puzzle with square tiles
- Image loading from remote URL (`https://picsum.photos/1024`) with local fallback
- Tap-to-select and swap tile mechanics
- Locked tiles when in correct position
- Completion notification
- State persistence across orientation changes
- 85+% unit test coverage for ViewModels and UseCases
- Clean Architecture with MVVM pattern
- Full accessibility support

## Architecture

The project follows Clean Architecture principles with clear separation of concerns:

- **Presentation Layer**: Views, ViewModels, UI components
- **Domain Layer**: Entities, UseCases, Repository Protocols, Domain Errors
- **Data Layer**: Repository Implementations, DataSources, Services
- **Application Layer**: Dependency Injection setup

## Project Structure

```text
GridMaster/
├── Presentation/
│   └── Feature/
│       ├── Home/
│       │   ├── HomeView.swift
│       │   ├── HomeView+ViewComponents.swift
│       │   ├── HomeViewModel.swift
│       │   ├── HomeFactory.swift
│       │   └── Components/
│       │       └── LocalAssetButton.swift
│       └── Puzzle/
│           ├── PuzzleView.swift
│           ├── PuzzleView+DragGesture.swift
│           ├── PuzzleView+GridView.swift
│           ├── PuzzleView+ViewComponents.swift
│           ├── PuzzleViewModel.swift
│           └── PuzzleFactory.swift
├── Domain/
│   ├── Image/
│   │   ├── UseCase/
│   │   │   └── PicsumImageFetcherUseCase.swift
│   │   ├── Repository/
│   │   │   └── ImageRepositoryProtocol.swift
│   │   └── Error/
│   │       └── ImageError.swift
│   ├── Puzzle/
│   │   ├── UseCase/
│   │   │   └── SplitImageIntoGridUseCase.swift
│   │   └── Error/
│   │       └── PuzzleError.swift
│   └── Network/
│       └── NetworkMonitorProtocol.swift
├── Data/
│   ├── Image/
│   │   └── Repository/
│   │       └── ImageRepositoryImpl.swift
│   └── Network/
│       └── NetworkMonitor.swift
└── Application/
    └── Navigation/
        ├── AppWaypoint.swift
        └── CoordinatorKey.swift
```

## How to Play

1. Select grid size (2x2, 3x3, 4x4, or 5x5)
2. Load an image from Picsum API or select a local asset (when offline)
3. Drag and drop tiles to swap them
4. Tiles in correct positions are locked and show haptic feedback
5. Complete the puzzle by placing all tiles correctly
6. Use "Shuffle" button to rearrange tiles

## Requirements

- iOS 18.6+
- Xcode 16.0+
- Swift 5.9+

## Testing

Run unit tests with:

```bash
xcodebuild test -scheme GridMaster -destination 'platform=iOS Simulator,name=iPhone 15'
```

## License

Apache 2.0 License
