drop table AEROPUERTO cascade constraints;
drop table TIPO_AVION cascade constraints;
drop table AVION cascade constraints;
drop table GENERO cascade constraints;
drop table PERSONA cascade constraints;
drop table AZAFATA cascade constraints;
drop table TIPO_LICENCIA cascade constraints;
drop table PILOTO cascade constraints;
drop table PILOTA cascade constraints;
drop table PASAJERO cascade constraints;
drop table EQUIPAJE_BODEGA cascade constraints;
drop table VUELO cascade constraints;
drop table SE_ASIGNA cascade constraints;
drop table REALIZA cascade constraints;

/*==============================================================*/
/* Table: AEROPUERTO                                            */
/*==============================================================*/
create table AEROPUERTO 
(
   AEROPUERTO_ID        NUMBER(10)           not null,
   NOMBRE               VARCHAR(50)          not null,
   PAIS                 VARCHAR(50)          not null,
   CIUDAD               VARCHAR(50)          not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_AEROPUERTO primary key (AEROPUERTO_ID)
);
alter table AEROPUERTO
    add constraint MOSTRAR_AEROPUERTO CHECK (MOSTRAR IN (0,1));
/*==============================================================*/
/* Table: TIPO_AVION                                            */
/*==============================================================*/
create table TIPO_AVION 
(
   TIPO_ID              NUMBER(10)         not null,
   TIPO_AVION           VARCHAR2(50)       not null,
   MOSTRAR              NUMBER(1)          not null,
   constraint PK_TIPO_AVION primary key (TIPO_ID)
);
alter table TIPO_AVION
    add constraint MOSTRAR_TIPO_AVION CHECK (MOSTRAR IN (0,1));
/*==============================================================*/
/* Table: AVION                                                 */
/*==============================================================*/
create table AVION 
(
   AVION_ID             NUMBER(10)           not null,
   TIPO_ID              NUMBER(10)           not null,
   CAPACIDAD_PASAJEROS  NUMBER(10)           not null,
   DISTANCIA_MAXIMA     NUMBER(10)           not null,
   CAPACIDAD_COMBUSTIBLE NUMBER(10)          not null,
   VELOCIDAD_CRUCERO    NUMBER(10)           not null,
   CAPACIDAD_BODEGA     NUMBER(10)           not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_AVION primary key (AVION_ID)
);

alter table AVION
   add constraint FK_AVION_ES_UN_TIPO_AVI foreign key (TIPO_ID)
      references TIPO_AVION (TIPO_ID);
alter table AVION
    add constraint MOSTRAR_AVION CHECK (MOSTRAR IN (0,1));    
      
/*==============================================================*/
/* Table: GENERO                                                */
/*==============================================================*/
create table GENERO 
(
   GENERO_ID            NUMBER(10)               not null,
   GENERO               VARCHAR2(10)             not null,
   MOSTRAR              NUMBER(1)                not null,
   constraint PK_GENERO primary key (GENERO_ID)
);
alter table GENERO
    add constraint MOSTRAR_GENERO CHECK (MOSTRAR IN (0,1));    
/*==============================================================*/
/* Table: PERSONA                                               */
/*==============================================================*/
create table PERSONA 
(
   PERSONA_ID           NUMBER(10)           not null,
   GENERO_ID            NUMBER(10)           not null,
   NUMERO_IDENTIFICACION NUMBER(10)           not null,
   NOMBRE               VARCHAR(50)          not null,
   APELLIDO             VARCHAR(50)          not null,
   FECHA_NAC            DATE                 not null,
   PAIS_NAC             VARCHAR(50)          not null,
   CIUDAD_NAC           VARCHAR(50)          not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_PERSONA primary key (PERSONA_ID)
);

alter table PERSONA
   add constraint FK_PERSONA_TIENE_GENERO foreign key (GENERO_ID)
      references GENERO (GENERO_ID);
alter table PERSONA
    add constraint MOSTRAR_PERSONA CHECK (MOSTRAR IN (0,1));    
/*==============================================================*/
/* Table: AZAFATA                                               */
/*==============================================================*/
create table AZAFATA 
(
   PERSONA_ID           NUMBER(10)           not null,
   AZAFATA_ID           NUMBER(10)           not null,
   VUELOS_ABORDADOS     NUMBER(10)           not null,
   IDIOMA_NATAL         VARCHAR(50)          not null,
   IDIOMA_SECUNDARIO    VARCHAR(50)          not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_AZAFATA primary key (AZAFATA_ID)
);
alter table AZAFATA
   add constraint FK_AZAFATA_ES_UNA_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);
alter table AZAFATA
    add constraint MOSTRAR_AZAFATA CHECK (MOSTRAR IN (0,1));    

/*==============================================================*/
/* Table: TIPO_LICENCIA                                         */
/*==============================================================*/
create table TIPO_LICENCIA 
(
   LICENCIA_ID          NUMBER(10)           not null,
   LICENCIA             VARCHAR(50)          not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_TIPO_LICENCIA primary key (LICENCIA_ID)
);
alter table TIPO_LICENCIA
    add constraint MOSTRAR_TIPO_LICENCIA CHECK (MOSTRAR IN (0,1));    
