import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class _InjectorScreenState extends State<InjectorScreen> with SingleTickerProviderStateMixin {
  bool _isInjecting = false;
  bool _showScam = false;
  bool _isProtected = false;

  late AnimationController _progressController;
  
  final ValueNotifier<List<String>> _logsNotifier = ValueNotifier([]);
  Timer? _logTimer;
  final Random _random = Random();

  final List<String> _realisticLogs = [
    '[System] Initializing injection engine...',
    '[Memory] Searching for PUBG Mobile process...',
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
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    )..addListener(() {
        if (_progressController.isCompleted) {
          _finishScam();
        }
      });
    
    // Включаем защиту от записи экрана при запуске
    _enableScreenProtection();
  }

  void _enableScreenProtection() {
    // Защита от скриншотов и записи экрана
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    
    // Защита от записи экрана через платформенные методы
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS: Используем безопасный флаг
      // Это предотвращает запись экрана, делая его черным при записи
      const MethodChannel('screen_protection')
          .invokeMethod('enableProtection');
    }
    
    _isProtected = true;
  }

  void _disableScreenProtection() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      const MethodChannel('screen_protection')
          .invokeMethod('disableProtection');
    }
    _isProtected = false;
  }

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _showScam = false;
    });
    
    // Включаем защиту экрана
    _enableScreenProtection();
    
    _logsNotifier.value = [];
    _progressController.forward(from: 0.0);

    int tickCount = 0;

    _logTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      tickCount++;
      List<String> currentLogs = List.from(_logsNotifier.value);

      if (tickCount < 180) {
        if (tickCount % 30 == 0) {
          int realisticIndex = (tickCount ~/ 30) - 1;
          if (realisticIndex < _realisticLogs.length) {
            currentLogs.insert(0, _realisticLogs[realisticIndex]);
          }
        }
      } else {
        for (int i = 0; i < 80; i++) {
          currentLogs.insert(0, _garbageLogs[_random.nextInt(_garbageLogs.length)]);
        }
      }

      if (currentLogs.length > 150) {
        currentLogs = currentLogs.sublist(0, 150);
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

    // Через 3 секунды после скама делаем respring
    Future.delayed(const Duration(seconds: 3), () {
      _performRespring();
    });
  }

  void _performRespring() {
    // Отключаем защиту экрана перед respring
    _disableScreenProtection();
    
    // Эффект вспышки
    _showFlashEffect();
    
    // Выполняем respring
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // iOS respring через приватные методы
      const MethodChannel('respring_channel').invokeMethod('respring');
    } else {
      // Android альтернатива - перезапуск приложения
      _restartApp();
    }
  }

  void _showFlashEffect() {
    // Визуальный эффект вспышки
    setState(() {
      // Добавляем белый слой поверх всего
    });
    
    // Создаем вспышку
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.white,
        opacity: const AlwaysStoppedAnimation(1.0),
        duration: const Duration(milliseconds: 100),
      ),
    );
    
    overlay.insert(entry);
    
    // Убираем вспышку через 100ms
    Future.delayed(const Duration(milliseconds: 100), () {
      entry.remove();
    });
  }

  void _restartApp() {
    // Для Android - перезапуск через системный метод
    final MethodChannel('restart_channel').invokeMethod('restartApp');
    
    // Запасной вариант - выход из приложения
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _progressController.dispose();
    _logsNotifier.dispose();
    _disableScreenProtection();
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

                  if (!_isInjecting && !_showScam)
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
                      }
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
                                final isGarbage = logs.length > 10;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(
                                    logs[index],
                                    style: TextStyle(
                                      fontSize: isGarbage ? 8 : 11,
                                      color: isGarbage ? Colors.grey[600] : Colors.grey[300],
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

          // Экран СКАМА с защитой от записи
          if (_showScam)
            Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
              // Защита от скриншотов через Flutter
              child: RepaintBoundary(
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
                      SizedBox(height: 40),
                      Text(
                        '📱 SCREEN RECORDING BLOCKED',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Courier',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
