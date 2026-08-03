import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Void Injector',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: const InjectorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InjectorScreen extends StatefulWidget {
  const InjectorScreen({super.key});

  @override
  State<InjectorScreen> createState() => _InjectorScreenState();
}

class _InjectorScreenState extends State<InjectorScreen> {
  bool _isInjecting = false;
  double _progress = 0.0;
  bool _showScam = false;
  List<String> _logLines = [];
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  // Реалистичные строки для первых 5 секунд
  final List<String> _realisticLogs = [
    '[System] Initializing injection engine...',
    '[Memory] Searching for PUBG Mobile process...',
    '[Memory] Process found!',
    '[Memory] Allocating payload buffer (2.4 MB)...',
    '[Memory] Bypassing anti-cheat...',
    '[Memory] Anti-cheat bypassed!',
  ];

  // ОГРОМНЫЙ массив мусора (будет повторяться)
  final List<String> _garbageLogs = [
    '[DYLIB] Loading libinject.dylib...',
    '[DYLIB] Resolving symbols...',
    '[DYLIB] Entry point found!',
    '[DYLIB] Bypassing PAC...',
    '[DYLIB] PAC bypassed!',
    '[DYLIB] KPP bypass...',
    '[DYLIB] KPP bypassed!',
    '[DYLIB] Disabling watchdog...',
    '[DYLIB] Watchdog disabled!',
    '[DYLIB] Overwriting pointers...',
    '[DYLIB] Pointers overwritten!',
    '[DYLIB] Kernel exploit...',
    '[DYLIB] Kernel exploit triggered!',
    '[DYLIB] Root privileges...',
    '[DYLIB] Root acquired!',
    '[DYLIB] Mounting RW...',
    '[DYLIB] Filesystem mounted!',
    '[DYLIB] SpringBoard inject...',
    '[DYLIB] SpringBoard injected!',
    '[DYLIB] Respring...',
    '[DYLIB] Respring complete!',
    '[DYLIB] AMFI bypass...',
    '[DYLIB] AMFI bypassed!',
    '[DYLIB] Sandbox escape...',
    '[DYLIB] Sandbox escaped!',
    '[DYLIB] Kernel extension...',
    '[DYLIB] Kernel extension loaded!',
    '[DYLIB] System calls override...',
    '[DYLIB] System calls overridden!',
    '[DYLIB] Hide process...',
    '[DYLIB] Process hidden!',
    '[DYLIB] SSL bypass...',
    '[DYLIB] SSL bypassed!',
    '[DYLIB] Decrypt traffic...',
    '[DYLIB] Traffic decrypted!',
    '[DYLIB] Game inject...',
    '[DYLIB] Game injected!',
    '[DYLIB] Hook render...',
    '[DYLIB] ESP activated!',
    '[DYLIB] Aimbot activated!',
    '[DYLIB] Clean traces...',
    '[DYLIB] Traces cleaned!',
    '[DYLIB] Writing payload...',
    '[DYLIB] Payload written!',
    '[DYLIB] Triggering exploit...',
    '[DYLIB] Exploit triggered!',
    '[DYLIB] Bypassing signature check...',
    '[DYLIB] Signature check bypassed!',
    '[DYLIB] Loading kernel module...',
    '[DYLIB] Kernel module loaded!',
    '[DYLIB] Overriding syscalls...',
    '[DYLIB] Syscalls overridden!',
    '[DYLIB] Hiding from lsof...',
    '[DYLIB] Hidden from lsof!',
    '[DYLIB] Bypassing codesign...',
    '[DYLIB] Codesign bypassed!',
    '[DYLIB] Injecting into SpringBoard...',
    '[DYLIB] SpringBoard injected!',
    '[DYLIB] Respringing...',
    '[DYLIB] Respring complete!',
    '[DYLIB] All done!',
  ];

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _progress = 0.0;
      _showScam = false;
      _logLines = [];
    });

    int logIndex = 0;
    int garbageIndex = 0;
    const int totalSeconds = 300; // 5 минут
    int secondsElapsed = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        secondsElapsed++;
        _progress = (secondsElapsed / totalSeconds) * 100;
        if (_progress >= 100) {
          _progress = 100;
          timer.cancel();
          _showScam = true;
          return;
        }

        // Первые 5 секунд (250 тиков по 20 мс = 5 секунд)
        if (secondsElapsed <= 250) {
          if (logIndex < _realisticLogs.length && secondsElapsed % 10 == 0) {
            _logLines.add(_realisticLogs[logIndex]);
            logIndex++;
          }
        } else {
          // Мусор — ОЧЕНЬ БЫСТРО (по 20-30 строк за раз)
          if (garbageIndex < _garbageLogs.length) {
            int count = 25 + (garbageIndex % 10); // от 25 до 34 строк за раз
            for (int i = 0; i < count && garbageIndex < _garbageLogs.length; i++) {
              _logLines.add(_garbageLogs[garbageIndex]);
              garbageIndex++;
            }
          } else {
            garbageIndex = 0; // повторяем
          }
        }

        // Автоматический скролл вниз
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeOut,
            );
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Void Injector',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontFamily: 'Courier',
                    ),
                  ),
                  const SizedBox(height: 50),

                  if (!_isInjecting)
                    ElevatedButton(
                      onPressed: _startInjection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'INJECT CHEAT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),

                  if (_isInjecting) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280,
                      child: LinearProgressIndicator(
                        value: _progress / 100,
                        backgroundColor: Colors.grey[800],
                        color: Colors.white,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_progress.toInt()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Courier',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _logLines.length,
                          itemBuilder: (context, index) {
                            final isGarbage = index > 6;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                _logLines[index],
                                style: TextStyle(
                                  fontSize: isGarbage ? 8 : 11,
                                  color: isGarbage ? Colors.grey[500] : Colors.grey,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),
                ],
              ),
            ),
          ),

          if (_showScam)
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: Text(
                  'YOU GOT SCAMMED',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
