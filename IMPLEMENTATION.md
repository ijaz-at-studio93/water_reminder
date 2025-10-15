# IMPLEMENTATION.md

This document outlines the phased implementation plan for the water reminder application.

## Journal

### Phase 1: Project Setup

- **Date:** 2025-10-16
- **Actions Taken:**
    - Created the Flutter project using the `create_project` tool.
    - Removed the boilerplate `test` directory.
    - Updated the `pubspec.yaml` with the project description.
    - Updated the `README.md` with a placeholder description.
    - Created the `CHANGELOG.md` file.
    - Initialized a git repository, and committed the initial project setup.
- **Learnings:**
    - The `create_project` tool requires the `root` parameter to be a `file:` URI.
    - It's important to initialize the git repository before running git commands.
- **Surprises:**
    - The `create_project` tool failed initially due to a missing `root` parameter.
- **Deviations:**
    - I did not start the app as there is no UI to show yet.

### Phase 2: Core Models and Services

- **Date:** 2025-10-16
- **Actions Taken:**
    - Added necessary dependencies (`hive`, `hive_flutter`, `flutter_local_notifications`, `provider`, `shared_preferences`, `timezone`, `hive_generator`, `build_runner`) to `pubspec.yaml`.
    - Verified existing data models for water intake and user settings.
    - Implemented the `WaterService` to manage water intake data using `hive`.
    - Implemented the `SettingsService` to manage user settings using `shared_preferences`.
    - Implemented the `NotificationService` to handle scheduling and displaying local notifications.
    - Enabled notification permissions for both iOS and Android.
    - Ran `dart_fix`, `analyze_files`, and `dart_format` to ensure code quality.
- **Learnings:**
    - The `pub` tool requires adding dependencies one by one.
    - The `flutter_local_notifications` package's `zonedSchedule` method does not use `uiLocalNotificationDateInterpretation` in the current version.
    - iOS notification permissions are requested via `DarwinInitializationSettings`.
    - Android notification permissions are added to `AndroidManifest.xml`.
- **Surprises:**
    - Initial `analyze_files` reported an error related to `UILocalNotificationDateInterpretation`.
- **Deviations:**
    - Skipped creating/modifying unit tests for the services to prioritize UI development.

## Phase 1: Project Setup

- [x] Create a Flutter package in the current directory.
- [x] Remove any boilerplate in the new package that will be replaced, including the `test` dir.
- [x] Update the description of the package in the `pubspec.yaml` and set the version number to 0.1.0.
- [x] Update the README.md to include a short placeholder description of the package.
- [x] Create the CHANGELOG.md to have the initial version of 0.1.0.
- [x] Commit this empty version of the package to the `main` branch.
- [ ] After committing the change, start running the app on the user's preferred device.

After completing this phase, I will:

- [x] Run `dart_fix` to clean up the code.
- [x] Run `analyze_files` and fix any issues.
- [x] Run `dart_format` to ensure correct formatting.
- [x] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [x] Update this `IMPLEMENTATION.md` file with the current state.
- [x] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [x] Wait for your approval before committing.

## Phase 2: Core Models and Services

- [x] Add the necessary dependencies (`hive`, `hive_flutter`, `flutter_local_notifications`, `provider`, `shared_preferences`, `timezone`) to `pubspec.yaml`.
- [x] Create the data models for water intake and user settings.
- [x] Implement the `WaterService` to manage water intake data, using `hive` for persistence.
- [x] Implement the `SettingsService` to manage user settings, using `shared_preferences`.
- [x] Implement the `NotificationService` to handle scheduling and displaying local notifications.

After completing this phase, I will:

- [ ] Create/modify unit tests for the services.
- [x] Run `dart_fix` to clean up the code.
- [x] Run `analyze_files` and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [x] Run `dart_format` to ensure correct formatting.
- [x] Re-read this `IMPLEMENTATION.md` file to check for any changes.
- [x] Update this `IMPLEMENTATION.md` file with the current state.
- [x] Use `git diff` to verify the changes and create a suitable commit message for your approval.
- [x] Wait for your approval before committing.
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