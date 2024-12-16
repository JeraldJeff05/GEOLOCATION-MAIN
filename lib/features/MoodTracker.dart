import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MoodTracker extends StatefulWidget {
  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  final List<String> moods = ["😄", "😐", "😞"]; // Emojis representing moods
  String? selectedMood;
  List<String> moodHistory = [];
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String interpretationMessage = ""; // Message for mood interpretation

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  // Load mood history from shared preferences
  Future<void> _loadMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      moodHistory = prefs.getStringList(currentDate) ?? [];
      _updateInterpretationMessage();
    });
  }

  // Save the selected mood to shared preferences
  Future<void> _saveMood(String mood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Limit mood history to 5 items for the current day
    if (moodHistory.length < 5) {
      setState(() {
        moodHistory.add(mood); // Add the new mood
        _updateInterpretationMessage(); // Update the message
      });
      await prefs.setStringList(currentDate, moodHistory);
    }
  }

  // Update the interpretation message based on mood history
  void _updateInterpretationMessage() {
    if (moodHistory.length == 5) {
      int happyCount = moodHistory.where((mood) => mood == "😄").length;
      int neutralCount = moodHistory.where((mood) => mood == "😐").length;
      int sadCount = moodHistory.where((mood) => mood == "😞").length;

      if (happyCount > neutralCount && happyCount > sadCount) {
        interpretationMessage = "You're having a cheerful day! 🌟";
      } else if (sadCount > happyCount && sadCount > neutralCount) {
        interpretationMessage = "It's been a tough day. Take some rest. 🛌";
      } else if (neutralCount > happyCount && neutralCount > sadCount) {
        interpretationMessage = "You're feeling neutral today. Keep going! ⚖️";
      } else if (happyCount == 0 && sadCount == 0) {
        interpretationMessage =
        "You're in a calm and balanced state. Well done! ✨";
      } else if (happyCount == 1 && sadCount == 4) {
        interpretationMessage =
        "It seems like you're having a tough time today. Hang in there! 💪";
      } else if (neutralCount == 2 && happyCount == 2 && sadCount == 1) {
        interpretationMessage =
        "Your mood is all over the place today. Take it one step at a time. 🛤️";
      } else if (happyCount == 5) {
        interpretationMessage = "You're on cloud nine! What a joyful day! ☁️💖";
      } else if (sadCount == 5) {
        interpretationMessage =
        "Today might feel like a challenge. Reach out if you need support. 🤗";
      } else if (neutralCount == 5) {
        interpretationMessage =
        "A steady day, neither good nor bad. It's okay to feel this way. ⚖️";
      } else if (happyCount == 4 && sadCount == 1) {
        interpretationMessage =
        "You're mostly in a good mood today! Keep that positivity flowing. ✨";
      } else if (sadCount == 4 && neutralCount == 1) {
        interpretationMessage =
        "It seems like you're struggling, but there's a spark of hope today. 🌱";
      } else if (neutralCount == 3 && happyCount == 2) {
        interpretationMessage =
        "You're mostly calm, but you're also feeling a bit positive. Great balance! ⚖️";
      } else if (happyCount == 3 && sadCount == 2) {
        interpretationMessage =
        "A mix of happiness and some difficulties. You're handling it well. 🌟";
      } else if (sadCount == 3 && neutralCount == 2) {
        interpretationMessage =
        "It looks like you're having a rough time, but don't forget to take breaks! 🧘‍♀️";
      } else if (happyCount == 2 && sadCount == 3) {
        interpretationMessage =
        "Not every day is easy, but you're finding moments of joy! 🌻";
      } else {
        interpretationMessage =
        "Your day is a mix of emotions. Balance is key! 💡";
      }
    } else {
      interpretationMessage = "";
    }
  }

  // Handle mood selection
  void _onMoodSelected(String mood) {
    if (moodHistory.length < 5) {
      setState(() {
        selectedMood = mood;
      });
      _saveMood(mood);
    } else {
      // Show a message if the limit is reached
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have reached the limit of 5 moods for today."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "How do you feel today?",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: moods.map((mood) {
                return GestureDetector(
                  onTap: () => _onMoodSelected(mood),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      mood,
                      style: const TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            if (selectedMood != null)
              Text(
                "You selected: $selectedMood",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            const SizedBox(height: 10),
            Text(
              "Mood History:",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: moodHistory.map((mood) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    mood,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (interpretationMessage.isNotEmpty)
              Text(
                interpretationMessage,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
