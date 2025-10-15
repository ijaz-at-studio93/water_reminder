
# IMPLEMENTATION.md

This document outlines the phased implementation plan for the water reminder application.

## Journal

This section will be updated after each phase with a log of actions taken, things learned, surprises, and deviations from the plan.

## Phase 1: Project Setup

- [ ] Create a Flutter package in the current directory.
- [ ] Remove any boilerplate in the new package that will be replaced, including the `test` dir.
- [ ] Update the description of the package in the `pubspec.yaml` and set the version number to 0.1.0.
- [ ] Update the README.md to include a short placeholder description of the package.
- [ ] Create the CHANGELOG.md to have the initial version of 0.1.0.
- [ ] Commit this empty version of the package to the `main` branch.
- [ ] After committing the change, start running the app on the user's preferred device.

After completing this phase, I will:

- [ ] Run `dart_fix` to clean up the code.
- [ ] Run `analyze_files` and fix any issues.
- [ ] Run `dart_format` to ensure correct formatting.
- [ ] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [ ] Update this `IMPLEMENTATION.md` file with the current state.
- [ ] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [ ] Wait for your approval before committing.

## Phase 2: Core Models and Services

- [ ] Add the necessary dependencies (`hive`, `hive_flutter`, `flutter_local_notifications`, `provider`) to `pubspec.yaml`.
- [ ] Create the data models for water intake and user settings.
- [ ] Implement the `WaterService` to manage water intake data, using `hive` for persistence.
- [ ] Implement the `SettingsService` to manage user settings, using `shared_preferences`.
- [ ] Implement the `NotificationService` to handle scheduling and displaying local notifications.

After completing this phase, I will:

- [ ] Create/modify unit tests for the services.
- [ ] Run `dart_fix` to clean up the code.
- [ ] Run `analyze_files` and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to ensure correct formatting.
- [ ] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [ ] Update this `IMPLEMENTATION.md` file with the current state.
- [ ] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [ ] Wait for your approval before committing.
- [ ] If the app is running, use the hot_reload tool to reload it.

## Phase 3: Home Screen UI

- [ ] Create the `HomeScreen` widget.
- [ ] Implement the circular progress indicator to show the daily water intake progress.
- [ ] Add buttons for logging predefined and custom water intake amounts.
- [ ] Connect the UI to the `WaterService` and `SettingsService` to display and update data.

After completing this phase, I will:

- [ ] Create/modify widget tests for the `HomeScreen`.
- [ ] Run `dart_fix` to clean up the code.
- [ ] Run `analyze_files` and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to ensure correct formatting.
- [ ] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [ ] Update this `IMPLEMENTATION.md` file with the current state.
- [ ] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [ ] Wait for your approval before committing.
- [ ] If the app is running, use the hot_reload tool to reload it.

## Phase 4: History Screen UI

- [ ] Create the `HistoryScreen` widget.
- [ ] Display a list of water intake records from the `WaterService`.
- [ ] Add a simple chart to visualize the intake history.

After completing this phase, I will:

- [ ] Create/modify widget tests for the `HistoryScreen`.
- [ ] Run `dart_fix` to clean up the code.
- [ ] Run `analyze_files` and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to ensure correct formatting.
- [ ] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [ ] Update this `IMPLEMENTATION.md` file with the current state.
- [ ] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [ ] Wait for your approval before committing.
- [ ] If the app is running, use the hot_reload tool to reload it.

## Phase 5: Settings Screen UI

- [ ] Create the `SettingsScreen` widget.
- [ ] Add UI elements to allow the user to edit their daily goal.
- [ ] Add UI elements to configure notification settings (e.g., enable/disable, frequency).
- [ ] Connect the UI to the `SettingsService`.

After completing this phase, I will:

- [ ] Create/modify widget tests for the `SettingsScreen`.
- [ ] Run `dart_fix` to clean up the code.
- [ ] Run `analyze_files` and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to ensure correct formatting.
- [ ] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [ ] Update this `IMPLEMENTATION.md` file with the current state.
- [ ] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [ ] Wait for your approval before committing.
- [ ] If the app is running, use the hot_reload tool to reload it.

## Phase 6: Finalization

- [ ] Create a comprehensive `README.md` file for the package.
- [ ] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, and implementation details.
- [ ] Ask you to inspect the app and the code and say if you are satisfied with it, or if any modifications are needed.

After completing a task, if I added any TODOs to the code or didn't fully implement anything, I will make sure to add new tasks so that I can come back and complete them later.
