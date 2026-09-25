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
- Clientes v1.1: listado, búsqueda, alta, detalle, edición y múltiples contactos.
- Horario estructurado de recepción de entregas de lunes a domingo, editable por día o mediante aplicación masiva a cualquier combinación de días.
- Modelos `Client`, `Contact`, `ReceptionDay` y `Purchase`; visualización básica de compras de ejemplo.
- Clientes utiliza datos en memoria y no agregó dependencias externas.
- Pedidos v1: listado, búsqueda por folio o cliente, filtro por estado, alta, detalle, edición, cambio manual de los estados permitidos y acceso al cliente relacionado.
- Modelo `Order` relacionado con `Client` mediante `clientId`, con ID interno independiente, folio alfanumérico, fechas, estado, observaciones generales y motivo de posposición separado.
- Home comparte temporalmente Clientes y Pedidos en memoria; no existe persistencia real.
- Prueba manual correcta en Android, `flutter analyze` sin problemas y 38 pruebas automatizadas superadas.
- Git/GitHub.

Prioridad de desarrollo:
1. Clientes v1.1: **IMPLEMENTADO**.
2. Pedidos v1: **IMPLEMENTADO**; referencias operativas a facturas, relación con clientes, estados, consulta y edición.
3. Rutas v1: **SIGUIENTE**; su diseño funcional sigue pendiente y se realizará antes de implementarlo.
4. Persistencia, sincronización e integraciones: etapas futuras según la arquitectura.

Las tarjetas de Rutas y Entregas aún no implementan esos módulos.

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
- horario estructurado de recepción de entregas por día de la semana.
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

### Clientes v1.1 (implementado)
- Listado, búsqueda, alta, detalle y edición de clientes.
- Editar sin perder ID, coordenadas, contactos ni compras existentes.
- Agregar y mostrar múltiples contactos.
- Ubicación: estado, municipio, dirección y coordenadas opcionales.
- Condiciones comerciales: descuento y crédito.
- Observaciones separadas del horario.
- Horario de recepción de entregas con exactamente siete días, sin duplicados ni faltantes.
- Cada día puede estar Sin definir, No recibe o Recibe en un intervalo Desde/Hasta.
- Configuración individual y opción "Aplicar horario a varios días" con selección libre de cualquier combinación.
- Después de aplicar en bloque, cada día continúa siendo editable individualmente.
- Validar horas completas, rangos válidos e inicio anterior al fin.
- Los datos permanecen solo en memoria y pueden perderse al recrear Home o la aplicación.
- Sin dependencias externas nuevas; probado manualmente en Android y con 25 pruebas automatizadas.

El horario representa cuándo el cliente recibe entregas, no necesariamente su horario comercial general.

### Pedidos v1 (implementado)
- Referencia operativa a una factura física, sin copiar productos, cantidades, precios, impuestos ni el contenido completo.
- ID interno independiente del folio.
- Folio alfanumérico como `String`, sin límite pequeño artificial y sin asumir unicidad definitiva.
- Relación con Cliente mediante `clientId` (`String`), sin duplicar sus datos.
- Fecha de factura y fecha prevista de entrega opcional.
- `notes`: observaciones generales opcionales, independientes del estado.
- `postponementReason`: motivo de posposición independiente de las observaciones generales.
- Estados: Sin ruta, En ruta, Entregado, Pospuesto y Cancelado.
- Todo pedido nuevo inicia automáticamente Sin ruta; el formulario de creación no permite elegir estado.
- En ruta queda reservado para la futura integración con Rutas y no es una transición manual en Pedidos v1.
- Para cambiar a Pospuesto, solicitar y validar un motivo obligatorio no vacío antes de confirmar.
- Mientras esté Pospuesto, mostrar claramente el motivo.
- No eliminar automáticamente un motivo existente al abandonar Pospuesto. La política definitiva de conservación o historial se decidirá después.
- Listado, búsqueda por folio o cliente, filtro por estado, alta, detalle, edición y cambio manual de los estados permitidos.
- Datos únicamente en memoria; Home comparte temporalmente Clientes y Pedidos.
- Probado manualmente en Android, con análisis estático sin problemas y 38 pruebas automatizadas totales.

### Decisiones que siguen pendientes
- Regla definitiva de unicidad o duplicidad del folio para la futura base de datos; temporalmente se permiten folios repetidos.
- Política definitiva para conservar o historizar motivos de posposición anteriores.
- Tratamiento de entregas fallidas y reprogramaciones.
- Reglas definitivas de selección de pedidos para Rutas.
- Transiciones automáticas relacionadas con Rutas, incluida En ruta.
- Diseño de Rutas v1: asignación de pedidos, orden de paradas, relación con choferes, inicio y finalización de rutas y cualquier regla adicional de reprogramación. No asumir estas decisiones antes de su diseño aprobado.

Primera versión:
- Listado.
- Búsqueda.
- Formulario.
- Detalle.
- Datos de prueba en memoria.

Estado técnico actual:
- No existe SQLite ni conexión con API.
- PostgreSQL está preparado para el futuro, pero no integrado.
- No existe autenticación real, sincronización offline ni integración de Maps, Routes API o Navigation SDK.
- Clientes v1.1 y Pedidos v1 están guardados en Git y GitHub.

Todavía NO:
- PostgreSQL integrado.
- SQLite.
- API.
- Maps, Routes API ni Navigation SDK integrados.
- Auth real.
- Sincronización offline.
- Módulos Rutas y Entregas aún no implementados.

Mantener la aplicación ligera para una gama amplia de dispositivos Android compatibles, sin dependencias ni optimizaciones complejas innecesarias.

## 14. Regla principal

No avanzar por cantidad de código.

Avanzar por funcionalidades pequeñas, probadas y entendibles.

Ante dudas de arquitectura o requisitos, detener implementación y solicitar aclaración.
