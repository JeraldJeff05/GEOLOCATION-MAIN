import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _ticker = Ticker((_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm:ss a').format(_currentTime);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine screen size categories
        bool isSmallScreen =
            constraints.maxWidth < 600 || constraints.maxHeight < 400;

        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: isSmallScreen ? 20 : 25,
              ),
              const SizedBox(width: 8),
              Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 20 : 25,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 3,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
