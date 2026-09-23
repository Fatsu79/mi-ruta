# Mi Ruta — Proyecto

## 1. Visión general

**Mi Ruta** es una aplicación móvil orientada a vendedores, administradores y choferes, enfocada principalmente en planificar y ejecutar rutas para la entrega de pedidos.

El flujo operativo parte de facturas físicas, que permiten identificar folio, cliente y contenido por entregar. Mi Ruta mantendrá información operativa actualizada de los clientes y permitirá dar seguimiento a pedidos/facturas, planificar rutas y registrar entregas, incluyendo escenarios futuros con conectividad limitada.

Flujo central:

```text
FACTURA FÍSICA
↓
PEDIDO EN MI RUTA
↓
CLIENTE con información actualizada
↓
PLANIFICACIÓN DE RUTA
↓
ENTREGA
```

La factura física ya existe y continúa siendo la fuente del detalle de lo que debe entregarse. Mi Ruta no pretende reemplazarla ni convertirse en un sistema de facturación, ventas o inventario. El Pedido será principalmente una referencia operativa a la factura y una unidad para seguimiento, planificación de rutas y entrega. No se duplicará innecesariamente su información: productos, cantidades, precios, impuestos y demás contenido quedan fuera del alcance actual.

La primera plataforma objetivo es **Android**.

## 2. Problema que resuelve

Mi Ruta busca centralizar en una sola aplicación:

- Información operativa actualizada de clientes, independiente de datos incompletos o desactualizados en las facturas.
- Contactos comerciales.
- Condiciones comerciales.
- Horarios de recepción/entrega.
- Historial de pedidos/facturas, consultable por folio, fecha y estado.
- Pedidos.
- Entregas.
- Ubicaciones geográficas.
- Planificación y ejecución de rutas de entrega.
- Operación offline.
- Sincronización cuando vuelve la conexión.

## 3. Usuarios objetivo

### Administrador
Puede administrar usuarios, clientes, pedidos, rutas y configuraciones.

### Vendedor
Podrá registrar y consultar clientes, registrar pedidos referenciados por factura, consultar su historial y planificar rutas de entrega.

### Chofer
Puede consultar su ruta, clientes asignados, pedidos, ubicaciones, contactos y estado de entregas.

> Un mismo usuario puede tener **más de un rol**.

## 4. Alcance funcional objetivo

Esta lista no implica que todas las funcionalidades estén implementadas.

- Inicio de sesión.
- Usuarios y roles.
- Clientes, múltiples contactos y horarios estructurados.
- Pedidos como referencias operativas a facturas físicas, relacionados con clientes.
- Historial de pedidos/facturas.
- Rutas y entregas.
- Ubicaciones.
- Operación offline.
- Sincronización.
- Navegación integrada.

## 5. Estado actual

### Implementado
- Proyecto Flutter creado.
- Aplicación ejecutándose en Android.
- Login visual sin autenticación real.
- Pantalla principal con Clientes, Pedidos, Rutas y Entregas.
- Clientes v1.1: listado, búsqueda, alta, detalle, edición, múltiples contactos y alta de contactos.
- Ubicación del cliente: estado, municipio, dirección y coordenadas opcionales.
- Condiciones comerciales, observaciones y horario estructurado de recepción de entregas.
- Horario de lunes a domingo: Sin definir, No recibe o intervalo Desde/Hasta; configuración individual y aplicación masiva a cualquier combinación de días.
- Validación de intervalos y de una semana con exactamente siete días, sin duplicados ni faltantes.
- Modelos `Client`, `Contact`, `ReceptionDay` y `Purchase`, con visualización básica de compras de ejemplo.
- Datos y cambios únicamente en memoria; pueden perderse al salir o recrear el módulo.
- Sin dependencias externas agregadas para Clientes v1.1.
- Implementación probada manualmente en Android; `flutter analyze` sin problemas y 25 pruebas automatizadas superadas.
- Git y GitHub configurados.
- Clientes v1.1 guardado en Git y GitHub.
- Emulador Android 16 / API 36 funcionando.

### Instalado/preparado
- Flutter / Dart.
- .NET 10.
- PostgreSQL.
- pgAdmin.
- Base de desarrollo `mi_ruta_dev`.
- Codex en VS Code.

### Prioridad del proyecto
1. **Clientes v1.1 — IMPLEMENTADO.**
2. **Pedidos v1 — SIGUIENTE.** Registro por folio de factura, relación con clientes, estados, consulta e historial.
3. **Rutas v1 — POSTERIOR.** Planificación de entregas usando pedidos que requieren entrega e información actualizada del cliente.
4. **Persistencia, sincronización e integraciones.** Según las siguientes etapas definidas en la arquitectura.

Las reglas exactas para incorporar pedidos a una ruta se definirán al diseñar Pedidos v1, sin restringir todavía su selección a estados específicos. También quedan pendientes las reglas de identificación/duplicados del folio y el tratamiento de entregas fallidas/reprogramaciones.

`Purchase` permanece temporalmente sin ampliar su funcionalidad. Se suspende el desarrollo de registro de compras, compras recientes e historial completo de compras.

Las tarjetas de Pedidos, Rutas y Entregas no tienen todavía funcionalidad. No existe SQLite, conexión con API, autenticación real, mapas ni sincronización. PostgreSQL está preparado para el futuro, pero no está integrado.

## 6. Tecnologías principales

- Flutter / Dart.
- ASP.NET Core / C# / .NET 10.
- PostgreSQL.
- SQLite.
- Google Maps Platform.
- Google Routes API.
- Google Navigation SDK.
- VS Code.
- Git / GitHub.
- Codex.

## 7. Principios del proyecto

1. Mantener el proyecto pequeño y entendible.
2. No agregar complejidad sin necesidad real.
3. Construir por módulos.
4. Probar cada incremento.
5. Diseñar seguridad desde el inicio.
6. Mantener documentación actualizada.
7. No permitir commits o push automáticos de IA.
8. Priorizar aprendizaje y comprensión.
9. Evitar dependencias innecesarias.
10. Diseñar pensando en conectividad limitada.
11. Mantener la aplicación ligera para una gama amplia de dispositivos Android compatibles.
12. Distinguir horario desconocido de días en que el cliente no recibe; el horario no sustituye a las observaciones.

## 8. Flujo de desarrollo

1. Definir requisito.
2. Actualizar documentación.
3. Pedir a Codex un plan.
4. Revisar y aprobar.
5. Implementar.
6. Ejecutar `dart format`, `flutter analyze`, `flutter test`.
7. Probar en Android.
8. Revisar `git diff`.
9. Commit manual.
10. Push manual.

## 9. Nombre

**Mi Ruta** es el nombre de trabajo actual.
