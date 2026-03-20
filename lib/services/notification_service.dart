import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

// ────────────────────────────────────────────────────────────
//  pubspec.yaml 에 추가:
//    dependencies:
//      flutter_local_notifications: ^17.2.2
//      timezone: ^0.9.4
//
//  Android: android/app/src/main/AndroidManifest.xml 에 추가
//    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
//    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
//    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
//    <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
//      <intent-filter>
//        <action android:name="android.intent.action.BOOT_COMPLETED"/>
//      </intent-filter>
//    </receiver>
//
//  iOS: AppDelegate.swift 에서 UNUserNotificationCenter.current().delegate 설정 필요
// ────────────────────────────────────────────────────────────

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const int _dailyVerseId  = 0;
  static const int _prayerId      = 1;

  // ── 초기화 (main.dart 에서 호출) ─────────────────────
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );
  }

  // ── 권한 요청 ─────────────────────────────────────
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  // ── 오늘의 말씀 알림 예약 ─────────────────────────
  Future<void> scheduleDailyVerse(TimeOfDay time) async {
    await _plugin.cancel(_dailyVerseId);
    await _plugin.zonedSchedule(
      _dailyVerseId,
      '오늘의 말씀 📖',
      '말씀으로 하루를 시작하세요',
      _nextInstanceOf(time),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_verse',
          '오늘의 말씀',
          channelDescription: '매일 말씀 알림',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );
  }

  // ── 기도 알림 예약 ────────────────────────────────
  Future<void> schedulePrayer(TimeOfDay time) async {
    await _plugin.cancel(_prayerId);
    await _plugin.zonedSchedule(
      _prayerId,
      '기도 시간 🙏',
      '잠시 멈추고 기도하는 시간을 가져보세요',
      _nextInstanceOf(time),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminder',
          '기도 알림',
          channelDescription: '기도 시간 알림',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );
  }

  // ── 알림 취소 ─────────────────────────────────────
  Future<void> cancelDailyVerse() => _plugin.cancel(_dailyVerseId);
  Future<void> cancelPrayer()     => _plugin.cancel(_prayerId);

  // ── 다음 알림 시각 계산 ───────────────────────────
  tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day,
      time.hour, time.minute,
    );
    // 이미 지난 시각이면 내일로
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}