/*==============================================================*/
/* Table: PILOTO                                                */
/*==============================================================*/
create table PILOTO 
(
   PERSONA_ID           NUMBER(10)           not null,
   PILOTO_ID            NUMBER(10)           not null,
   LICENCIA_ID          NUMBER(10)           not null,
   VUELOS               NUMBER(10)           not null,
   EMISION_LICENCIA     DATE                 not null,
   VENCIMIENTO_LICENCIA DATE                 not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_PILOTO primary key (PILOTO_ID)
);
alter table PILOTO
   add constraint FK_PILOTO_ES_UN2_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);

alter table PILOTO
   add constraint FK_PILOTO_TIENE_3_TIPO_LIC foreign key (LICENCIA_ID)
      references TIPO_LICENCIA (LICENCIA_ID);

alter table PILOTO
    add constraint MOSTRAR_PILOTO CHECK (MOSTRAR IN (0,1));   

/*==============================================================*/
/* Table: PASAJERO                                              */
/*==============================================================*/
create table PASAJERO 
(
   PERSONA_ID           NUMBER(10)           not null,
   PASAJERO_ID          NUMBER(10)           not null,
   COMPANION_ID         NUMBER(10),
   COSTO                NUMBER(10)           not null,
   DESTINO              VARCHAR(50)          not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_PASAJERO primary key (PASAJERO_ID)
);
alter table PASAJERO
   add constraint FK_PASAJERO_ACOMPANIA_PASAJERO foreign key (COMPANION_ID)
      references PASAJERO (PASAJERO_ID);

alter table PASAJERO
   add constraint FK_PASAJERO_ES_UN4_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);

alter table PASAJERO
    add constraint MOSTRAR_PASAJERO CHECK (MOSTRAR IN (0,1));  
      
/*==============================================================*/
/* Table: PILOTA                                                */
/*==============================================================*/
create table PILOTA 
(
   PILOTO_ID            NUMBER(10)               not null,
   AVION_ID             NUMBER(10)               not null,
   FECHA_INICIO         DATE                     not null,
   FECHA_FIN            DATE                     not null,
   MOSTRAR              NUMBER(1)                not null,
   constraint PK_PILOTA primary key (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
);

alter table PILOTA
   add constraint FK_PILOTA_PILOTA_PILOTO foreign key (PILOTO_ID)
      references PILOTO (PILOTO_ID);

alter table PILOTA
   add constraint FK_PILOTA_PILOTA_AVION foreign key (AVION_ID)
      references AVION (AVION_ID);

alter table PILOTA
    add constraint MOSTRAR_PILOTA CHECK (MOSTRAR IN (0,1));  

/*==============================================================*/
/* Table: EQUIPAJE                                              */
/*==============================================================*/
create table EQUIPAJE_BODEGA 
(
   EQUIPAJE_ID          NUMBER(10)           not null,
   PASAJERO_ID          NUMBER(10)           not null,
   PESO                 NUMBER(10)           not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_EQUIPAJE_BODEGA primary key (EQUIPAJE_ID)
);
alter table EQUIPAJE_BODEGA
   add constraint FK_EQUIPAJE_TIENE_1_PASAJERO foreign key (PASAJERO_ID)
      references PASAJERO (PASAJERO_ID);
      
alter table EQUIPAJE_BODEGA
    add constraint MOSTRAR_EQUIPAJE_BODEGA CHECK (MOSTRAR IN (0,1));  

/*==============================================================*/
/* Table: VUELO                                                 */
/*==============================================================*/
create table VUELO 
(
   VUELO_ID             NUMBER(10)           not null,
   AEROPUERTO_SALIDA_ID NUMBER(10)           not null,
   AEROPUERTO_LLEGADA_ID NUMBER(10)           not null,
   AVION_ID             NUMBER(10)           not null,
   DESTINO              VARCHAR(50)          not null,
   FECHA_SALIDA         DATE                 not null,
   FECHA_LLEGADA        DATE                 not null,
   CANTIDAD_PASAJEROS   NUMBER(10)           not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_VUELO primary key (VUELO_ID)
);
alter table VUELO
   add constraint FK_VUELO_POSEE_1_AVION foreign key (AVION_ID)
      references AVION (AVION_ID);

alter table VUELO
   add constraint FK_VUELO_RECIBE_AEROPUER foreign key (AEROPUERTO_LLEGADA_ID)
      references AEROPUERTO (AEROPUERTO_ID);

alter table VUELO
   add constraint FK_VUELO_SALE_AEROPUER foreign key (AEROPUERTO_SALIDA_ID)
      references AEROPUERTO (AEROPUERTO_ID);

alter table VUELO
    add constraint MOSTRAR_VUELO CHECK (MOSTRAR IN (0,1));  

/*==============================================================*/
/* Table: SE_ASIGNA                                             */
/*==============================================================*/
create table SE_ASIGNA 
(
   AZAFATA_ID           NUMBER(10)           not null,
   VUELO_ID             NUMBER(10)           not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_SE_ASIGNA primary key (AZAFATA_ID, VUELO_ID)
);

alter table SE_ASIGNA
   add constraint FK_SE_ASIGN_SE_ASIGNA_AZAFATA foreign key (AZAFATA_ID)
      references AZAFATA (AZAFATA_ID);

alter table SE_ASIGNA
   add constraint FK_SE_ASIGN_SE_ASIGNA_VUELO foreign key (VUELO_ID)
      references VUELO (VUELO_ID);

alter table SE_ASIGNA
    add constraint MOSTRAR_SE_ASIGNA CHECK (MOSTRAR IN (0,1));  

/*==============================================================*/
/* Table: REALIZA                                               */
/*==============================================================*/
create table REALIZA 
(
   VUELO_ID             NUMBER(10)           not null,
   PASAJERO_ID          NUMBER(10)           not null,
   MOSTRAR              NUMBER(1)            not null,
   constraint PK_REALIZA primary key (VUELO_ID, PASAJERO_ID)
);

alter table REALIZA
   add constraint FK_REALIZA_REALIZA_PASAJERO foreign key (PASAJERO_ID)
      references PASAJERO (PASAJERO_ID);

alter table REALIZA
   add constraint FK_REALIZA_REALIZA2_VUELO foreign key (VUELO_ID)
      references VUELO (VUELO_ID);

alter table REALIZA
    add constraint MOSTRAR_REALIZA CHECK (MOSTRAR IN (0,1));  

--aeropuerto
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (1, 'Aeropuerto 1', 'Pais 1', 'Ciudad 1', 1);
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (2, 'Aeropuerto 2', 'Pais 2', 'Ciudad 2', 1);
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (3, 'Aeropuerto 3', 'Pais 3', 'Ciudad 3', 1);
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (4, 'Aeropuerto 4', 'Pais 4', 'Ciudad 4', 1);
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (5, 'Aeropuerto 5', 'Pais 5', 'Ciudad 5', 1);
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
VALUES (6, 'Aeropuerto 6', 'Pais 6', 'Ciudad 6', 1);

--tipo avion
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION, MOSTRAR)
VALUES (1, 'TipoAvion1', 1);
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION, MOSTRAR)
VALUES (2, 'TipoAvion2', 1);
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION, MOSTRAR)
VALUES (3, 'TipoAvion3', 1);
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION, MOSTRAR)
VALUES (4, 'TipoAvion4', 1);
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION, MOSTRAR)
VALUES (5, 'TipoAvion5', 1);

