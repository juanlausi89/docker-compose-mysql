
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
    idSala INT AUTO_INCREMENT NOT NULL,
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
    IdFuncion INT AUTO_INCREMENT NOT NULL,
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
    NumeroEntrada INT AUTO_INCREMENT NOT NULL,
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

