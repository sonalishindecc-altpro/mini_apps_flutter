import 'package:flutter/material.dart';

class StopwatchApp extends StatefulWidget {
  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  late Stopwatch _stopwatch;
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _ticker = Ticker((_) {
      setState(() {
        _elapsed = _stopwatch.elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}:${(d.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stopwatch")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_formatTime(_elapsed), style: TextStyle(fontSize: 48)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _stopwatch.start,
                  child: Text("Start"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopwatch.stop,
                  child: Text("Stop"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _stopwatch.reset();
                    setState(() {
                      _elapsed = Duration.zero;
                    });
                  },
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper ticker class
class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _sw;
  late final Duration _interval;
  bool _running = false;

  Ticker(this.onTick, {Duration interval = const Duration(milliseconds: 100)}) {
    _sw = Stopwatch();
    _interval = interval;
  }

  void start() {
    _running = true;
    _sw.start();
    _tick();
  }

  void _tick() async {
    while (_running) {
      await Future.delayed(_interval);
      onTick(_sw.elapsed);
    }
  }

  void stop() {
    _running = false;
    _sw.stop();
  }

  void dispose() {
    _running = false;
  }
}
