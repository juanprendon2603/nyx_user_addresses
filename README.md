# NYX User Addresses (Flutter)

Prueba técnica **Double V Partners — NYX**  
Crea usuarios, agrega **múltiples direcciones** (País/Departamento/Municipio) y consulta todo en un **resumen** con estado reactivo.

## ✨ Funcionalidades

- Formulario de **Usuario** (Nombre, Apellido, Fecha de nacimiento).
- Editor de **Direcciones** (Colombia → Departamento → Municipio) con validaciones.
- **Multiusuario**: lista de usuarios, selección y eliminación.
- **Resumen** en tiempo real (Riverpod).
- UI con **Material 3**, tema custom y pantalla de **bienvenida**.

## 🧱 Arquitectura (resumen)

- **Presentation**: Widgets/UI + `go_router` + Providers de Riverpod.
- **Domain**: Entidades puras (`NyxUser`, `Address`).
- **Data**: Datasource de ubicaciones desde asset JSON (`assets/data/locations_co.json`).
- **Estado**: Riverpod (`usersProvider`, `selectedUserIdProvider`, `userProvider` derivado).

> Persistencia: **no** se guarda en disco en este MVP. Se dejó listo para enchufar una capa de storage (p.ej. Hive o SharedPreferences) si se requiere.

## 🛠️ Requisitos

- Flutter 3.x / Dart 3.x
- iOS: Xcode con runtime del simulador instalado
- Android: SDK/Emulador configurado

## ▶️ Ejecutar

```bash
flutter pub get
flutter run
```
