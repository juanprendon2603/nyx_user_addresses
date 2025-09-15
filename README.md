# Prueba Flutter - Usuarios y Direcciones

Proyecto base para la prueba técnica (3 pantallas): datos básicos, direcciones con cascada País/Departamento/Municipio y resumen con persistencia local.

## Stack
- Flutter + Material 3
- Riverpod (StateNotifier)
- GoRouter
- Freezed + json_serializable
- Hive (persistencia simple)
- Tests: unit (validators, notifier) y widget (pendiente de ejemplo completo)

## Correr
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Tests
```bash
flutter test
```

## Decisiones
- Dataset de ubicaciones en `assets/data/locations_co.json` (fácil de extender).
- Persistencia con Hive en un solo box `user_box`.
- Arquitectura en capas (domain/data/presentation) para mantener testabilidad.

## Mejoras futuras
- i18n
- Validaciones adicionales y máscaras de inputs
- Adapters tipados de Hive
- Diseño visual más pulido y estados de carga/errores más ricos
