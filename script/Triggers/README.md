# 🧩 TRIGGERS

## 📘 Caso de estudio  

El objetivo de esta sección es documentar y proveer **triggers** para el proyecto (dominio de distribuidora: `Producto`, `Stock`, `Venta` / `DetalleVenta`, `Proveedor`, etc.).  
Los triggers se utilizan para **auditar cambios** y **hacer cumplir reglas de negocio**, como actualizar stock al vender o impedir borrados físicos.

---

## 🧠 Definición  

Un **trigger** es un objeto de base de datos que se ejecuta automáticamente ante operaciones `INSERT`, `UPDATE` o `DELETE` sobre una tabla.  
En este proyecto (SQL Server / T-SQL) se emplean para:

- Registrar valores *antes de un cambio* (auditoría).  
- Mantener integridad derivada (por ejemplo, descontar stock).  
- Evitar acciones no permitidas (por ejemplo, *soft-delete* en `Proveedor`).

---

## ⚙️ Buenas prácticas adoptadas  

- **Nombres:** `TRG_<Tabla>_<Acción>_<Propósito>`  
- **Operar por conjuntos:** no asumir una sola fila afectada.  
- **Registrar:** fecha, usuario y tipo de operación.  
- **Validar:** reglas de negocio y cancelar transacciones cuando corresponda.  

---

## 🗄️ Tablas de soporte (Auditoría)  

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

