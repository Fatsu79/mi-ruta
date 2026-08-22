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

La decisión de qué cliente visitar es lógica propia de Mi Ruta.

## 12. Estado actual

Implementado:
- Flutter.
- Android.
- Login visual sin auth real.
- Home con Clientes, Pedidos, Rutas y Entregas.
- Tests básicos.
- Git/GitHub.

Próximo módulo:
**Clientes**.

## 13. Módulo Clientes — dirección inicial

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
- compras.

### Contacto
- nombre.
- puesto/área.
- teléfono.
- correo.

### Compra
- fecha.
- monto.
- número de factura opcional.

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

## 14. Regla principal

No avanzar por cantidad de código.

Avanzar por funcionalidades pequeñas, probadas y entendibles.

Ante dudas de arquitectura o requisitos, detener implementación y solicitar aclaración.
