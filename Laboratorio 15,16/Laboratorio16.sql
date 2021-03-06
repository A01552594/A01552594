
--BORRADO DE TABLAS--
drop TABLE entregan
drop TABLE materiales
drop TABLE proyectos
drop TABLE Proveedores


/*Crear tablas*/
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Materiales')
DROP TABLE Materiales

CREATE TABLE Materiales(
	Clave NUMERIC (5) NOT NULL,
	Descripcion VARCHAR(50),
	Costo numeric(8,2)
);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Proveedores')
DROP TABLE Proveedores
CREATE TABLE Proveedores(
	RFC CHAR(13) NOT NULL,
	RazonSocial VARCHAR(50)

);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Proyectos')
DROP TABLE Proyectos
CREATE TABLE Proyectos(
	Numero NUMERIC(5) NOT NULL,
	Denominaci�n VARCHAR(50)

);

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Entregan')
DROP TABLE Entregan
CREATE TABLE Entregan(
	Clave NUMERIC (5) NOT NULL,
	RFC CHAR(13) NOT NULL,
	Numero NUMERIC(5) NOT NULL,
	Fecha DATETIME NOT NULL,
	Cantidad NUMERIC(8,2)
);


/*Datos de las tablas*/

SET DATEFORMAT dmy

BULK INSERT a1552594.a1552594.[Materiales]
   FROM 'e:\wwwroot\rcortese\materiales.csv'
   WITH
      (
         CODEPAGE = 'ACP',
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\n'
      )

BULK INSERT a1552594.a1552594.[Proveedores]
   FROM 'e:\wwwroot\rcortese\Proveedores.csv'
   WITH
      (
         CODEPAGE = 'ACP',
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\n'
      )

BULK INSERT a1552594.a1552594.[Proyectos]
   FROM 'e:\wwwroot\rcortese\Proyectos.csv'
   WITH
      (
         CODEPAGE = 'ACP',
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\n'
      )

BULK INSERT a1552594.a1552594.[Entregan]
   FROM 'e:\wwwroot\rcortese\Entregan.csv'
   WITH
      (
         CODEPAGE = 'ACP',
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\n'
      )





/*
	Inconsistencia: Ya se tiene un dato con esa llave
*/
 INSERT INTO Materiales values(1000, 'xxx', 1000)
 Delete from Materiales where Clave = 1000 and Costo = 1000

/*Declaraci�n de llaves primarias*/

 ALTER TABLE Materiales add constraint llaveMateriales PRIMARY KEY (Clave)
 ALTER TABLE Proveedores add constraint llaveProveedores PRIMARY KEY (RFC)
 ALTER TABLE Proyectos add constraint llaveProyectos PRIMARY KEY (Numero)
 ALTER TABLE Entregan add constraint llaveEntregan PRIMARY KEY (Clave, RFC, Numero, Fecha)

 /*
	Que ocurri�: no se puende agrgar nuevos datos si la llave primaria esta repetida
*/
 INSERT INTO Materiales values(1000, 'xxx', 1000)


 /*
 �Qu� informaci�n muestra esta consulta?
	Muestra la informaci�n del constraint de las llaves primarias que ya creamos

 �Qu� sentencias utilizaste para definir las llaves primarias?
	PRIMARY KEY

 �Qu� sentencias utilizaste para definir este constrait?
	Alter table
*/
 sp_helpconstraint Materiales
 sp_helpconstraint Proveedores
 sp_helpconstraint Proyectos
 sp_helpconstraint Entregan

 --BORRAR LLAVE PRIMARIA (CONSTRAINT)--
 ALTER TABLE Materiales drop constraint llaveMateriales

 

 --CHECAR TABLAS--
SELECT * FROM Materiales
SELECT * FROM Proveedores
SELECT * FROM Proyectos
SELECT * FROM Entregan


 /*
	�Qu� particularidad observas en los valores para clave, rfc y numero?
	Que no tinen un formato correcto para las personas pero s� para el sistema

	�C�mo responde el sistema a la inserci�n de este registro?
	Lo acepta correctamente
*/
INSERT INTO entregan values (0, 'xxx', 0, '1-jan-02', 0) ;
Delete from Entregan where Clave = 0


--LLAVES FORANEAS--

 /*
�Qu� significa el mensaje que emite el sistema?
Que no permite agregar esa columna

�Qu� significado tiene la sentencia anterior?
Que no permite gracias a que debe ser una clave existente en la tabla materiales
*/
 ALTER TABLE entregan add constraint cfentreganclave foreign key (clave) references materiales(clave);
 ALTER TABLE entregan add constraint cfentreganRFC foreign key (RFC) references Proveedores(RFC);
 ALTER TABLE entregan add constraint cfentregannumero foreign key (Numero) references Proyectos(Numero);

 sp_helpconstraint Entregan

 ------------------------------------------------------------EJERCICIO 4--------------------------------------------------------------------

/*
�Qu� uso se le est� dando a GETDATE()?
	Se �ne la fecha y el tiempo en el que se agrega la informaci�n

�Tiene sentido el valor del campo de cantidad?
	no
*/
 INSERT INTO entregan values (1000, 'AAAA800101', 5000, GETDATE(), 0);
 Delete from Entregan where Cantidad = 0


 /*
�C�mo responde el sistema?
	The INSERT statement conflicted with the CHECK constraint "cantidad". The conflict occurred in database "a1552594", table "a1552594.Entregan", column 'Cantidad'.

�Qu� significa el mensaje?
	Que no se puede gracias a que ya pusimos una restricci�n
*/
 ALTER TABLE entregan add constraint cantidad check (cantidad > 0) ;

 /*
�Que ssignifica integridad referencial?
	que la clave externa de una tabla de referencia siempre debe aludir a una fila v�lida de la tabla a la que se haga referencia*/