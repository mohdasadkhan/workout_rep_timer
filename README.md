## 1. OBJECTIVE
Build FitFlow, a Flutter fitness app combining a Tabata-style workout timer with a rep tracker and smart reminder notifications. The goal is a production-ready MVP with clean architecture, BLoC state management, and reliable local notification scheduling.

## 2. CURRENT STATUS
✅ **Locked in and working:**
- Workout timer: full Tabata configuration, preview screen, running timer with foreground notification (pause/stop buttons)
- Rep tracker: exercise library, set logging (weight/reps), workout history, personal records auto-calculated from history
- Reminder feature: per-day scheduling, independent time pickers, weekly recurring notifications using `zonedSchedule` with `DateTimeComponents.dayOfWeekAndTime`, survives device reboot via boot receiver, random title rotation
- Navigation: go_router with routes for all features, settings menu button (⋮) in both main screens
- Settings screen: categorized sections (Preferences, Notifications, Data, Support), theme integrated
- Architecture: Clean Architecture (domain/data/presentation) with BLoC pattern, get_it DI, SharedPreferences for storage

## 3. TECH STACK / CONSTRAINTS

**Explicit rules established:**
- Flutter 3.27+, Dart 3.6+
- State management: flutter_bloc ONLY (no setState in new screens)
- Navigation: go_router ONLY (use `context.push('/route')`, not `Navigator.of(context)`)
- DI: get_it (registerLazySingleton for services, registerFactory for BLoCs)
- Storage: SharedPreferences current, Hive/Drift planned for future
- Notifications: flutter_local_notifications, use `zonedSchedule` for recurring (NOT periodicallyShow)
- Theming: AppColors and AppTextStyles constants, no hardcoded colors
- Testing: abstracted services (ReminderNotificationService interface) for mocks

**Critical Android requirements:**
- Permissions: `RECEIVE_BOOT_COMPLETED`, `VIBRATE`
- Receivers: `ScheduledNotificationBootReceiver`, `ScheduledNotificationReceiver`

## 4. DETAILED BREAKDOWN

**Key decisions made:**
- Settings placement: overflow menu (⋮) → Settings screen → Reminders (2-step) for scalability
- Reminder scheduling: `zonedSchedule` with `matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime` (prevents weekly recurrence bugs)
- PR calculation: scans all workout sessions for max weight×reps per exercise
- Background timer: foreground notification keeps timer alive when app backgrounded
- Navigation structure: `/tabata`, `/rep-tracker`, `/settings`, `/reminder-settings`
- Feature dropdown: custom widget allows switching between Timer and Reps
- No bottom navigation bar; uses appBar with dropdown and settings menu

**Architecture patterns confirmed:**
- Domain layer: pure Dart, no Flutter imports
- Data layer: repositories + local data sources (SharedPreferences)
- Presentation layer: BLoC + widgets
- Each feature self-contained within `/features/feature_name/`

**Current file structure established:**
```
lib/
├── core/ (theme, router, di, constants, services, widgets)
└── features/
    ├── workout_timer/ (domain + presentation)
    ├── rep_tracker/ (domain + data + presentation)
    ├── reminder/ (domain + data + presentation)
    ├── settings/ (presentation)
    └── notification/ (legacy FCM)
```

**Specific data models:**
```dart
WorkoutConfig { prepare, work, rest, cyclesPerSet, sets, restBetweenSets, coolDown }
ReminderSchedule { enabled, List<DaySchedule> } // 7 days, each with isActive + TimeOfDay
WorkoutSession { id, date, List<Exercise> }
Exercise { name, List<ExerciseSet> }
ExerciseSet { weight, reps, completed }
```

**Routes registered:**
```dart
'/tabata', '/tabata/preview', '/tabata/running'
'/rep-tracker', '/rep-tracker/history'
'/settings'
'/reminder-settings'
```

## 5. OPEN THREADS & NEXT STEPS

**Immediate priorities (next session):**
1. **Database migration** - Replace SharedPreferences with Hive/Drift (current bottleneck: PR calculation scans entire array, slow at 100+ sessions)
2. **Theme toggle** - Implement dark/light mode switch in Settings screen
3. **Pagination** - Load workout history 20 sessions at a time

