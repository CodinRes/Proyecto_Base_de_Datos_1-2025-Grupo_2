# Proyecto de Estudio: (Título/Nombre Proyecto)

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Integrantes**:

- Samuel Zini
- Gaston
- Mercedes
- Hugo elias

**Año**: 2025

## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio

El objetivo de este trabajo es especificar, diseñar e implementar una base de datos relacional inspirada en Chess ERP, adaptada a un alcance reducido y con fines académicos para la asignatura Base de Datos 1 de la carrera Licenciatura en Sistemas de Información (Facultad de Ciencias Exactas, Naturales y Agrimensura, Universidad Nacional del Nordeste). El sistema funcionará sobre un servidor de bases de datos local y deberá cubrir las siguientes funcionalidades y requisitos:

### Definición o planteamiento del problema

El diseño final debe priorizar la práctica de conceptos de bases de datos vistos en la materia (modelo concpetual, modelo entidad-relación, normalización hasta 3FN, integridad referencial, restricciones, índices, consultas SQL, vistas, procedimientos, transacciones y otros conceptos).

### Objetivo del Trabajo Práctico

#### Objetivos Generales

Ejecutar los conceptos teoricos y practicos aprendidos en las clases y examenes parciales de la asginatura.

#### Objetivos Específicos

Objetivo funcional: soportar la gestión básica de un negocio de venta de productos mediante módulos de administración de productos, gestión de clientes y preventistas, procesamiento de ventas/pedidos y generación de reportes administrativos.

## CAPITULO II: MARCO CONCEPTUAL O REFERENCIAL

En la actualidad, resulta difícil pensar en la gestión empresarial sin el apoyo de sistemas informáticos que automaticen procesos clave. La administración de clientes, productos, ventas e inventarios requiere cada vez más soluciones integradas que permitan reducir errores, agilizar operaciones y disponer de información confiable en tiempo real. Estas necesidades han impulsado la creación de herramientas que unifican la gestión en un único sistema, con el fin de mejorar la eficiencia operativa y la competitividad de las organizaciones.

Dentro de este contexto, los sistemas ERP (Enterprise Resource Planning) se han posicionado como una de las principales alternativas de solución. Estos sistemas permiten centralizar la información de distintas áreas de una empresa en una misma base de datos, evitando duplicidad de registros y facilitando la toma de decisiones estratégicas. Gracias a ello, procesos que antes se llevaban en planillas separadas o de manera manual ahora se encuentran interrelacionados y gestionados desde una plataforma centralizada.

El papel de las bases de datos relacionales resulta esencial en este escenario. Motores como SQL Server permiten almacenar y procesar grandes volúmenes de datos estructurados, garantizando la integridad, la consistencia y la seguridad de la información. La organización en tablas con claves primarias y foráneas posibilita modelar entidades como clientes, productos, pedidos y proveedores, reflejando de forma lógica las relaciones del mundo real. Además, al permitir consultas eficientes mediante SQL, se facilita el acceso a datos confiables y actualizados para la gestión diaria.

Nuestro caso de estudio —desarrollado en el repositorio MercedesHugo— se orienta a la implementación de un sistema bajo una arquitectura en capas, un modelo de diseño ampliamente utilizado en el desarrollo de software empresarial. La arquitectura está organizada en cuatro niveles principales:

Capa de Entidades: Representa los objetos centrales de la aplicación, como Clientes, Productos, Proveedores o Pedidos. Estas entidades funcionan como el puente entre el modelo de datos y el resto del sistema.

Capa de Datos: Gestiona la comunicación con la base de datos. En este nivel se definen las consultas, procedimientos y operaciones CRUD necesarias para almacenar y recuperar información.

Capa de Negocio: Contiene la lógica y las reglas de negocio de la aplicación. Aquí se realizan validaciones, cálculos y procesos que aseguran que las operaciones se ejecuten correctamente según las necesidades de la organización.

