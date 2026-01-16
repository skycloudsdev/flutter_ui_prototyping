# AI Copilot Instructions for UI Prototyping Project

## Project Overview

This is a Flutter lab application designed to experiment with AI agents' UI prototyping capabilities. The project focuses on creating and testing various user interface components and interactions using Flutter. Some UI components may need **BlOC pattern** for state management.

## Architecture & Key Patterns

### Directory Structure

- **`lib/core/`** - Application-wide configuration and setup
  - `config/app.dart` - App initialization, theme, orientation settings
  - `config/router.dart` - Route definitions and splash screen setup
  - `constants/`, `enums/` - Shared constants and enum types
- **`lib/features/`** - Feature modules (each feature is self-contained)

  - `home/` - Landing screen with uis selection (source of truth for available uis)
  - Future ui features follow the same pattern

  ### State Management & Game Development

- **BLoC**: Uses `flutter_bloc: ^9.1.1` for state management
  - Pattern: Each feature should have `bloc/`, `models/`, and `screens/` subdirectories
  - Ideal for menu navigation and app-level state

### Navigation Pattern

- Uses named routes defined in `AppRouter` class
- HomeScreen lists available uis with their routes.
- New ui features must register routes in `AppRouter.routes` before they're accessible

### Code Analysis

- All code must pass `flutter analyze` - check `analysis_options.yaml` for strict rules
- Key enforcements: strict type inference/casts, always declare return types, avoid print statements
- Use `flutter format` to format code consistently

## Project-Specific Conventions

### Naming Conventions

- UI routes follow snake_case.
- StatelessWidget screens end with `Screen` suffix (e.g., `HomeScreen`)
- Static route IDs defined in screen classes (see `HomeScreen.id = '/'`)

### UI/UX Patterns

- Portrait orientation only
- Uses Material Design (`flutter: uses-material-design: true`)
- No theme currently applied (theme code commented in `app.dart`) - add themes sparingly
- GestureDetector at app root dismisses focus on tap (unfocus helper)
- Native splash screen via `flutter_native_splash: ^2.4.7`

### Dependencies

- Minimal dependencies by design - only `flutter_bloc` and `flutter_native_splash` in production
- Dev dependencies: `bloc_test`, `mocktail` for testing framework compatibility
- No external API integrations currently

## Integration Points

### Adding a New UI Feature

1. Create `lib/features/new_ui/` directory
2. Create `new_ui_screen.dart` with a StatelessWidget extending the UI widget tree
3. Add route to `HomeScreen` UIs list (name + route path)
4. Register the route in `AppRouter.routes` with the screen widget
5. Update `lib/features/new_ui/new_ui.dart` as a barrel export file

### Cross-Feature Communication

- Currently minimal coupling - features communicate only through routing
- Future: If cross-feature state needed, manage in `lib/core/` and provide to features via BLoC provider
- Avoid importing between feature folders

## Key Files to Reference

- [lib/core/config/app.dart](./../lib/core/config/app.dart) - App setup and theming entry point
- [lib/core/config/router.dart](./../lib/core/config/router.dart) - Route registry
- [lib/features/home/home_screen.dart](./../lib/features/home/home_screen.dart) - UIs list and navigation pattern
- [analysis_options.yaml](./../analysis_options.yaml) - Code quality rules
- [pubspec.yaml](./../pubspec.yaml) - Dependencies and build configuration
