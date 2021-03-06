USE [GD2015C1]
GO
--CREACIÓN DE SCHEMA--------------------------------
CREATE SCHEMA GD_GESTION_DE_VAGOS;
GO
--CREACIÓN DE TABLAS--------------------------------

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'telemetria_motor')
CREATE TABLE GD_GESTION_DE_VAGOS.telemetria_motor(
ID int IDENTITY PRIMARY KEY,
TEMP_ACEITE decimal(18, 6) not null,
TEMP_AGUA decimal (18, 6) not null,
RPM decimal (18, 6) not null,
POTENCIA decimal (18, 6) not null
);


IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'telemetria_caja_de_cambioss')
CREATE TABLE GD_GESTION_DE_VAGOS.telemetria_caja_de_cambioss(
ID int IDENTITY PRIMARY KEY,
TEMP_ACEITE decimal (18, 2) not null,
RPM decimal (18, 2) not null,
DESGASTE decimal (18, 2) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'piloto')
CREATE TABLE GD_GESTION_DE_VAGOS.piloto(
ID int IDENTITY PRIMARY KEY,
NOMBRE nvarchar(50) not null,
APELLIDO nvarchar(50) not null,
NACIONALIDAD nvarchar(50) not null,
NACIMIENTO date not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'caja_de_cambios')
CREATE TABLE GD_GESTION_DE_VAGOS.caja_de_cambios(
ID nvarchar(255) PRIMARY KEY,
MODELO nvarchar(50) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'motor')
CREATE TABLE GD_GESTION_DE_VAGOS.motor(
ID nvarchar(255) PRIMARY KEY,
MODELO nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'escuderia')
CREATE TABLE GD_GESTION_DE_VAGOS.escuderia(
ID int IDENTITY PRIMARY KEY,
NOMBRE nvarchar(255) not null,
NACIONALIDAD nvarchar(255) not null
);
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'auto')
CREATE TABLE GD_GESTION_DE_VAGOS.auto(
ID decimal(18,0) IDENTITY PRIMARY KEY,
ID_ESCUDERIA int REFERENCES GD_GESTION_DE_VAGOS.escuderia  not null,
ID_PILOTO int REFERENCES GD_GESTION_DE_VAGOS.piloto  not null,
ID_MOTOR nvarchar(255) REFERENCES GD_GESTION_DE_VAGOS.motor  not null,
ID_CAJA nvarchar(255) REFERENCES GD_GESTION_DE_VAGOS.caja_de_cambios  not null,
MODELO nvarchar(255) not null,
NUMERO int not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'freno')
CREATE TABLE GD_GESTION_DE_VAGOS.freno(
ID nvarchar(255) PRIMARY KEY,
ID_AUTO decimal(18,0) REFERENCES GD_GESTION_DE_VAGOS.auto  not null,
TAMANIO_DISCO decimal(18,2) not null,
POSICION nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'tipo_neumatico')
CREATE TABLE GD_GESTION_DE_VAGOS.tipo_neumatico(
ID int IDENTITY PRIMARY KEY,
NOMBRE nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'neumatico')
CREATE TABLE GD_GESTION_DE_VAGOS.neumatico(
ID int IDENTITY PRIMARY KEY,
ID_AUTO decimal(18,0) REFERENCES GD_GESTION_DE_VAGOS.auto  not null,
ID_TIPO_NEUMATICO int REFERENCES GD_GESTION_DE_VAGOS.tipo_neumatico  not null,
POSICION nvarchar(255) not null,
ESTA_EN_USO bit not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'pais')
CREATE TABLE GD_GESTION_DE_VAGOS.pais(
ID int IDENTITY PRIMARY KEY,
NOMBRE nvarchar(255) not null
);


IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'circuito')
CREATE TABLE GD_GESTION_DE_VAGOS.circuito(
ID int IDENTITY PRIMARY KEY,
ID_PAIS int REFERENCES GD_GESTION_DE_VAGOS.pais not null,
NOMBRE nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'carrera')
CREATE TABLE GD_GESTION_DE_VAGOS.carrera(
    ID int IDENTITY PRIMARY KEY,
    ID_CIRCUITO int REFERENCES GD_GESTION_DE_VAGOS.circuito not null,
    FECHA date not null,
    MAX_VUELTAS int not null,
    CLIMA nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'parada_box')