--avion
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA, MOSTRAR)
VALUES (1, 1, 150, 3000, 10000, 500, 200, 1);
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA, MOSTRAR)
VALUES (2, 2, 200, 4000, 12000, 550, 250, 1);
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA, MOSTRAR)
VALUES (3, 1, 180, 3500, 11000, 520, 230, 1);

--genero
INSERT INTO GENERO (GENERO_ID, GENERO, MOSTRAR)
VALUES (1, 'Masculino', 1);
INSERT INTO GENERO (GENERO_ID, GENERO, MOSTRAR)
VALUES (2, 'Femenino', 1);

--persona
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (1, 1, 123456789, 'Juan', 'Perez',TO_DATE('2000-01-15', 'YYYY-MM-DD'), 'Pais', 'Ciudad', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (2, 2, 987654321, 'Maria', 'Lopez', TO_DATE('1998-05-20', 'YYYY-MM-DD'), 'OtroPais', 'OtraCiudad', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (3, 1, 555555555, 'Pedro', 'Gonzalez', TO_DATE('1995-09-10', 'YYYY-MM-DD'), 'DistintoPais', 'DistintaCiudad', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (4, 2, 111111111, 'Luisa', 'Martï¿½nez', TO_DATE('1990-03-25', 'YYYY-MM-DD'), 'OtroPais2', 'OtraCiudad2', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (5, 1, 999999999, 'Carlos', 'Ramirez', TO_DATE('1987-11-30', 'YYYY-MM-DD'), 'OtroPais3', 'OtraCiudad3', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (6, 2, 888888888, 'Maria', 'Lopez', TO_DATE('1992-05-14', 'YYYY-MM-DD'), 'PaisX', 'CiudadX', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (7, 1, 777777777, 'Pedro', 'Gonzalez', TO_DATE('1990-09-20', 'YYYY-MM-DD'), 'PaisY', 'CiudadY', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (8, 2, 666666666, 'Luisa', 'Martinez', TO_DATE('1988-04-25', 'YYYY-MM-DD'), 'PaisZ', 'CiudadZ', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (9, 1, 555555555, 'Miguel', 'Hernandez', TO_DATE('1985-12-30', 'YYYY-MM-DD'), 'PaisA', 'CiudadA', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (10, 2, 444444444, 'Ana', 'Sanchez', TO_DATE('1983-06-10', 'YYYY-MM-DD'), 'PaisB', 'CiudadB', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (11, 1, 333333333, 'Santiago', 'Perez', TO_DATE('1980-02-18', 'YYYY-MM-DD'), 'PaisC', 'CiudadC', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (12, 2, 222222222, 'Carmen', 'Gomez', TO_DATE('1978-08-05', 'YYYY-MM-DD'), 'PaisD', 'CiudadD', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (13, 1, 111111111, 'Javier', 'Fernï¿½ndez', TO_DATE('1975-04-15', 'YYYY-MM-DD'), 'PaisE', 'CiudadE', 1);
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICACION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC, MOSTRAR)
VALUES (14, 2, 99999999, 'Isabel', 'Ortega', TO_DATE('1973-10-25', 'YYYY-MM-DD'), 'PaisF', 'CiudadF', 1);


--azafata
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO, MOSTRAR)
VALUES (1, 1, 100, 'Espanol', 'Ingles', 1);
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO, MOSTRAR)
VALUES (2, 2, 75, 'Frances', 'Aleman', 1);
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO, MOSTRAR)
VALUES (3, 3, 120, 'Ingles', 'Espanol', 1);

--tipo licencia
INSERT INTO TIPO_LICENCIA (LICENCIA_ID, LICENCIA, MOSTRAR)
VALUES (1, 'LicenciaTipo1', 1);
INSERT INTO TIPO_LICENCIA (LICENCIA_ID, LICENCIA, MOSTRAR)
VALUES (2, 'LicenciaTipo2', 1);

--piloto
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(4, 1, 1, 100, TO_DATE('2023-01-01','YYYY-MM-DD'),  TO_DATE('2024-01-01','YYYY-MM-DD'), 1);
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(5, 2, 2, 120, TO_DATE('2023-02-01','YYYY-MM-DD'),  TO_DATE('2024-02-01','YYYY-MM-DD'), 1);
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(6, 3, 1, 80, TO_DATE('2023-03-01','YYYY-MM-DD'),  TO_DATE('2024-03-01','YYYY-MM-DD'), 1);
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(7, 4, 2, 90, TO_DATE('2023-04-01','YYYY-MM-DD'),  TO_DATE('2024-04-01','YYYY-MM-DD'), 1);
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(8, 5, 1, 110, TO_DATE('2023-05-01','YYYY-MM-DD'),  TO_DATE('2024-05-01','YYYY-MM-DD'), 1);
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA, MOSTRAR)
VALUES(9, 6, 1, 110, TO_DATE('2023-05-01','YYYY-MM-DD'),  TO_DATE('2024-05-01','YYYY-MM-DD'), 1);

--pilota
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (1, 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (2, 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (3, 2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (4, 2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (5, 3, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN, MOSTRAR)
VALUES (6, 3, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1);

--vuelo
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS, MOSTRAR)
VALUES(1, 1, 2, 1, 'Destino1', TO_DATE('2023-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-01-05 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 100, 1);
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS, MOSTRAR)
VALUES(2, 3, 4, 2, 'Destino2', TO_DATE('2023-02-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-02-05 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 120, 1);
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS, MOSTRAR)
VALUES(3, 5, 6, 3, 'Destino3', TO_DATE('2023-03-01 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-03-05 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), 80, 1);

--se asigna
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID, MOSTRAR)
VALUES (1, 1, 1);
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID, MOSTRAR)
VALUES (1, 2, 1);
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID, MOSTRAR)
VALUES (2, 1, 1);
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID, MOSTRAR)
VALUES (3, 1, 1);

--pasajero
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO, MOSTRAR)
VALUES (10, 1, 500, 'Destino1', 1);
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO, MOSTRAR)
VALUES (11, 2, 600, 'Destino2', 1);
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO, MOSTRAR)
VALUES (12, 3, 450, 'Destino3', 1);
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COMPANION_ID, COSTO, DESTINO, MOSTRAR)
VALUES (13, 4, 1, 550, 'Destino4', 1);
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO, MOSTRAR)
VALUES (14, 5, 700, 'Destino5', 1);

--realiza
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID, MOSTRAR)
VALUES (1, 1, 1);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID, MOSTRAR)
VALUES (1, 2, 1);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID, MOSTRAR)
VALUES (2, 3, 1);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID, MOSTRAR)
VALUES (2, 4, 1);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID, MOSTRAR)
VALUES (2, 5, 1);

