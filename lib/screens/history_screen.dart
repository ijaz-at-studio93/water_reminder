import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/water_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake History')),
      body: Consumer<WaterService>(
        builder: (context, waterService, child) {
          final waterIntakes = waterService.waterIntakes.reversed.toList();

          if (waterIntakes.isEmpty) {
            return const Center(child: Text('No water intake recorded yet.'));
          }

          return ListView.builder(
            itemCount: waterIntakes.length,
            itemBuilder: (context, index) {
              final intake = waterIntakes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${intake.amount} ml',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        DateFormat(
                          'MMM d, yyyy - hh:mm a',
                        ).format(intake.timestamp),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
