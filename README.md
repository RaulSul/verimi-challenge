# verimi-image-viewer
## Description
This app pulls images from Lorem Picsum website, and allows the user to flag any image as `Favorite`.

## Tools used:
- Xcode (v16.3)
- Simulator: iPhone 15 Pro (iOS 17.4)

## Notes on code:
- MVVM-C pattern (w/ coordinator)
- SwiftUI
- Combine
- SwiftData (for retaining the favorite images)
- No 3rd party libraries
- I opted to use pagination with low amount of images per page (10) in `.webp` format to optimize the app performance
- I covered two viewModels in Unit Tests to make sure that if any changes happen to the core functionality of the app, the dev can make sure that all possible use cases are still intact and behave properly.
