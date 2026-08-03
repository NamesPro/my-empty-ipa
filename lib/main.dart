import 'dart:async';
import 'dart:math';
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

// Используем SingleTickerProviderStateMixin для AnimationController
class _InjectorScreenState extends State<InjectorScreen> with SingleTickerProviderStateMixin {
  bool _isInjecting = false;
  bool _showScam = false;

  late AnimationController _progressController;
  
  // ValueNotifier позволяет обновлять только список логов, не перерисовывая весь экран
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
    // Ровно 5 минут (300 секунд) на весь процесс
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 5),
    )..addListener(() {
        if (_progressController.isCompleted) {
          _finishScam();
        }
      });
  }

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _showScam = false;
    });
    
    _logsNotifier.value = [];
    _progressController.forward(from: 0.0);

    int tickCount = 0;

    // Таймер работает на частоте ~60 FPS (16 мс)
    _logTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      tickCount++;
      List<String> currentLogs = List.from(_logsNotifier.value);

      // Первые 3 секунды (примерно 180 тиков) выводим реалистичные логи
      if (tickCount < 180) {
        if (tickCount % 30 == 0) { // Каждые полсекунды
          int realisticIndex = (tickCount ~/ 30) - 1;
          if (realisticIndex < _realisticLogs.length) {
            // Добавляем в НАЧАЛО списка (так как список перевернут)
            currentLogs.insert(0, _realisticLogs[realisticIndex]);
          }
        }
      } else {
        // НАЧИНАЕТСЯ БЕЗУМИЕ: 80 строк за ОДИН кадр (около 5000 строк в секунду)
        for (int i = 0; i < 80; i++) {
          currentLogs.insert(0, _garbageLogs[_random.nextInt(_garbageLogs.length)]);
        }
      }

      // ОПТИМИЗАЦИЯ: Удерживаем в памяти только последние 150 строк.
      // Это спасет приложение от вылета из-за нехватки оперативной памяти.
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
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    _progressController.dispose();
    _logsNotifier.dispose();
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
                    // Используем AnimatedBuilder для плавной отрисовки прогресса
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
                        // ValueListenableBuilder обновляет только список логов
                        child: ValueListenableBuilder<List<String>>(
                          valueListenable: _logsNotifier,
                          builder: (context, logs, child) {
                            return ListView.builder(
                              reverse: true, // КЛЮЧЕВАЯ ОПТИМИЗАЦИЯ: список строится снизу вверх
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                // Поскольку список перевернут, index 0 - это последняя добавленная строка
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

          // Экран СКАМА
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
