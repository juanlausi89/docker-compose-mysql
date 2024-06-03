
CREATE TABLE PERSONA (
    tipoDoc VARCHAR(20) NOT NULL,
    NroDocumento CHAR(20) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
     
    Esta pregunta es obligatoria.
    
    telefono VARCHAR(15) NOT NULL,
    correoElectronico VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento)
);

CREATE TABLE CLIENTE (
    tipoDoc VARCHAR(20) NOT NULL,
    NroDocumento CHAR(20) NOT NULL,
    situacionFiscal VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ENCARGADO (
    tipoDoc VARCHAR(20) NOT NULL,
    NroDocumento VARCHAR(20) NOT NULL,
    legajo VARCHAR(20) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PUBLICIDAD (
    id INT AUTO_INCREMENT NOT NULL,
    Duracion TIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE SALA (
    idSala INT AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    cantidadAsientos INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    tipoDocEncargado VARCHAR(20) NOT NULL,
    NroDocumentoEncargado VARCHAR(20) NOT NULL,
    PRIMARY KEY (idSala),
    FOREIGN KEY (tipoDocEncargado, NroDocumentoEncargado) REFERENCES ENCARGADO(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ASIENTO (
    idSala INT NOT NULL,
    nroAsiento INT NOT NULL,
    fila VARCHAR(5) NOT NULL,
    PRIMARY KEY (idSala, nroAsiento),
    FOREIGN KEY (idSala) REFERENCES SALA(idSala) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE FUNCION (
    IdFuncion INT AUTO_INCREMENT NOT NULL,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    IdSala INT NOT NULL,
    idPubicidadInicio INT NOT NULL,
    idPublicidadFinal INT NOT NULL,
    PRIMARY KEY (IdFuncion),
    FOREIGN KEY (IdSala) REFERENCES SALA(idSala) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idPublicidadInicio) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idPublicidadFinal) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ENTRADA (
    NumeroEntrada INT AUTO_INCREMENT NOT NULL,
    tipoDocCliente VARCHAR(20) NOT NULL,
    NroDocumentoCliente VARCHAR(20) NOT NULL,
    idSala INT NOT NULL,
    NroAsiento INT NOT NULL,
    idFuncion INT NOT NULL,
    fechaEmision DATE NOT NULL,
    PRIMARY KEY (NumeroEntrada),
    FOREIGN KEY (tipoDocCliente, NroDocumentoCliente) REFERENCES CLIENTE(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idSala, NroAsiento) REFERENCES ASIENTO(idSala, nroAsiento) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idFuncion) REFERENCES FUNCION(IdFuncion) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PREFIERE (
    tipoDocCliente VARCHAR(20) NOT NULL,
    NroDocumentoCliente VARCHAR(20) NOT NULL,
    idPublicidad INT NOT NULL,
    Motivo VARCHAR(255) NOT NULL,
    PRIMARY KEY (tipoDocCliente, NroDocumentoCliente, idPublicidad),
    FOREIGN KEY (tipoDocCliente, NroDocumentoCliente) REFERENCES CLIENTE(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idPublicidad) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT
);


/* EJERCICIO 3
a) Agregar un Encargado a la base de datos. Tener en cuenta las restricciones de acuerdo a su DDL.*/
INSERT INTO persona (tipoDoc, NroDocumento, apellido, nombre, fechaNacimiento, telefono, correoElectronico)
    VALUES ('DNI', 12345678, 'barra', 'santiago', '2004-05-07', 29993284, 'santi@ejemplo.com');

INSERT INTO ENCARGADO (tipoDoc, NroDocumento, legajo, categoria)
    VALUES ('DNI', 12345678, 123456, 'Gerente');

/*b) Actualizar la Hora de las funciones del viernes 24 de junio de 2022: hora a actualizar 20:00.*/
UPDATE FUNCION
SET Hora = '20:00:00'
WHERE Fecha = '2022-06-24';

/*c) Eliminar los Encargados que nunca han sido encargados de una sala.*/
DELETE FROM ENCARGADO
WHERE (tipoDoc, NroDocumento) NOT IN (SELECT tipoDocEncargado, NroDocumentoEncargado FROM SALA);

/*EJERCICIO 4:
a) Seleccionar NumeroEntrada, NroAsiento, idSala, idFuncion de aquellas entradas emitidas 2 días antes de la fecha de la función.*/
SELECT E.NumeroEntrada, E.NroAsiento, E.idSala, E.idFuncion
FROM ENTRADA E
INNER JOIN FUNCION F ON E.idFuncion = F.idFuncion
WHERE DATEDIFF(F.Fecha, E.fechaEmision) = 2;

/*b) Seleccionar los asientos de las salas tipo ‘3D’, que nunca han sido vendidos en Entradas. Listar idSala, NroAsiento, fila. Utilizar Not Exists.*/
SELECT A.idSala, A.nroAsiento, A.fila
FROM asiento A
INNER JOIN sala S ON S.idSala = A.idSala
WHERE S.tipo = '3D'
AND NOT EXISTS (
	SELECT 1
	FROM entrada E
	WHERE E.idSala = A.idSala AND E.nroAsiento = A.nroAsiento
);

/*c) Listar la cantidad de funciones por cada publicidad inicial en lo que va de este año 2022. Listar idPublicidad, Duración y cantidad.*/
SELECT P.idPublicidad, P.Duracion, COUNT(F.idPublicidadInicio) AS cantidadDeFunciones
FROM PUBLICIDAD P
INNER JOIN FUNCION F ON P.id = F.idPublicidadInicio
WHERE YEAR(F.Fecha) = 2022
GROUP BY P.id;

/*d) Listar la cantidad de entradas emitidas por fecha que correspondan a funciones del mes de Mayo de 2022 y además la publicidad final debe ser de 5 minutos.
Listar fecha de emisión y cantidad. Utilice el operador IN para determinar la publicidad final.*/
SELECT E.fechaEmision, COUNT(E.NumeroEntrada) AS cantidadEntradasEmitidas
FROM ENTRADA E
INNER JOIN FUNCION F ON E.idFuncion = F.idFuncion
INNER JOIN PUBLICIDAD P ON F.idPublicidadFinal = P.id
WHERE F.Fecha BETWEEN '2022-05-01' AND '2022-05-31' AND F.idPublicidadFinal IN (SELECT id FROM PUBLICIDAD WHERE Duracion = '00:05:00')
ORDER BY E.fechaEmision;
