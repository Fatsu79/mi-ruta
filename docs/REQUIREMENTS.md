# Mi Ruta — Requerimientos funcionales

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
- Razón social / nombre de facturación.
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

### RF-101 Contactos
Un cliente puede tener uno o varios contactos.

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
Modificar información existente.

### RF-104 Eliminar cliente
Debe requerir autorización adecuada. Se evaluará eliminación lógica.

## 3. Historial de compras

### RF-200 Registrar compra
- Cliente.
- Fecha.
- Monto.
- Número de factura opcional.

### RF-201 Consultar historial
Futuro:
- Última compra.
- Días desde última compra.
- Total mensual.
- Promedio mensual.
- Total anual.

## 4. Pedidos

### RF-300 Crear pedido
- ID.
- Cliente.
- Fecha.
- Estado.
- Observaciones.
- Fecha de entrega.
- Prioridad opcional.

### RF-301 Estados
- Pendiente.
- Asignado.
- En ruta.
- Entregado.
- No entregado.
- Cancelado.

### RF-302 Detalle
- Producto / descripción.
- Cantidad.
- Unidad.
- Importe opcional.

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
Considerar:
- Ubicación actual.
- Clientes pendientes.
- Pedidos pendientes.
- Ubicaciones registradas.
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
Clientes podrán tener ventanas de recepción.

### RF-504 Navegación
- Routes API: calcula/proporciona rutas.
- Navigation SDK: guía al chofer.
- Mi Ruta: decide qué cliente conviene visitar mediante reglas de negocio.

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
- Pruebas básicas.
- Git como historial.
