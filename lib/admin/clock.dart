import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late DateTime _currentTime;
  late List<PerformanceData> _performanceData;
  final Random _random = Random();
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Initialize time and performance data
    _currentTime = DateTime.now();
    _performanceData = _generateRandomData();

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        // Randomly update performance data
        _performanceData = _generateRandomData();
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer if it's active
    _timer?.cancel();

    // Stop the animation controller before disposing
    _animationController.stop();

    // Dispose of the animation controller
    _animationController.dispose();

    super.dispose();
  }

  // Generate random performance data with wave-like characteristics
  List<PerformanceData> _generateRandomData() {
    return List.generate(20, (index) {
      // Create a more wavy, smooth pattern
      double baseValue = 50 + sin(index * 0.5) * 20;
      double randomVariation = _random.nextDouble() * 10 - 5;
      return PerformanceData(
        time: DateTime.now().subtract(Duration(minutes: 20 - index)),
        value: baseValue + randomVariation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format time and date
    final String formattedTime = DateFormat('hh:mm:ss a').format(_currentTime);
    final String formattedDay = DateFormat('EEEE').format(_currentTime);
    final String formattedDate =
        DateFormat('MMM dd, yyyy').format(_currentTime);

    // Get screen width and height
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Determine responsive sizing
    bool isVerySmallScreen = screenWidth < 600;
    bool isNarrowScreen = screenWidth >= 600 && screenWidth < 1000;
    bool isWideScreen = screenWidth >= 1000;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth > 1430 ? 1430 : double.infinity,
            maxHeight:
                screenHeight * 0.9, // Limit height to 90% of screen height
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade800,
                Colors.blueAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen ? 8 : (isNarrowScreen ? 12 : 20),
            vertical: isVerySmallScreen ? 8 : (isNarrowScreen ? 10 : 15),
          ),
          margin: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row with Time and Location
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: isVerySmallScreen ? 16 : 25,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isVerySmallScreen ? 16 : 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$formattedDay, $formattedDate',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isVerySmallScreen ? 10 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Location Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white70,
                                  size: isVerySmallScreen ? 14 : 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'San Pablo City, Philippines HQ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: isVerySmallScreen ? 10 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Corporate Dashboard',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: isVerySmallScreen ? 8 : 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Animated Performance Graph
              const SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.minutes,
                            labelStyle: const TextStyle(color: Colors.white54),
                            axisLine: const AxisLine(color: Colors.white24),
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(
                              text: 'Performance',
                              textStyle: const TextStyle(color: Colors.white70),
                            ),
                            labelStyle: const TextStyle(color: Colors.white54),
                            axisLine: const AxisLine(color: Colors.white24),
                          ),
                          series: <CartesianSeries<PerformanceData, DateTime>>[
                            SplineAreaSeries<PerformanceData, DateTime>(
                              dataSource: _performanceData,
                              xValueMapper: (PerformanceData data, _) =>
                                  data.time,
                              yValueMapper: (PerformanceData data, _) =>
                                  data.value,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white
                                      .withOpacity(0.7 * _animation.value),
                                  Colors.white
                                      .withOpacity(0.2 * _animation.value),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderColor: Colors.white,
                              borderWidth: 2,
                            ),
                          ],
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            header: 'Performance',
                            canShowMarker: true,
                            format: 'point.x : point.y',
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Data model for performance tracking
class PerformanceData {
  final DateTime time;
  final double value;

  PerformanceData({required this.time, required this.value});
}
