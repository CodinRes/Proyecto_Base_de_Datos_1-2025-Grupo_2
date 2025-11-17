# Transacciones en SQL Server (Resumen práctico)

Una transacción es una unidad atómica de trabajo: o se confirma por completo (COMMIT) o se revierte (ROLLBACK). Su objetivo es mantener la integridad y consistencia de los datos.

## Modos de transacción

- **Auto-commit**: cada instrucción es una transacción.
- **Explícitas**: `BEGIN TRANSACTION` … `COMMIT`/`ROLLBACK`.
- **Implícitas**: `SET IMPLICIT_TRANSACTIONS ON`; inicia nuevas transacciones automáticamente, pero requieren `COMMIT`/`ROLLBACK` explícito.
- **Ámbito por lotes (MARS)**: en sesiones MARS; SQL Server revierte automáticamente si el lote termina sin confirmar.

## BEGIN TRANSACTION

Inicia una transacción local explícita.

```sql
BEGIN { TRAN | TRANSACTION }
    [ { transaction_name | @tran_name_variable }
      [ WITH MARK [ 'description' ] ]
    ];
```

Puntos clave:

- **Contador**: incrementa `@@TRANCOUNT` en 1.
- **Registro**: no se escribe en el log hasta que hay DML (`INSERT`/`UPDATE`/`DELETE`).
- **Bloqueos**: los recursos quedan bloqueados según el nivel de aislamiento hasta `COMMIT`/`ROLLBACK`.
- **Nombres**: solo el nombre de la transacción más externa es relevante; los internos son guía para el programador.
- **Escalado a distribuida**: si hay tablas remotas o RPC con `REMOTE_PROC_TRANSACTIONS ON`, la transacción se promueve y la coordina MS DTC.
- **Implícitas**: con `IMPLICIT_TRANSACTIONS ON`, un `BEGIN TRANSACTION` crea dos niveles anidados.

Transacciones marcadas (`WITH MARK`):

- **Uso**: marca con nombre en el log para recuperación consistente entre bases relacionadas.
- **Requisito**: solo se marca si la transacción modifica datos.
- **Anidación**: una marca interna redefine el nombre de marca; marcar una ya marcada emite advertencia.

Ejemplo mínimo:

```sql
BEGIN TRANSACTION;
    DELETE FROM HumanResources.JobCandidate WHERE JobCandidateID = 13;
COMMIT; -- o ROLLBACK;
```

## BEGIN DISTRIBUTED TRANSACTION

Inicia una transacción distribuida coordinada por MS DTC.

```sql
BEGIN DISTRIBUTED { TRAN | TRANSACTION }
    [ transaction_name | @tran_name_variable ];
```

Puntos clave:

- **Origen**: la instancia que ejecuta `BEGIN DISTRIBUTED TRANSACTION` coordina la confirmación/rollback.
- **Inscripción remota**: servidores remotos participan vía procedimientos remotos o consultas distribuidas.
- **Promoción**: una transacción local se promueve automáticamente si ejecuta consulta/operación distribuida compatible.
- **Aislamiento**: snapshot isolation no admite transacciones distribuidas.

## COMMIT TRANSACTION

Finaliza con éxito una transacción (local o distribuida).

```sql
COMMIT [ { TRAN | TRANSACTION } [ transaction_name | @tran_name_variable ] ]
       [ WITH ( DELAYED_DURABILITY = { OFF | ON } ) ];
```

Puntos clave:

- **Anidadas**: cada `COMMIT` decrementa `@@TRANCOUNT`. Los cambios se hacen permanentes y se liberan recursos cuando `@@TRANCOUNT` llega a 0 (transacción más externa).
- **Distribuidas**: dispara confirmación en dos fases (2PC) coordinada por MS DTC.
- **Irreversible**: tras `COMMIT` de la transacción externa, no puede revertirse.
- **Durabilidad diferida**: `DELAYED_DURABILITY` puede mejorar rendimiento con riesgos controlados.

Ejemplo anidado (flujo del contador):

```sql
BEGIN TRAN OuterTran;   -- @@TRANCOUNT = 1
BEGIN TRAN Inner1;      -- @@TRANCOUNT = 2
COMMIT TRAN Inner1;     -- @@TRANCOUNT = 1 (aún no se persiste)
COMMIT TRAN OuterTran;  -- @@TRANCOUNT = 0 (se confirma todo)
```

## ROLLBACK TRANSACTION

Revierte una transacción completa o hasta un punto de guardado (savepoint).

```sql
ROLLBACK { TRAN | TRANSACTION }
    [ transaction_name | @tran_name_variable | savepoint_name | @savepoint_variable ];
```

Puntos clave:

- **Total**: sin nombre, revierte toda la transacción y deja `@@TRANCOUNT` en 0.
- **Parcial**: a `savepoint_name` no cambia `@@TRANCOUNT` y revierte solo lo posterior al savepoint.
- **Distribuidas**: no admite rollback a savepoint en transacciones distribuidas explícitas.
- **Procedimientos/Triggers**: en triggers, el rollback revierte cambios hasta ese punto y termina el lote que disparó el trigger.

Ejemplo con savepoint:

```sql
BEGIN TRAN;
    SAVE TRAN s1;
    INSERT INTO dbo.ValueTable VALUES (1);
    ROLLBACK TRAN s1; -- deshace la inserción, la transacción sigue abierta
COMMIT;
```

## Buenas prácticas

- **Acotar alcance/tiempo**: mantener las transacciones cortas para reducir bloqueos.
- **Manejo de errores**: usar `TRY...CATCH`, `XACT_STATE()`, y `THROW`/`RAISERROR` para consistencia.
- **Savepoints**: útiles para deshacer parte del trabajo sin abortar todo.
- **Operaciones remotas**: minimizar en transacciones críticas; comprender promoción a distribuida.
- **Permisos**: basta pertenecer al rol `public` para usar las sentencias básicas.

## Referencias

<https://learn.microsoft.com/es-es/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/t-sql/language-elements/begin-distributed-transaction-transact-sql?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/t-sql/language-elements/commit-transaction-transact-sql?view=sql-server-ver17>

<https://learn.microsoft.com/es-es/sql/t-sql/language-elements/rollback-transaction-transact-sql?view=sql-server-ver17>
