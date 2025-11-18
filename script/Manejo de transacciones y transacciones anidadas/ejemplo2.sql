SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
    @pedido_id INT = 1001,
    @cliente_id INT = 1,
    @estado_id INT = 1,
    @vendedor_id INT = 2,
    @producto_id INT = 1,
    @presentacion_id INT = 1,
    @cantidad_unidades INT = 120,
    @cantidad_bulto INT = 10,
    @precio_unitario DECIMAL(8,2) = 150.75,
    @descuento DECIMAL(4,1) = 5.0,
    @monto DECIMAL(9,1) = 1810.0,
    @nro_factura INT = 900001,
    @stock_actual INT;

BEGIN TRY
    BEGIN TRAN tran_pedido;

    INSERT INTO pedido (pedido_id, monto, nro_factura, cliente_id, estado_id, vendedor)
    VALUES (@pedido_id, @monto, @nro_factura, @cliente_id, @estado_id, @vendedor_id);

    SAVE TRAN sp_detalle;

    INSERT INTO detalle_pedido
    (
        pedido_id, cantidad_unidades, descuento,
        precio_unitario, cantidad_bulto,
        producto_id, presentacion_id
    )
    VALUES
    (
        @pedido_id, @cantidad_unidades, @descuento,
        @precio_unitario, @cantidad_bulto,
        @producto_id, @presentacion_id
    );

    SELECT @stock_actual = stock_actual
    FROM stock
    WHERE producto_id = @producto_id AND presentacion_id = @presentacion_id;

    IF @stock_actual IS NULL
    BEGIN
        ROLLBACK TRAN sp_detalle;
        THROW 50001, 'No existe stock para la combinación solicitada.', 1;
    END;

    IF @stock_actual < @cantidad_unidades
    BEGIN
        ROLLBACK TRAN sp_detalle;
        THROW 50002, 'Stock insuficiente para confirmar el pedido.', 1;
    END;

    UPDATE stock
    SET stock_actual = stock_actual - @cantidad_unidades
    WHERE producto_id = @producto_id AND presentacion_id = @presentacion_id;

    COMMIT TRAN tran_pedido;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRAN;
    THROW;
END CATCH;