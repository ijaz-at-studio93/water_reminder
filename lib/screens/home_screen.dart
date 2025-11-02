import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/services/settings_service.dart';
import 'package:water_reminder/services/water_service.dart';
import 'package:water_reminder/screens/history_screen.dart';
import 'package:water_reminder/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Reminder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer2<WaterService, SettingsService>(
        builder: (context, waterService, settingsService, child) {
          final dailyGoal = settingsService.userSettings.dailyGoal;
          final todayIntake = waterService.todayIntake;
          final progress = todayIntake / dailyGoal;

          _animationController.animateTo(progress);

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              final isSmallScreen = screenWidth < 600;
              final isMediumScreen = screenWidth >= 600 && screenWidth < 1200;
              final isLargeScreen = screenWidth >= 1200;

              final progressSize = isSmallScreen
                  ? screenWidth * 0.65
                  : isMediumScreen
                  ? 300.0
                  : 350.0;

              final buttonSpacing = isSmallScreen ? 8.0 : 16.0;
              final verticalSpacing = isSmallScreen ? 32.0 : 40.0;
              final buttonPadding = isSmallScreen
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                  : const EdgeInsets.symmetric(horizontal: 25, vertical: 15);

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen
                        ? 16.0
                        : isLargeScreen
                        ? 64.0
                        : 32.0,
                    vertical: isSmallScreen ? 16.0 : 32.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isLargeScreen ? 600 : double.infinity,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: progressSize,
                                  height: progressSize,
                                  child: CustomPaint(
                                    painter: WaterProgressPainter(
                                      progress: _animation.value,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.2),
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${todayIntake.toInt()} ml',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                            fontSize: isSmallScreen
                                                ? 36.0
                                                : 48.0,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    Text(
                                      'of ${dailyGoal.toInt()} ml',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontSize: isSmallScreen
                                                ? 16.0
                                                : 20.0,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: verticalSpacing),
                        isSmallScreen
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: buttonSpacing / 2,
                                          ),
                                          child: _buildWaterButton(
                                            context,
                                            waterService,
                                            200,
                                            buttonPadding,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: buttonSpacing / 2,
                                          ),
                                          child: _buildWaterButton(
                                            context,
                                            waterService,
                                            300,
                                            buttonPadding,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: buttonSpacing / 2,
                                          ),
                                          child: _buildWaterButton(
                                            context,
                                            waterService,
                                            500,
                                            buttonPadding,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showCustomAmountDialog(
                                          context,
                                          waterService,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      label: const Text('Custom Amount'),
                                      style: ElevatedButton.styleFrom(
                                        padding: buttonPadding,
                                        textStyle: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: waterService.waterIntakes.isEmpty
                                              ? null
                                              : () {
                                                  _showUndoConfirmationDialog(
                                                    context,
                                                    waterService,
                                                  );
                                                },
                                          icon: const Icon(Icons.undo),
                                          label: const Text('Undo'),
                                          style: OutlinedButton.styleFrom(
                                            padding: buttonPadding,
                                            textStyle: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: buttonSpacing),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: waterService.todayIntakes.isEmpty
                                              ? null
                                              : () {
                                                  _showResetConfirmationDialog(
                                                    context,
                                                    waterService,
                                                  );
                                                },
                                          icon: const Icon(Icons.refresh),
                                          label: const Text('Reset'),
                                          style: OutlinedButton.styleFrom(
                                            padding: buttonPadding,
                                            textStyle: Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildWaterButton(
                                        context,
                                        waterService,
                                        200,
                                        buttonPadding,
                                      ),
                                      _buildWaterButton(
                                        context,
                                        waterService,
                                        300,
                                        buttonPadding,
                                      ),
                                      _buildWaterButton(
                                        context,
                                        waterService,
                                        500,
                                        buttonPadding,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _showCustomAmountDialog(
                                        context,
                                        waterService,
                                      );
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Text('Custom Amount'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMediumScreen
                                            ? 40.0
                                            : 50.0,
                                        vertical: isMediumScreen ? 16.0 : 18.0,
                                      ),
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: waterService.waterIntakes.isEmpty
                                            ? null
                                            : () {
                                                _showUndoConfirmationDialog(
                                                  context,
                                                  waterService,
                                                );
                                              },
                                        icon: const Icon(Icons.undo),
                                        label: const Text('Undo'),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMediumScreen
                                                ? 30.0
                                                : 35.0,
                                            vertical: isMediumScreen ? 14.0 : 16.0,
                                          ),
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      OutlinedButton.icon(
                                        onPressed: waterService.todayIntakes.isEmpty
                                            ? null
                                            : () {
                                                _showResetConfirmationDialog(
                                                  context,
                                                  waterService,
                                                );
                                              },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Reset'),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMediumScreen
                                                ? 30.0
                                                : 35.0,
                                            vertical: isMediumScreen ? 14.0 : 16.0,
                                          ),
                                          textStyle: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWaterButton(
    BuildContext context,
    WaterService waterService,
    int amount,
    EdgeInsets padding,
  ) {
    return ElevatedButton(
      onPressed: () => waterService.addWaterIntake(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: padding,
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      child: Text('$amount ml'),
    );
  }

  void _showCustomAmountDialog(
    BuildContext context,
    WaterService waterService,
  ) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Custom Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount in ml'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  waterService.addWaterIntake(amount);
                  Navigator.pop(context);
                }
              },
              child: const Text('Log'),
            ),
          ],
        );
      },
    );
  }

  void _showUndoConfirmationDialog(
    BuildContext context,
    WaterService waterService,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Undo Last Entry'),
          content: const Text(
            'Are you sure you want to remove the last water intake entry?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                waterService.undoLastIntake();
                Navigator.pop(context);
              },
              child: const Text('Undo'),
            ),
          ],
        );
      },
    );
  }

  void _showResetConfirmationDialog(
    BuildContext context,
    WaterService waterService,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Today\'s Intake'),
          content: const Text(
            'Are you sure you want to reset all water intake entries for today? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                waterService.resetTodayIntake();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}

class WaterProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color foregroundColor;

  WaterProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width / 10;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Foreground arc
    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5 * 3.14159, // Start at the top
      2 * 3.14159 * progress, // Sweep angle
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant WaterProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.foregroundColor != foregroundColor;
  }
}
