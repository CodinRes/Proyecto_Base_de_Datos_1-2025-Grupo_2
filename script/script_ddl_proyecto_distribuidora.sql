create database distribuidora;
use distribuidora;

CREATE TABLE rol
(
  rol_id INT IDENTITY(1,1) NOT NULL,
  descripcion VARCHAR(25) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_rol PRIMARY KEY (rol_id),
  CONSTRAINT uq_rol_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_rol_descripcion CHECK (LTRIM(RTRIM(descripcion)) <> '')

);

CREATE TABLE marca
(
  marca_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (30) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_marca PRIMARY KEY (marca_id),
  CONSTRAINT uq_marca_nombre UNIQUE (nombre),
  CONSTRAINT ck_marca_nombre CHECK (LTRIM(RTRIM(nombre)) <> '')

);

CREATE TABLE familia
(
  familia_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (30) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_familia PRIMARY KEY (familia_id),
  CONSTRAINT uq_familia_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_familia_descripcion CHECK (LTRIM(RTRIM(descripcion)) <> ''),
  CONSTRAINT ck_familia_tipos CHECK (descripcion IN('Comidas', 'Bebidas', 'Lácteos', 'Higiene 
Personal', 'Bebidas alcohólicas', 'Cuidado Doméstico', 'Pilas–Velas–Encendedores'))
);

CREATE TABLE categoria_negocio
(
  categoria_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (30) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_categoria_negocio PRIMARY KEY (categoria_id),
  CONSTRAINT uq_categoria_negocio_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_categoria_negocio_descripcion CHECK (LTRIM(RTRIM(descripcion)) <> ''),
  CONSTRAINT ck_categoria_negocio_descrip CHECK (descripcion IN ('Pequeño', 'Mediano', 'Grande'))


);

CREATE TABLE estado
(
  estado_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (20) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_estado PRIMARY KEY (estado_id),
  CONSTRAINT uq_estado_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_estado_descripcion CHECK (descripcion IN ('Pendiente', 'En preparación', 'Entregado', 'Cancelado', 'Retrasado'))
);

CREATE TABLE metodo_pago
(
  metodo_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (20) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_metodo_pago PRIMARY KEY (metodo_id),
  CONSTRAINT uq_metodo_pago_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_metodo_pago_descripcion CHECK (descripcion IN ('Efectivo', 'Transferencia', 'Tarjeta Crédito', 'Tarjeta Débito'))

);

CREATE TABLE presentacion
(
  presentacion_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (30) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_presentacion PRIMARY KEY (presentacion_id),
  CONSTRAINT uq_presentacion_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_presentacion_descripcion CHECK (LTRIM(RTRIM(descripcion)) <> '')
);

CREATE TABLE accion
(
  accion_id INT IDENTITY (1,1) NOT NULL,
  descripcion VARCHAR (20) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_accion PRIMARY KEY (accion_id),
  CONSTRAINT uq_accion_descripcion UNIQUE (descripcion),
  CONSTRAINT ck_accion_descripcion CHECK (LTRIM(RTRIM(descripcion)) <> '')
);

CREATE TABLE entidad
(
  entidad_id INT IDENTITY (1,1) NOT NULL,
  nombre_entidad VARCHAR(25) COLLATE Latin1_General_CI_AI  NOT NULL,
  CONSTRAINT pk_entidad PRIMARY KEY (entidad_id),
  CONSTRAINT uq_entidad_nombre UNIQUE (nombre_entidad),
  CONSTRAINT ck_entidad_nombre CHECK (LTRIM(RTRIM(nombre_entidad)) <> '')
);

CREATE TABLE provincia
(
  provincia_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (30) COLLATE Latin1_General_CI_AI NOT NULL,
  CONSTRAINT pk_provincia PRIMARY KEY (provincia_id),
  CONSTRAINT ck_provincia_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
  CONSTRAINT uq_provincia_nombre UNIQUE (nombre)
);

CREATE TABLE usuario
(
  usuario_id INT IDENTITY (1,1) NOT NULL,  
  contraseña VARCHAR (450) NOT NULL,
  estado BIT NOT NULL DEFAULT 1,  
  nombre_usuario VARCHAR (20) NOT NULL,
  fecha_alta DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
  rol_id INT NOT NULL,
  CONSTRAINT pk_usuario PRIMARY KEY (usuario_id),
  CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES rol(rol_id),  
  CONSTRAINT fk_usuario_nombre_usuario UNIQUE (nombre_usuario)
);

CREATE TABLE zona
(
  zona_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (50) COLLATE Latin1_General_CI_AI NOT NULL,
  preventista INT NOT NULL,
  CONSTRAINT pk_zona PRIMARY KEY (zona_id),
  CONSTRAINT fk_zona_preventista FOREIGN KEY (preventista) REFERENCES usuario(usuario_id),
  CONSTRAINT uq_zona_preventista UNIQUE (preventista),
  CONSTRAINT uq_zona_nombre UNIQUE (nombre),
  CONSTRAINT ck_zona_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
);

CREATE TABLE producto
(
  producto_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (30) NOT NULL,
  familia_id INT NOT NULL,
  marca_id INT NOT NULL,
  CONSTRAINT pk_producto PRIMARY KEY (producto_id),
  CONSTRAINT fk_producto_familia FOREIGN KEY (familia_id) REFERENCES familia(familia_id),
  CONSTRAINT fk_producto_marca FOREIGN KEY (marca_id) REFERENCES marca(marca_id),
  CONSTRAINT ck_producto_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
  );

CREATE TABLE auditoria
(
  auditoria_id INT identity (1,1) NOT NULL,
  fecha_hora DATETIME NOT NULL CONSTRAINT df_auditoria_fecha_hora DEFAULT GETDATE(),
  valor_nuevo VARCHAR (40) NOT NULL,
  valor_anterior VARCHAR (40) NOT NULL,
  accion_id INT NOT NULL,
  entidad_id INT NOT NULL,
  usuario_id INT NOT NULL,
  CONSTRAINT pk_auditoria PRIMARY KEY (auditoria_id),
  CONSTRAINT fk_auditoria_accion FOREIGN KEY (accion_id) REFERENCES accion(accion_id),
  CONSTRAINT fk_auditoria_entidad FOREIGN KEY (entidad_id) REFERENCES entidad(entidad_id),
  CONSTRAINT ck_auditoria_fecha_hora CHECK(fecha_hora = GETDATE()),
  CONSTRAINT fk_auditoria_usuario_id FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
  CONSTRAINT uq_auditoria_usuario UNIQUE (usuario_id)
);

CREATE TABLE producto_presentacion
(
  
  producto_id INT NOT NULL,
  presentacion_id INT NOT NULL,
  cod_producto INT NOT NULL,
  precioLista DECIMAL (8,2) NOT NULL,
  unidades_bulto INT NOT NULL,  
  activo BIT NOT NULL CONSTRAINT df_producto_presentacion_activo DEFAULT 0,
  CONSTRAINT pk_producto_presentacion PRIMARY KEY (producto_id, presentacion_id),
  CONSTRAINT fk_producto_presentacion_producto FOREIGN KEY (producto_id) REFERENCES producto(producto_id),
  CONSTRAINT fk_producto_presentacion_presentacion FOREIGN KEY (presentacion_id) REFERENCES presentacion(presentacion_id),
  CONSTRAINT ck_producto_presentacion_precioLista CHECK (precioLista > 0 AND precioLista < 100000),
  CONSTRAINT ck_producto_presentacion_unidades_bulto CHECK (unidades_bulto > 0),
  CONSTRAINT uq_producto_presentacion UNIQUE (cod_producto)
);

CREATE TABLE empleado
(
  usuario_id INT NOT NULL,
  nombre VARCHAR (30) NOT NULL,
  apellido VARCHAR (30) NOT NULL,
  dni INT NOT NULL,
  email VARCHAR (50) NOT NULL,
  calle VARCHAR (30) NOT NULL,
  numero INT NOT NULL,
  telefono_movil BIGINT NOT NULL,  
  CONSTRAINT pk_empleado PRIMARY KEY (usuario_id),
  CONSTRAINT fk_empleado_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
  CONSTRAINT uq_empleado_email UNIQUE (email),
  CONSTRAINT uq_empleado_telefono_movil UNIQUE (telefono_movil),
  CONSTRAINT uq_empleado_dni UNIQUE (dni),
  CONSTRAINT ck_empleado_numero CHECK (numero > 0 AND numero < 100000),
  CONSTRAINT ck_empleado_dni CHECK (dni > 999999 AND dni <= 99999999),
  CONSTRAINT ck_empleado_email CHECK (email LIKE '_%@_%._%'),
  CONSTRAINT ck_empleado_telefono_movil CHECK (telefono_movil BETWEEN 1000000000 AND 999999999999),
  CONSTRAINT ck_empleado_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
  CONSTRAINT ck_empleado_apellido CHECK (LTRIM(RTRIM(apellido)) <> '')
);

CREATE TABLE stock
(
  stock_id INT IDENTITY (1,1) NOT NULL,
  producto_id INT NOT NULL,
  presentacion_id INT NOT NULL,  
  stock_actual INT NOT NULL DEFAULT 0,
  umbral_stock INT NOT NULL,
  CONSTRAINT pk_stock PRIMARY KEY (stock_id),
  CONSTRAINT fk_stock_producto FOREIGN KEY (producto_id, presentacion_id) REFERENCES producto_presentacion(producto_id, presentacion_id),
  CONSTRAINT uq_stock_producto UNIQUE (producto_id, presentacion_id),
  CONSTRAINT ck_stock_stock_actual CHECK (umbral_stock > 0),
);

CREATE TABLE ciudad
(
  ciudad_id INT NOT NULL,
  nombre VARCHAR (30) NOT NULL,
  provincia_id INT NOT NULL,
  CONSTRAINT pk_ciudad PRIMARY KEY (ciudad_id),
  CONSTRAINT fk_ciudad_provincia FOREIGN KEY (provincia_id) REFERENCES provincia(provincia_id),
  CONSTRAINT ck_ciudad_nombre CHECK (LTRIM(RTRIM(nombre)) <> '')
);

CREATE TABLE proveedor
(
  proveedor_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (40) NOT NULL,
  telefono BIGINT NOT NULL,
  email VARCHAR (50) NOT NULL,
  calle VARCHAR (30)NOT NULL,
  numero INT NOT NULL,
  cod_postal INT NOT NULL,
  cuit BIGINT NOT NULL,
  razon_social VARCHAR (40) NOT NULL,
  ciudad_id INT NOT NULL,
  CONSTRAINT pk_proveedor PRIMARY KEY (proveedor_id),
  CONSTRAINT fk_proveedor_ciudad FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id),
  CONSTRAINT uq_proveedor_email UNIQUE (email),
  CONSTRAINT uq_proveedor_cuit UNIQUE (cuit),
  CONSTRAINT ck_proveedor_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
  CONSTRAINT ck_proveedor_email CHECK (email LIKE '_%@_%._%'),
  CONSTRAINT ck_proveedor_telefono CHECK (telefono BETWEEN 1000000000 AND 999999999999),
  CONSTRAINT ck_proveedor_numero CHECK (numero > 0),
  CONSTRAINT ck_proveedor_cod_postal CHECK (cod_postal BETWEEN 1000 AND 9999),
  CONSTRAINT ck_proveedor_cuit CHECK (cuit BETWEEN 20000000000 AND 27999999999),
  CONSTRAINT ck_proveedor_razon_social CHECK (LTRIM(RTRIM(razon_social)) <> '')
);

CREATE TABLE cliente
(
  cliente_id INT IDENTITY (1,1) NOT NULL,
  nombre VARCHAR (25)NOT NULL,
  dni INT NOT NULL,
  telefono BIGINT NOT NULL,
  email VARCHAR (50) NOT NULL,
  calle VARCHAR (30) NOT NULL,
  numero INT NOT NULL,
  cod_postal INT NOT NULL,
  fecha_alta DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
  estado BIT NOT NULL,
  razon_social VARCHAR (50),
  condicion_frenteIVA VARCHAR (25) NOT NULL,
  cuil_cuit BIGINT NOT NULL,
  apellido VARCHAR (30) NOT NULL,
  zona_id INT NOT NULL,
  categoria_id INT NOT NULL,
  ciudad_id INT NOT NULL,
  CONSTRAINT pk_cliente PRIMARY KEY (cliente_id),
  CONSTRAINT fk_cliente_zona FOREIGN KEY (zona_id) REFERENCES zona(zona_id),
  CONSTRAINT fk_cliente_categoria FOREIGN KEY (categoria_id) REFERENCES categoria_negocio(categoria_id),
  CONSTRAINT fk_cliente_ciudad FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id),
  CONSTRAINT uq_cliente_dni UNIQUE (dni),
  CONSTRAINT uq_cliente_email UNIQUE (email),
  CONSTRAINT uq_cliente_cuil_cuit UNIQUE (cuil_cuit),
  CONSTRAINT ck_cliente_nombre CHECK (LTRIM(RTRIM(nombre)) <> ''),
  CONSTRAINT ck_cliente_apellido CHECK (LTRIM(RTRIM(apellido)) <> ''),
  CONSTRAINT ck_cliente_email CHECK (email LIKE '_%@_%._%'),
  CONSTRAINT ck_cliente_telefono CHECK (telefono BETWEEN 1000000000 AND 999999999999),
  CONSTRAINT ck_cliente_numero CHECK (numero > 0),
  CONSTRAINT ck_cliente_cod_postal CHECK (cod_postal BETWEEN 1000 AND 9999),
  CONSTRAINT ck_cliente_dni CHECK (dni BETWEEN 1000000 AND 99999999),
  CONSTRAINT ck_cliente_cuil_cuit CHECK (cuil_cuit BETWEEN 20000000000 AND 27999999999),
  CONSTRAINT ck_cliente_condicion_IVA CHECK (condicion_frenteIVA IN ('Responsable Inscripto', 'Exento', 'Monotributista', 'Consumidor Final', 'No Responsable')),
  CONSTRAINT ck_cliente_fecha_alta CHECK (fecha_alta = GETDATE())
);

