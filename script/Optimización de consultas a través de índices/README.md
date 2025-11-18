# Optimización de consultas a través de índices

## ¿Qué es un índice?

Un índice es una estructura de disco asociada con una tabla o una vista que acelera la recuperación de filas. Contiene claves generadas a partir de una o varias columnas y se almacena en un árbol B, lo que permite buscar filas de forma rápida y eficiente.

## Tipos de índices

Una tabla o vista puede contener varios tipos de índices:

### Índice *clustered*

- Ordena y almacena las filas de datos según los valores de la clave del índice, es decir, las columnas incluidas en su definición.
- Solo puede existir un índice clustered por tabla porque los datos pueden almacenarse físicamente de una única forma.
- Las tablas con índice clustered se denominan tablas agrupadas; las tablas sin él almacenan las filas en un montón no ordenado.

### Índice *nonclustered*

- Tiene una estructura separada de las filas de datos y contiene los valores de clave junto con un puntero a la fila correspondiente.
- El puntero (localizador de fila) depende de si los datos están en un montón (puntero físico) o en una tabla agrupada (clave del índice clustered).
- Se pueden agregar columnas sin clave al nivel hoja para cubrir consultas completas o evitar límites de longitud de clave.

### Índices únicos

- Pueden ser clustered o nonclustered.
- Garantizan que dos filas no compartan el mismo valor de clave; si no son únicos, varias filas pueden repetir la clave.
- SQL Server mantiene automáticamente los índices cuando cambian los datos de la tabla o vista.

## Índices y restricciones

- SQL Server crea índices automáticamente al definir restricciones `PRIMARY KEY` y `UNIQUE`.
- Una restricción `UNIQUE` genera un índice nonclustered.
- Una `PRIMARY KEY` crea un índice clustered, a menos que ya exista uno; en tal caso, se crea un índice nonclustered para la clave primaria.

## Uso de índices por el optimizador de consultas

- Índices bien diseñados reducen E/S de disco y consumo de recursos, mejorando el rendimiento de consultas `SELECT`, `UPDATE`, `DELETE` y `MERGE`.
- Si no hay un índice útil, el optimizador recurre a un recorrido completo de la tabla (table scan), lo cual puede ser costoso si devuelve pocas filas.
- Cuando utiliza un índice, el optimizador busca en las columnas clave, obtiene la ubicación de las filas necesarias y recupera solo las filas coincidentes, lo que suele ser más rápido porque el índice tiene pocas columnas y está ordenado.
- Diseñe y cree índices adecuados para ofrecer al optimizador múltiples opciones eficientes y evitar recorridos innecesarios.

## Creación de un índice clúster

### ¿Cuándo usarlo?

Puede crear índices agrupados con SQL Server Management Studio (SSMS) o Transact-SQL. Con pocas excepciones, cada tabla debería contar con un índice clúster porque:

- Mejora el rendimiento de consultas y operaciones de ordenamiento.
- Permite recompilar o reorganizar la estructura para controlar la fragmentación.
- Puede aplicarse tanto a tablas como a vistas.

### Implementaciones típicas (índice clúster)

- **Restricciones PRIMARY KEY y UNIQUE**: al crear una `PRIMARY KEY`, SQL Server genera un índice clúster único si la tabla aún no tiene uno (la clave primaria no admite `NULL`). Las restricciones `UNIQUE` crean por defecto índices nonclustered, pero es posible forzar que sean clustered cuando no exista uno previo. El índice hereda el nombre de la restricción.
- **Índice independiente**: si la clave primaria es nonclustered, puede definirse manualmente un índice clúster sobre otra columna para optimizar el acceso físico.

### Limitaciones y consideraciones

- Durante la creación se necesitan dos copias: la estructura origen y la destino; se libera la anterior solo al confirmar la transacción.
- Si la tabla (montón) ya tiene índices nonclustered, todos deben reconstruirse para incluir la clave clustered. Lo contrario ocurre al eliminar el clustered.
- En tablas grandes conviene crear primero el índice clúster y luego los nonclustered, preferentemente con la opción `ONLINE = ON` para minimizar bloqueos.
- La clave clustered no debe incluir columnas `VARCHAR` con datos en `ROW_OVERFLOW_DATA`; de otro modo, fallarán inserciones o actualizaciones que generen desbordes.

### Requisitos de permisos para índices clúster

Se requiere permiso `ALTER` sobre la tabla o vista. Normalmente lo poseen membresías `sysadmin`, `db_owner` o `db_ddladmin`.

### Procedimientos en SQL Server Management Studio (clúster)

#### Desde el Explorador de objetos

1. Expanda la base de datos y la tabla destino.
2. Abra la carpeta `Índices`, haga clic derecho y elija `Nuevo índice > Índice agrupado...`.
3. Asigne un nombre en el campo **Nombre de índice**.
4. Seleccione **Agregar** en **Columnas de clave de índice** y marque las columnas clave.
5. Confirme con **Aceptar** y guarde los cambios.

#### Mediante el Diseñador de tablas

1. Cree o abra la tabla en modo diseño.
2. En el menú **Diseñador de tablas**, elija **Índices o claves** y pulse **Agregar**.
3. Seleccione el nuevo índice, configure las columnas deseadas y establezca **Crear como agrupado = Sí**.
4. Cierre el cuadro de diálogo y guarde la tabla.

### Ejemplo en Transact-SQL (clúster)

