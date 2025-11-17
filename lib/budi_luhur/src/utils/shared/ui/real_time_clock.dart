import 'dart:async';

import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart';

class RealTimeClock extends StatefulWidget {
  final TextStyle? style;
  final ValueChanged<DateTime>? onTick;

  const RealTimeClock({super.key, this.style, this.onTick});

  @override
  State<RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock>
    with WidgetsBindingObserver {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isActive) return;
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });

      if (widget.onTick != null) widget.onTick!(_now);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _isActive = false;
    } else if (state == AppLifecycleState.resumed) {
      _isActive = true;
      if (mounted) {
        setState(() => _now = DateTime.now());
        if (widget.onTick != null) widget.onTick!(_now);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(Utils.formatClock(_now), style: widget.style);
  }
}
