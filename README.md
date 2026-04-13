# app_lifecycle

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │  └─ usecases
│  │     └─ usecase.dart
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
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ workout_bloc.dart
│  │  │     │  ├─ workout_event.dart
│  │  │     │  └─ workout_state.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  │        │  ├─ timer_event.dart
│  │        │  └─ timer_state.dart
│  │        ├─ screens
│  │        │  ├─ config_screen.dart
│  │        │  ├─ running_timer_screen.dart
│  │        │  └─ workout_timer_screen.dart
│  │        └─ widgets
│  │           └─ config_tile.dart
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │  ├─ usecases
│  │  │  └─ usecase.dart
│  │  └─ widgets
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ workout_bloc.dart
│  │  │     │  ├─ workout_event.dart
│  │  │     │  └─ workout_state.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  │        │  ├─ timer_event.dart
│  │        │  └─ timer_state.dart
│  │        ├─ screens
│  │        │  ├─ config_screen.dart
│  │        │  └─ running_timer_screen.dart
│  │        └─ widgets
│  │           └─ config_tile.dart
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │  ├─ usecases
│  │  │  └─ usecase.dart
│  │  ├─ utils
│  │  │  └─ foreground_task_handler.dart
│  │  └─ widgets
│  │     ├─ dialogs
│  │     │  └─ exit_dialog.dart
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ workout_bloc.dart
│  │  │     │  ├─ workout_event.dart
│  │  │     │  └─ workout_state.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ workout_bloc.dart
│  │  │     │  ├─ workout_event.dart
│  │  │     │  └─ workout_state.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │  │     ├─ get_personal_records.dart
│  │  │  │     ├─ get_workout_history.dart
│  │  │  │     └─ save_workout_session.dart
│  │  │  └─ presentation
│  │  │     ├─ bloc
│  │  │     │  ├─ workout_bloc.dart
│  │  │     │  ├─ workout_event.dart
│  │  │     │  └─ workout_state.dart
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │     └─ pages
│  │  │        ├─ workout_history_page.dart
│  │  │        └─ workout_session_page.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  │        └─ rep_tracker_widgets
│  │  │           └─ ready_to_train.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  ├─ home_screen.dart
│  ├─ main.dart
│  └─ text_preferences.dart
├─ linux
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```
```
app_lifecycle
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gradle
│  │  ├─ 8.12
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ expanded
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ noVersion
│  │  │  └─ buildLogic.lock
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ .kotlin
│  │  └─ sessions
│  ├─ app
│  │  ├─ build.gradle.kts
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     └─ asadcoder
│  │     │  │        └─ app_lifecycle
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
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
│  ├─ local.properties
│  └─ settings.gradle.kts
├─ devtools_options.yaml
├─ ios
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ ephemeral
│  │  │  ├─ flutter_lldbinit
│  │  │  └─ flutter_lldb_helper.py
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
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
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
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
│  │     └─ feature_dropdown
│  │        ├─ dropdown_overlay.dart
│  │        ├─ extension_on_appfeature.dart
│  │        └─ feature_dropdown.dart
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
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ flutter_local_notifications_linux
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ flutter_local_notifications_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ dbus_wrapper.dart
│  │  │     │  │     ├─ file_system.dart
│  │  │     │  │     ├─ flutter_local_notifications.dart
│  │  │     │  │     ├─ flutter_local_notifications_platform_linux.dart
│  │  │     │  │     ├─ flutter_local_notifications_stub.dart
│  │  │     │  │     ├─ helpers.dart
│  │  │     │  │     ├─ model
│  │  │     │  │     │  ├─ capabilities.dart
│  │  │     │  │     │  ├─ enums.dart
│  │  │     │  │     │  ├─ hint.dart
│  │  │     │  │     │  ├─ icon.dart
│  │  │     │  │     │  ├─ initialization_settings.dart
│  │  │     │  │     │  ├─ location.dart
│  │  │     │  │     │  ├─ notification_details.dart
│  │  │     │  │     │  ├─ sound.dart
│  │  │     │  │     │  └─ timeout.dart
│  │  │     │  │     ├─ notifications_manager.dart
│  │  │     │  │     ├─ notification_info.dart
│  │  │     │  │     ├─ platform_info.dart
│  │  │     │  │     ├─ posix.dart
│  │  │     │  │     └─ storage.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ notifications_manager_test.dart
│  │  │     │     ├─ notifications_manager_test.mocks.dart
│  │  │     │     ├─ posix_test.dart
│  │  │     │     ├─ storage_test.dart
│  │  │     │     └─ storage_test.mocks.dart
│  │  │     ├─ path_provider_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ integration_test
│  │  │     │  │  │  └─ path_provider_test.dart
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  ├─ README.md
│  │  │     │  │  └─ test_driver
│  │  │     │  │     └─ integration_test.dart
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ path_provider_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     ├─ get_application_id.dart
│  │  │     │  │     ├─ get_application_id_real.dart
│  │  │     │  │     ├─ get_application_id_stub.dart
│  │  │     │  │     └─ path_provider_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ get_application_id_test.dart
│  │  │     │     └─ path_provider_linux_test.dart
│  │  │     └─ shared_preferences_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ shared_preferences_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  └─ shared_preferences_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ fake_path_provider_linux.dart
│  │  │           ├─ legacy_shared_preferences_linux_test.dart
│  │  │           ├─ shared_preferences_linux_async_test.dart
│  │  │           └─ shared_preferences_linux_test.dart
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
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
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
│  └─ widget_test.dart
└─ web
   ├─ favicon.png
   ├─ icons
   │  ├─ Icon-192.png
   │  ├─ Icon-512.png
   │  ├─ Icon-maskable-192.png
   │  └─ Icon-maskable-512.png
   ├─ index.html
   └─ manifest.json

```