--equipaje
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO, MOSTRAR)
VALUES (1, 2, 20, 1);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO, MOSTRAR)
VALUES (2, 2, 25, 1);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO, MOSTRAR)
VALUES (3, 3, 18, 1);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO, MOSTRAR)
VALUES (4, 4, 22, 1);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO, MOSTRAR)
VALUES (5, 5, 30, 1);

--Paquete para operaciones CRUD en la tabla AEROPUERTO
DROP SEQUENCE aeropuertos_seq;
CREATE SEQUENCE aeropuertos_seq
    START WITH 7
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE aeropuerto_crud AS
    TYPE aeropuerto_type IS RECORD
    (
        aeropuerto_id aeropuerto.aeropuerto_id%TYPE,
        nombre aeropuerto.nombre%TYPE,
        pais aeropuerto.pais%TYPE,
        ciudad aeropuerto.ciudad%TYPE,
        mostrar aeropuerto.mostrar%TYPE
    );
    -- Procedimiento para crear un nuevo aeropuerto
    FUNCTION crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) RETURN BOOLEAN;
    
    -- Procedimiento para leer informaciï¿½n de un aeropuerto
    PROCEDURE leer_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aeropuerto_info OUT aeropuerto_type
    );
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto_type,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    );
    
    PROCEDURE leer_aeropuertos(p_aeropuertos OUT SYS_REFCURSOR);
    
    -- Procedimiento para actualizar informaciï¿½n de un aeropuerto
    FUNCTION actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aero_info IN aeropuerto_type
    )RETURN BOOLEAN;
    
    -- Procedimiento para eliminar un aeropuerto
    FUNCTION eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) RETURN BOOLEAN;
