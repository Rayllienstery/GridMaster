# GridMaster

A 3x3 grid puzzle game with drag-and-drop tile swapping. Built with SwiftUI following Clean Architecture principles based on [TMArchitecture](https://github.com/Rayllienstery/TMArchitecture).

## Features

- ✅ 3x3 grid puzzle with square tiles
- ✅ Image loading from remote URL (https://picsum.photos/1024) with local fallback
- ✅ Tap-to-select and swap tile mechanics
- ✅ Locked tiles when in correct position
- ✅ Completion notification
- ✅ State persistence across orientation changes
- ✅ 100% unit test coverage for ViewModels and UseCases
- ✅ Clean Architecture with MVVM pattern
- ✅ Full accessibility support

## Architecture

The project follows Clean Architecture principles with clear separation of concerns:

- **Presentation Layer**: Views, ViewModels, UI components
- **Domain Layer**: Entities, UseCases, Repository Protocols, Domain Errors
- **Data Layer**: Repository Implementations, DataSources, Services
- **Application Layer**: Dependency Injection setup

## Project Structure

```
GridMaster/
├── Presentation/
│   └── Puzzle/
│       ├── PuzzleView.swift
│       ├── PuzzleViewModel.swift
│       └── Components/
│           ├── PuzzleTileView.swift
│           └── PuzzleGridView.swift
├── Domain/
│   └── Puzzle/
│       ├── Entity/
│       ├── UseCase/
│       ├── Repository/
│       └── Error/
├── Data/
│   └── Puzzle/
│       ├── Repository/
│       ├── DataSource/
│       └── Service/
└── Application/
    └── DependencyInjection/
```

## How to Play

1. Tap a tile to select it (it will be highlighted)
2. Tap another tile to swap them
3. Tiles in correct positions are locked (green border with checkmark)
4. Complete the puzzle by placing all tiles correctly
5. Tap "Reset Puzzle" to start a new game

## Requirements

- iOS 18.4+
- Xcode 15.0+
- Swift 5.9+

## Testing

Run unit tests with:
```bash
xcodebuild test -scheme GridMaster -destination 'platform=iOS Simulator,name=iPhone 15'
```

## License

MIT License
