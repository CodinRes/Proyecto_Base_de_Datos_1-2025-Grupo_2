USE distribuidora;
GO

-- =============================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =============================================

-- 1. TABLA: rol
INSERT INTO rol (descripcion) VALUES 
('Administrador'),
('Vendedor'),
('Preventista'),
('Supervisor'),
('Almacenero');

-- 2. TABLA: marca
INSERT INTO marca (nombre) VALUES 
('Coca Cola'),
('Quilmes'),
('Arcor'),
('Marolio'),
('Molinos'),
('La Serenísima'),
('Sedal'),
('Ayudín'),
('Duracell'),
('Bimbo');

-- 3. TABLA: familia (valores restringidos por CHECK)
INSERT INTO familia (descripcion) VALUES 
('Comidas'),
('Bebidas'),
('Lácteos'),
('Higiene Personal'),
('Bebidas alcohólicas'),
('Cuidado Doméstico'),
('Pilas, Velas, Encendedores');

-- 4. TABLA: categoria_negocio (valores restringidos por CHECK)
INSERT INTO categoria_negocio (descripcion) VALUES 
('Pequeño'),
('Mediano'),
('Grande');

-- 5. TABLA: estado (valores restringidos por CHECK)
INSERT INTO estado (descripcion) VALUES 
('Pendiente'),
('En preparación'),
('Entregado'),
('Cancelado'),
('Retrasado');

-- 6. TABLA: metodo_pago (valores restringidos por CHECK)
INSERT INTO metodo_pago (descripcion) VALUES 
('Efectivo'),
('Transferencia'),
('Tarjeta Crédito'),
('Tarjeta Débito');

-- 7. TABLA: presentacion
INSERT INTO presentacion (descripcion) VALUES 
('Botella 500ml'),
('Botella 1L'),
('Botella 2L'),
('Pack x6'),
('Pack x12'),
('Caja x24'),
('Unidad'),
('Bolsa 1kg'),
('Botella 750ml'),
('Lata 355ml');

-- 8. TABLA: accion
INSERT INTO accion (descripcion) VALUES 
('INSERT'),
('UPDATE'),
('DELETE'),
('LOGIN'),
('LOGOUT');

-- 9. TABLA: entidad
INSERT INTO entidad (nombre_entidad) VALUES 
('usuario'),
('cliente'),
('producto'),
('pedido'),
('compra'),
('stock'),
('empleado'),
('proveedor');

-- 10. TABLA: provincia
INSERT INTO provincia (nombre) VALUES 
('Buenos Aires'),
('Córdoba'),
('Santa Fe'),
('Mendoza'),
('Tucumán');

-- 11. TABLA: usuario
INSERT INTO usuario (clave, estado, nombre_usuario, rol_id) VALUES 
('hash_clave_admin123', 1, 'admin', 1),
('hash_clave_vend001', 1, 'vendedor1', 2),
('hash_clave_vend002', 1, 'vendedor2', 2),
('hash_clave_prev001', 1, 'preventista1', 3),
('hash_clave_prev002', 1, 'preventista2', 3),
('hash_clave_super001', 1, 'supervisor1', 4),
('hash_clave_alma001', 1, 'almacenero1', 5);

-- 12. TABLA: zona
INSERT INTO zona (nombre, preventista) VALUES 
('Zona Norte', 4),
('Zona Sur', 5);

-- 13. TABLA: producto
INSERT INTO producto (nombre, familia_id, marca_id) VALUES 
('Coca Cola Regular', 2, 1),
('Coca Cola Zero', 2, 1),
('Cerveza Quilmes Clásica', 5, 2),
('Arroz Fino', 1, 5),
('Fideos Mostachol', 1, 4),
('Leche Entera', 3, 6),
('Yogur Natural', 3, 6),
('Shampoo Sedal', 4, 7),
('Lavandina', 6, 8),
('Pilas AA', 7, 9),
('Pan Lactal', 1, 10),
('Alfajores Triple', 1, 3);