END aeropuerto_crud;
/
CREATE OR REPLACE PACKAGE BODY aeropuerto_crud AS
    -- Implementaciï¿½n de procedimiento para crear un aeropuerto
    FUNCTION crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD, MOSTRAR)
        VALUES (aeropuertos_seq.NEXTVAL, p_nombre, p_pais, p_ciudad, 1);
        COMMIT;
        RETURN true;
    END crear_aeropuerto;
    
    -- Implementaciï¿½n de funciï¿½n para leer un aeropuerto
    PROCEDURE leer_aeropuerto(
        p_aeropuerto_id IN NUMBER, 
        p_aeropuerto_info OUT aeropuerto_type) 
    IS
    BEGIN
        SELECT * 
        INTO p_aeropuerto_info
        FROM aeropuerto a
        WHERE a.aeropuerto_id = p_aeropuerto_id
        AND a.mostrar = 1;
    END leer_aeropuerto;
    
    PROCEDURE leer_aeropuertos(
        p_aeropuertos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_aeropuertos FOR
        SELECT * 
        FROM aeropuerto
        WHERE mostrar = 1;
    END;
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto_type,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    ) IS
    BEGIN
        SELECT * 
        INTO p_aeropuerto_info 
        FROM aeropuerto a
        WHERE a.aeropuerto_id = p_aeropuerto_id;
        
        OPEN p_vuelos_llegada FOR
        SELECT 
            v.vuelo_id, 
            v.destino, 
            v.fecha_llegada, 
            v.fecha_salida, 
            v.cantidad_pasajeros,
            a.nombre aeropuerto_salida
        FROM vuelo v
        INNER JOIN aeropuerto a
        ON v.aeropuerto_salida_id = a.aeropuerto_id
        WHERE v.aeropuerto_llegada_id = p_aeropuerto_id;
        
        OPEN p_vuelos_salida FOR
        SELECT 
            v.vuelo_id, 
            v.destino, 
            v.fecha_llegada, 
            v.fecha_salida, 
            v.cantidad_pasajeros,
            a.nombre aeropuerto_llegada
        FROM vuelo v
        INNER JOIN aeropuerto a
        ON v.aeropuerto_llegada_id = a.aeropuerto_id
        WHERE v.aeropuerto_salida_id = p_aeropuerto_id;
    END obtener_info;
    
    -- Implementaciï¿½n de procedimiento para actualizar un aeropuerto
    FUNCTION actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_aero_info IN aeropuerto_type
    )
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AEROPUERTO
        SET 
            NOMBRE = p_aero_info.nombre, 
            PAIS = p_aero_info.pais, 
            CIUDAD = p_aero_info.ciudad
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        COMMIT;
        RETURN TRUE;
    END actualizar_aeropuerto;
    
    -- Implementaciï¿½n de procedimiento para eliminar un aeropuerto
    FUNCTION eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AEROPUERTO 
        SET MOSTRAR = 0
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        COMMIT;
        RETURN TRUE;
    END eliminar_aeropuerto;
    
END aeropuerto_crud;
/

---------------------------------------------------------------------------------------
--PARA VUELO
DROP SEQUENCE vuelo_seq;
CREATE SEQUENCE vuelo_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/ 
CREATE OR REPLACE PACKAGE vuelo_crud AS
    TYPE vuelo_type IS RECORD
    (
        vuelo_id             vuelo.vuelo_id%TYPE,
        aeropuerto_salida_id vuelo.aeropuerto_salida_id%TYPE,
        aeropuerto_llegada_id vuelo.aeropuerto_llegada_id%TYPE,
        avion_id             vuelo.avion_id%TYPE,
        destino              vuelo.destino%TYPE,
        fecha_salida         vuelo.fecha_salida%TYPE,
        fecha_llegada        vuelo.fecha_llegada%TYPE,
        cantidad_pasajeros   vuelo.cantidad_pasajeros%TYPE,
        mostrar              vuelo.mostrar%TYPE
    );

    FUNCTION crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE, 
        p_fecha_llegada IN DATE
    ) RETURN vuelo.vuelo_id%TYPE;
    
    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    );

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo_type
    );
    
    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );

    FUNCTION actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_vuelo_info IN vuelo_type
    ) RETURN BOOLEAN;

    FUNCTION eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) RETURN BOOLEAN;
END vuelo_crud;

