### Procedimientos y funciones almacenadas

## Introducción

En SQL Server, los procedimientos almacenados y las funciones son herramientas clave que permiten optimizar y organizar las operaciones que se realizan en una base de datos.

Los procedimientos almacenados se utilizan principalmente para ejecutar tareas específicas, como operaciones de inserción, actualización o eliminación de datos. Al encapsular varios pasos en un bloque de código reutilizable, se logra mayor seguridad y consistencia en el manejo de la información.

Por su parte, las funciones almacenadas permiten realizar cálculos o transformaciones de datos que se integran directamente en consultas SQL. Estas funciones devuelven un valor y se pueden invocar en un SELECT, WHERE o cualquier otra cláusula de consulta, facilitando la manipulación dinámica de la información sin modificar la estructura de la base de datos.

En el caso de estudio de la concesionaria MercedesHugo, se implementaron procedimientos y funciones que permiten automatizar operaciones habituales como registrar la compra/venta de vehículos, gestionar clientes y calcular datos relevantes de autos o personas.

## ¿Qué es un procedimiento almacenado?

Un procedimiento almacenado es un bloque de instrucciones T-SQL que se guarda en el servidor de bases de datos y se ejecuta bajo demanda. Son ideales para centralizar la lógica de negocio, garantizando la integridad de los datos y reduciendo la repetición de código en las aplicaciones que interactúan con la base de datos.

## Ejemplo de Procedimiento: Alta de Cliente
Este procedimiento encapsula la lógica de registrar un nuevo cliente en el sistema, evitando duplicaciones de código.

```sql
CREATE PROCEDURE CrearCliente
  @dni INT,
  @nombre NVARCHAR(50),
  @apellido NVARCHAR(50),
  @telefono NVARCHAR(20),
  @email NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Clientes (dni, nombre, apellido, telefono, email)
  VALUES (@dni, @nombre, @apellido, @telefono, @email);
END;
```
Con este procedimiento, se asegura que todos los registros de clientes se realicen de manera uniforme y segura.

## Ejemplo de Procedimiento: Registrar Venta de Vehículo
En una concesionaria, registrar una venta es una de las operaciones más frecuentes. Para ello se implementó un procedimiento que toma los datos del cliente, el vehículo y el monto de la transacción.

```sql
CREATE PROCEDURE RegistrarVenta
  @id_cliente INT,
  @id_vehiculo INT,
  @fecha DATE,
  @monto DECIMAL(12,2)
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO Ventas (id_cliente, id_vehiculo, fecha, monto)
  VALUES (@id_cliente, @id_vehiculo, @fecha, @monto);

  UPDATE Vehiculos
  SET estado = 'Vendido'
  WHERE id_vehiculo = @id_vehiculo;
END;
```
Este procedimiento no solo registra la venta, sino que además actualiza el estado del vehículo, asegurando consistencia en el inventario.

## ¿Qué es una función almacenada?

Una función almacenada es un objeto que recibe parámetros, realiza cálculos o consultas, y retorna un valor. A diferencia de los procedimientos, las funciones no pueden modificar datos en las tablas, pero sí son muy útiles para obtener información derivada.

## Ejemplo de Función: Calcular Antigüedad de un Vehículo

Permite calcular cuántos años pasaron desde el año de fabricación de un auto hasta la fecha actual.

```sql
CREATE FUNCTION CalcularAntiguedad (@anioFabricacion INT)
RETURNS INT
AS
BEGIN
  RETURN (YEAR(GETDATE()) - @anioFabricacion);
END;
```
Con esta función, en una consulta se puede obtener la antigüedad de cada vehículo:

```sql
SELECT modelo, anio_fabricacion, dbo.CalcularAntiguedad(anio_fabricacion) AS antiguedad
FROM Vehiculos;
```

## Ejemplo de Función: Calcular Edad de un Cliente
Facilita la obtención automática de la edad de los clientes en base a su fecha de nacimiento.

```sql
CREATE FUNCTION CalcularEdad (@fechaNacimiento DATE)
RETURNS INT
AS
BEGIN
  RETURN DATEDIFF(YEAR, @fechaNacimiento, GETDATE());
END;
```
Esto permite generar reportes con información actualizada de clientes:

```sql
SELECT nombre, apellido, dbo.CalcularEdad(fecha_nacimiento) AS edad
FROM Clientes;
```

## CONCLUSION

La implementación de procedimientos y funciones almacenadas en el sistema de la concesionaria MercedesHugo permitió estandarizar y automatizar tareas fundamentales como la gestión de clientes, vehículos y ventas. Gracias a los procedimientos, se logró centralizar la lógica de negocio y garantizar la consistencia de los datos, mientras que las funciones facilitaron la obtención de información derivada, como la edad de un cliente o la antigüedad de un vehículo. En conjunto, estas herramientas optimizan el rendimiento de la base de datos y brindan mayor seguridad y organización al trabajo diario, consolidándose como un componente esencial del proyecto.
