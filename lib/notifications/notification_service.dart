import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/models.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const String _channelId = 'programme_channel';
  static const String _channelName = 'Programme Guide MSM';
  static const String _channelDesc =
      'Rappels des étapes du programme (11–12 oct. 2025)';

  static void _log(String message) {
    debugPrint(message);
    dev.log(message);
  }

  static Future<void> init() async {
    _log('[LNS] init() start');
    // Timezone
    tzdata.initializeTimeZones();
    final localTz = await _safeLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));
    _log('[LNS] timezone set: $localTz');

    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS (Darwin) init – autoriser l’affichage en foreground
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
    );

    try {
      await _plugin.initialize(
        const InitializationSettings(android: androidInit, iOS: darwinInit),
      );
      _ready = true;
      _log('[LNS] plugin initialized, ready=$_ready');
    } on MissingPluginException catch (e) {
      _ready = false;
      _log('[LNS] MissingPluginException: ${e.message} — rebuild app required');
      return;
    } catch (e) {
      _ready = false;
      _log('[LNS] initialize error: $e');
      return;
    }

    // Android 13+ permissions explicites
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    // Créer le canal Android
    await androidImpl
        ?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
    ));
    _log('[LNS] Android notification channel created');

    // Demander les permissions iOS explicitement
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      _log('[LNS] iOS permissions requested, granted: $granted');
    }

    await _logCurrentPermissions();
  }

  static Future<String> _safeLocalTimezone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return 'UTC';
    }
  }

  static NotificationDetails _details({required String bigText}) {
    final android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(bigText),
      category: AndroidNotificationCategory.reminder,
      color: const Color(0xFFACBBE9), // kOutremer
      icon: '@mipmap/ic_launcher',
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  static Future<void> _logCurrentPermissions() async {
    try {
      final iosImpl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl == null) {
        _log('[LNS] iOS plugin implementation not available');
        return;
      }
      final settings = await iosImpl.checkPermissions();
      _log('[LNS] iOS permissions: $settings');
      _log('[LNS] iOS isEnabled: ${settings?.isEnabled}');
    } on MissingPluginException catch (e) {
      _log('[LNS] getNotificationSettings missing plugin: ${e.message}');
    } catch (e) {
      _log('[LNS] unable to fetch notification settings: $e');
    }
  }

  static Future<bool> requestPermissions() async {
    _log('[LNS] requestPermissions() called explicitly');
    try {
      final iosImpl = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosImpl != null) {
        final granted = await iosImpl.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        _log('[LNS] iOS permissions granted: $granted');
        await _logCurrentPermissions();
        return granted ?? false;
      }

      final androidImpl = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final granted = await androidImpl.requestNotificationsPermission();
        _log('[LNS] Android permissions granted: $granted');
        return granted ?? false;
      }

      _log('[LNS] No platform-specific implementation available');
      return false;
    } catch (e) {
      _log('[LNS] requestPermissions error: $e');
      return false;
    }
  }

  static Future<void> scheduleProgrammeNotifications(
      List<ProgrammeDay> days) async {
    if (!_ready) {
      _log('[LNS] schedule skipped: plugin not ready');
      return;
    }
    // Réinitialise pour éviter doublons
    await _plugin.cancelAll();
    _log('[LNS] scheduling from programme: days=${days.length}');

    final now = DateTime.now();
    _log('[LNS] scheduling reference now=$now');
    int id = 1000; // espace d’IDs réservé aux rappels

    for (final day in days) {
      // date au format YYYY-MM-DD (local)
      DateTime? baseDate;
      try {
        baseDate = DateTime.parse(day.date);
      } catch (_) {}
      if (baseDate == null) {
        _log('[LNS] skip day: date invalide (${day.date})');
        continue;
      }

      for (final e in day.entries) {
        // Gère le format "09:15/30" en prenant la première partie
        String timeStr = e.time;
        if (timeStr.contains('/')) {
          timeStr = timeStr.split('/')[0]; // Prend "09:15" de "09:15/30"
        }

        final parts = timeStr.split(':');
        if (parts.length != 2) {
          _log('[LNS] skip entry: heure invalide ${e.time}');
          continue;
        }
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h == null || m == null) {
          _log('[LNS] skip entry: parsing impossible ${e.time}');
          continue;
        }

        final dt = DateTime(baseDate.year, baseDate.month, baseDate.day, h, m);
        if (!dt.isAfter(now)) {
          _log('[LNS] skip past event "${e.title}" at $dt');
          continue; // ne pas planifier le passé
        }
        final tzDate = tz.TZDateTime.from(dt, tz.local);

        final title = '⏰ ${e.time} · ${e.title}';
        final place = (e.place ?? '').trim();
        final notes = (e.notes ?? '').trim();
        final body = [
          if (place.isNotEmpty) '📍 $place',
          if (notes.isNotEmpty) '✍️ $notes',
        ].join('\n');

        try {
          await _plugin.zonedSchedule(
            id++,
            title,
            body.isEmpty ? 'Guide MSM' : body,
            tzDate,
            _details(bigText: body.isEmpty ? title : '$title\n\n$body'),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'programme',
          );
          _log('[LNS] scheduled id=${id - 1} at=$tzDate title=$title');
        } catch (e) {
          _log('[LNS] schedule error for $title at $tzDate: $e');
        }
      }
    }
    _log('[LNS] scheduling complete');
  }

  static Future<bool> showDemoNow() async {
    _log('[LNS] ========================================');
    _log('[LNS] demo request (ready=$_ready)');
    _log('[LNS] ========================================');

    if (!_ready) {
      _log('[LNS] demo skipped: plugin not ready');
      await _logCurrentPermissions();
      return false;
    }

    await _logCurrentPermissions();

    const title = '🔔 Démo notifications';
    const body = 'Exemple de rappel élégant du programme';

    _log('[LNS] About to call _plugin.show()...');

    try {
      await _plugin.show(
        9999,
        title,
        body,
        _details(bigText: '$title\n\n$body'),
        payload: 'demo',
      );
      _log('[LNS] ✅ demo notification shown successfully (ready=$_ready)');
      return true;
    } catch (e) {
      _log('[LNS] ❌ demo notification error: $e');
      _log('[LNS] Error type: ${e.runtimeType}');
      return false;
    }
  }
}
