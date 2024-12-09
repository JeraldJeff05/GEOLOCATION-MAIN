import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CorporateDashboard extends StatelessWidget {
  const CorporateDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Corporate Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Project Progress',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey[700],
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('70%', style: TextStyle(color: Colors.white)),
                  Text('Deadline: Dec 15',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
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
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Goal Achieved',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sales Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Use Expanded or SizedBox to take full width
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${group.x + 1}\n',
                        const TextStyle(color: Colors.white, fontSize: 5),
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
                          style: const TextStyle(color: Colors.white),
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
                              fontSize: 10, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 8, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(
                        toY: 10, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 6, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(
                        toY: 12, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 4, barRods: [
                    BarChartRodData(toY: 9, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 5, barRods: [
                    BarChartRodData(toY: 7, color: Colors.blueAccent, width: 15)
                  ]),
                  BarChartGroupData(x: 6, barRods: [
                    BarChartRodData(
                        toY: 11, color: Colors.blueAccent, width: 15)
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