/
CREATE OR REPLACE PACKAGE BODY vuelo_crud AS
     FUNCTION crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE
    ) 
    RETURN vuelo.vuelo_id%TYPE
    IS
        v_vuelo_id vuelo.vuelo_id%TYPE := vuelo_seq.NEXTVAL;
    BEGIN
        INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS, MOSTRAR)
        VALUES (v_vuelo_id, p_aeropuerto_salida_id, p_aeropuerto_llegada_id, p_avion_id, p_destino, p_fecha_salida, p_fecha_llegada, 0, 1);
        COMMIT;
        RETURN v_vuelo_id;
    END crear_vuelo;

    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_aviones FOR
        SELECT a.avion_id, ta.tipo_avion
        FROM avion a
        INNER JOIN tipo_avion ta
        ON a.tipo_id = ta.tipo_id;
        
        OPEN p_aeropuertos FOR
        SELECT a.aeropuerto_id, a.nombre
        FROM aeropuerto a;
    END obtener_info_para_crear;

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo_type
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM VUELO 
        WHERE VUELO_ID = p_vuelo_id
        AND mostrar = 1;
    END leer_vuelo;

    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    ) IS
    BEGIN
        OPEN p_vuelos FOR
        SELECT *
        FROM (
            SELECT 
                v.vuelo_id,
                v.aeropuerto_salida_id,
                v.aeropuerto_llegada_id,
                a.nombre aeropuerto_llegada,
                b.nombre aeropuerto_salida,
                v.destino,
                v.fecha_llegada,
                v.fecha_salida,
                v.cantidad_pasajeros, 
                v.mostrar,
                ROW_NUMBER() OVER (ORDER BY FECHA_SALIDA) AS rn
            FROM vuelo v
            INNER JOIN aeropuerto a
            ON v.aeropuerto_salida_id = a.aeropuerto_id
            INNER JOIN aeropuerto b
            ON v.aeropuerto_llegada_id = b.aeropuerto_id
            WHERE v.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END;

    FUNCTION actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_vuelo_info IN vuelo_type
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE VUELO
        SET 
            AEROPUERTO_SALIDA_ID = p_vuelo_info.aeropuerto_salida_id,
            AEROPUERTO_LLEGADA_ID = p_vuelo_info.aeropuerto_llegada_id,
            AVION_ID = p_vuelo_info.avion_id,
            DESTINO = p_vuelo_info.destino,
            FECHA_SALIDA = p_vuelo_info.fecha_salida,
            FECHA_LLEGADA = p_vuelo_info.fecha_llegada
        WHERE VUELO_ID = p_vuelo_id;
        COMMIT;
        RETURN TRUE;
    END actualizar_vuelo;

    FUNCTION eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) 
    RETURN BOOLEAN
    IS
    BEGIN
        UPDATE VUELO 
        SET MOSTRAR = 0
        WHERE VUELO_ID = p_vuelo_id;
        COMMIT;
        RETURN TRUE;
    END eliminar_vuelo;
END vuelo_crud;
/

--PARA PERSONA:
DROP SEQUENCE persona_seq;
CREATE SEQUENCE persona_seq
    START WITH 15
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE PERSONA_CRUD AS
    TYPE persona_type IS RECORD 
    (
       persona_id           persona.persona_id%TYPE,
       genero_id            persona.genero_id%TYPE,
       numero_identificacion persona.numero_identificacion%TYPE,
       nombre               persona.nombre%TYPE,
       apellido             persona.apellido%TYPE,
       fecha_nac            persona.fecha_nac%TYPE,
       pais_nac             persona.pais_nac%TYPE,
       ciudad_nac           persona.ciudad_nac%TYPE,
       mostrar              persona.mostrar%TYPE
    );

    FUNCTION crear_persona(
        p_persona_info persona_type
    ) RETURN NUMBER;
    
    FUNCTION eliminar_persona(
        p_persona_id persona.persona_id%TYPE
    )RETURN BOOLEAN;
END PERSONA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY PERSONA_CRUD AS
    FUNCTION crear_persona(
        p_persona_info persona_type
    ) 
    RETURN NUMBER
    IS
        v_persona_id persona.persona_id%TYPE := persona_seq.NEXTVAL;
    BEGIN
        SAVEPOINT v_before_insert_persona;
        INSERT INTO persona (persona_id, genero_id, numero_identificacion, nombre, apellido, fecha_nac, pais_nac, ciudad_nac, mostrar)
        VALUES (
            v_persona_id, 
            p_persona_info.genero_id, 
            p_persona_info.numero_identificacion, 
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            1);
        RETURN v_persona_id;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_persona;
        RAISE;
    END crear_persona;
    
     FUNCTION eliminar_persona(
        p_persona_id persona.persona_id%TYPE
    )RETURN BOOLEAN
    IS
    BEGIN
        SAVEPOINT v_before_delete_persona;
        UPDATE persona p 
        SET p.mostrar = 0
        WHERE p.persona_id = p_persona_id;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_persona;
        RAISE;
    END;
END PERSONA_CRUD;
/

