SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @cliente_id INT;

BEGIN TRY
    BEGIN TRAN tran_alta_cliente;

    INSERT INTO cliente
    (
        nombre, dni, telefono, email, calle, numero, cod_postal, estado,
        razon_social, condicion_frenteIVA, cuil_cuit, apellido,
        zona_id, categoria_id, ciudad_id
    )
    VALUES
    (
        'Maximiliano', 30111222, 1122334455, 'maxi@ejemplo.com', 'San Martín', 123, 1700, 1,
        'Maxi Mayorista SRL', 'Responsable Inscripto', 20999888777, 'Pérez',
        1, 1, 1
    );

    SET @cliente_id = SCOPE_IDENTITY();

    INSERT INTO cuenta_corriente (cliente_id, saldo_actual)
    VALUES (@cliente_id, 0.0);

    COMMIT TRAN tran_alta_cliente;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN tran_alta_cliente;
    THROW;
END CATCH;