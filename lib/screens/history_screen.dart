import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/water_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake History')),
      body: Consumer<WaterService>(
        builder: (context, waterService, child) {
          final waterIntakes = waterService.waterIntakes.reversed.toList();

          // Prepare data for the chart (last 7 days)
          Map<String, double> dailyIntake = {};
          for (int i = 6; i >= 0; i--) {
            final date = DateTime.now().subtract(Duration(days: i));
            final formattedDate = DateFormat('MMM d').format(date);
            dailyIntake[formattedDate] = 0.0;
          }

          for (var intake in waterIntakes) {
            final formattedDate = DateFormat('MMM d').format(intake.timestamp);
            if (dailyIntake.containsKey(formattedDate)) {
              dailyIntake[formattedDate] =
                  dailyIntake[formattedDate]! + intake.amount;
            }
          }

          final List<BarChartGroupData> barGroups = [];
          int x = 0;
          dailyIntake.forEach((date, amount) {
            barGroups.add(
              BarChartGroupData(
                x: x,
                barRods: [
                  BarChartRodData(
                    toY: amount,
                    color: Theme.of(context).colorScheme.primary,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            );
            x++;
          });

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final isSmallScreen = screenWidth < 600;
              final isLargeScreen = screenWidth >= 1200;

              final horizontalPadding = isSmallScreen
                  ? 16.0
                  : isLargeScreen
                  ? 64.0
                  : 32.0;
              final maxWidth = isLargeScreen ? 1000.0 : double.infinity;
              final chartHeight = isSmallScreen
                  ? screenHeight * 0.3
                  : isLargeScreen
                  ? 350.0
                  : 300.0;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SizedBox(
                        height: chartHeight,
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      dailyIntake.keys.elementAt(value.toInt()),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: isSmallScreen ? 35 : 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}ml',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: waterIntakes.isEmpty
                        ? const Center(
                            child: Text('No water intake recorded yet.'),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            itemCount: waterIntakes.length,
                            itemBuilder: (context, index) {
                              final intake = waterIntakes[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isLargeScreen ? 0 : 0,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${intake.amount} ml',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    DateFormat(
                                      'MMM d, yyyy - hh:mm a',
                                    ).format(intake.timestamp),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