Capa de Presentación: Es la interfaz gráfica que interactúa directamente con el usuario final. Su objetivo es ofrecer una experiencia simple y clara, permitiendo que los procesos empresariales sean ejecutados de forma intuitiva.

El uso de esta arquitectura multicapa no solo mejora la organización del proyecto, sino que también facilita la escalabilidad y el mantenimiento del sistema. En caso de que la empresa desee incorporar nuevos módulos, como facturación electrónica o gestión de logística, estos pueden añadirse sin afectar el resto de la aplicación, lo que brinda flexibilidad y asegura la evolución del software en el tiempo.

Asimismo, la integración de SQL Server con el sistema garantiza que los datos se manejen de manera segura y eficiente. Este motor de base de datos no solo ofrece herramientas para mantener la integridad referencial, sino que también incorpora funciones avanzadas como transacciones, procedimientos almacenados y vistas, que fortalecen la consistencia y fiabilidad de la información empresarial.

## CAPÍTULO III: METODOLOGÍA SEGUIDA

Donec lobortis tincidunt erat, non egestas mi volutpat in. Cras ante purus, luctus sed fringilla non, ullamcorper at eros.

 **a) Cómo se realizó el Trabajo Práctico**
Vestibulum rutrum feugiat molestie. Nunc id varius augue. Ut augue mauris, venenatis et lacus ut, mattis blandit urna. Fusce lobortis, quam non vehicula scelerisque, nisi enim ultrices diam, ac tristique libero ex nec orci.

 **b) Herramientas (Instrumentos y procedimientos)**
Donec lobortis tincidunt erat, non egestas mi volutpat in. Cras ante purus, luctus sed fringilla non, ullamcorper at eros. Integer interdum id orci id rutrum. Curabitur facilisis lorem sed metus interdum accumsan.

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS

Maecenas molestie lacus tincidunt, placerat dolor et, ullamcorper erat. Mauris tortor nisl, ultricies ac scelerisque nec, feugiat in nibh. Pellentesque interdum aliquam magna sit amet rutrum.

### Diagrama conceptual (opcional)

Ejemplo usando Live Editor <https://mermaid.js.org/> (ejemplo opcional)

```mermaid
erDiagram
CUSTOMER  }|..|{  DELIVERY-ADDRESS  : has
CUSTOMER  ||--o{  ORDER  : places
CUSTOMER  ||--o{  INVOICE  : "liable for"
DELIVERY-ADDRESS  ||--o{  ORDER  : receives
INVOICE  ||--|{  ORDER  : covers
ORDER  ||--|{  ORDER-ITEM  : includes
PRODUCT-CATEGORY  ||--|{  PRODUCT  : contains
PRODUCT  ||--o{  ORDER-ITEM  : "ordered in"
```

### Diagrama relacional

![diagrama_relacional](https://github.com/dovillegas/basesdatos_proyecto_estudio/blob/main/doc/image_relational.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

### Desarrollo TEMA 1 "----"

Fusce auctor finibus lectus, in aliquam orci fermentum id. Fusce sagittis lacus ante, et sodales eros porta interdum. Donec sed lacus et eros condimentum posuere.

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_1](script/tema01_nombre_tema)

### Desarrollo TEMA 2 "----"

Proin aliquet mauris id ex venenatis, eget fermentum lectus malesuada. Maecenas a purus arcu. Etiam pellentesque tempor dictum.

> Acceder a la siguiente carpeta para la descripción completa del tema [scripts-> tema_2](script/tema02_nombre_tema)

...

## CAPÍTULO V: CONCLUSIONES

Nunc sollicitudin purus quis ante sodales luctus. Proin a scelerisque libero, vitae pharetra lacus. Nunc finibus, tellus et dictum semper, nisi sem accumsan ligula, et euismod quam ex a tellus.

## BIBLIOGRAFÍA DE CONSULTA

 1. List item
 2. List item
 3. List item
 4. List item
 5. List item
