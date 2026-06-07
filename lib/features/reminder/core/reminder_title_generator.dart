import 'dart:math';

class ReminderTitleGenerator {
  static const List<String> _titles = [
    "It's Workout Time! 🏋️",
    "Let's Get After It! 🔥",
    "Time to Build! 💪",
    "No Excuses Today! ⚡",
    "Your Future Self is Watching 👀",
    "Rise & Grind! 🌅",
    "Consistency Builds Champions 🏆",
    "You Planned This. Now Show Up. 🎯",
    "Gains Don't Wait ⏱️",
    "One Session at a Time 🧱",
    "Sunil Bhai is Waiting 😤",
    "Better Than Yesterday 📈",
    "Move. Sweat. Repeat. 🔄",
    "Another Rep in the Bank 💰",
    "The Iron Doesn't Lie 🪨",
  ];

  static final Random _random = Random();

  static String random([Random? random]) {
    final r = random ?? _random;
    return _titles[r.nextInt(_titles.length)];
  }

  static int get titlesCount => _titles.length;
}