CREATE TABLE pedido
(
  pedido_id INT NOT NULL,
  fecha_creacion DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
  monto DECIMAL (9,1) NOT NULL,
  nro_factura INT NOT NULL,
  cliente_id INT NOT NULL,
  estado_id INT NOT NULL,
  vendedor INT NOT NULL,
  CONSTRAINT pk_pedido PRIMARY KEY (pedido_id),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
  CONSTRAINT fk_pedido_estado FOREIGN KEY (estado_id) REFERENCES estado(estado_id),
  CONSTRAINT fk_pedido_vendedor FOREIGN KEY (vendedor) REFERENCES usuario(usuario_id),
  CONSTRAINT uq_pedido_nro_factura UNIQUE (nro_factura),
  CONSTRAINT ck_pedido_monto CHECK (monto > 0),
  CONSTRAINT ck_pedido_fecha CHECK (fecha_creacion = GETDATE())
);

CREATE TABLE detalle_pedido
(
  pedido_id INT NOT NULL,
  detalle_pedido_id INT IDENTITY (1,1) NOT NULL,
  cantidad_unidades INT,
  descuento DECIMAL(4,1) NOT NULL,  
  precio_unitario DECIMAL (8,2) NOT NULL,
  cantidad_bulto INT,  
  producto_id INT NOT NULL,
  presentacion_id INT NOT NULL,
  CONSTRAINT pk_detalle_pedido PRIMARY KEY (pedido_id, detalle_pedido_id),
  CONSTRAINT fk_detalle_pedido_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id),
  CONSTRAINT fk_detalle_pedido_producto FOREIGN KEY (producto_id, presentacion_id) REFERENCES producto_presentacion(producto_id, presentacion_id),
  CONSTRAINT ck_detalle_pedido_cantidad_unidades CHECK (cantidad_unidades > 0),
  CONSTRAINT ck_detalle_pedido_descuento CHECK (descuento BETWEEN 0 AND 100),
  CONSTRAINT ck_detalle_pedido_precio_unitario CHECK (precio_unitario > 0),
  CONSTRAINT ck_detalle_pedido_cantidad_bulto CHECK (cantidad_bulto >= 0)
);