-- 14. TABLA: producto_presentacion
INSERT INTO producto_presentacion (producto_id, presentacion_id, cod_producto, precioLista, unidades_bulto, activo) VALUES 
(1, 3, 10001, 1200.50, 6, 1),  -- Coca Cola 2L
(1, 1, 10002, 650.00, 12, 1),  -- Coca Cola 500ml
(2, 3, 10003, 1250.00, 6, 1),  -- Coca Zero 2L
(3, 10, 10004, 580.00, 24, 1), -- Cerveza Quilmes lata
(3, 9, 10005, 850.00, 12, 1),  -- Cerveza Quilmes 750ml
(4, 8, 10006, 890.00, 10, 1),  -- Arroz 1kg
(5, 7, 10007, 420.00, 20, 1),  -- Fideos unidad
(6, 2, 10008, 780.00, 12, 1),  -- Leche 1L
(7, 7, 10009, 350.00, 24, 1),  -- Yogur unidad
(8, 7, 10010, 1850.00, 6, 1),  -- Shampoo
(9, 2, 10011, 920.00, 6, 1),   -- Lavandina 1L
(10, 4, 10012, 3200.00, 10, 1), -- Pilas pack x6
(11, 7, 10013, 1450.00, 10, 1), -- Pan Lactal
(12, 4, 10014, 2800.00, 12, 1); -- Alfajores pack x6

-- 15. TABLA: empleado
INSERT INTO empleado (usuario_id, nombre, apellido, dni, email, calle, numero, telefono_movil) VALUES 
(1, 'Juan', 'Pérez', 35123456, 'juan.perez@distribuidora.com', 'San Martín', 1234, 541112345678),
(2, 'María', 'González', 28456789, 'maria.gonzalez@distribuidora.com', 'Belgrano', 567, 541123456789),
(3, 'Carlos', 'Rodríguez', 32987654, 'carlos.rodriguez@distribuidora.com', 'Mitre', 890, 541134567890),
(4, 'Ana', 'Martínez', 30456123, 'ana.martinez@distribuidora.com', 'Rivadavia', 2345, 541145678901),
(5, 'Pedro', 'López', 29789456, 'pedro.lopez@distribuidora.com', 'Sarmiento', 678, 541156789012),
(6, 'Laura', 'Fernández', 33654987, 'laura.fernandez@distribuidora.com', 'Alsina', 901, 541167890123),
(7, 'Diego', 'Sánchez', 31321654, 'diego.sanchez@distribuidora.com', 'Moreno', 1567, 541178901234);

-- 16. TABLA: stock
INSERT INTO stock (producto_id, presentacion_id, stock_actual, umbral_stock) VALUES 
(1, 3, 150, 50),   -- Coca Cola 2L
(1, 1, 300, 100),  -- Coca Cola 500ml
(2, 3, 80, 30),    -- Coca Zero 2L
(3, 10, 200, 80),  -- Cerveza lata
(3, 9, 120, 40),   -- Cerveza 750ml
(4, 8, 180, 60),   -- Arroz
(5, 7, 250, 100),  -- Fideos
(6, 2, 200, 80),   -- Leche
(7, 7, 150, 50),   -- Yogur
(8, 7, 90, 30),    -- Shampoo
(9, 2, 100, 40),   -- Lavandina
(10, 4, 60, 20),   -- Pilas
(11, 7, 120, 50),  -- Pan
(12, 4, 80, 30);   -- Alfajores

-- 17. TABLA: ciudad
INSERT INTO ciudad (ciudad_id, nombre, provincia_id) VALUES 
(1, 'La Plata', 1),
(2, 'Mar del Plata', 1),
(3, 'Córdoba Capital', 2),
(4, 'Rosario', 3),
(5, 'Santa Fe Capital', 3),
(6, 'Mendoza Capital', 4),
(7, 'San Miguel de Tucumán', 5);

