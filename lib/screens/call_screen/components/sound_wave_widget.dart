import 'package:flutter/material.dart';

class SoundWaveWidget extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double size;

  const SoundWaveWidget({
    Key? key,
    required this.isActive,
    required this.color,
    this.size = 100,
  }) : super(key: key);

  @override
  State<SoundWaveWidget> createState() => _SoundWaveWidgetState();
}

class _SoundWaveWidgetState extends State<SoundWaveWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    if (widget.isActive) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted && widget.isActive) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimations() {
    for (var controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void didUpdateWidget(SoundWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startAnimations();
      } else {
        _stopAnimations();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.4, // Reduced from 0.6
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: 3, // Reduced from 4
                height: widget.isActive 
                    ? (widget.size * 0.4 * _animations[index].value) // Updated multiplier
                    : (widget.size * 0.08), // Reduced minimum height
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(
                    widget.isActive ? _animations[index].value : 0.3,
                  ),
                  borderRadius: BorderRadius.circular(1.5), // Reduced from 2
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class PulseRippleWidget extends StatefulWidget {
  final bool isActive;
  final Color color;
  final double size;

  const PulseRippleWidget({
    Key? key,
    required this.isActive,
    required this.color,
    this.size = 120,
  }) : super(key: key);

  @override
  State<PulseRippleWidget> createState() => _PulseRippleWidgetState();
}

class _PulseRippleWidgetState extends State<PulseRippleWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 300)),
        vsync: this,
      );
    });

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.7, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    if (widget.isActive) {
      _startRipples();
    }
  }

  void _startRipples() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        if (mounted && widget.isActive) {
          _controllers[i].repeat();
        }
      });
    }
  }

  void _stopRipples() {
    for (var controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void didUpdateWidget(PulseRippleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startRipples();
      } else {
        _stopRipples();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
      );
    }

    return SizedBox(
      width: widget.size * 1.5, // Reduced from 2
      height: widget.size * 1.5, // Reduced from 2
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withOpacity(_opacityAnimations[index].value),
                      width: 1.5, // Reduced from 2
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
