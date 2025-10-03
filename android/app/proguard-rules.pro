## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

## Google Fonts
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Hive
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }
-keepclassmembers class * extends io.flutter.embedding.engine.plugins.FlutterPlugin { *; }

## Local Notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

## Play Core (for Flutter deferred components - not used but Flutter references it)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