-- 18. TABLA: proveedor
INSERT INTO proveedor (nombre, telefono, email, calle, numero, cod_postal, cuit, razon_social, ciudad_id) VALUES 
('Distribuidora Bebidas SA', 541145678900, 'ventas@bebidas.com.ar', 'Av. Industrial', 1500, 1900, 20304050607, 'Distribuidora Bebidas SA', 1),
('Alimentos del Sur SRL', 541156789011, 'contacto@alimentossur.com', 'Ruta 2 Km 45', 2300, 7600, 20405060708, 'Alimentos del Sur SRL', 2),
('Lácteos Premium SA', 543514567890, 'ventas@lacteospremium.com', 'Av. Colón', 3456, 5000, 20506070809, 'Lácteos Premium SA', 3),
('Higiene Total SA', 543414567891, 'info@higienetotal.com.ar', 'Bv. Oroño', 2789, 2000, 20607080910, 'Higiene Total SA', 4);

-- 19. TABLA: cliente
INSERT INTO cliente (nombre, dni, telefono, email, calle, numero, cod_postal, estado, razon_social, condicion_frenteIVA, cuil_cuit, apellido, zona_id, categoria_id, ciudad_id) VALUES 
('Roberto', 25123456, 541198765432, 'roberto.gomez@kiosco.com', 'Av. Libertad', 456, 1900, 1, 'Kiosco El Rápido', 'Monotributista', 20251234569, 'Gómez', 1, 1, 1),
('Silvana', 27456789, 541187654321, 'silvana.ruiz@minimarket.com', 'Calle 50', 1234, 1900, 1, 'Minimarket Central', 'Responsable Inscripto', 27274567893, 'Ruiz', 1, 2, 1),
('Fernando', 30789456, 542234567890, 'fernando.diaz@supermercado.com', 'Av. Constitución', 2567, 7600, 1, 'Supermercado La Económica', 'Responsable Inscripto', 20307894564, 'Díaz', 2, 3, 2),
('Patricia', 29654321, 543415678901, 'patricia.torres@almacen.com', 'San Juan', 890, 5000, 1, NULL, 'Consumidor Final', 27296543212, 'Torres', 1, 1, 3),
('Gustavo', 31987654, 543426789012, 'gustavo.morales@despensa.com', 'Belgrano', 345, 2000, 1, 'Despensa Don Gustavo', 'Monotributista', 20319876545, 'Morales', 2, 2, 4);

-- 20. TABLA: pedido
-- Nota: Las fechas con DEFAULT GETDATE() y CHECK se insertan sin especificar la fecha
INSERT INTO pedido (pedido_id, monto, nro_factura, cliente_id, estado_id, vendedor) VALUES 
(1, 25800.5, 100001, 1, 3, 2),  -- Entregado
(2, 48500.0, 100002, 2, 3, 2),  -- Entregado
(3, 125600.0, 100003, 3, 1, 3), -- Pendiente
(4, 8900.5, 100004, 4, 2, 2),   -- En preparación
(5, 67200.0, 100005, 5, 1, 3);  -- Pendiente

-- 21. TABLA: detalle_pedido
INSERT INTO detalle_pedido (pedido_id, cantidad_unidades, descuento, precio_unitario, cantidad_bulto, producto_id, presentacion_id) VALUES 
-- Pedido 1
(1, 12, 0, 1200.50, 2, 1, 3),    -- 2 bultos Coca 2L
(1, 24, 5.0, 580.00, 1, 3, 10),  -- 1 bulto Cerveza lata
-- Pedido 2
(2, 18, 0, 1200.50, 3, 1, 3),    -- 3 bultos Coca 2L
(2, 20, 0, 420.00, 1, 5, 7),     -- Fideos
(2, 12, 10.0, 780.00, 1, 6, 2),  -- Leche
-- Pedido 3
(3, 48, 5.0, 1200.50, 8, 1, 3),  -- 8 bultos Coca 2L
(3, 72, 5.0, 580.00, 3, 3, 10),  -- Cerveza
(3, 100, 10.0, 420.00, 5, 5, 7), -- Fideos
-- Pedido 4
(4, 10, 0, 890.00, 1, 4, 8),     -- Arroz
-- Pedido 5
(5, 60, 8.0, 650.00, 5, 1, 1),   -- Coca 500ml
(5, 48, 8.0, 580.00, 2, 3, 10);  -- Cerveza

