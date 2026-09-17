# Mi Ruta — Proyecto

## 1. Visión general

**Mi Ruta** es una aplicación móvil orientada a vendedores, administradores y choferes, enfocada principalmente en planificar y ejecutar rutas para la entrega de pedidos.

El flujo operativo parte de facturas físicas, que permiten identificar folio, cliente y contenido por entregar. Mi Ruta mantendrá información operativa actualizada de los clientes y permitirá dar seguimiento a pedidos/facturas, planificar rutas y registrar entregas, incluyendo escenarios futuros con conectividad limitada.

Flujo conceptual: **Factura física → Pedido en Mi Ruta → Cliente → Ruta → Entrega**.

Mi Ruta no pretende reemplazar el sistema de facturación ni convertirse en un sistema completo de ventas. El Pedido será principalmente una referencia a la factura física y una unidad operativa para seguimiento, planificación de rutas y entrega. No se duplicará innecesariamente su información: productos, cantidades, precios, impuestos y demás contenido de la factura quedan fuera del alcance actual.

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
- Clientes v1: listado, búsqueda, alta con un contacto y detalle; datos de ejemplo y altas únicamente en memoria, que se pierden al salir del módulo y volver a entrar.
- Modelos `Client`, `Contact` y `Purchase`, con visualización básica de compras de ejemplo.
- Pruebas básicas de login → Home, Home → Clientes y apertura del formulario.
- Git y GitHub configurados.
- Emulador Android 16 / API 36 funcionando.

### Instalado/preparado
- Flutter / Dart.
- .NET 10.
- PostgreSQL.
- pgAdmin.
- Base de desarrollo `mi_ruta_dev`.
- Codex en VS Code.

### Próximos incrementos (no implementados)
1. **Clientes v1.1:** editar sin perder datos existentes, múltiples contactos y horario semanal de recepción/entrega; solo en memoria.
2. **Pedidos v1:** registro por folio de factura, relación con clientes, estados, consulta e historial.
3. **Rutas v1:** planificación de entregas usando pedidos que requieren entrega y ubicación, contactos y horarios actualizados del cliente.

Las reglas exactas para incorporar pedidos a una ruta se definirán al diseñar Pedidos v1, sin restringir todavía su selección a estados específicos. También quedan pendientes las reglas de identificación/duplicados del folio y el tratamiento de entregas fallidas/reprogramaciones.

`Purchase` permanece temporalmente sin ampliar su funcionalidad. Se suspende el desarrollo de registro de compras, compras recientes e historial completo de compras.

Las tarjetas de Pedidos, Rutas y Entregas no tienen todavía funcionalidad. Persistencia, API, autenticación real, mapas y sincronización siguen siendo objetivos futuros, no parte del incremento actual.

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
