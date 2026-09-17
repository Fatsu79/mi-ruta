# AGENTS.md — Reglas para Codex y agentes de código

## 1. Contexto obligatorio

Antes de trabajar:

1. Leer este archivo.
2. Leer:
   - `docs/PROJECT.md`
   - `docs/REQUIREMENTS.md`
   - `docs/ARCHITECTURE.md`
3. Revisar el repositorio.
4. No asumir que una tecnología documentada ya está implementada.

La documentación es la fuente de verdad funcional y arquitectónica.

## 2. Flujo de trabajo

Para tareas nuevas o que afecten varios archivos:

1. Analizar.
2. Proponer plan breve.
3. Indicar archivos a crear/modificar.
4. Esperar aprobación.
5. Implementar solo lo aprobado.
6. Ejecutar verificaciones.
7. Resumir cambios.

## 3. Git

El agente NO debe:
- Hacer commit.
- Hacer push.
- Cambiar ramas sin autorización.
- Reescribir historial.
- Ejecutar acciones destructivas.

El humano controla Git.

## 4. Calidad

Después de cambios Flutter, cuando aplique:

```bash
dart format lib test
flutter analyze
flutter test
```

No ignorar fallos.

## 5. Dependencias

No agregar paquetes externos sin justificar:
- necesidad.
- problema que resuelve.
- alternativas.
- impacto.

## 6. Arquitectura

Mantenerla simple.

No introducir sin necesidad:
- Clean Architecture completa.
- Microservicios.
- CQRS.
- Event sourcing.
- State management complejo.
- DI compleja.
- Capas redundantes.

El proyecto es pequeño/mediano y también tiene finalidad de aprendizaje.

## 7. Flutter

Prioridad:
1. Código legible.
2. Widgets pequeños.
3. Separar pantallas y modelos.
4. Evitar archivos gigantes.
5. Navegación clara.
6. Android primero.

`models/` representa estructuras del negocio en Dart, no la base de datos.

## 8. Backend

Objetivo:
- ASP.NET Core.
- C#.
- .NET 10.
- PostgreSQL.

No implementar backend hasta que se solicite explícitamente.

## 9. Offline

Objetivo:
- SQLite.

No implementar sincronización sin diseño aprobado.

PostgreSQL será fuente oficial; SQLite será almacenamiento local de trabajo.

## 10. Seguridad

No incluir:
- Contraseñas reales.
- Tokens.
- Secrets.
- Connection strings de producción.
- API keys sin restricciones.

Autorización siempre en backend.

## 11. Google Maps

Planificado:
- Google Maps Platform.
- Routes API.
- Navigation SDK.

No integrarlos hasta que se solicite explícitamente.

La planificación de entregas y el orden de las paradas son lógica propia de Mi Ruta.

## 12. Estado actual

Implementado:
- Flutter.
- Android.
- Login visual sin auth real.
- Home con Clientes, Pedidos, Rutas y Entregas.
- Clientes v1: listado, búsqueda, alta con un contacto y detalle con datos de ejemplo en memoria.
- Modelos `Client`, `Contact` y `Purchase`; visualización básica de compras de ejemplo.
- Tests básicos.
- Git/GitHub.

Prioridad de desarrollo (todavía no implementada):
1. Clientes v1.1: edición, múltiples contactos y horario de recepción/entrega.
2. Pedidos v1: referencias a facturas, relación con clientes, estados, consulta e historial.
3. Rutas v1: selección de pedidos que requieren entrega y planificación con información actualizada del cliente.

Las tarjetas de Pedidos, Rutas y Entregas aún no implementan esos módulos.

## 13. Clientes y dirección operativa

Mi Ruta prioriza la planificación y ejecución de entregas. No reemplaza el sistema de facturación ni es un sistema completo de ventas.

Flujo conceptual: Factura física → Pedido en Mi Ruta → Cliente → Ruta → Entrega.

El Pedido será principalmente una referencia a la factura física y una unidad operativa para seguimiento, planificación de rutas y entrega. No duplicar innecesariamente la factura: productos, cantidades, precios, impuestos y demás contenido quedan fuera del alcance actual.

### Cliente
- id.
- nombre comercial.
- razón social.
- estado.
- municipio.
- dirección.
- latitud opcional.
- longitud opcional.
- descuento.
- tiene crédito.
- observaciones.
- contactos.
- horario de recepción/entrega estructurado por día de la semana (planificado).
- compras existentes únicamente como compatibilidad temporal.

### Contacto
- nombre.
- puesto/área.
- teléfono.
- correo.

### Compra (temporal)
- fecha.
- monto.
- número de factura opcional.

Mantener `Purchase` temporalmente sin ampliar su funcionalidad ni convertirlo en Pedido. La prioridad futura es el historial de pedidos/facturas.

### Clientes v1.1 (planificado)
- Editar sin perder ID, coordenadas, contactos ni compras existentes.
- Agregar y mostrar múltiples contactos.
- Horario semanal separado de observaciones: desconocido, no recibe o intervalo de recepción.
- Mantener los datos solo en memoria; actualmente se pierden al salir del módulo y volver a entrar.

### Decisiones pendientes para Pedidos v1
- No asumir que el folio de factura es globalmente único; definir identificación y duplicados.
- Definir tratamiento de entregas fallidas y reprogramaciones; una entrega fallida no equivale a cancelar el pedido.
- Usar pedidos que requieren entrega para planificar rutas, sin fijar todavía estados elegibles ni reglas exactas.
- Estados base propuestos: Pendiente, Programado, En ruta, Entregado y Cancelado. No agregar otros sin necesidad funcional definida.

Primera versión:
- Listado.
- Búsqueda.
- Formulario.
- Detalle.
- Datos de prueba en memoria.

Todavía NO:
- PostgreSQL.
- SQLite.
- API.
- Maps.
- Auth real.
- Sincronización offline.
- Módulo Pedidos sin solicitud y diseño aprobados.

Mantener la aplicación ligera para una gama amplia de dispositivos Android compatibles, sin dependencias ni optimizaciones complejas innecesarias.

## 14. Regla principal

No avanzar por cantidad de código.

Avanzar por funcionalidades pequeñas, probadas y entendibles.

Ante dudas de arquitectura o requisitos, detener implementación y solicitar aclaración.