CREATE TABLE cuenta_corriente
(
  cliente_id INT NOT NULL,
  saldo_actual DECIMAL(8,1) NOT NULL,
  fecha_ultimo_movimiento DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),  
  CONSTRAINT pk_cuenta_corriente PRIMARY KEY (cliente_id),
  CONSTRAINT fk_cuenta_corriente_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
  CONSTRAINT ck_cuenta_corriente_saldo CHECK (saldo_actual >= 0),
  CONSTRAINT ck_cuenta_corriente_fecha CHECK (fecha_ultimo_movimiento = GETDATE())
);

CREATE TABLE marca_proveedor
(
  marca_id INT NOT NULL,
  proveedor_id INT NOT NULL,
  CONSTRAINT pk_marca_proveedor PRIMARY KEY (marca_id, proveedor_id),
  CONSTRAINT fk_marca_proveedor_marca FOREIGN KEY (marca_id) REFERENCES marca(marca_id),
  CONSTRAINT fk_marca_proveedor_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedor(proveedor_id)
);

CREATE TABLE compra
(
  compra_id INT NOT NULL,
  fecha_compra DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
  monto_total DECIMAL (9,1) NOT NULL,
  nro_factura INT NOT NULL,
  proveedor_id INT NOT NULL,
  CONSTRAINT pk_compra PRIMARY KEY (compra_id),
  CONSTRAINT fk_compra_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedor(proveedor_id),
  CONSTRAINT uq_compra_nro_factura UNIQUE (nro_factura),
  CONSTRAINT ck_compra_monto CHECK (monto_total > 0),
  CONSTRAINT ck_compra_fecha CHECK (fecha_compra = GETDATE())
);

