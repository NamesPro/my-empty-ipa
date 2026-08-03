import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Активация системной защиты от скриншотов и записи экрана
  final noScreenshot = NoScreenshot.instance;
  await noScreenshot.screenshotOff();

  runApp(const MyApp());
}

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

class _InjectorScreenState extends State<InjectorScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool _isInjecting = false;
  bool _showScam = false;
  bool _showFakeError = false;
  
  // Флаг, чтобы ошибка вылазила только один раз за сессию
  bool _hasErroredBefore = false;

  late AnimationController _progressController;
  final ValueNotifier<List<String>> _logsNotifier = ValueNotifier([]);
  Timer? _logTimer;
  final Random _random = Random();

  final List<String> _realisticLogs = [
    '[System] Initializing injection engine...',
    '[Memory] Searching for target process...',
    '[Memory] Process found!',
    '[Memory] Allocating payload buffer (2.4 MB)...',
    '[Memory] Bypassing anti-cheat...',
    '[Memory] Anti-cheat bypassed!',
  ];

  final List<String> _garbageLogs = [
    '[DYLIB] Loading libinject.dylib...',
    '[DYLIB] Resolving symbols...',
    '[DYLIB] Entry point found!',
    '[DYLIB] Bypassing PAC...',
    '[DYLIB] KPP bypassed!',
    '[DYLIB] Disabling watchdog...',
    '[DYLIB] Overwriting pointers...',
    '[DYLIB] Kernel exploit triggered!',
    '[DYLIB] Root acquired!',
    '[DYLIB] Mounting RW...',
    '[DYLIB] Filesystem mounted!',
    '[DYLIB] SpringBoard injected!',
    '[DYLIB] Respring complete!',
    '[DYLIB] AMFI bypassed!',
    '[DYLIB] Sandbox escaped!',
    '[DYLIB] Kernel extension loaded!',
    '[DYLIB] System calls overridden!',
    '[DYLIB] Process hidden!',
    '[DYLIB] SSL bypassed!',
    '[DYLIB] Traffic decrypted!',
    '[DYLIB] Game injected!',
    '[DYLIB] ESP activated!',
    '[DYLIB] Aimbot activated!',
    '[DYLIB] Traces cleaned!',
    '[DYLIB] Payload written!',
    '[DYLIB] Exploit triggered!',
    '[DYLIB] Signature check bypassed!',
    '[DYLIB] Hidden from lsof!',
    '[DYLIB] Codesign bypassed!',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Таймер на 10 минут
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 10),
    )..addListener(() {
        // Ошибка сработает ровно 1 раз на 5-й минуте (50%), дальше путь свободен к скаму
        if (_progressController.value >= 0.5 && !_hasErroredBefore) {
          _triggerFakeError();
        } else if (_progressController.isCompleted) {
          _finishScam();
        }
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _logTimer?.cancel();
    _progressController.dispose();
    _logsNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (_isInjecting && !_showFakeError) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
        _progressController.stop();
        _logTimer?.cancel();
      } else if (state == AppLifecycleState.resumed) {
        _progressController.forward();
        _startLogLoop();
      }
    }
  }

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _showScam = false;
      _showFakeError = false;
    });

    _logsNotifier.value = [];
    _progressController.forward(from: _progressController.value);
    _startLogLoop();
  }

  void _triggerFakeError() {
    _progressController.stop();
    _logTimer?.cancel();
    setState(() {
      _isInjecting = false;
      _hasErroredBefore = true; // Запоминаем, что ошибка уже была
      _showFakeError = true;
    });
  }

  void _restartAfterError() {
    setState(() {
      _showFakeError = false;
    });
    // Продолжаем движение прогресса с того же места или с нуля (тут с текущего или с 0.5)
    _progressController.forward();
    _startInjection();
  }

  void _startLogLoop() {
    _logTimer?.cancel();
    // Ускоренная генерация логов (каждые 15 миллисекунд)
    _logTimer = Timer.periodic(const Duration(milliseconds: 15), (timer) {
      List<String> currentLogs = List.from(_logsNotifier.value);

      // Выбрасываем сразу пачку строк для бешеной скорости
      for (int i = 0; i < 15; i++) {
        currentLogs.insert(0, _garbageLogs[_random.nextInt(_garbageLogs.length)]);
      }

      if (currentLogs.length > 250) {
        currentLogs = currentLogs.sublist(0, 250);
      }

      _logsNotifier.value = currentLogs;
    });
  }

  void _finishScam() {
    _logTimer?.cancel();
    setState(() {
      _isInjecting = false;
      _showScam = true;
    });
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

                  if (!_isInjecting && !_showScam && !_showFakeError)
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

                  // Экран фейковой ошибки
                  if (_showFakeError) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: Colors.redAccent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '[CRITICAL ERROR]',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Offset mismatch at 0x7FFF5FBFF848.\nMemory protection triggered.\nInjection aborted, restart required.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontFamily: 'Courier',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _restartAfterError,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'RESTART INJECTION',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_isInjecting) ...[
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 280,
                              child: LinearProgressIndicator(
                                value: _progressController.value,
                                backgroundColor: Colors.grey[800],
                                color: Colors.white,
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${(_progressController.value * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ValueListenableBuilder<List<String>>(
                          valueListenable: _logsNotifier,
                          builder: (context, logs, child) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    logs[index],
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey[400],
                                      fontFamily: 'Courier',
                                    ),
                                  ),
                                );
                              },
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ТЫ ЗАСКАМЛЕН',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        color: Colors.redAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'YOU GOT SCAMMED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Courier',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
