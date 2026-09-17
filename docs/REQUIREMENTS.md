# Mi Ruta — Requerimientos funcionales

## Alcance y estado

Mi Ruta prioriza seguimiento de pedidos y planificación/ejecución de entregas, no ventas ni facturación. Flujo conceptual: Factura física → Pedido en Mi Ruta → Cliente → Ruta → Entrega.

Implementado: login visual, Home y Clientes v1 (listado, búsqueda, alta con un contacto y detalle), únicamente en memoria. Las altas se pierden al salir del módulo y volver a entrar. Existe visualización básica de compras de ejemplo.

Planificado: Clientes v1.1 (edición, múltiples contactos y horario), después Pedidos v1 y Rutas v1. Los demás requisitos son objetivos futuros salvo indicación contraria. No implementar todavía persistencia, API, autenticación real, mapas, Routes API, Navigation SDK ni sincronización offline.

## 1. Usuarios y acceso

### RF-001 Inicio de sesión
- Usuario o correo.
- Contraseña.

### RF-002 Roles múltiples
Un usuario puede tener uno o varios roles:
- Administrador.
- Vendedor.
- Chofer.

### RF-003 Permisos
Los permisos reales se validarán en backend.

## 2. Clientes

### RF-100 Registrar cliente

Datos generales:
- ID.
- Nombre comercial.
- Razón social / nombre fiscal.
- Estado.
- Municipio.
- Dirección.
- Observaciones.

Datos comerciales:
- Descuento.
- Tiene crédito: sí/no.

Ubicación:
- Latitud opcional.
- Longitud opcional.
- Dirección escrita.
- Futuro: usar ubicación actual, seleccionar en mapa, abrir en Google Maps.

Clientes será la fuente de información operativa actualizada, porque los datos de la factura física pueden estar incompletos o desactualizados.

### RF-101 Contactos
Un cliente puede tener uno o varios contactos.

Clientes v1 permite capturar un contacto y mostrar la lista del modelo. Clientes v1.1 permitirá agregar nuevos contactos sin perder los existentes y mostrarlos todos.

Cada contacto:
- Nombre.
- Puesto o área.
- Teléfono.
- Correo.

### RF-102 Consultar clientes
- Listar.
- Buscar.
- Abrir detalle.
- Consultar contacto, ubicación y condiciones comerciales.

### RF-103 Editar cliente
Planificado para Clientes v1.1: modificar información existente desde el detalle, reutilizando el formulario cuando sea razonable y precargando datos. Conservar ID, coordenadas, contactos y compras existentes; actualizar la lista en memoria.

### RF-104 Eliminar cliente
Debe requerir autorización adecuada. Se evaluará eliminación lógica.

Fuera de Clientes v1.1.

### RF-105 Horario de recepción/entrega
Planificado para Clientes v1.1:
- Información estructurada por día de la semana, separada de observaciones.
- Distinguir horario desconocido, día en que no recibe e intervalo de recepción.
- Inicialmente un intervalo por día, con inicio anterior al fin.
- Permitir capturar y consultar el horario sin implementar aún cálculo de rutas.
- Horarios partidos, intervalos nocturnos y excepciones por fecha quedan para una ampliación futura, sin sobrecomplicar la primera implementación.

## 3. Compras — funcionalidad suspendida

`Purchase` y su visualización existente pueden permanecer temporalmente. No ampliar su funcionalidad ni convertirlo en Pedido. Registro de compras, compras recientes e historial completo de compras quedan suspendidos hasta decidir si son necesarios. Se conservan los identificadores RF para trazabilidad.

### RF-200 Registrar compra
Suspendido; no implementado.
- Cliente.
- Fecha.
- Monto.
- Número de factura opcional.

### RF-201 Consultar historial
Ampliaciones suspendidas:
- Última compra.
- Días desde última compra.
- Total mensual.
- Promedio mensual.
- Total anual.

## 4. Pedidos

### RF-300 Crear pedido
Un Pedido representa una factura que debe ser atendida o que históricamente fue atendida. Será principalmente una referencia a esa factura física y una unidad operativa para seguimiento, planificación de rutas y entrega, sin duplicar innecesariamente su contenido.

Campos iniciales propuestos para Pedidos v1 (no implementado):
- ID interno.
- Folio de factura.
- Cliente relacionado.
- Fecha.
- Estado.
- Observaciones operativas.
- Fecha prevista/programada de entrega, cuando corresponda.

No asumir que el folio es globalmente único. Las reglas de identificación y duplicados se definirán al diseñar Pedidos v1. Prioridades podrán considerarse posteriormente para rutas; su captura y reglas no están definidas todavía.