**Medium priority:**
4. Data export - CSV export of workout history
5. Unit tests - Cover PR calculation, reminder scheduling logic, timer state transitions
6. Background worker - Replace foreground notification with WorkManager (Android) for better battery efficiency

**Deferred (labeled "SOON" in Settings screen):**
- Theme switching UI
- Unit preferences (kg/lbs)
- Timer sounds toggle
- Haptic feedback toggle
- Backup & sync (requires Firebase auth)
- Rate FitFlow (Play Store launch dependent)

**Known technical debt:**
- No pagination in history screen
- SharedPreferences JSON parsing inefficient for complex queries
- Minimal test coverage
- No error analytics (Crashlytics not integrated)

## 6. COMPACT CONTEXT BLURB

FitFlow is a Flutter fitness MVP with three features: Tabata timer (configurable intervals, foreground notification), rep tracker (exercise logging, history, auto-calculated PRs), and smart reminders (per-day scheduling, weekly recurring using `zonedSchedule` + `dayOfWeekAndTime`, survives reboot). Architecture: Clean + BLoC + get_it DI + go_router + SharedPreferences. Key patterns: no setState, abstracted services for testability, theme constants (AppColors/AppTextStyles), domain layer pure Dart. Settings accessed via ⋮ menu → Settings screen. Reminder notifications require Android boot receiver. Next priorities: Hive migration for performance, theme toggle, pagination. No bottom navigation bar - uses appBar dropdown for feature switching. Timer uses foreground notification for background persistence. PRs calculated by scanning all sessions for max weight×reps per exercise.

