import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_notifier.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _scaleIn = Tween<double>(begin: .98, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final hasUser = user.firstName.isNotEmpty || user.lastName.isNotEmpty;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton.filledTonal(
            tooltip: 'Usuarios',
            onPressed: () => context.go('/users'),
            icon: const Icon(Icons.group_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const _GradientBackground(),
          const _Bubbles(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: ScaleTransition(
                scale: _scaleIn,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: _GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: 48,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: .9),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'NYX User Addresses',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Double V Partners — Prueba Técnica',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            const _FeatureChips(),
                            const SizedBox(height: 18),
                            Text(
                              'Crea usuarios, agrega direcciones con Departamento y Municipio, '
                              'y consulta todo en un resumen limpio y en tiempo real.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                FilledButton.icon(
                                  icon: const Icon(Icons.person_add_alt_1),
                                  label: Text(
                                    hasUser ? 'Editar usuario' : 'Comenzar',
                                  ),
                                  onPressed: () => context.go('/'),
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.list_alt),
                                  label: const Text('Ver resumen'),
                                  onPressed: () => context.go('/summary'),
                                ),
                                FilledButton.tonalIcon(
                                  icon: const Icon(Icons.group_outlined),
                                  label: const Text('Usuarios'),
                                  onPressed: () => context.go('/users'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (hasUser)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Hola, ${user.firstName} ${user.lastName}'
                                      .trim(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: .12),
            cs.secondary.withValues(alpha: .10),
            cs.tertiary.withValues(alpha: .10),
          ],
          begin: const Alignment(-1, -1),
          end: const Alignment(1, 1),
        ),
      ),
    );
  }
}

class _Bubbles extends StatelessWidget {
  const _Bubbles();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          _blurCircle(
            const Offset(-40, 60),
            140,
            primary.withValues(alpha: .20),
          ),
          _blurCircle(
            const Offset(40, 220),
            90,
            primary.withValues(alpha: .15),
          ),
          _blurCircle(
            const Offset(-20, 420),
            120,
            primary.withValues(alpha: .12),
          ),
          _blurCircle(
            const Offset(220, 140),
            110,
            primary.withValues(alpha: .10),
          ),
          _blurCircle(
            const Offset(-60, 640),
            160,
            primary.withValues(alpha: .10),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(Offset offset, double size, Color color) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final surface = cs.surface;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: surface.withValues(alpha: .6),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: .4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _FeatureChips extends StatelessWidget {
  const _FeatureChips();

  final _items = const [
    (Icons.check_circle, '3 pantallas'),
    (Icons.memory, 'Estado con Riverpod'),
    (Icons.route, 'go_router'),
    (Icons.map_outlined, 'Depto/Municipio'),
    (Icons.shield_outlined, 'Validaciones'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _items
          .map(
            (e) => Chip(
              avatar: Icon(e.$1, size: 18),
              label: Text(e.$2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
          .toList(),
    );
  }
}