### RF-301 Estados
- Pendiente.
- Programado.
- En ruta.
- Entregado.
- Cancelado.

Estados base propuestos; no agregar otros sin necesidad funcional definida. Transiciones, entregas fallidas y reprogramaciones se definirán al diseñar Pedidos v1. Una entrega fallida no equivale a cancelar el pedido.

### RF-302 Detalle
Fuera del alcance actual: captura de productos, cantidades, precios, impuestos y demás conceptos o contenido de la factura. El folio permite localizar la factura física cuando se necesitan esos detalles. Se conserva este identificador para trazabilidad, sin compromiso de implementación.

### RF-303 Consulta e historial de pedidos/facturas
Planificado para Pedidos v1: consultar pedidos y, desde un cliente, localizar sus pedidos/facturas mostrando al menos folio, fecha y estado. El folio servirá para investigar una entrega histórica consultando la factura física.

## 5. Entregas

### RF-400 Ruta del chofer
Consultar:
- Ruta del día.
- Paradas.
- Clientes.
- Pedidos.
- Ubicaciones.
- Contactos.

### RF-401 Registrar entrega
Objetivo futuro; el tratamiento de intentos fallidos, su registro y la reprogramación quedan pendientes. No introducir automáticamente un estado adicional de Pedido por el resultado de un intento.
- Entregado / no entregado.
- Fecha.
- Hora.
- Observaciones.

Futuro:
- Firma.
- Foto.
- Evidencia.
- Coordenadas.

## 6. Rutas

### RF-500 Generar ruta
Los pedidos que requieren entrega serán utilizados para planificar rutas. Las reglas exactas de selección se definirán al diseñar Pedidos v1; no se fijan todavía estados específicos elegibles.

Un Pedido pertenece a un Cliente, que proporciona ubicación, contactos, horario y demás información actualizada. Pedidos no debe diseñarse como un módulo aislado de Clientes y Rutas.

Considerar:
- Ubicación actual.
- Pedidos que requieren entrega y su estado.
- Ubicación, contactos y horario de recepción del cliente.
- Prioridades cuando se definan.
- Tráfico y condiciones de ruta cuando exista conexión.
- Entregas completadas.

### RF-501 Orden de paradas
Routes API podrá ayudar a calcular el orden.

### RF-502 Replanificación
Recalcular cuando:
- Se completa una entrega.
- Cambia un pedido.
- Existe tráfico importante.
- Cambia la ubicación.
- Se aproxima una ventana de entrega.
- El usuario solicita recalcular.

### RF-503 Horarios
Clientes v1.1 capturará horarios estructurados según RF-105. Su utilización para determinar viabilidad de entregas y orden de paradas será futura; no se implementará lógica de planificación todavía.

### RF-504 Navegación
- Routes API: calcula/proporciona rutas.
- Navigation SDK: guía al chofer.
- Mi Ruta: decide la planificación de entregas y el orden de paradas mediante reglas de negocio.

Google Maps, Routes API y Navigation SDK son integraciones futuras, no autorizadas para el incremento actual.

## 7. Operación offline

### RF-600 Consulta offline
Datos previamente sincronizados:
- Clientes.
- Contactos.
- Pedidos.
- Ruta.
- Paradas.

### RF-601 Escritura offline
Permitir registrar:
- Entrega.
- No entrega.
- Observaciones.
- Estados operativos.

### RF-602 Última ruta válida
Si se pierde Internet, conservar la última ruta válida y actualizar localmente las paradas completadas.

## 8. Sincronización

### RF-700 Sincronización
- PostgreSQL = fuente oficial.
- SQLite = base local de trabajo.
- Flujo: PostgreSQL ↔ API ↔ SQLite ↔ Flutter.

### RF-701 Conflictos
Definir política antes de implementar sincronización avanzada.

## 9. Seguridad

### RF-800 Autenticación real
Backend; no guardar contraseñas en texto plano.

### RF-801 Autorización
Validación en backend.

### RF-802 Comunicación
HTTPS/TLS en producción.

### RF-803 Secretos
No guardar en repositorio:
- Contraseñas.
- Tokens.
- Secrets.
- Connection strings reales.
- API keys sin restricciones.

## 10. No funcionales

- Prioridad Android.
- Interfaz simple.
- Fácil de usar en campo.
- Buena respuesta con conectividad limitada.
- Código legible.
- Aplicación ligera para una gama amplia de dispositivos Android compatibles, incluidos gama baja y media.
- Preferir soluciones Flutter/Dart sin dependencias externas innecesarias ni optimizaciones complejas prematuras.
- Pruebas básicas.
- Git como historial.