-----------------------------------------------------------------------------------------
--PARA AZAFATA
DROP SEQUENCE azafata_seq;
CREATE SEQUENCE azafata_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/
CREATE OR REPLACE PACKAGE AZAFATA_CRUD AS
    TYPE azafata_type IS RECORD 
    (
        persona_id            azafata.persona_id%TYPE,
        azafata_id            azafata.azafata_id%TYPE,
        vuelos_abordados      azafata.vuelos_abordados%TYPE,
        idioma_natal          azafata.idioma_natal%TYPE,
        idioma_secundario     azafata.idioma_secundario%TYPE,
        mostrar               azafata.mostrar%TYPE
    );
    
    FUNCTION crear_azafata(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_azafata_info IN azafata_type
    )RETURN BOOLEAN;
    
    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_azafata_info OUT azafata_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    );
    
    PROCEDURE leer_azafatas(
        p_azafatas OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    );
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN NUMBER
    ) RETURN BOOLEAN;
    
    PROCEDURE leer_azafatas_por_vuelo(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafatas OUT SYS_REFCURSOR
    );
    
    FUNCTION eliminar_se_asigna(
        p_vuelo_id vuelo.vuelo_id%TYPE,
        p_azafata_id azafata.azafata_id%TYPE
    )RETURN BOOLEAN;
    
     FUNCTION asignar_azafata(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN;
    
END AZAFATA_CRUD;
/
CREATE OR REPLACE PACKAGE BODY AZAFATA_CRUD AS
    FUNCTION crear_azafata(
        p_persona_info IN PERSONA_CRUD.persona_type,
        p_azafata_info IN azafata_type
    )
    RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_insert_azafata VARCHAR2(30) := 'BEFORE_INSERT_AZAFATA';
    BEGIN
        SAVEPOINT v_before_insert_azafata;
        v_persona_id := PERSONA_CRUD.crear_persona(p_persona_info);
        INSERT INTO azafata (persona_id, azafata_id, vuelos_abordados, idioma_natal, idioma_secundario, mostrar)
        VALUES (
            v_persona_id, 
            azafata_seq.NEXTVAL, 
            p_azafata_info.vuelos_abordados, 
            p_azafata_info.idioma_natal,
            p_azafata_info.idioma_secundario,
            1);
            
        COMMIT;
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_azafata;
        RAISE;
    END;

    PROCEDURE leer_azafata(
        p_azafata_id IN NUMBER,
        p_azafata_info OUT azafata_type,
        p_persona_info OUT PERSONA_CRUD.persona_type
    ) IS
    BEGIN
        SELECT 
            p.persona_id,
            p.genero_id,
            p.numero_identificacion,
            p.nombre,
            p.apellido,
            p.fecha_nac,
            p.pais_nac,
            p.ciudad_nac,
            a.persona_id,
            a.azafata_id,
            a.vuelos_abordados,
            a.idioma_natal,
            a.idioma_secundario,
            a.mostrar
        INTO 
            p_persona_info.persona_id, 
            p_persona_info.genero_id,
            p_persona_info.numero_identificacion,
            p_persona_info.nombre,
            p_persona_info.apellido,
            p_persona_info.fecha_nac,
            p_persona_info.pais_nac,
            p_persona_info.ciudad_nac,
            p_azafata_info.persona_id,
            p_azafata_info.azafata_id,
            p_azafata_info.vuelos_abordados,
            p_azafata_info.idioma_natal,
            p_azafata_info.idioma_secundario,
            p_azafata_info.mostrar
        FROM azafata a 
        INNER JOIN persona p
        ON a.persona_id = p.persona_id
        WHERE a.azafata_id = p_azafata_id
        AND a.mostrar = 1 
        AND p.mostrar = 1;
    END leer_azafata;
    
    PROCEDURE leer_azafatas(
        p_azafatas OUT SYS_REFCURSOR,
        p_tamanio_pagina IN NUMBER := 10,
        p_pagina_actual IN NUMBER := 1
    )IS
    BEGIN
        OPEN p_azafatas FOR
        SELECT *
        FROM (
            SELECT 
                p.persona_id,
                p.genero_id,
                p.numero_identificacion,
                p.nombre,
                p.apellido,
                p.fecha_nac,
                p.pais_nac,
                p.ciudad_nac,
                a.azafata_id,
                a.vuelos_abordados,
                a.idioma_natal,
                a.idioma_secundario,
                a.mostrar,
                ROW_NUMBER() OVER (ORDER BY p.persona_id) AS rn
            FROM azafata a 
            INNER JOIN persona p
            ON a.persona_id = p.persona_id
            AND a.mostrar = 1 
            AND p.mostrar = 1
        )
        WHERE rn 
        BETWEEN (p_pagina_actual - 1) * p_tamanio_pagina + 1 
            AND p_pagina_actual * p_tamanio_pagina;
    END leer_azafatas;
    
    FUNCTION eliminar_azafata(p_azafata_id IN NUMBER)
        RETURN BOOLEAN
    IS
    BEGIN
        UPDATE AZAFATA 
        SET MOSTRAR = 0
        WHERE AZAFATA_ID = p_azafata_id;
        COMMIT;
        RETURN TRUE;    
    END;
    
    PROCEDURE leer_azafatas_por_vuelo(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafatas OUT SYS_REFCURSOR
    )IS
    BEGIN
        OPEN p_azafatas FOR 
            SELECT * 
            FROM azafata a
            INNER JOIN se_asigna sa
            ON a.azafata_id = sa.azafata_id
            INNER JOIN persona p
            ON p.persona_id = a.persona_id
            WHERE sa.vuelo_id = p_vuelo_id
            AND a.mostrar = 1;
    END;
    
    FUNCTION eliminar_se_asigna(
        p_vuelo_id vuelo.vuelo_id%TYPE,
        p_azafata_id azafata.azafata_id%TYPE
    )RETURN BOOLEAN
    IS
    BEGIN
        DELETE 
        FROM se_asigna sa
        WHERE sa.vuelo_id = p_vuelo_id 
        AND sa.azafata_id = p_azafata_id;
        COMMIT;
        RETURN TRUE;
    END;
    
    FUNCTION asignar_azafata(
        p_vuelo_id IN vuelo.vuelo_id%TYPE,
        p_azafata_id IN azafata.azafata_id%TYPE
    )
    RETURN BOOLEAN
    IS
    BEGIN
        INSERT INTO se_asigna (azafata_id, vuelo_id, mostrar)
        VALUES (p_azafata_id, p_vuelo_id, 1);
        COMMIT;
        RETURN TRUE;
    END asignar_azafata;
    
    FUNCTION eliminar_azafata(
        p_azafata_id IN azafata.azafata_id%TYPE
    ) RETURN BOOLEAN
    IS
        v_persona_id persona.persona_id%TYPE;
        v_before_delete_azafata VARCHAR2(30) := 'BEFORE_DELETE_AZAFATA';
        v_res BOOLEAN := false;
        delete_error EXCEPTION; 
    BEGIN
        SELECT a.persona_id
        INTO v_persona_id
        FROM azafata a
        WHERE a.azafata_id = p_azafata_id;
    
        SAVEPOINT v_before_delete_azafata;
        
        UPDATE azafata a
        SET a.mostrar = 0
        WHERE a.azafata_id = p_azafata_id;
        
        v_res := persona_crud.eliminar_persona(v_persona_id);
        IF v_res THEN
            COMMIT;
            RETURN TRUE;
        ELSE
            RAISE delete_error;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK TO SAVEPOINT v_before_insert_azafata;
        RAISE;
    END;
END AZAFATA_CRUD;
/

-----------------------------------------------------------------------------------
--TRIGGERS
CREATE OR REPLACE TRIGGER verificar_vuelo
    BEFORE INSERT ON vuelo
FOR EACH ROW
DECLARE
    CURSOR aviones IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM vuelo v
        WHERE v.avion_id = :NEW.avion_id;
    v_capacidad_pasajeros_avion vuelo.cantidad_pasajeros%TYPE;
BEGIN
    FOR avionInfo IN aviones LOOP
        IF :NEW.fecha_salida 
        BETWEEN avionInfo.fecha_salida 
        AND avionInfo.fecha_llegada 
        OR
        :NEW.fecha_llegada 
        BETWEEN avionInfo.fecha_salida 
        AND avionInfo.fecha_llegada 
        THEN
            RAISE_APPLICATION_ERROR(
                -20202, 
                'El avion ya tiene asignado un vuelo en el rango de fechas'
            );
        END IF;      
    END LOOP;
    
    IF :NEW.aeropuerto_salida_id = :NEW.aeropuerto_llegada_id THEN
        RAISE_APPLICATION_ERROR(
            -20203, 
            'El aeropuerto de salida no puede ser igual al aeropuerto de llegada'
        );
    END IF;
        
    IF :NEW.fecha_salida > :NEW.fecha_llegada THEN
        RAISE_APPLICATION_ERROR(
            -20201, 
            'La fecha de salida no puede ser mayor a la fecha de llegada'
        );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER verificar_pasajeros_vuelo
    BEFORE UPDATE OF cantidad_pasajeros ON vuelo
FOR EACH ROW
DECLARE
    v_capacidad_pasajeros_avion avion.capacidad_pasajeros%TYPE;
    v_capacidad_equipaje_avion avion.capacidad_bodega%TYPE;
    v_peso_actual avion.capacidad_bodega%TYPE;
    v_aux avion.capacidad_bodega%TYPE;
    CURSOR equipaje_pasajeros IS
        SELECT r.pasajero_id
        FROM realiza r
        WHERE r.vuelo_id = :OLD.avion_id;
BEGIN
    SELECT a.capacidad_pasajeros, a.capacidad_bodega
    INTO v_capacidad_pasajeros_avion, v_capacidad_equipaje_avion
    FROM avion a
    WHERE a.avion_id = :OLD.avion_id;
    
    IF :NEW.cantidad_pasajeros > v_capacidad_pasajeros_avion THEN
        RAISE_APPLICATION_ERROR(
            -20204, 
            'No hay mas puestos en el avion'
        );
    END IF;
       
    FOR equipaje_pasajero IN equipaje_pasajeros LOOP
        SELECT SUM(e.peso)
        INTO v_aux
        FROM equipaje_bodega e
        WHERE e.pasajero_id = equipaje_pasajero.pasajero_id;
        v_peso_actual := v_peso_actual + v_aux;
    END LOOP;    
    
    IF v_peso_actual > v_capacidad_equipaje_avion THEN 
        RAISE_APPLICATION_ERROR(
            -20205, 
            'Capacidad de carga excedida'
        );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER verificar_azafata
    BEFORE INSERT ON se_asigna
FOR EACH ROW
DECLARE
    v_mostrar_vuelo vuelo.mostrar%TYPE;
    v_fecha_llegada vuelo.fecha_llegada%TYPE;
    v_fecha_salida vuelo.fecha_salida%TYPE;
    CURSOR azafatas_vuelos IS
        SELECT v.fecha_salida, v.fecha_llegada
        FROM se_asigna sa
        INNER JOIN vuelo v
        ON sa.vuelo_id = v.vuelo_id
        WHERE sa.azafata_id = :NEW.azafata_id;   
BEGIN 
    SELECT v.mostrar 
    INTO v_mostrar_vuelo
    FROM vuelo v
    WHERE v.vuelo_id = :NEW.vuelo_id;

    IF v_mostrar_vuelo = 0 THEN
        RAISE_APPLICATION_ERROR(
                -20142, 
                'El vuelo no está disponible'
            );
    END IF;
    
    SELECT v.fecha_salida, v.fecha_llegada
    INTO v_fecha_salida, v_fecha_llegada
    FROM vuelo v
    WHERE v.vuelo_id = :NEW.vuelo_id;
    
    FOR azafata_vuelo IN azafatas_vuelos LOOP
        IF v_fecha_salida 
        BETWEEN azafata_vuelo.fecha_salida 
        AND azafata_vuelo.fecha_llegada 
        OR
        v_fecha_llegada 
        BETWEEN azafata_vuelo.fecha_salida 
        AND azafata_vuelo.fecha_llegada 
        THEN
            RAISE_APPLICATION_ERROR(
                -20141, 
                'La azafata ya tiene asignado un vuelo en el rango de fechas'
            );
        END IF;      
    END LOOP;
END;
/