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

Arquitectura futura: Flutter ↔ SQLite ↔ API ASP.NET Core ↔ PostgreSQL. SQLite será almacenamiento local de trabajo; PostgreSQL será la fuente autoritativa del servidor. No implementarla en el incremento actual.

Actualmente Flutter usa datos en memoria dentro de Clientes, con navegación y estado local sencillo. No hay SQLite, API, PostgreSQL integrado, autenticación real, mapas ni sincronización. Las altas se pierden al salir del módulo y volver a entrar.

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

La estructura mostrada corresponde a Clientes v1 existente. Clientes v1.1 está planificado, no implementado.

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

### Relaciones operativas futuras
- Un Pedido pertenece a un Cliente mediante su ID interno.
- Cliente aporta ubicación, múltiples contactos, horario y demás información operativa actualizada, aunque la factura física esté incompleta o desactualizada.
- Pedidos que requieren entrega se utilizarán para planificar rutas; las reglas exactas se definirán en Pedidos v1, sin fijar estados elegibles todavía.
- Ruta relacionará pedidos y paradas de entrega, usando información actualizada del cliente. No diseñar Pedidos de forma aislada de Clientes y Rutas.

Flujo conceptual: Factura física → Pedido en Mi Ruta → Cliente → Ruta → Entrega.

Pedido será principalmente una referencia a la factura física y una unidad operativa para seguimiento, planificación de rutas y entrega. Mi Ruta no reemplaza facturación ni es un sistema completo de ventas. Productos, cantidades, precios, impuestos y demás contenido de la factura quedan fuera del alcance actual, evitando duplicación innecesaria.

Pedido contemplará ID interno, folio de factura, cliente relacionado, fecha, fecha prevista/programada de entrega opcional, estado y observaciones operativas. No asumir folio globalmente único: definir identificación y duplicados en Pedidos v1. Estados base propuestos: Pendiente, Programado, En ruta, Entregado y Cancelado; transiciones, entregas fallidas y reprogramaciones quedan pendientes. Una entrega fallida no equivale a cancelación.

`Purchase` representa compras, no Pedidos. Permanece temporalmente junto con su visualización actual, sin ampliar funcionalidad. El historial prioritario futuro será de pedidos/facturas por folio, fecha y estado.

### Horario del cliente (planificado para Clientes v1.1)
Modelo Dart sencillo, independiente de widgets Flutter, con siete entradas semanales:
- Día de semana: lunes 1 a domingo 7, siguiendo la convención de Dart.
- Estado: desconocido, no recibe o recibe en un intervalo.
- Inicio y fin en minutos desde medianoche solo cuando recibe; validar rango de 0 a 1439 e inicio anterior al fin.

El horario no es texto libre ni observaciones. Los clientes sin horario registrado se consideran de horario desconocido, no cerrados. Inicialmente se admite un intervalo por día; horarios partidos, intervalos nocturnos y excepciones por fecha quedan fuera de v1.1 y podrán ampliarse después. Capturar horarios no implica implementar todavía planificación de rutas.

Edición y alta de contactos conservarán ID, coordenadas, contactos y compras existentes. Clientes seguirá usando únicamente memoria y estado local simple, sin nuevas capas ni gestión avanzada de estado.

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
- pedidos.
- rutas.
- paradas.

El esquema definitivo se creará mediante migraciones.

`compras` y `detalle_pedido`, contemplados anteriormente, no son entidades prioritarias ni compromisos del alcance actual. La existencia del modelo Dart `Purchase` no implica crear una tabla. No implementar backend ni esquema en esta etapa.

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
- Cómo utilizar ubicación, contactos y horarios actualizados del cliente.
- En qué orden realizar las paradas de entrega.
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
- Clientes v1: listado, búsqueda, alta con un contacto y detalle en memoria.
- Modelos `Client`, `Contact` y `Purchase` y visualización básica de compras de ejemplo.
- Pruebas básicas de navegación y apertura del formulario de cliente.
- Git/GitHub.

### Preparado
- .NET 10.
- PostgreSQL.
- pgAdmin.
- `mi_ruta_dev`.

### Pendiente
- Clientes v1.1: edición, múltiples contactos y horario semanal estructurado, solo en memoria.
- Pedidos v1: referencias operativas a facturas, relación con clientes, estados, consulta e historial.
- Rutas v1: selección de pedidos que requieren entrega y planificación usando información actualizada del cliente.
- Backend.
- API.
- Auth real.
- SQLite.
- Sync.
- Maps.
- Routes API.
- Navigation SDK.

Orden de prioridad: Clientes v1.1 → Pedidos v1 → Rutas v1. Las tarjetas de Pedidos, Rutas y Entregas aún no implementan esos módulos. No ampliar funcionalidades de compras. Mantener una aplicación ligera para una gama amplia de dispositivos Android compatibles, sin paquetes externos innecesarios ni arquitectura compleja.