CREATE TABLE detalle_compra
(
  compra_id INT NOT NULL,
  detalle_id INT NOT NULL,
  cantidad_bulto INT NOT NULL,  
  precio_unitario DECIMAL(8,1) NOT NULL, 
  producto_id INT not null,
  presentacion_id INT NOT NULL,
  CONSTRAINT pk_detalle_compra PRIMARY KEY (compra_id, detalle_id),
  CONSTRAINT fk_detalle_compra_compra FOREIGN KEY (compra_id) REFERENCES compra(compra_id),
  CONSTRAINT fk_detalle_compra_producto_presentacion FOREIGN KEY (producto_id, presentacion_id) REFERENCES producto_presentacion(producto_id, presentacion_id),
  CONSTRAINT ck_detalle_compra_cantidad_bulto CHECK (cantidad_bulto > 0),
  CONSTRAINT ck_detalle_compra_precio_unitario CHECK (precio_unitario > 0)

);

CREATE TABLE pago
(
  pago_id INT NOT NULL,
  monto DECIMAL (8,1) NOT NULL,
  fecha DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
  metodo_id INT NOT NULL,
  cuenta_cte INT,
  CONSTRAINT pk_pago PRIMARY KEY (pago_id),
  CONSTRAINT fk_pago_metodo FOREIGN KEY (metodo_id) REFERENCES metodo_pago(metodo_id),
  CONSTRAINT fk_pago_cuenta_cte FOREIGN KEY (cuenta_cte) REFERENCES cuenta_corriente(cliente_id),
  CONSTRAINT ck_pago_monto CHECK (monto > 0),
  CONSTRAINT ck_pago_fecha CHECK (fecha = GETDATE())
);

CREATE TABLE pedido_pago
(
  saldo DECIMAL (8,1) NOT NULL,
  pedido_id INT NOT NULL,
  pago_id INT NOT NULL,
  CONSTRAINT pk_pedido_pago PRIMARY KEY (pedido_id, pago_id),
  CONSTRAINT fk_pedido_pago_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id),
  CONSTRAINT fk_pedido_pago_pago FOREIGN KEY (pago_id) REFERENCES pago(pago_id),
  CONSTRAINT ck_pedido_pago_saldo CHECK (saldo >= 0)
);