```sql
USE AdventureWorks2022;
GO

CREATE TABLE dbo.TestTable (
    TestCol1 INT NOT NULL,
    TestCol2 NCHAR(10) NULL,
    TestCol3 NVARCHAR(50) NULL
);
GO

CREATE CLUSTERED INDEX IX_TestTable_TestCol1
    ON dbo.TestTable (TestCol1);
GO
```

## Creación de índices no agrupados

### Descripción general

Un índice nonclustered es independiente de los datos físicos de la tabla. Reordena una o más columnas seleccionadas y puede cubrir consultas completas o apuntar rápidamente a las filas subyacentes. Es habitual crear varios índices nonclustered para consultas frecuentes no cubiertas por el índice clúster o en tablas tipo montón.

### Implementaciones típicas (índice nonclustered)

- **Restricciones UNIQUE**: generan automáticamente un índice nonclustered único, salvo que se solicite explícitamente un clustered y no exista otro.
- **Índices independientes**: de manera predeterminada, `CREATE INDEX` produce índices nonclustered. Una tabla puede tener hasta 999 de ellos (sin contar índices XML).
- **Vistas indizadas**: tras definir un índice clúster único sobre la vista, pueden añadirse nonclustered para optimizar consultas.

### Requisitos de permisos para índices no agrupados

También requieren permiso `ALTER` sobre la tabla o vista (roles `sysadmin`, `db_owner` o `db_ddladmin`).

### Procedimientos en SQL Server Management Studio (nonclustered)

#### Con el Diseñador de tablas

1. Abra la base de datos y la tabla deseada en modo diseño.
2. En la columna objetivo, seleccione **Índices o claves**.
3. Pulse **Agregar**, configure las columnas de clave y establezca **Crear como agrupado = No**.
4. Cierre el cuadro de diálogo y guarde la tabla.

#### Con el Explorador de objetos

1. Expanda la base de datos, la tabla y la carpeta `Índices`.
2. Clic derecho en `Índices` > `Nuevo índice > Índice no agrupado...`.
3. Defina el nombre y agregue las columnas clave necesarias.
4. Guarde la definición seleccionando **Aceptar**.

### Ejemplo en Transact-SQL (nonclustered)

```sql
USE AdventureWorks2022;
GO

IF EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_ProductVendor_VendorID'
)
    DROP INDEX IX_ProductVendor_VendorID ON Purchasing.ProductVendor;
GO

CREATE NONCLUSTERED INDEX IX_ProductVendor_VendorID
    ON Purchasing.ProductVendor (BusinessEntityID);
GO
```

## Pruebas

En las siguientes imágenes se puede ver la diferencia en eficiencia al realizar una consulta con y sin índice nonclustered sobre la tabla `cliente` con 1.000.000 de filas insertadas con el script [Optimización de consultas a través de índices](../crear_muchos.sql) y con el [ejemplo de índices](./indices.sql).

La consulta utilizada fue:

```sql
SELECT  [cliente_id]
      , [zona_id]
      , [categoria_id]
      , [ciudad_id]
FROM [dbo].[cliente];
```

como se podrá ver en las diferencias entre las imágenes, el Costo de E/S estimado, Costo de operador estimado, Costo de subárbol estimado en la examinación de Clustered Index Scan y el Costo de subárbol estimado en SELECT son mayores, mientras que en Nivel de optimización en SELECT dice FULL sin el índice, y TRIVIAL con el índice colocado. Los costos de ejecución estimados en Index Scan (NonClustered) son menores.

### Sin índice nonclustered

![prueba sin índice](./Prueba%20de%20SELECT%20sin%20indices.png)

En este caso el optimizador utiliza un Clustered Index Scan sobre la clave primaria pk_cliente. Como no existe un índice específico que contenga las columnas de la consulta, debe recorrer todo el índice clustered, que tiene todas las columnas de la fila.
Esto produce:

Nivel de optimización: FULL, el optimizador debe explorar más alternativas de plan.
Costo de E/S estimado, costo de operador y costo de subárbol estimado más altos, porque se leen más páginas de datos (filas más “anchas”).

### Con índice nonclustered

![prueba con índice](./Prueba%20de%20SELECT%20con%20indices.png)

Con este índice el optimizador puede resolver la consulta leyendo solo el índice nonclustered, cuya estructura es más liviana (menos columnas) que el índice clustered. El plan cambia a un Index Scan (NonClustered) y se observan las siguientes diferencias:

Nivel de optimización: TRIVIAL, el optimizador detecta rápidamente que usar este índice es la mejor opción, sin necesidad de una búsqueda compleja de planes.
Menor Costo de E/S estimado, costo de operador estimado y costo de subárbol estimado, porque las páginas del índice nonclustered contienen menos datos por fila.
Aunque en la prueba la consulta devuelve 1.000.000 de filas (no hay WHERE), y por eso el tiempo total de ejecución es similar, el motor considera más barato leer un índice nonclustered que el índice clustered completo.

De acuerdo con la teoría, si la consulta tuviera filtros selectivos sobre las columnas indexadas (por ejemplo WHERE zona_id = 5 AND categoria_id = 2), el optimizador podría usar un Index Seek en lugar de un Scan, leyendo solo una parte del índice y reduciendo mucho más la E/S y el tiempo de respuesta.

## Referencias

<https://learn.microsoft.com/es-es/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/relational-databases/indexes/create-clustered-indexes?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/relational-databases/indexes/create-nonclustered-indexes?view=sql-server-ver17>
