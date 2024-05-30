
CREATE TABLE PERSONA (
    tipoDoc VARCHAR(10),
    NroDocumento VARCHAR(20),
    apellido VARCHAR(50),
    nombre VARCHAR(50),
    fechaNacimiento DATE,
    telefono VARCHAR(15),
    correoElectronico VARCHAR(50),
    PRIMARY KEY (tipoDoc, NroDocumento)
);

CREATE TABLE CLIENTE (
    tipoDoc VARCHAR(10),
    NroDocumento VARCHAR(20),
    situacionFiscal VARCHAR(50),
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento)
);

CREATE TABLE ENCARGADO (
    tipoDoc VARCHAR(10),
    NroDocumento VARCHAR(20),
    legajo VARCHAR(20),
    categoria VARCHAR(50),
    PRIMARY KEY (tipoDoc, NroDocumento),
    FOREIGN KEY (tipoDoc, NroDocumento) REFERENCES PERSONA(tipoDoc, NroDocumento)
);

CREATE TABLE PUBLICIDAD (
    id INT AUTO_INCREMENT,
    Duracion INT,
    PRIMARY KEY (id)
);

CREATE TABLE SALA (
    idSala INT AUTO_INCREMENT,
    nombre VARCHAR(50),
    cantidadAsientos INT,
    tipo VARCHAR(50),
    tipoDocEncargado VARCHAR(10),
    NroDocumentoEncargado VARCHAR(20),
    PRIMARY KEY (idSala),
    FOREIGN KEY (tipoDocEncargado, NroDocumentoEncargado) REFERENCES ENCARGADO(tipoDoc, NroDocumento)
);

CREATE TABLE ASIENTO (
    idSala INT,
    nroAsiento INT,
    fila VARCHAR(5),
    PRIMARY KEY (idSala, nroAsiento),
    FOREIGN KEY (idSala) REFERENCES SALA(idSala)
);

CREATE TABLE FUNCION (
    IdFuncion INT AUTO_INCREMENT,
    Fecha DATE,
    Hora TIME,
    IdSala INT,
    idPubicidadInicio INT,
    idPublicidadFinal INT,
    PRIMARY KEY (IdFuncion),
    FOREIGN KEY (IdSala) REFERENCES SALA(idSala),
    FOREIGN KEY (idPubicidadInicio) REFERENCES PUBLICIDAD(id),
    FOREIGN KEY (idPublicidadFinal) REFERENCES PUBLICIDAD(id)
);

CREATE TABLE ENTRADA (
    NumeroEntrada INT AUTO_INCREMENT,
    tipoDocCliente VARCHAR(10),
    NroDocumentoCliente VARCHAR(20),
    idSala INT,
    NroAsiento INT,
    idFuncion INT,
    fechaEmision DATE,
    PRIMARY KEY (NumeroEntrada),
    FOREIGN KEY (tipoDocCliente, NroDocumentoCliente) REFERENCES CLIENTE(tipoDoc, NroDocumento),
    FOREIGN KEY (idSala, NroAsiento) REFERENCES ASIENTO(idSala, nroAsiento),
    FOREIGN KEY (idFuncion) REFERENCES FUNCION(IdFuncion)
);

CREATE TABLE PREFIERE (
    tipoDocCliente VARCHAR(10),
    NroDocumentoCliente VARCHAR(20),
    idPublicidad INT,
    Motivo VARCHAR(255),
    PRIMARY KEY (tipoDocCliente, NroDocumentoCliente, idPublicidad),
    FOREIGN KEY (tipoDocCliente, NroDocumentoCliente) REFERENCES CLIENTE(tipoDoc, NroDocumento),
    FOREIGN KEY (idPublicidad) REFERENCES PUBLICIDAD(id)
);