-- 22. TABLA: cuenta_corriente
INSERT INTO cuenta_corriente (cliente_id, saldo_actual) VALUES 
(1, 0),
(2, 5000.0),
(3, 15000.5),
(4, 0),
(5, 8500.0);

-- 23. TABLA: marca_proveedor
INSERT INTO marca_proveedor (marca_id, proveedor_id) VALUES 
(1, 1),  -- Coca Cola - Distribuidora Bebidas
(2, 1),  -- Quilmes - Distribuidora Bebidas
(3, 2),  -- Arcor - Alimentos del Sur
(4, 2),  -- Marolio - Alimentos del Sur
(5, 2),  -- Molinos - Alimentos del Sur
(6, 3),  -- La Serenísima - Lácteos Premium
(7, 4),  -- Sedal - Higiene Total
(8, 4);  -- Ayudín - Higiene Total

-- 24. TABLA: compra
INSERT INTO compra (compra_id, monto_total, nro_factura, proveedor_id) VALUES 
(1, 185000.0, 50001, 1),
(2, 95000.0, 50002, 2),
(3, 45000.0, 50003, 3);

-- 25. TABLA: detalle_compra
INSERT INTO detalle_compra (compra_id, detalle_id, cantidad_bulto, precio_unitario, producto_id, presentacion_id) VALUES 
-- Compra 1 - Bebidas
(1, 1, 50, 900.0, 1, 3),   -- Coca 2L
(1, 2, 30, 450.0, 3, 10),  -- Cerveza lata
-- Compra 2 - Alimentos
(2, 1, 40, 650.0, 4, 8),   -- Arroz
(2, 2, 50, 300.0, 5, 7),   -- Fideos
-- Compra 3 - Lácteos
(3, 1, 60, 600.0, 6, 2),   -- Leche
(3, 2, 40, 250.0, 7, 7);   -- Yogur

-- 26. TABLA: pago
INSERT INTO pago (pago_id, monto, metodo_id, cuenta_cte) VALUES 
(1, 25800.5, 1, NULL),  -- Efectivo - Pedido 1
(2, 48500.0, 2, NULL),  -- Transferencia - Pedido 2
(3, 8900.5, 1, NULL);   -- Efectivo - Pedido 4

-- 27. TABLA: pedido_pago
INSERT INTO pedido_pago (saldo, pedido_id, pago_id) VALUES 
(0, 1, 1),     -- Pedido 1 pagado completo
(0, 2, 2),     -- Pedido 2 pagado completo
(0, 4, 3);     -- Pedido 4 pagado completo

-- 28. TABLA: auditoria (solo un ejemplo, el CONSTRAINT con GETDATE() puede ser problemático)
-- Nota: Esta tabla tiene un CHECK (fecha_hora = GETDATE()) que hará que sea difícil insertar datos
-- Se comenta ya que solo funcionaría en el momento exacto de la inserción
/*
INSERT INTO auditoria (valor_nuevo, valor_anterior, accion_id, entidad_id, usuario_id) VALUES 
('activo=1', 'activo=0', 2, 1, 1);
*/

GO

-- =============================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =============================================

PRINT '=== VERIFICACIÓN DE INSERCIONES ==='
PRINT 'Roles: ' + CAST((SELECT COUNT(*) FROM rol) AS VARCHAR(10))
PRINT 'Marcas: ' + CAST((SELECT COUNT(*) FROM marca) AS VARCHAR(10))
PRINT 'Productos: ' + CAST((SELECT COUNT(*) FROM producto) AS VARCHAR(10))
PRINT 'Clientes: ' + CAST((SELECT COUNT(*) FROM cliente) AS VARCHAR(10))
PRINT 'Pedidos: ' + CAST((SELECT COUNT(*) FROM pedido) AS VARCHAR(10))
PRINT 'Stock items: ' + CAST((SELECT COUNT(*) FROM stock) AS VARCHAR(10))
PRINT '==================================='