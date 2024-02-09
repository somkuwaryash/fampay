# FamPay Assignment

This iOS application is a SwiftUI project that displays different card groups fetched from a mock API. Each card group is presented with a specific design type, creating a visually appealing user interface. The project utilizes SwiftUI for UI components and Combine for asynchronous data fetching.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Card Components](#card-components)
- [Card Views](#card-views)
- [Data Fetching](#data-fetching)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [License](#license)

## Overview

The FamPay Assignment app consists of a main view, `ContentView.swift`, responsible for displaying a list of card groups. Each card group has a specific design type, such as small display card, big display card, image card, small card with arrow, and dynamic width card. The UI is dynamically rendered based on the design type of each card group.

## Project Structure

The project is organized into several Swift files, each serving a specific purpose:

- **ContentView.swift**: The main SwiftUI view displaying the list of card groups.
- **CardGroupView.swift**: Determines the appropriate card view based on the design type of the card group.
- **Model.swift**: Defines the data model for the API response and various card components.
- **CardViewModel.swift**: Manages data fetching logic using Combine.
- **Card Views**: Different SwiftUI views representing various design types for cards within a card group.

## Card Components

1. **CardGroup**: Represents a group of cards with a specific design type, containing an array of `Card` instances.
2. **Card**: Represents an individual card with various properties such as title, description, image, and call-to-action buttons.
3. **DesignTypes Enum**: Enumerates different design types that a card group can have.
4. **Entity, CallToAction, GradientModel, CardImage, FormattedText**: Additional models representing different components within a card.

## Card Views

1. **SmallDisplayCardView**: Displays a card group with a small display card design type. Supports horizontal scrolling if the card group is scrollable.
2. **BigDisplayCardView**: Displays a card group with a big display card design type. Supports horizontal scrolling and presents an action sheet on long-press.
3. **ImageCardView**: Displays a card group with an image card design type. Supports horizontal scrolling and shows image, title, description, and call-to-action buttons.
4. **SmallCardWithArrowView**: Displays a card group with a small card design featuring an arrow. Shows title, description, and an arrow icon.
5. **DynamicWidthCardView**: Displays a card group with a dynamic width card design type. Supports different content components such as title, description, and call-to-action buttons.

## Data Fetching

1. The `CardGroupsViewModel` class fetches data from the mock API endpoint using Combine and URLSession.
2. Fetched data is decoded into the `APIResponse` model, and card groups are assigned to the `cardGroups` property.
3. Loading and error states are handled, and updates are reflected in the UI.

## Getting Started

To run the app on your local machine, follow these steps:

1. Clone the repository: `https://github.com/somkuwaryash/FamPayAssignment.git`
2. Open the Xcode project: `cd AssignmentFamPay && open AssignmentFamPay.xcodeproj`
3. Build and run the project using Xcode.

## Contributing

If you'd like to contribute to the project, please follow these guidelines:

1. Fork the repository.
2. Create a new branch for your feature or bug fix: `git checkout -b feature-name`
3. Make your changes and commit them with descriptive messages: `git commit -m "Description of changes"`
4. Push your changes to your fork: `git push origin feature-name`
5. Open a pull request against the main repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
