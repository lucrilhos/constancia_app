import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum _Phase { focus, rest }

class FocusCycleScreen extends StatefulWidget {
  final String taskTitle;
  final int focusMinutes;
  final int restMinutes;

  const FocusCycleScreen({
    super.key,
    required this.taskTitle,
    this.focusMinutes = 1,
    this.restMinutes = 1,
  });

  @override
  State<FocusCycleScreen> createState() => _FocusCycleScreenState();
}

class _FocusCycleScreenState extends State<FocusCycleScreen> {
  late int _focusTotal;
  late int _restTotal;
  late int _remaining;
  _Phase _phase = _Phase.focus;
  int _completedCycles = 0;
  bool _dayValidated = false;
  Timer? _timer;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _focusTotal = widget.focusMinutes * 60;
    _restTotal = widget.restMinutes * 60;
    _remaining = _focusTotal;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining > 0) {
        setState(() => _remaining--);
        return;
      }
      setState(() {
        if (_phase == _Phase.focus) {
          _dayValidated = true;
          if (_restTotal > 0) {
            _phase = _Phase.rest;
            _remaining = _restTotal;
          } else {
            _completedCycles++;
            _remaining = _focusTotal;
          }
        } else {
          _completedCycles++;
          _phase = _Phase.focus;
          _remaining = _focusTotal;
        }
      });
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

  void _skipRest() {
    setState(() {
      _completedCycles++;
      _phase = _Phase.focus;
      _remaining = _focusTotal;
    });
  }

  void _endSession() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get _showingRest => _phase == _Phase.rest;
  bool get _hasRest => _restTotal > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _endSession,
        ),
        title: Text(_showingRest ? 'Descanso' : 'Foco'),
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
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                if (_dayValidated)
                  _Badge(
                    text: '✓ Dia validado',
                    color: AppColors.primary,
                  ),
                if (_completedCycles > 0)
                  _Badge(
                    text: '${_completedCycles + 1}º ciclo de foco',
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _hasRest
                  ? (_showingRest
                      ? [
                          _TimerRing(
                            size: 86,
                            progress: 1,
                            color: AppColors.primary,
                            label: '✓',
                            sublabel: 'Foco',
                            fontSize: 22,
                          ),
                          const SizedBox(width: 16),
                          _TimerRing(
                            size: 170,
                            progress: 1 - (_remaining / _restTotal),
                            color: AppColors.statusDesenvolvimento,
                            label: _format(_remaining),
                            sublabel: 'Descanso',
                            fontSize: 34,
                          ),
                        ]
                      : [
                          _TimerRing(
                            size: 170,
                            progress: 1 - (_remaining / _focusTotal),
                            color: AppColors.accentOrange,
                            label: _format(_remaining),
                            sublabel: 'Foco',
                            fontSize: 34,
                          ),
                          const SizedBox(width: 16),
                          _TimerRing(
                            size: 86,
                            progress: 0,
                            color: AppColors.statusDesenvolvimento,
                            label: _format(_restTotal),
                            sublabel: 'Descanso',
                            fontSize: 16,
                          ),
                        ])
                  : [
                      _TimerRing(
                        size: 220,
                        progress: 1 - (_remaining / _focusTotal),
                        color: AppColors.accentOrange,
                        label: _format(_remaining),
                        fontSize: 40,
                      ),
                    ],
            ),
            const SizedBox(height: 32),
            Text(
              _showingRest
                  ? 'Hora de descansar!'
                  : 'Um ciclo de foco concluído já valida o dia.',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _togglePause,
                icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                label: Text(_running ? 'Pausar' : 'Retomar'),
              ),
            ),
            const SizedBox(height: 12),
            if (_showingRest)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _skipRest,
                    child: const Text('Pular descanso'),
                  ),
                  const Text('·', style: TextStyle(color: AppColors.divider)),
                  TextButton(
                    onPressed: _endSession,
                    child: const Text('Encerrar sessão'),
                  ),
                ],
              )
            else
              TextButton(
                onPressed: _endSession,
                child: Text(
                  _dayValidated ? 'Encerrar sessão' : 'Desistir deste ciclo',
                  style: TextStyle(
                    color: _dayValidated
                        ? AppColors.textSecondary
                        : AppColors.statusParada,
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _TimerRing extends StatelessWidget {
  final double size;
  final double progress;
  final Color color;
  final String label;
  final String? sublabel;
  final double fontSize;

  const _TimerRing({
    required this.size,
    required this.progress,
    required this.color,
    required this.label,
    required this.fontSize,
    this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0, 1),
              strokeWidth: size > 120 ? 10 : 6,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              if (sublabel != null)
                Text(
                  sublabel!,
                  style: TextStyle(
                    fontSize: size > 120 ? 12 : 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
