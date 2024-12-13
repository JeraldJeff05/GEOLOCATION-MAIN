import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animations/animations.dart';

class CorporateDashboard extends StatefulWidget {
  const CorporateDashboard({Key? key}) : super(key: key);

  @override
  _CorporateDashboardState createState() => _CorporateDashboardState();
}

class _CorporateDashboardState extends State<CorporateDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black87,
                Colors.blueGrey.shade900,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Corporate Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Icon(
                          Icons.analytics_outlined,
                          color: Colors.blueAccent.withOpacity(value),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Project Progress with Animated Progress Indicator
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                tween: Tween(begin: 0, end: 0.7),
                builder: (context, progress, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Project Progress',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[800],
                        color: Colors.blueAccent,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(progress * 100).toInt()}%',
                              style: const TextStyle(color: Colors.white)),
                          const Text('Deadline: Dec 15',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              // Animated Goal Indicator
              Expanded(
                child: Center(
                  child: OpenContainer(
                    closedBuilder: (context, action) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.blueAccent.shade100,
                            Colors.blueAccent.shade700,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '45%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Goal Achieved',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    openBuilder: (context, action) => Container(
                      color: Colors.blueGrey.shade900,
                      child: const Center(
                        child: Text(
                          'Detailed Goal Breakdown',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sales Analysis with Modern Chart

              const Text(
                'Sales Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${group.x + 1}\n',
                            const TextStyle(color: Colors.white, fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sales: ${rod.toY.toStringAsFixed(1)}k',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.1,
                              ),
                            );
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              '${value.toInt()}k',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                letterSpacing: 1.1,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [
                        BarChartRodData(
                          toY: 8,
                          color: Colors.blueAccent.shade200,
                          width: 15,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            color: Colors.blueGrey.shade800,
                          ),
                        )
                      ]),
                      BarChartGroupData(x: 1, barRods: [
                        BarChartRodData(
                          toY: 10,
                          color: Colors.blueAccent.shade200,
                          width: 15,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            color: Colors.blueGrey.shade800,
                          ),
                        )
                      ]),

                      BarChartGroupData(x: 2, barRods: [
                        BarChartRodData(
                            toY: 6, color: Colors.blueAccent, width: 15)
                      ]),
                      BarChartGroupData(x: 3, barRods: [
                        BarChartRodData(
                            toY: 12, color: Colors.blueAccent, width: 15)
                      ]),
                      BarChartGroupData(x: 4, barRods: [
                        BarChartRodData(
                            toY: 9, color: Colors.blueAccent, width: 15)
                      ]),
                      BarChartGroupData(x: 5, barRods: [
                        BarChartRodData(
                            toY: 7, color: Colors.blueAccent, width: 15)
                      ]),
                      BarChartGroupData(x: 6, barRods: [
                        BarChartRodData(
                            toY: 11, color: Colors.blueAccent, width: 15)
                      ]),

                      // ... (rest of the bar groups remain the same)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
