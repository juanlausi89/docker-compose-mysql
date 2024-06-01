
CREATE TABLE PERSONA (
    tipoDoc VARCHAR(10) NOT NULL,
    NroDocumento CHAR(8) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    fechaNacimiento DATE NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correoElectronico VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento)
);

CREATE TABLE CLIENTE (
    tipoDoc VARCHAR(10) NOT NULL,
    NroDocumento CHAR(8) NOT NULL,
    situacionFiscal VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ENCARGADO (
    tipoDoc VARCHAR(10) NOT NULL,
    NroDocumento CHAR(8) NOT NULL,
    legajo VARCHAR(20) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PUBLICIDAD (
    id INT AUTO_INCREMENT NOT NULL,
    Duracion INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE SALA (
    idSala INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    cantidadAsientos INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    tipoDocEncargado VARCHAR(10) NOT NULL,
    NroDocumentoEncargado CHAR(8) NOT NULL,
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
    IdFuncion INT AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    IdSala INT NOT NULL,
    idPubicidadInicio INT NOT NULL,
    idPublicidadFinal INT NOT NULL,
    PRIMARY KEY (IdFuncion),
    FOREIGN KEY (IdSala) REFERENCES SALA(idSala),
    FOREIGN KEY (idPubicidadInicio) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idPublicidadFinal) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ENTRADA (
    NumeroEntrada INT AUTO_INCREMENT,
    tipoDocCliente VARCHAR(10) NOT NULL,
    NroDocumentoCliente CHAR(8) NOT NULL,
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
    tipoDocCliente VARCHAR(10) NOT NULL,
    NroDocumentoCliente CHAR(8) NOT NULL,
    idPublicidad INT NOT NULL,
    Motivo VARCHAR(255) NOT NULL,
    PRIMARY KEY (tipoDocCliente, NroDocumentoCliente, idPublicidad),
    FOREIGN KEY (tipoDocCliente, NroDocumentoCliente) REFERENCES CLIENTE(tipoDoc, NroDocumento) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (idPublicidad) REFERENCES PUBLICIDAD(id) ON UPDATE CASCADE ON DELETE RESTRICT
);


/* EJERCICIO 3
a) Agregar un Encargado a la base de datos. Tener en cuenta las restricciones de acuerdo a su DDL.*/
INSERT INTO ENCARGADO (tipoDoc, NroDocumento, legajo, categoria)
    VALUES ('DNI', 12345678, 123456, 'Gerente');

/*b) Actualizar la Hora de las funciones del viernes 24 de junio de 2022: hora a actualizar 20:00.*/
UPDATE FUNCION
SET Hora = '20:00'
WHERE Fecha = '2022-06-24';

/*c) Eliminar los Encargados que nunca han sido encargados de una sala.*/
DELETE FROM ENCARGADO
WHERE (tipoDoc, NroDocumento) NOT IN (SELECT tipoDocEncargado, NroDocumentoEncargado FROM SALA);

/*EJERCICIO 4:
a) Seleccionar NumeroEntrada, NroAsiento, idSala, idFuncion de aquellas entradas emitidas 2 días antes de la fecha de la función.*/
SELECT NumeroEntrada, NroAsiento, idSala, idFuncion
FROM ENTRADA E
INNER JOIN FUNCION F ON E.idFuncion = F.idFuncion
WHERE DATEDIFF(F.Fecha, E.fechaEmision) = 2;

/*b) Seleccionar los asientos de las salas tipo ‘3D’, que nunca han sido vendidos en Entradas. Listar idSala, NroAsiento, fila. Utilizar Not Exists.*/
SELECT idSala, nroAsiento, fila
FROM ASIENTO A
INNER JOIN SALA S ON A.idSala = S.idSala
INNER JOIN ENTRADA E ON A.idSala = E.idSala
WHERE S.tipo = '3D' AND NOT EXISTS (SELECT * FROM ENTRADA WHERE A.idSala = E.idSala AND A.nroAsiento = E.nroAsiento);

/*c) Listar la cantidad de funciones por cada publicidad inicial en lo que va de este año 2022. Listar idPublicidad, Duración y cantidad.*/
SELECT idPublicidad, Duracion, COUNT(F.idPublicidadInicio) AS [Cantidad de funciones]
FROM PUBLICIDAD P
INNER JOIN FUNCION F ON P.id = F.idPublicidadInicio
WHERE YEAR(F.Fecha) = 2022
GROUP BY P.id;

/*d) Listar la cantidad de entradas emitidas por fecha que correspondan a funciones del mes de Mayo de 2022 y además la publicidad final debe ser de 5 minutos.
Listar fecha de emisión y cantidad. Utilice el operador IN para determinar la publicidad final.*/
SELECT fechaEmision, COUNT(NumeroEntrada) AS [Cantidad de entradas emitidas]
FROM ENTRADA E
INNER JOIN FUNCION F ON E.idFuncion = F.idFuncion
INNER JOIN PUBLICIDAD P ON F.idPublicidadFinal = P.id
WHERE F.Fecha BETWEEN '2024-05-01' AND '2024-05-31' AND F.idPublicidadFinal IN (SELECT id FROM PUBLICIDAD WHERE Duracion = 5)
ORDER BY E.fechaEmision;
