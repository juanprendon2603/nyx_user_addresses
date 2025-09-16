import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'glass_card.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.centerContent = true,
    this.maxWidth = 720,
    this.showBack = true,
    this.fab,
    this.fallbackRoute = '/welcome',
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool centerContent;
  final double maxWidth;
  final bool showBack;
  final Widget? fab;
  final String fallbackRoute;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: showBack
            ? (context.canPop()
                ? const BackButton()
                : IconButton(
                    tooltip: 'Volver',
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go(fallbackRoute),
                  ))
            : null,
        title: Text(title),
        actions: actions,
      ),
      floatingActionButton: fab,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-1, -1),
                  end: const Alignment(1, 1),
                  colors: [
                    cs.primary.withValues(alpha: .10),
                    cs.secondary.withValues(alpha: .10),
                    cs.tertiary.withValues(alpha: .08),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: 80,
            child: _blurDot(cs.primary.withValues(alpha: .18), 140),
          ),
          Positioned(
            right: -30,
            top: 200,
            child: _blurDot(cs.secondary.withValues(alpha: .14), 110),
          ),
          Positioned(
            left: -20,
            bottom: -10,
            child: _blurDot(cs.tertiary.withValues(alpha: .12), 160),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: centerContent ? GlassCard(child: child) : child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurDot(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 60, spreadRadius: 10)
          ],
        ),
      ),
    );
  }
}
