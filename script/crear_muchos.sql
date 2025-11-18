-- =============================================
-- SCRIPT DE POBLACIÓN MASIVA PARA BASE DE DATOS DISTRIBUIDORA
-- Genera ~1 millón de registros por tabla para pruebas de rendimiento
-- =============================================

USE distribuidora;
GO

SET NOCOUNT ON;
GO

-- Desactivar constraints para mejor rendimiento
PRINT 'Desactivando constraints...';
EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- =============================================
-- TABLAS CATÁLOGO (menor volumen)
-- =============================================

-- ROL
PRINT 'Insertando roles...';
INSERT INTO rol (descripcion) VALUES 
('Administrador'), ('Vendedor'), ('Preventista'), 
('Gerente'), ('Supervisor');

-- MARCA (100,000 registros)
PRINT 'Insertando marcas...';
WITH Numbers AS (
    SELECT TOP 100000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO marca (nombre)
SELECT 'Marca_' + RIGHT('00000' + CAST(num AS VARCHAR(10)), 6)
FROM Numbers;

-- FAMILIA
PRINT 'Insertando familias...';
INSERT INTO familia (descripcion) VALUES 
('Comidas'), ('Bebidas'), ('Lácteos'), 
('Higiene Personal'), ('Bebidas alcohólicas'), 
('Cuidado Doméstico'), ('Pilas, Velas, Encendedores');

-- CATEGORIA_NEGOCIO
PRINT 'Insertando categorías...';
INSERT INTO categoria_negocio (descripcion) VALUES 
('Pequeño'), ('Mediano'), ('Grande');

-- ESTADO
PRINT 'Insertando estados...';
INSERT INTO estado (descripcion) VALUES 
('Pendiente'), ('En preparación'), ('Entregado'), 
('Cancelado'), ('Retrasado');

-- METODO_PAGO
PRINT 'Insertando métodos de pago...';
INSERT INTO metodo_pago (descripcion) VALUES 
('Efectivo'), ('Transferencia'), ('Tarjeta Crédito'), ('Tarjeta Débito');

-- PRESENTACION
PRINT 'Insertando presentaciones...';
WITH PresentacionesBase AS (
    SELECT * FROM (VALUES 
        ('Unidad'), ('Pack x6'), ('Pack x12'), ('Caja x24'),
        ('Botella 500ml'), ('Botella 1L'), ('Botella 2L'),
        ('Lata 350ml'), ('Sachet'), ('Bolsa 1kg')
    ) AS T(descripcion)
)
INSERT INTO presentacion (descripcion)
SELECT descripcion FROM PresentacionesBase;

-- ACCION
PRINT 'Insertando acciones...';
INSERT INTO accion (descripcion) VALUES 
('INSERT'), ('UPDATE'), ('DELETE'), ('SELECT');

-- ENTIDAD
PRINT 'Insertando entidades...';
INSERT INTO entidad (nombre_entidad) VALUES 
('usuario'), ('cliente'), ('producto'), ('pedido'), ('compra');

-- PROVINCIA (24 provincias argentinas)
PRINT 'Insertando provincias...';
INSERT INTO provincia (nombre) VALUES 
('Buenos Aires'), ('CABA'), ('Córdoba'), ('Santa Fe'), ('Mendoza'),
('Tucumán'), ('Salta'), ('Entre Ríos'), ('Misiones'), ('Chaco'),
('Corrientes'), ('Santiago del Estero'), ('San Juan'), ('Jujuy'),
('Río Negro'), ('Neuquén'), ('Formosa'), ('Chubut'), ('San Luis'),
('Catamarca'), ('La Rioja'), ('La Pampa'), ('Santa Cruz'), ('Tierra del Fuego');

-- =============================================
-- USUARIOS (50,000)
-- =============================================
PRINT 'Insertando usuarios...';
WITH Numbers AS (
    SELECT TOP 50000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO usuario (nombre_usuario, clave, estado, rol_id, fecha_alta)
SELECT 
    'usuario_' + RIGHT('00000' + CAST(num AS VARCHAR(10)), 6),
    'hash_' + CAST(num AS VARCHAR(50)),
    CASE WHEN num % 10 = 0 THEN 0 ELSE 1 END,
    (num % 5) + 1,
    DATEADD(DAY, -(num % 365), GETDATE())
FROM Numbers;

-- =============================================
-- ZONAS (10,000)
-- =============================================
PRINT 'Insertando zonas...';
WITH Numbers AS (
    SELECT TOP 10000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO zona (nombre, preventista)
SELECT 
    'Zona_' + RIGHT('00000' + CAST(num AS VARCHAR(10)), 6),
    num
FROM Numbers
WHERE num <= (SELECT COUNT(*) FROM usuario WHERE rol_id = 3);

-- =============================================
-- PRODUCTOS (500,000)
-- =============================================
PRINT 'Insertando productos...';
WITH Numbers AS (
    SELECT TOP 500000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO producto (nombre, familia_id, marca_id)
SELECT 
    'Producto_' + RIGHT('000000' + CAST(num AS VARCHAR(10)), 7),
    (num % 7) + 1,
    (num % 100000) + 1
FROM Numbers;

-- =============================================
-- PRODUCTO_PRESENTACION (1,000,000)
-- =============================================
PRINT 'Insertando producto_presentacion...';
WITH Numbers AS (
    SELECT TOP 1000000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO producto_presentacion (producto_id, presentacion_id, cod_producto, precioLista, unidades_bulto, activo)
SELECT 
    ((num - 1) % 500000) + 1,
    ((num - 1) % 10) + 1,
    num,
    CAST((RAND(CHECKSUM(NEWID())) * 9000 + 1000) AS DECIMAL(8,2)),
    (num % 24) + 1,
    CASE WHEN num % 10 <= 8 THEN 1 ELSE 0 END
FROM Numbers;

-- =============================================
-- CIUDADES (10,000)
-- =============================================
PRINT 'Insertando ciudades...';
WITH Numbers AS (
    SELECT TOP 10000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO ciudad (ciudad_id, nombre, provincia_id)
SELECT 
    num,
    'Ciudad_' + RIGHT('00000' + CAST(num AS VARCHAR(10)), 6),
    (num % 24) + 1
FROM Numbers;

-- =============================================
-- EMPLEADOS (10,000)
-- =============================================
PRINT 'Insertando empleados...';
WITH Numbers AS (
    SELECT TOP 10000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO empleado (usuario_id, nombre, apellido, dni, email, calle, numero, telefono_movil)
SELECT 
    num,
    'Nombre_' + CAST(num AS VARCHAR(10)),
    'Apellido_' + CAST(num AS VARCHAR(10)),
    10000000 + num,
    'empleado' + CAST(num AS VARCHAR(10)) + '@empresa.com',
    'Calle_' + CAST(num AS VARCHAR(10)),
    (num % 9999) + 1,
    1100000000 + num
FROM Numbers
WHERE num <= (SELECT COUNT(*) FROM usuario);

-- =============================================
-- PROVEEDORES (5,000)
-- =============================================
PRINT 'Insertando proveedores...';
WITH Numbers AS (
    SELECT TOP 5000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO proveedor (nombre, telefono, email, calle, numero, cod_postal, cuit, razon_social, ciudad_id)
SELECT 
    'Proveedor_' + RIGHT('0000' + CAST(num AS VARCHAR(10)), 5),
    1140000000 + num,
    'proveedor' + CAST(num AS VARCHAR(10)) + '@proveedor.com',
    'Calle_' + CAST(num AS VARCHAR(10)),
    (num % 9999) + 1,
    (num % 8999) + 1000,
    20000000000 + num,
    'Razon_Social_' + CAST(num AS VARCHAR(10)),
    (num % 10000) + 1
FROM Numbers;

-- =============================================
-- CLIENTES (1,000,000)
-- =============================================
PRINT 'Insertando clientes (esto puede tomar varios minutos)...';

DECLARE @batchSize INT = 10000;
DECLARE @counter INT = 0;
DECLARE @totalClientes INT = 1000000;

WHILE @counter < @totalClientes
BEGIN
    WITH Numbers AS (
        SELECT TOP (@batchSize) 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @counter as num
        FROM sys.all_columns a CROSS JOIN sys.all_columns b
    )
    INSERT INTO cliente (nombre, apellido, dni, telefono, email, calle, numero, 
                         cod_postal, estado, razon_social, condicion_frenteIVA, 
                         cuil_cuit, zona_id, categoria_id, ciudad_id, fecha_alta)
    SELECT 
        'Cliente_' + CAST(num AS VARCHAR(10)),
        'Apellido_' + CAST(num AS VARCHAR(10)),
        1000000 + (num % 98999999),
        1150000000 + (num % 999999999),
        'cliente' + CAST(num AS VARCHAR(10)) + '@mail.com',
        'Calle_' + CAST(num AS VARCHAR(10)),
        (num % 9999) + 1,
        (num % 8999) + 1000,
        CASE WHEN num % 10 = 0 THEN 0 ELSE 1 END,
        CASE WHEN num % 3 = 0 THEN 'Comercio_' + CAST(num AS VARCHAR(10)) ELSE NULL END,
        CASE (num % 5)
            WHEN 0 THEN 'Responsable Inscripto'
            WHEN 1 THEN 'Monotributista'
            WHEN 2 THEN 'Consumidor Final'
            WHEN 3 THEN 'Exento'
            ELSE 'No Responsable'
        END,
        20000000000 + num,
        (num % 10000) + 1,
        (num % 3) + 1,
        (num % 10000) + 1,
        DATEADD(DAY, -(num % 1825), GETDATE())
    FROM Numbers;
    
    SET @counter = @counter + @batchSize;
    
    IF @counter % 100000 = 0
        PRINT 'Insertados ' + CAST(@counter AS VARCHAR(10)) + ' clientes...';
END

-- =============================================
-- STOCK (500,000)
-- =============================================
PRINT 'Insertando stock...';
WITH ProductosActivos AS (
    SELECT producto_id, presentacion_id, 
           ROW_NUMBER() OVER (ORDER BY producto_id, presentacion_id) as rn
    FROM producto_presentacion
    WHERE activo = 1
)
INSERT INTO stock (producto_id, presentacion_id, stock_actual, umbral_stock)
SELECT TOP 500000
    producto_id,
    presentacion_id,
    ABS(CHECKSUM(NEWID())) % 1000,
    ABS(CHECKSUM(NEWID())) % 50 + 10
FROM ProductosActivos;

-- =============================================
-- PEDIDOS (1,000,000)
-- =============================================
PRINT 'Insertando pedidos (esto puede tomar varios minutos)...';

SET @counter = 0;
SET @batchSize = 10000;
DECLARE @totalPedidos INT = 1000000;

WHILE @counter < @totalPedidos
BEGIN
    WITH Numbers AS (
        SELECT TOP (@batchSize) 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @counter as num
        FROM sys.all_columns a CROSS JOIN sys.all_columns b
    )
    INSERT INTO pedido (pedido_id, fecha_creacion, monto, nro_factura, cliente_id, estado_id, vendedor)
    SELECT 
        num,
        DATEADD(DAY, -(num % 730), GETDATE()),
        CAST((RAND(CHECKSUM(NEWID())) * 90000 + 10000) AS DECIMAL(9,1)),
        num,
        (num % 1000000) + 1,
        (num % 5) + 1,
        (num % 50000) + 1
    FROM Numbers;
    
    SET @counter = @counter + @batchSize;
    
    IF @counter % 100000 = 0
        PRINT 'Insertados ' + CAST(@counter AS VARCHAR(10)) + ' pedidos...';
END

-- =============================================
-- DETALLE_PEDIDO (3,000,000 - promedio 3 items por pedido)
-- =============================================
PRINT 'Insertando detalles de pedido (esto puede tomar varios minutos)...';

SET @counter = 0;
SET @batchSize = 10000;
DECLARE @totalDetalles INT = 3000000;

WHILE @counter < @totalDetalles
BEGIN
    WITH Numbers AS (
        SELECT TOP (@batchSize) 
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @counter as num
        FROM sys.all_columns a CROSS JOIN sys.all_columns b
    )
    INSERT INTO detalle_pedido (pedido_id, cantidad_unidades, descuento, precio_unitario, 
                                cantidad_bulto, producto_id, presentacion_id)
    SELECT 
        ((num - 1) / 3) + 1,
        (num % 100) + 1,
        CAST((num % 20) AS DECIMAL(4,1)),
        CAST((RAND(CHECKSUM(NEWID())) * 9000 + 1000) AS DECIMAL(8,2)),
        (num % 10) + 1,
        (num % 500000) + 1,
        (num % 10) + 1
    FROM Numbers;
    
    SET @counter = @counter + @batchSize;
    
    IF @counter % 100000 = 0
        PRINT 'Insertados ' + CAST(@counter AS VARCHAR(10)) + ' detalles...';
END

-- =============================================
-- COMPRAS (100,000)
-- =============================================
PRINT 'Insertando compras...';
WITH Numbers AS (
    SELECT TOP 100000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO compra (compra_id, fecha_compra, monto_total, nro_factura, proveedor_id)
SELECT 
    num,
    DATEADD(DAY, -(num % 730), GETDATE()),
    CAST((RAND(CHECKSUM(NEWID())) * 490000 + 10000) AS DECIMAL(9,1)),
    num,
    (num % 5000) + 1
FROM Numbers;

-- =============================================
-- CUENTA_CORRIENTE (500,000)
-- =============================================
PRINT 'Insertando cuentas corrientes...';
WITH Numbers AS (
    SELECT TOP 500000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as num
    FROM sys.all_columns a CROSS JOIN sys.all_columns b
)
INSERT INTO cuenta_corriente (cliente_id, saldo_actual, fecha_ultimo_movimiento)
SELECT 
    num,
    CAST((RAND(CHECKSUM(NEWID())) * 99999) AS DECIMAL(8,1)),
    DATEADD(DAY, -(num % 365), GETDATE())
FROM Numbers;

-- =============================================
-- REACTIVAR CONSTRAINTS
-- =============================================
PRINT 'Reactivando constraints...';
EXEC sp_msforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';

-- Reconstruir índices
PRINT 'Reconstruyendo índices...';
EXEC sp_msforeachtable 'ALTER INDEX ALL ON ? REBUILD';

-- Actualizar estadísticas
PRINT 'Actualizando estadísticas...';
EXEC sp_updatestats;

PRINT '=============================================';
PRINT 'POBLACIÓN COMPLETADA EXITOSAMENTE';
PRINT '=============================================';

-- Mostrar conteos
PRINT 'Conteo de registros por tabla:';
SELECT 'marca' as Tabla, COUNT(*) as Registros FROM marca UNION ALL
SELECT 'producto', COUNT(*) FROM producto UNION ALL
SELECT 'producto_presentacion', COUNT(*) FROM producto_presentacion UNION ALL
SELECT 'usuario', COUNT(*) FROM usuario UNION ALL
SELECT 'empleado', COUNT(*) FROM empleado UNION ALL
SELECT 'cliente', COUNT(*) FROM cliente UNION ALL
SELECT 'proveedor', COUNT(*) FROM proveedor UNION ALL
SELECT 'pedido', COUNT(*) FROM pedido UNION ALL
SELECT 'detalle_pedido', COUNT(*) FROM detalle_pedido UNION ALL
SELECT 'compra', COUNT(*) FROM compra UNION ALL
SELECT 'stock', COUNT(*) FROM stock UNION ALL
SELECT 'cuenta_corriente', COUNT(*) FROM cuenta_corriente
ORDER BY Registros DESC;

SET NOCOUNT OFF;
GO