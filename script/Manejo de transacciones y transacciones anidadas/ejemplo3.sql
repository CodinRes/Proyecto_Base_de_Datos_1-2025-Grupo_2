SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
    @compra_id INT = 5001,
    @proveedor_id INT = 1,
    @producto_id INT = 1,
    @presentacion_id INT = 1,
    @detalle_id INT = 1,
    @cantidad_bulto INT = 50,
    @precio_unitario DECIMAL(8,1) = 80.5,
    @monto_total DECIMAL(9,1) = 4025.0,
    @nro_factura INT = 700001,
    @umbral INT = 30;

BEGIN TRY
    BEGIN TRAN tran_compra WITH MARK 'Sincronizar compras y stock';

    INSERT INTO compra (compra_id, monto_total, nro_factura, proveedor_id)
    VALUES (@compra_id, @monto_total, @nro_factura, @proveedor_id);

    INSERT INTO detalle_compra
    (
        compra_id, detalle_id, cantidad_bulto,
        precio_unitario, producto_id, presentacion_id
    )
    VALUES
    (
        @compra_id, @detalle_id, @cantidad_bulto,
        @precio_unitario, @producto_id, @presentacion_id
    );

    MERGE stock AS tgt
    USING (SELECT @producto_id AS producto_id, @presentacion_id AS presentacion_id) AS src
    ON tgt.producto_id = src.producto_id AND tgt.presentacion_id = src.presentacion_id
    WHEN MATCHED THEN
        UPDATE SET stock_actual = stock_actual + @cantidad_bulto
    WHEN NOT MATCHED THEN
        INSERT (producto_id, presentacion_id, stock_actual, umbral_stock)
        VALUES (@producto_id, @presentacion_id, @cantidad_bulto, @umbral);

    COMMIT TRAN tran_compra;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN tran_compra;
    THROW;
END CATCH;