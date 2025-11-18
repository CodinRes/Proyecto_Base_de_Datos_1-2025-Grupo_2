USE distribuidora;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cliente_zona_categoria') --crear si no existe ya el indice del mismo nombre
BEGIN-- comenzar transaccion, una transaccion es un bloque de instrucciones que se ejecutan como una sola unidad y si falla, se revierten todas las operaciones
    CREATE NONCLUSTERED INDEX IX_cliente_zona_categoria -- crear indice no agrupado con nombre especifico
        ON dbo.cliente (zona_id, categoria_id) -- especificar tabla y columnas para el indice
        INCLUDE (estado, ciudad_id, condicion_frenteIVA); -- columnas adicionales para incluir en el indice y optimizar consultas
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cliente_ciudad')
BEGIN
    CREATE NONCLUSTERED INDEX IX_cliente_ciudad
        ON dbo.cliente (ciudad_id)
        INCLUDE (apellido, nombre, telefono);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_pedido_cliente_estado')
BEGIN
    CREATE NONCLUSTERED INDEX IX_pedido_cliente_estado
        ON dbo.pedido (cliente_id, estado_id)
        INCLUDE (fecha_creacion, monto, vendedor);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_pedido_estado_fecha')
BEGIN
    CREATE NONCLUSTERED INDEX IX_pedido_estado_fecha
        ON dbo.pedido (estado_id, fecha_creacion)
        INCLUDE (cliente_id, monto);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_detalle_pedido_producto')
BEGIN
    CREATE NONCLUSTERED INDEX IX_detalle_pedido_producto
        ON dbo.detalle_pedido (producto_id, presentacion_id)
        INCLUDE (pedido_id, cantidad_unidades, precio_unitario);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_producto_presentacion_producto')
BEGIN
    CREATE NONCLUSTERED INDEX IX_producto_presentacion_producto
        ON dbo.producto_presentacion (producto_id)
        INCLUDE (presentacion_id, precioLista, activo);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_pago_cuenta_fecha')
BEGIN
    CREATE NONCLUSTERED INDEX IX_pago_cuenta_fecha
        ON dbo.pago (cuenta_cte, fecha)
        INCLUDE (monto, metodo_id);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_cuenta_corriente_fecha')
BEGIN
    CREATE NONCLUSTERED INDEX IX_cuenta_corriente_fecha
        ON dbo.cuenta_corriente (fecha_ultimo_movimiento)
        INCLUDE (saldo_actual);
END
GO