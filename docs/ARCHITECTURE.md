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

## 4. Estructura Flutter actual relevante

```text
lib/
├── main.dart
├── models/
│   ├── client.dart
│   ├── contact.dart
│   ├── purchase.dart
│   └── reception_day.dart
└── screens/
    ├── login_screen.dart
    ├── home_screen.dart
    └── clients/
        ├── clients_screen.dart
        ├── client_form_screen.dart
        ├── client_detail_screen.dart
        ├── contact_form_screen.dart
        └── widgets/
            └── reception_schedule_editor.dart
test/
├── widget_test.dart
├── models/
│   ├── client_test.dart
│   └── reception_day_test.dart
└── screens/
    └── clients_v11_test.dart
```

Mantenerla simple. No introducir arquitectura compleja sin necesidad.

La estructura corresponde a Clientes v1.1 implementado y probado.

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
- Pedidos que requieren entrega se utilizarán para planificar rutas; las reglas exactas se definirán antes de implementar Rutas v1, sin fijar estados elegibles todavía.
- Ruta relacionará pedidos y paradas de entrega, usando información actualizada del cliente. No diseñar Pedidos de forma aislada de Clientes y Rutas.

Flujo conceptual: Factura física → Pedido en Mi Ruta → Cliente → Ruta → Entrega.

Pedido será principalmente una referencia a la factura física y una unidad operativa para seguimiento, planificación de rutas y entrega. Mi Ruta no reemplaza facturación ni es un sistema completo de ventas. Productos, cantidades, precios, impuestos y demás contenido de la factura quedan fuera del alcance actual, evitando duplicación innecesaria.

### Pedido (diseño aprobado para Pedidos v1)
Modelo Dart previsto, independiente de widgets Flutter:
- `id`: `String` interno e inmutable, independiente del folio.
- `invoiceNumber`: folio alfanumérico `String`, obligatorio y sin límite pequeño artificial.
- `clientId`: `String` que referencia a `Client.id`, sin copiar datos del cliente.
- `invoiceDate`: fecha de factura.
- `expectedDeliveryDate`: fecha prevista de entrega opcional.
- `status`: estado del pedido.
- `notes`: observaciones generales opcionales.
- `postponementReason`: motivo de posposición separado de `notes`.

Estados: Sin ruta, En ruta, Entregado, Pospuesto y Cancelado. Un pedido nuevo inicia automáticamente Sin ruta y su formulario de creación no expone el estado. En ruta queda reservado para la futura integración con Rutas y no será una transición manual en Pedidos v1.

El modelo validará que un Pedido Pospuesto tenga un motivo no vacío. La interfaz solicitará el motivo antes de confirmar, mantendrá las observaciones generales separadas y mostrará claramente el motivo mientras el pedido esté Pospuesto. No se eliminará automáticamente un motivo existente al abandonar Pospuesto; la política definitiva de conservación o historial queda pendiente. No habrá historial complejo de estados o motivos en v1.

El folio no será clave primaria ni identificador interno. En memoria se permitirán folios repetidos y las actualizaciones usarán `Order.id`. La regla definitiva de unicidad se decidirá antes de diseñar la base de datos.

### Estado compartido temporal
`HomeScreen` mantendrá temporalmente `List<Client>` y `List<Order>` y entregará las mismas colecciones a Clientes y Pedidos. `Order` guardará solo `clientId`; las pantallas resolverán el cliente actual en la lista compartida. Así, una edición del cliente se reflejará en sus pedidos sin duplicar ubicación, coordenadas, contactos, horario u observaciones.

Esta solución será estado local sencillo y únicamente en memoria. No introduce paquetes, singleton, persistencia ni gestión avanzada de estado. Los datos podrán perderse al recrear Home o la aplicación.

Pedidos v1 tendrá listado con búsqueda y filtro, formulario reutilizado para alta/edición, detalle, cambio de estado y navegación al detalle del cliente. No incluirá productos, cantidades, precios, impuestos, inventario, ventas, generación de facturas, historial complejo, Rutas o Entregas.

`Purchase` representa compras, no Pedidos. Permanece temporalmente junto con su visualización actual, sin ampliar funcionalidad. El historial prioritario futuro será de pedidos/facturas por folio, fecha y estado.

### Horario de recepción de entregas (implementado en Clientes v1.1)
Modelo Dart sencillo, independiente de widgets Flutter, con siete entradas semanales:
- Día de semana: lunes 1 a domingo 7, siguiendo la convención de Dart.
- Estado: desconocido, no recibe o recibe en un intervalo.
- Inicio y fin en minutos desde medianoche solo cuando recibe; validar rango de 0 a 1439 e inicio anterior al fin.

`Client` valida que el horario contenga exactamente los siete días, sin duplicados ni faltantes, los ordena y expone como lista no modificable. `ReceptionDay` valida el día, el rango de minutos y que el inicio sea anterior al fin.

El horario representa cuándo el cliente recibe entregas, no necesariamente su horario comercial general. No es texto libre ni observaciones. Los clientes sin horario registrado se consideran de horario desconocido, no cerrados. Se admite un intervalo por día; horarios partidos, intervalos nocturnos y excepciones por fecha quedan fuera de v1.1.

La interfaz permite editar cada día individualmente y aplicar Sin definir, No recibe o un intervalo Desde/Hasta a cualquier combinación de días. La aplicación masiva conserva los días no seleccionados y no impide modificar después un día individual. Capturar horarios no implica implementar planificación de rutas.

La edición y el alta de contactos conservan ID, coordenadas, contactos y compras existentes. `ClientsScreen` mantiene la lista en memoria; detalle y formularios devuelven clientes actualizados y la lista reemplaza el elemento por su ID. Salir o recrear el módulo puede perder los cambios. No se añadieron capas, gestión avanzada de estado ni dependencias externas.

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
- Clientes v1.1: listado, búsqueda, alta, detalle, edición, múltiples contactos y horario estructurado en memoria.
- Configuración individual y masiva del horario de recepción de entregas.
- Modelos `Client`, `Contact`, `ReceptionDay` y `Purchase`, con visualización básica de compras de ejemplo.
- Prueba manual correcta en Android, análisis estático sin problemas y 25 pruebas automatizadas superadas.
- Git/GitHub.

### Preparado
- .NET 10.
- PostgreSQL.
- pgAdmin.
- `mi_ruta_dev`.

### Pendiente
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

Orden de prioridad: Clientes v1.1 **IMPLEMENTADO** → Pedidos v1 **SIGUIENTE** → Rutas v1 **POSTERIOR** → persistencia, sincronización e integraciones según las etapas definidas. Las tarjetas de Pedidos, Rutas y Entregas aún no implementan esos módulos. No ampliar funcionalidades de compras. Mantener una aplicación ligera para una gama amplia de dispositivos Android compatibles, sin paquetes externos innecesarios ni arquitectura compleja.