Ready for handoff. Paste this into the new model to resume.
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ proguard-rules.pro
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ fitflow
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-hdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-mdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-night
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-night-hdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-night-mdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-night-v21
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-night-xhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-night-xxhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-night-xxxhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-v21
│  │     │     │  ├─ background.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-xhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-xxhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ drawable-xxxhdpi
│  │     │     │  ├─ android12splash.png
│  │     │     │  └─ splash.png
│  │     │     ├─ mipmap-hdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  ├─ ic_launcher_dark.png
│  │     │     │  └─ ic_launcher_light.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  ├─ ic_launcher_dark.png
│  │     │     │  └─ ic_launcher_light.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  ├─ ic_launcher_dark.png
│  │     │     │  └─ ic_launcher_light.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  ├─ ic_launcher_dark.png
│  │     │     │  └─ ic_launcher_light.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  ├─ ic_launcher_dark.png
│  │     │     │  └─ ic_launcher_light.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     ├─ values-night
│  │     │     │  └─ styles.xml
│  │     │     ├─ values-night-v31
│  │     │     │  └─ styles.xml
│  │     │     └─ values-v31
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle.kts
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  └─ settings.gradle.kts
├─ apk
│  ├─ .metadata
│  ├─ analysis_options.yaml
│  ├─ android
│  │  ├─ app
│  │  │  ├─ build.gradle.kts
│  │  │  └─ src
│  │  │     ├─ debug
│  │  │     │  └─ AndroidManifest.xml
│  │  │     ├─ main
│  │  │     │  ├─ AndroidManifest.xml
│  │  │     │  ├─ java
│  │  │     │  │  └─ io
│  │  │     │  │     └─ flutter
│  │  │     │  │        └─ plugins
│  │  │     │  ├─ kotlin
│  │  │     │  │  └─ com
│  │  │     │  │     └─ example
│  │  │     │  │        └─ apk
│  │  │     │  │           └─ MainActivity.kt
│  │  │     │  └─ res
│  │  │     │     ├─ drawable
│  │  │     │     │  └─ launch_background.xml
│  │  │     │     ├─ drawable-v21
│  │  │     │     │  └─ launch_background.xml
│  │  │     │     ├─ mipmap-hdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-mdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xxhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ mipmap-xxxhdpi
│  │  │     │     │  └─ ic_launcher.png
│  │  │     │     ├─ values
│  │  │     │     │  └─ styles.xml
│  │  │     │     └─ values-night
│  │  │     │        └─ styles.xml
│  │  │     └─ profile
│  │  │        └─ AndroidManifest.xml
│  │  ├─ build.gradle.kts
│  │  ├─ gradle
│  │  │  └─ wrapper
│  │  │     └─ gradle-wrapper.properties
│  │  ├─ gradle.properties
│  │  └─ settings.gradle.kts
│  ├─ ios
│  │  ├─ Flutter
│  │  │  ├─ AppFrameworkInfo.plist
│  │  │  ├─ Debug.xcconfig
│  │  │  └─ Release.xcconfig
│  │  ├─ Runner
│  │  │  ├─ AppDelegate.swift
│  │  │  ├─ Assets.xcassets
│  │  │  │  ├─ AppIcon.appiconset
│  │  │  │  │  ├─ Contents.json
│  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  │  └─ LaunchImage.imageset
│  │  │  │     ├─ Contents.json
│  │  │  │     ├─ LaunchImage.png
│  │  │  │     ├─ LaunchImage@2x.png
│  │  │  │     ├─ LaunchImage@3x.png
│  │  │  │     └─ README.md
│  │  │  ├─ Base.lproj
│  │  │  │  ├─ LaunchScreen.storyboard
│  │  │  │  └─ Main.storyboard
│  │  │  ├─ Info.plist
│  │  │  └─ Runner-Bridging-Header.h
│  │  ├─ Runner.xcodeproj
│  │  │  ├─ project.pbxproj
│  │  │  ├─ project.xcworkspace
│  │  │  │  ├─ contents.xcworkspacedata
│  │  │  │  └─ xcshareddata
│  │  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │  │     └─ WorkspaceSettings.xcsettings
│  │  │  └─ xcshareddata
│  │  │     └─ xcschemes
│  │  │        └─ Runner.xcscheme
│  │  ├─ Runner.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ RunnerTests
│  │     └─ RunnerTests.swift
│  ├─ lib
│  │  └─ main.dart
│  ├─ linux
│  │  ├─ CMakeLists.txt
│  │  ├─ flutter
│  │  │  ├─ CMakeLists.txt
│  │  │  ├─ generated_plugins.cmake
│  │  │  ├─ generated_plugin_registrant.cc
│  │  │  └─ generated_plugin_registrant.h
│  │  └─ runner
│  │     ├─ CMakeLists.txt
│  │     ├─ main.cc
│  │     ├─ my_application.cc
│  │     └─ my_application.h
│  ├─ macos
│  │  ├─ Flutter
│  │  │  ├─ Flutter-Debug.xcconfig
│  │  │  └─ Flutter-Release.xcconfig
│  │  ├─ Runner
│  │  │  ├─ AppDelegate.swift
│  │  │  ├─ Assets.xcassets
│  │  │  │  └─ AppIcon.appiconset
│  │  │  │     ├─ app_icon_1024.png
│  │  │  │     ├─ app_icon_128.png
│  │  │  │     ├─ app_icon_16.png
│  │  │  │     ├─ app_icon_256.png
│  │  │  │     ├─ app_icon_32.png
│  │  │  │     ├─ app_icon_512.png
│  │  │  │     ├─ app_icon_64.png
│  │  │  │     └─ Contents.json
│  │  │  ├─ Base.lproj
│  │  │  │  └─ MainMenu.xib
│  │  │  ├─ Configs
│  │  │  │  ├─ AppInfo.xcconfig
│  │  │  │  ├─ Debug.xcconfig
│  │  │  │  ├─ Release.xcconfig
│  │  │  │  └─ Warnings.xcconfig
│  │  │  ├─ DebugProfile.entitlements
│  │  │  ├─ Info.plist
│  │  │  ├─ MainFlutterWindow.swift
│  │  │  └─ Release.entitlements
│  │  ├─ Runner.xcodeproj
│  │  │  ├─ project.pbxproj
│  │  │  ├─ project.xcworkspace
│  │  │  │  └─ xcshareddata
│  │  │  │     └─ IDEWorkspaceChecks.plist
│  │  │  └─ xcshareddata
│  │  │     └─ xcschemes
│  │  │        └─ Runner.xcscheme
│  │  ├─ Runner.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     └─ IDEWorkspaceChecks.plist
│  │  └─ RunnerTests
│  │     └─ RunnerTests.swift
│  ├─ pubspec.lock
│  ├─ pubspec.yaml
│  ├─ README.md
│  ├─ test
│  │  └─ widget_test.dart
│  └─ web
│     ├─ favicon.png
│     ├─ icons
│     │  ├─ Icon-192.png
│     │  ├─ Icon-512.png
│     │  ├─ Icon-maskable-192.png
│     │  └─ Icon-maskable-512.png
│     ├─ index.html
│     └─ manifest.json
├─ assets
│  ├─ splash_dark.png
│  └─ splash_light.png
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  ├─ LaunchBackground.imageset
│  │  │  │  ├─ background.png
│  │  │  │  ├─ Contents.json
│  │  │  │  └─ darkbackground.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     ├─ LaunchImageDark.png
│  │  │     ├─ LaunchImageDark@2x.png
│  │  │     ├─ LaunchImageDark@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ core
│  │  ├─ const
│  │  │  └─ firebase_const.dart
│  │  ├─ constants
│  │  │  └─ pref_keys.dart
│  │  ├─ di
│  │  │  └─ injection.dart
│  │  ├─ failure
│  │  │  ├─ cache_exceptions.dart
│  │  │  └─ failure.dart
│  │  ├─ router
│  │  │  └─ app_router.dart
│  │  ├─ services
│  │  │  └─ notification_reminder_service.dart
│  │  ├─ theme
│  │  │  ├─ app_colors.dart
│  │  │  ├─ app_text_styles.dart
│  │  │  ├─ app_theme.dart
│  │  │  └─ theme_extensions.dart
│  │  ├─ usecases
│  │  │  └─ usecase.dart
│  │  ├─ utils
│  │  │  └─ foreground_task_handler.dart
│  │  └─ widgets
│  │     ├─ dialogs
│  │     │  └─ exit_dialog.dart
│  │     ├─ feature_dropdown
│  │     │  ├─ dropdown_overlay.dart
│  │     │  ├─ extension_on_appfeature.dart
│  │     │  └─ feature_dropdown.dart
│  │     └─ settings_menu_button.dart
│  ├─ features
│  │  ├─ background_lifecycle
│  │  │  ├─ data
│  │  │  │  ├─ local
│  │  │  │  │  └─ timer_preferences.dart
│  │  │  │  └─ repositories
│  │  │  │     └─ timer_repository_impl.dart
│  │  │  ├─ domain
│  │  │  │  ├─ entities
│  │  │  │  │  └─ timer_session.dart
│  │  │  │  └─ repositories
│  │  │  │     └─ timer_repository.dart
│  │  │  └─ presentation
│  │  │     ├─ background_lifecycle_bloc
│  │  │     │  ├─ background_lifecycle_bloc.dart
│  │  │     │  ├─ background_lifecycle_event.dart
│  │  │     │  └─ background_lifecycle_state.dart
│  │  │     └─ pages
│  │  │        ├─ setting_screen.dart
│  │  │        └─ workout_screen.dart
│  │  ├─ notification
│  │  │  ├─ data
│  │  │  │  ├─ datasources
│  │  │  │  │  ├─ fcm_remote_datasource.dart
│  │  │  │  │  └─ local_notification_datasource.dart
│  │  │  │  ├─ models
│  │  │  │  │  └─ notification_model.dart
│  │  │  │  └─ repository
│  │  │  │     └─ notification_repository_impl.dart
│  │  │  ├─ domain
│  │  │  │  ├─ entities
│  │  │  │  │  └─ notification_entity.dart
│  │  │  │  ├─ repositories
│  │  │  │  │  └─ notification_repository.dart
│  │  │  │  └─ usecases
│  │  │  │     ├─ handle_notification_tap.dart
│  │  │  │     ├─ listen_foreground_notifications.dart
│  │  │  │     └─ subscribe_to_topic.dart
│  │  │  └─ presentation
│  │  │     └─ bloc
│  │  │        ├─ notification_bloc.dart
│  │  │        ├─ notification_event.dart
│  │  │        └─ notification_state.dart
│  │  ├─ reminder
│  │  │  ├─ core
│  │  │  │  └─ reminder_title_generator.dart
│  │  │  ├─ data
│  │  │  │  ├─ datasources
│  │  │  │  │  └─ reminder_local_datasource.dart
│  │  │  │  └─ repositories
│  │  │  │     ├─ reminder_notification_service_impl.dart
│  │  │  │     └─ reminder_repository_impl.dart
│  │  │  ├─ domain
│  │  │  │  ├─ entities
│  │  │  │  │  └─ reminder_schedule.dart
│  │  │  │  ├─ repositories
│  │  │  │  │  ├─ reminder_notification_service.dart
│  │  │  │  │  └─ reminder_repository.dart
│  │  │  │  └─ usecases
│  │  │  │     ├─ load_reminder_settings_usecases.dart
│  │  │  │     └─ save_reminder_settings_usecase.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ reminder_bloc.dart
│  │  │     │  ├─ reminder_event.dart
│  │  │     │  └─ reminder_state.dart
│  │  │     ├─ screens
│  │  │     │  ├─ notification_debug_panel.dart
│  │  │     │  └─ reminder_settings_screen.dart
│  │  │     └─ widgets
│  │  │        └─ day_schedule_card.dart
│  │  ├─ rep_tracker
│  │  │  ├─ data
│  │  │  │  ├─ datasources
│  │  │  │  │  └─ workout_local_datasource.dart
│  │  │  │  ├─ models
│  │  │  │  │  ├─ exercise_model.dart
│  │  │  │  │  ├─ set_model.dart
│  │  │  │  │  └─ workout_session_model.dart
│  │  │  │  └─ repositories
│  │  │  │     └─ workout_repository_impl.dart
│  │  │  ├─ domain
│  │  │  │  ├─ entities
│  │  │  │  │  ├─ exercise.dart
│  │  │  │  │  ├─ exercise_set.dart
│  │  │  │  │  ├─ personal_record.dart
│  │  │  │  │  └─ workout_session.dart
│  │  │  │  ├─ repositories
│  │  │  │  │  └─ workout_repository.dart
│  │  │  │  └─ usecases
│  │  │  │     ├─ delete_workout_session.dart
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ personal_records_bloc
│  │  │     │  │  ├─ personal_records_bloc.dart
│  │  │     │  │  ├─ personal_records_event.dart
│  │  │     │  │  └─ personal_records_state.dart
│  │  │     │  ├─ workout_history_bloc
│  │  │     │  │  ├─ workout_history_bloc.dart
│  │  │     │  │  ├─ workout_history_event.dart
│  │  │     │  │  └─ workout_history_state.dart
│  │  │     │  └─ workout_session_bloc
│  │  │     │     ├─ workout_session_bloc.dart
│  │  │     │     ├─ workout_session_event.dart
│  │  │     │     └─ workout_session_state.dart
│  │  │     ├─ pages
│  │  │     │  ├─ workout_history_page.dart
│  │  │     │  └─ workout_session_page.dart
│  │  │     └─ widgets
│  │  │        ├─ history_and_prs_widgets
│  │  │        │  ├─ empty_state.dart
│  │  │        │  ├─ personal_record_card.dart
│  │  │        │  └─ session_card.dart
│  │  │        └─ session_widgets
│  │  │           ├─ add_exercise_bottom_sheet.dart
│  │  │           └─ workout_session_widgets.dart
│  │  ├─ settings
│  │  │  ├─ data
│  │  │  │  ├─ datasources
│  │  │  │  │  └─ theme_local_datasource.dart
│  │  │  │  └─ repositories
│  │  │  │     └─ theme_repository_impl.dart
│  │  │  ├─ domain
│  │  │  │  ├─ entities
│  │  │  │  │  └─ app_theme_mode.dart
│  │  │  │  ├─ repositories
│  │  │  │  │  └─ theme_repository.dart
│  │  │  │  └─ usecases
│  │  │  │     ├─ get_theme_mode.dart
│  │  │  │     └─ save_theme_mode.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ theme_bloc.dart
│  │  │     │  ├─ theme_event.dart
│  │  │     │  └─ theme_state.dart
│  │  │     ├─ screens
│  │  │     │  └─ settings_screen.dart
│  │  │     └─ widgets
│  │  │        └─ theme_selector_bottom_sheet.dart
│  │  └─ workout_timer
│  │     ├─ domain
│  │     │  ├─ entity
│  │     │  │  ├─ workout_config.dart
│  │     │  │  └─ workout_phase.dart
│  │     │  └─ usecases
│  │     │     └─ generate_workout_usecase.dart
│  │     └─ presentation
│  │        ├─ bloc
│  │        │  ├─ timer_bloc.dart
│  │        │  ├─ timer_effect.dart
│  │        │  ├─ timer_event.dart
│  │        │  └─ timer_state.dart
│  │        ├─ screens
│  │        │  ├─ config_screen.dart
│  │        │  ├─ running_timer_screen.dart
│  │        │  └─ workout_preview_screen.dart
│  │        └─ widgets
│  │           ├─ config_tile.dart
│  │           └─ finish_overlay.dart
│  └─ main.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ generated_plugins.cmake
│  │  ├─ generated_plugin_registrant.cc
│  │  └─ generated_plugin_registrant.h
│  └─ runner
│     ├─ CMakeLists.txt
│     ├─ main.cc
│     ├─ my_application.cc
│     └─ my_application.h
├─ macos
│  ├─ Flutter
│  │  ├─ Flutter-Debug.xcconfig
│  │  └─ Flutter-Release.xcconfig
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  └─ AppIcon.appiconset
│  │  │     ├─ app_icon_1024.png
│  │  │     ├─ app_icon_128.png
│  │  │     ├─ app_icon_16.png
│  │  │     ├─ app_icon_256.png
│  │  │     ├─ app_icon_32.png
│  │  │     ├─ app_icon_512.png
│  │  │     ├─ app_icon_64.png
│  │  │     └─ Contents.json
│  │  ├─ Base.lproj
│  │  │  └─ MainMenu.xib
│  │  ├─ Configs
│  │  │  ├─ AppInfo.xcconfig
│  │  │  ├─ Debug.xcconfig
│  │  │  ├─ Release.xcconfig
│  │  │  └─ Warnings.xcconfig
│  │  ├─ DebugProfile.entitlements
│  │  ├─ Info.plist
│  │  ├─ MainFlutterWindow.swift
│  │  └─ Release.entitlements
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  └─ xcshareddata
│  │  │     └─ IDEWorkspaceChecks.plist
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     └─ IDEWorkspaceChecks.plist
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
├─ test
│  ├─ features
│  │  ├─ rep_tracker
│  │  │  ├─ data
│  │  │  │  ├─ datasources
│  │  │  │  │  ├─ workout_local_datasource_test.dart
│  │  │  │  │  └─ workout_local_datasource_test.mocks.dart
│  │  │  │  └─ repositories
│  │  │  │     └─ workout_repository_impl_test.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ personal_records_bloc_test.dart
│  │  │     │  ├─ workout_history_bloc_test.dart
│  │  │     │  └─ workout_session_bloc_test.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page_test.dart
│  │  │        └─ workout_session_page_test.dart
│  │  └─ workout_timer
│  │     ├─ domain
│  │     │  └─ usecases
│  │     │     └─ generate_workout_usecase_test.dart
│  │     └─ presentation
│  │        ├─ bloc
│  │        │  └─ timer_bloc_test.dart
│  │        └─ screens
│  │           └─ workout_timer_screens_test.dart
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   ├─ manifest.json
   └─ splash
      └─ img
         ├─ dark-1x.png
         ├─ dark-2x.png
         ├─ dark-3x.png
         ├─ dark-4x.png
         ├─ light-1x.png
         ├─ light-2x.png
         ├─ light-3x.png
         └─ light-4x.png

```