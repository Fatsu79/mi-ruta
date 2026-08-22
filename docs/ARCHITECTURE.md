# Mi Ruta — Arquitectura técnica

## 1. Objetivo

Este documento describe la arquitectura objetivo.

> Que una tecnología aparezca aquí no significa que ya esté implementada.

## 2. Arquitectura general

```text
Flutter UI
   |
   v
SQLite
   ^
   |
   v
ASP.NET Core API
   |
   v
PostgreSQL
```

## 3. Aplicación móvil

Tecnología:
- Flutter.
- Dart.
- Material Design.
- Android primero.

Responsabilidades:
- Interfaz.
- Navegación.
- Formularios.
- Validaciones UX.
- SQLite.
- Sincronización.
- Mapas.
- Consumo de API.

## 4. Estructura Flutter inicial

```text
lib/
├── main.dart
├── models/
│   ├── client.dart
│   ├── contact.dart
│   └── purchase.dart
└── screens/
    ├── login_screen.dart
    ├── home_screen.dart
    └── clients/
        ├── clients_screen.dart
        ├── client_form_screen.dart
        └── client_detail_screen.dart
```

Mantenerla simple. No introducir arquitectura compleja sin necesidad.

## 5. Modelos

Los modelos representan entidades del negocio dentro de Dart.

Ejemplos:
- Client.
- Contact.
- Purchase.
- Order.
- Route.
- Stop.
- User.

Los modelos no son la base de datos.

## 6. Backend

Tecnología:
- ASP.NET Core.
- C#.
- .NET 10.

Responsabilidades:
- Autenticación.
- Autorización.
- Reglas de negocio.
- Validaciones.
- PostgreSQL.
- Sincronización.
- API REST.

## 7. PostgreSQL

Fuente oficial de información.

Base actual:
`mi_ruta_dev`

Entidades conceptuales:
- usuarios.
- roles.
- usuarios_roles.
- clientes.
- contactos.
- compras.
- pedidos.
- detalle_pedido.
- rutas.
- paradas.

El esquema definitivo se creará mediante migraciones.

## 8. SQLite

Base local de trabajo.

Responsabilidades:
- Consultas rápidas.
- Datos offline.
- Ruta actual.
- Clientes asignados.
- Pedidos.
- Estados.
- Cola de sincronización.

## 9. Sincronización

Cada cambio offline debe poder registrar:
- Estado de sync.
- Fecha/hora.
- Identificador.
- Operación pendiente.
- Versión o timestamp.

## 10. Mapas y rutas

### Routes API
Calcula rutas, distancias, tiempos y orden de paradas.

### Navigation SDK
Proporciona navegación dentro de la app.

### Motor de Mi Ruta
Código propio que decide:
- Qué pedidos entran.
- Qué clientes están pendientes.
- Qué cliente conviene visitar.
- Cuándo recalcular.
- Cómo considerar prioridad y horarios.

## 11. Offline de rutas

Sin Internet:
- No hay tráfico nuevo.
- Se conserva última ruta válida.
- Se conservan coordenadas.
- Se actualizan estados locales.

Al volver Internet:
1. Sincronizar.
2. Obtener estado actual.
3. Recalcular si corresponde.

## 12. Seguridad

- Autorización en backend.
- HTTPS.
- Tokens seguros.
- Hash de contraseñas.
- Secure Storage.
- No hardcodear secretos.
- Validación cliente + servidor.
- Logs sin datos sensibles.
- Rate limiting antes de producción.
- Referencia futura: OWASP MASVS / MASTG.

## 13. Roles

Un usuario puede tener varios roles:
- Administrador.
- Vendedor.
- Chofer.

## 14. Git

- Rama principal: `main`.
- GitHub remoto.
- Commits pequeños.
- Revisar `git diff`.
- IA no hace commit ni push.

## 15. Docker

No obligatorio para el MVP.

Uso futuro probable:
```text
Docker Compose
├── ASP.NET Core API
└── PostgreSQL
```

PostgreSQL usaría volúmenes para persistencia.

## 16. Estado

### Implementado
- Flutter.
- Android.
- Login visual.
- Home.
- Git/GitHub.

### Preparado
- .NET 10.
- PostgreSQL.
- pgAdmin.
- `mi_ruta_dev`.

### Pendiente
- Clientes.
- Backend.
- API.
- Auth real.
- SQLite.
- Sync.
- Maps.
- Routes API.
- Navigation SDK.
