#  TRIGGERS

##  Caso de estudio  

El objetivo de esta sección es documentar y proveer **triggers** para el proyecto (dominio de distribuidora: `Producto`, `Stock`, `Venta` / `DetalleVenta`, `Proveedor`, etc.).  
Los triggers se utilizan para **auditar cambios** y **hacer cumplir reglas de negocio**, como actualizar stock al vender o impedir borrados físicos.

---

##  Definición  

Un **trigger** es un objeto de base de datos que se ejecuta automáticamente ante operaciones `INSERT`, `UPDATE` o `DELETE` sobre una tabla.  
En este proyecto (SQL Server / T-SQL) se emplean para:

- Registrar valores *antes de un cambio* (auditoría).  
- Mantener integridad derivada (por ejemplo, descontar stock).  
- Evitar acciones no permitidas (por ejemplo, *soft-delete* en `Proveedor`).

---

##  Buenas prácticas adoptadas  

- **Nombres:** `TRG_<Tabla>_<Acción>_<Propósito>`  
- **Operar por conjuntos:** no asumir una sola fila afectada.  
- **Registrar:** fecha, usuario y tipo de operación.  
- **Validar:** reglas de negocio y cancelar transacciones cuando corresponda.  

---

##  Tablas de soporte (Auditoría)  

Estas tablas almacenan los valores anteriores a un `UPDATE` o `DELETE`.  
Ajustar tipos o columnas si el DDL del proyecto difiere.

```sql
-- Auditoría de cambios en Producto
IF OBJECT_ID('dbo.AuditoriaProducto') IS NULL
BEGIN
  CREATE TABLE dbo.AuditoriaProducto (
    id_auditoria     INT IDENTITY(1,1) PRIMARY KEY,
    id_producto      INT NOT NULL,
    descripcion_old  NVARCHAR(200) NULL,
    precio_old       DECIMAL(12,2) NULL,
    id_marca_old     INT NULL,
    fecha_evento     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    usuario_db       SYSNAME   NOT NULL DEFAULT SUSER_SNAME(),
    operacion        CHAR(6)   NOT NULL CHECK (operacion IN ('UPDATE','DELETE'))
  );
END;
GO

```
##  Ejemplos de TRIGGERS

### 1) Auditoría en **Producto** (UPDATE)
Guarda los valores previos cuando se actualizan campos relevantes.

```sql
CREATE OR ALTER TRIGGER dbo.TRG_Producto_UPDATE_Auditoria
ON dbo.Producto
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.AuditoriaProducto
    (id_producto, descripcion_old, precio_old, id_marca_old, operacion)
  SELECT d.id_producto, d.descripcion, d.precio, d.id_marca, 'UPDATE'
  FROM deleted d
  JOIN inserted i ON i.id_producto = d.id_producto
  WHERE (ISNULL(i.descripcion,'') <> ISNULL(d.descripcion,''))
     OR (ISNULL(i.precio,0)      <> ISNULL(d.precio,0))
     OR (ISNULL(i.id_marca,0)    <> ISNULL(d.id_marca,0));
END;
GO
```

### 2) Auditoría en Producto (DELETE)
Registra la información antes de eliminar un producto.

```sql
CREATE OR ALTER TRIGGER dbo.TRG_Producto_DELETE_Auditoria
ON dbo.Producto
AFTER DELETE
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.AuditoriaProducto
    (id_producto, descripcion_old, precio_old, id_marca_old, operacion)
  SELECT d.id_producto, d.descripcion, d.precio, d.id_marca, 'DELETE'
  FROM deleted d;
END;
GO
```

## 3) Actualización de Stock al insertar en DetalleVenta
Descuenta automáticamente el stock de los productos vendidos.
Si el resultado es negativo, revierte la transacción.
```sql
CREATE OR ALTER TRIGGER dbo.TRG_DetalleVenta_INSERT_DescuentaStock
ON dbo.DetalleVenta
AFTER INSERT
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE s
  SET s.cantidad = s.cantidad - i.cantidad
  FROM dbo.Stock s
  JOIN inserted i ON i.id_producto = s.id_producto;

  IF EXISTS (SELECT 1 FROM dbo.Stock WHERE cantidad < 0)
  BEGIN
    UPDATE s
    SET s.cantidad = s.cantidad + i.cantidad
    FROM dbo.Stock s
    JOIN inserted i ON i.id_producto = s.id_producto;

    RAISERROR(N'Operación inválida: stock insuficiente para la venta.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END
END;
GO
```

## 4) Soft-delete en Proveedor
Evita el borrado físico y marca la columna activo = 0.
```sql
CREATE OR ALTER TRIGGER dbo.TRG_Proveedor_INSTEADOF_DELETE_Soft
ON dbo.Proveedor
INSTEAD OF DELETE
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE p
  SET p.activo = 0
  FROM dbo.Proveedor p
  JOIN deleted d ON d.id_proveedor = p.id_proveedor;
END;
GO
```

### Cómo probar los triggers

```sql
-- 1) Cambiar productos → genera registros en AuditoriaProducto
UPDATE dbo.Producto
SET precio = precio * 1.05
WHERE id_producto IN (1,2);

-- 2) Insertar ventas → descuenta stock y valida
INSERT INTO dbo.DetalleVenta (id_venta, id_producto, cantidad, precio)
VALUES (1,1,2,1500.00),(1,2,1,2200.00);

-- 3) Borrado lógico de proveedor
DELETE FROM dbo.Proveedor WHERE id_proveedor = 10;

-- 4) Consultar auditorías
SELECT TOP 10 * FROM dbo.AuditoriaProducto ORDER BY fecha_evento DESC;

```