CREATE TABLE GD_GESTION_DE_VAGOS.parada_box(
    ID int IDENTITY PRIMARY KEY,
    ID_AUTO decimal(18,0) REFERENCES GD_GESTION_DE_VAGOS.auto  not null,
    ID_CARRERA int REFERENCES GD_GESTION_DE_VAGOS.carrera  not null,
    TIEMPO_PARADA decimal(18,2) not null,
    NRO_VUELTA decimal(18,0) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'cambio_neumatico')
CREATE TABLE GD_GESTION_DE_VAGOS.cambio_neumatico(
ID int IDENTITY PRIMARY KEY,
ID_PARADA_BOX int REFERENCES GD_GESTION_DE_VAGOS.parada_box  not null,
ID_NEUMATICO_VIEJO int REFERENCES GD_GESTION_DE_VAGOS.neumatico  not null,
ID_NEUMATICO_NUEVO int REFERENCES GD_GESTION_DE_VAGOS.neumatico  not null,
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'bandera')
CREATE TABLE GD_GESTION_DE_VAGOS.bandera(
ID int IDENTITY PRIMARY KEY,
COLOR nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'incidente')
CREATE TABLE GD_GESTION_DE_VAGOS.incidente(
ID int IDENTITY PRIMARY KEY,
BANDERA int REFERENCES GD_GESTION_DE_VAGOS.bandera not null,
TIEMPO decimal(18,2) not null
);


IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'tipo_incidente')
CREATE TABLE GD_GESTION_DE_VAGOS.tipo_incidente(
ID int IDENTITY PRIMARY KEY,
NOMBRE nvarchar(255) not null
);


IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'auto_incidente')
CREATE TABLE GD_GESTION_DE_VAGOS.auto_incidente(
ID int IDENTITY PRIMARY KEY,
ID_AUTO decimal(18,0) REFERENCES GD_GESTION_DE_VAGOS.auto  not null,
ID_TIPO_INCIDENTE int REFERENCES GD_GESTION_DE_VAGOS.tipo_incidente not null,
ID_INCIDENTE int REFERENCES GD_GESTION_DE_VAGOS.incidente not null,
NRO_VUELTA decimal(18,0) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'tipo_sector')
CREATE TABLE GD_GESTION_DE_VAGOS.tipo_sector(
    ID int IDENTITY PRIMARY KEY,
	NOMBRE nvarchar(255) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'sector')
CREATE TABLE GD_GESTION_DE_VAGOS.sector(
    ID int IDENTITY PRIMARY KEY,
    ID_CIRCUITO int REFERENCES GD_GESTION_DE_VAGOS.circuito  not null,
	ID_TIPO_SECTOR int REFERENCES GD_GESTION_DE_VAGOS.tipo_sector not null,
	DISTANCIA decimal(18,2) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'medicion')
CREATE TABLE GD_GESTION_DE_VAGOS.medicion(
ID int IDENTITY PRIMARY KEY,
ID_AUTO decimal(18,0) REFERENCES GD_GESTION_DE_VAGOS.auto  not null,
ID_CARRERA int REFERENCES GD_GESTION_DE_VAGOS.carrera  not null,
ID_SECTOR int REFERENCES GD_GESTION_DE_VAGOS.sector  not null,
ID_TELE_MOTOR int REFERENCES GD_GESTION_DE_VAGOS.telemetria_motor  not null,
ID_TELE_CAJA int REFERENCES GD_GESTION_DE_VAGOS.telemetria_caja_de_cambioss  not null,
DIST_VUELTA decimal(18,2) not null,
TIEMPO_VUELTA decimal(18,2) not null,
POSICION nvarchar(255) not null,
VELOCIDAD decimal(18,2) not null,
COMBUSTIBLE decimal(18,2) not null,
NRO_VUELTA int not null,
DIST_CARRERA decimal(18,2) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'telemetria_freno')
CREATE TABLE GD_GESTION_DE_VAGOS.telemetria_freno(
ID int IDENTITY PRIMARY KEY,
ID_MEDICION int REFERENCES GD_GESTION_DE_VAGOS.medicion  not null,
GROSOR_PASTILLA decimal(18,2) not null,
TEMPERATURA decimal(18,2) not null
);

IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'telemetria_neumatico')
CREATE TABLE GD_GESTION_DE_VAGOS.telemetria_neumatico(
ID int IDENTITY PRIMARY KEY,
ID_NEUMATICO  int REFERENCES GD_GESTION_DE_VAGOS.neumatico  not null,
ID_MEDICION int REFERENCES GD_GESTION_DE_VAGOS.medicion  not null,
PROFUNDIDAD decimal(18,6) not null,
POSICION nvarchar(255) not null,
PRESION decimal(18,6) not null,
TEMPERATURA decimal(18,6) not null
);