import 'dart:async';
import 'package:flutter/material.dart';
import '../data/task_completion.dart';
import '../theme/app_colors.dart';

class FocusCycleScreen extends StatefulWidget {
  final String taskTitle;
  final int focusMinutes;

  const FocusCycleScreen({
    super.key,
    required this.taskTitle,
    required this.focusMinutes,
  });

  @override
  State<FocusCycleScreen> createState() => _FocusCycleScreenState();
}

class _FocusCycleScreenState extends State<FocusCycleScreen> {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.focusMinutes * 1;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        TaskCompletion.markDone(widget.taskTitle);
        setState(() {});
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _togglePause() {
    setState(() => _running = !_running);
    if (_running) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _totalSeconds == 0 ? 0.0 : 1 - (_remainingSeconds / _totalSeconds);
    final finished = _remainingSeconds == 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Foco'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              widget.taskTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation(
                        finished ? AppColors.primary : AppColors.accentOrange,
                      ),
                    ),
                  ),
                  Text(
                    finished ? '✓' : _formatted,
                    style: TextStyle(
                      fontSize: finished ? 56 : 40,
                      fontWeight: FontWeight.w800,
                      color:
                          finished ? AppColors.primary : AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              finished
                  ? '(✓) Dia validado — ciclo concluído hoje.'
                  : 'Um ciclo concluído já valida o dia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: finished ? AppColors.primary : AppColors.textSecondary,
                fontWeight: finished ? FontWeight.w700 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            if (!finished) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _togglePause,
                  icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                  label: Text(_running ? 'Pausar' : 'Retomar'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Desistir deste ciclo',
                  style: TextStyle(color: AppColors.statusParada),
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar pro card'),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
