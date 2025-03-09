import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'components/blast_effect.dart';
import 'components/glow_effects.dart';
import 'components/center_dot.dart';
import 'components/rotating_ring.dart';
import 'components/ambient_glow.dart';
import 'components/particle_effect.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _mainController;

  late Ticker _ticker;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  late AnimationController _syncEffectController;
  late Animation<double> _syncPulseAnimation;
  late Animation<Color?> _syncColorAnimation;

  final List<Map<String, dynamic>> _particles = [];
  final Random _random = Random();

  final List<String> _outerRingLetters = [
    'あ',
    'い',
    'う',
    'え',
    'お',
    'か',
    'き',
    'く',
    'け',
    'こ',
    'さ',
    'し',
    'す',
    'せ',
    'そ',
    'た',
    'ち',
    'つ',
    'て',
    'と',
    'な',
    'に',
    'ぬ',
    'ね',
    'の',
    'は',
    'ひ',
    'ふ',
    'へ',
    'ほ',
  ];

  final List<String> _middleRingLetters = [
    'ま',
    'み',
    'む',
    'め',
    'も',
    'や',
    'ゆ',
    'よ',
    'ら',
    'り',
    'る',
    'れ',
    'ろ',
    'わ',
    'を',
    'ん',
  ];

  final List<String> _innerRingLetters = [
    'ア',
    'イ',
    'ウ',
    'エ',
    'オ',
    'カ',
    'キ',
    'ク',
    'ケ',
    'コ',
  ];

  final List<String> _innermostRingLetters = [
    'サ',
    'シ',
    'ス',
    'セ',
    'ソ',
    'タ',
    'チ',
    'ツ',
  ];

  double _outerRingRotation = 0.0;
  double _middleRingRotation = 0.0;
  double _innerRingRotation = 0.0;
  double _innermostRingRotation = 0.0;

  double _outerRingSpeed = 1.2;
  double _middleRingSpeed = -1.5;
  double _innerRingSpeed = 1.8;
  double _innermostRingSpeed = 2.2;

  double _speedMultiplier = 1.0;

  bool _allRingsSameDirection = false;
  bool _isTransitioning = false;
  int? _syncDebounceTimer;
  int _stableStateCounter = 0;
  bool _lastDirectionState = false;

  late AnimationController _blastController;
  late Animation<double> _blastAnimation;
  bool _showBlast = false;

  double _outerRingOpacity = 1.0;
  double _middleRingOpacity = 0.6;
  double _innerRingOpacity = 0.4;
  double _innermostRingOpacity = 0.3;

  int? _outerRingTimerId;
  int? _middleRingTimerId;
  int? _innerRingTimerId;
  int? _innermostRingTimerId;

  final List<List<Offset>> _ringPositions = [[], [], [], []];

  Duration? _lastFrameTime;

  @override
  void initState() {
    super.initState();

    _precalculatePositions();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );

    _mainController.repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _glowAnimation = Tween<double>(begin: 0.05, end: 0.2).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _glowController.repeat(reverse: true);

    _syncEffectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _syncPulseAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(
        parent: _syncEffectController,
        curve: Curves.easeInOut,
      ),
    );

    _syncColorAnimation = ColorTween(
      begin: Colors.blue.withOpacity(0.8),
      end: Colors.purple.withOpacity(0.8),
    ).animate(_syncEffectController);

    _blastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _blastAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_blastController);

    _blastController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showBlast = false;
        });
      }
    });

    _initializeParticles();

    _ticker = createTicker(_onTick);
    _ticker.start();

    _scheduleOuterRingDirectionChange();
    _scheduleMiddleRingDirectionChange();
    _scheduleInnerRingDirectionChange();
    _scheduleInnermostRingDirectionChange();
  }

  void _precalculatePositions() {
    for (int i = 0; i < _outerRingLetters.length; i++) {
      final angle = 2 * pi * i / _outerRingLetters.length;
      final radius = 160.0;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      _ringPositions[0].add(Offset(x, y));
    }

    for (int i = 0; i < _middleRingLetters.length; i++) {
      final angle = 2 * pi * i / _middleRingLetters.length;
      final radius = 130.0;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      _ringPositions[1].add(Offset(x, y));
    }

    for (int i = 0; i < _innerRingLetters.length; i++) {
      final angle = 2 * pi * i / _innerRingLetters.length;
      final radius = 100.0;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      _ringPositions[2].add(Offset(x, y));
    }

    for (int i = 0; i < _innermostRingLetters.length; i++) {
      final angle = 2 * pi * i / _innermostRingLetters.length;
      final radius = 70.0;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      _ringPositions[3].add(Offset(x, y));
    }
  }

  void _initializeParticles() {
    for (int i = 0; i < 20; i++) {
      _particles.add({
        'angle': _random.nextDouble() * 2 * pi,
        'radius': 30.0 + _random.nextDouble() * 150,
        'speed': 0.2 + _random.nextDouble() * 0.8,
        'size': 2.0 + _random.nextDouble() * 4.0,
        'opacity': 0.3 + _random.nextDouble() * 0.7,
      });
    }
  }

  void _checkAllRingsSameDirection() {
    bool allPositive = _outerRingSpeed > 0 &&
        _middleRingSpeed > 0 &&
        _innerRingSpeed > 0 &&
        _innermostRingSpeed > 0;

    bool allNegative = _outerRingSpeed < 0 &&
        _middleRingSpeed < 0 &&
        _innerRingSpeed < 0 &&
        _innermostRingSpeed < 0;

    bool sameDirection = allPositive || allNegative;

    if (_isTransitioning) {
      return;
    }

    if (sameDirection != _lastDirectionState) {
      _stableStateCounter = 0;
      _lastDirectionState = sameDirection;
      return;
    } else {
      if (_stableStateCounter < 10) {
        _stableStateCounter++;
        return;
      }
    }

    if (sameDirection != _allRingsSameDirection && _stableStateCounter >= 10) {
      if (_syncDebounceTimer != null) {
        Future.microtask(() => _syncDebounceTimer = null);
      } else {
        _syncDebounceTimer =
            Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            bool currentAllPositive = _outerRingSpeed > 0 &&
                _middleRingSpeed > 0 &&
                _innerRingSpeed > 0 &&
                _innermostRingSpeed > 0;

            bool currentAllNegative = _outerRingSpeed < 0 &&
                _middleRingSpeed < 0 &&
                _innerRingSpeed < 0 &&
                _innermostRingSpeed < 0;

            bool currentSameDirection =
                currentAllPositive || currentAllNegative;

            if (currentSameDirection != _allRingsSameDirection &&
                currentSameDirection == sameDirection) {
              _isTransitioning = true;

              setState(() {
                _allRingsSameDirection = currentSameDirection;
              });

              if (currentSameDirection) {
                setState(() {
                  _showBlast = true;
                });
                _blastController.reset();

                Future.microtask(() {
                  if (mounted && _allRingsSameDirection) {
                    _blastController.forward();
                  } else {
                    setState(() {
                      _showBlast = false;
                    });
                  }
                });

                _syncEffectController.repeat(reverse: true);

                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && _allRingsSameDirection) {
                    setState(() {
                      _speedMultiplier = 2.5;
                    });

                    Future.delayed(const Duration(milliseconds: 200), () {
                      _isTransitioning = false;
                    });
                  }
                });
              } else {
                _syncEffectController.stop();

                setState(() {
                  _speedMultiplier = 1.0;
                  _showBlast = false;
                });

                Future.delayed(const Duration(milliseconds: 200), () {
                  _isTransitioning = false;
                });
              }
            }
          }
          _syncDebounceTimer = null;
        }).hashCode;
      }
    }
  }

  void _onTick(Duration elapsed) {
    if (_lastFrameTime == null) {
      _lastFrameTime = elapsed;
      return;
    }

    final delta = (elapsed - _lastFrameTime!).inMicroseconds /
        Duration.microsecondsPerSecond;
    _lastFrameTime = elapsed;

    if (mounted) {
      setState(() {
        _outerRingRotation += _outerRingSpeed * delta * 0.2 * _speedMultiplier;
        _middleRingRotation +=
            _middleRingSpeed * delta * 0.2 * _speedMultiplier;
        _innerRingRotation += _innerRingSpeed * delta * 0.2 * _speedMultiplier;
        _innermostRingRotation +=
            _innermostRingSpeed * delta * 0.2 * _speedMultiplier;

        if (_allRingsSameDirection) {
          for (var particle in _particles) {
            particle['angle'] += particle['speed'] * delta * 0.5;

            if (_random.nextDouble() < 0.01) {
              particle['radius'] = 30.0 + _random.nextDouble() * 150;
              particle['opacity'] = 0.3 + _random.nextDouble() * 0.7;
            }
          }
        }

        _checkAllRingsSameDirection();

        if (_showBlast && !_allRingsSameDirection) {
          _showBlast = false;
        }
      });
    }
  }

  void _scheduleOuterRingDirectionChange() {
    _outerRingTimerId = Future.delayed(const Duration(seconds: 7), () {
      if (!mounted) return;

      setState(() {
        _outerRingOpacity = 0.7;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _outerRingSpeed *= -1;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _outerRingOpacity = 1.0;
          });
        });
      });

      _scheduleOuterRingDirectionChange();
    }).hashCode;
  }

  void _scheduleMiddleRingDirectionChange() {
    _middleRingTimerId = Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      setState(() {
        _middleRingOpacity = 0.4;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _middleRingSpeed *= -1;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _middleRingOpacity = 0.6;
          });
        });
      });

      _scheduleMiddleRingDirectionChange();
    }).hashCode;
  }

  void _scheduleInnerRingDirectionChange() {
    _innerRingTimerId = Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _innerRingOpacity = 0.3;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _innerRingSpeed *= -1;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _innerRingOpacity = 0.4;
          });
        });
      });

      _scheduleInnerRingDirectionChange();
    }).hashCode;
  }

  void _scheduleInnermostRingDirectionChange() {
    _innermostRingTimerId = Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _innermostRingOpacity = 0.2;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _innermostRingSpeed *= -1;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            _innermostRingOpacity = 0.3;
          });
        });
      });

      _scheduleInnermostRingDirectionChange();
    }).hashCode;
  }

  @override
  void dispose() {
    _mainController.dispose();
    _ticker.dispose();
    _glowController.dispose();
    _syncEffectController.dispose();
    _blastController.dispose();

    if (_syncDebounceTimer != null) {
      Future.microtask(() => _syncDebounceTimer = null);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxScreenDimension = screenSize.width > screenSize.height
        ? screenSize.width
        : screenSize.height;
    final blastMaxSize = maxScreenDimension * 2.0;

    bool shouldShowBlast = _showBlast && _allRingsSameDirection;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          AmbientGlow(
            isVisible: _allRingsSameDirection,
            glowAnimation: _glowAnimation,
            colorAnimation: _syncColorAnimation,
          ),
          if (shouldShowBlast)
            BlastEffect(
              animation: _blastAnimation,
              maxSize: blastMaxSize,
            ),
          Center(
            child: RepaintBoundary(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _allRingsSameDirection ? 1.0 : 0.0,
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                (_syncColorAnimation.value ?? Colors.blue)
                                    .withOpacity(_glowAnimation.value * 0.6),
                                (_syncColorAnimation.value ?? Colors.blue)
                                    .withOpacity(_glowAnimation.value * 0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GlowEffects(
                    isVisible: _allRingsSameDirection,
                    syncPulseAnimation: _syncPulseAnimation,
                    syncColorAnimation: _syncColorAnimation,
                  ),
                  ParticleEffect(
                    particles: _particles,
                    isVisible: _allRingsSameDirection,
                    syncPulseAnimation: _syncPulseAnimation,
                    syncColorAnimation: _syncColorAnimation,
                  ),
                  RotatingRing(
                    letters: _outerRingLetters,
                    positions: _ringPositions[0],
                    rotation: _outerRingRotation,
                    opacity: _outerRingOpacity,
                    isSynchronized: _allRingsSameDirection,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  RotatingRing(
                    letters: _middleRingLetters,
                    positions: _ringPositions[1],
                    rotation: _middleRingRotation,
                    opacity: _middleRingOpacity,
                    isSynchronized: _allRingsSameDirection,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  RotatingRing(
                    letters: _innerRingLetters,
                    positions: _ringPositions[2],
                    rotation: _innerRingRotation,
                    opacity: _innerRingOpacity,
                    isSynchronized: _allRingsSameDirection,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  RotatingRing(
                    letters: _innermostRingLetters,
                    positions: _ringPositions[3],
                    rotation: _innermostRingRotation,
                    opacity: _innermostRingOpacity,
                    isSynchronized: _allRingsSameDirection,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  CenterDot(
                    isVisible: _allRingsSameDirection,
                    animation: _syncPulseAnimation,
                    colorAnimation: _syncColorAnimation,
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
