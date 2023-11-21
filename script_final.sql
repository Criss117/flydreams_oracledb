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
   constraint PK_AEROPUERTO primary key (AEROPUERTO_ID)
);
/*==============================================================*/
/* Table: TIPO_AVION                                            */
/*==============================================================*/
create table TIPO_AVION 
(
   TIPO_ID              NUMBER(10)         not null,
   TIPO_AVION           VARCHAR2(50)       not null,
   constraint PK_TIPO_AVION primary key (TIPO_ID)
);

/*==============================================================*/
/* Table: AVION                                                 */
/*==============================================================*/
create table AVION 
(
   AVION_ID             NUMBER(10)           not null,
   TIPO_ID              NUMBER(10)           not null,
   CAPACIDAD_PASAJEROS  NUMBER(10)           not null,
   DISTANCIA_MAXIMA     NUMBER(10)           not null,
   CAPACIDAD_COMBUSTIBLE NUMBER(10)           not null,
   VELOCIDAD_CRUCERO    NUMBER(10)           not null,
   CAPACIDAD_BODEGA     NUMBER(10)           not null,
   constraint PK_AVION primary key (AVION_ID)
);

alter table AVION
   add constraint FK_AVION_ES_UN_TIPO_AVI foreign key (TIPO_ID)
      references TIPO_AVION (TIPO_ID);
      
      
/*==============================================================*/
/* Table: GENERO                                                */
/*==============================================================*/
create table GENERO 
(
   GENERO_ID            NUMBER(10)               not null,
   GENERO               VARCHAR2(10)             not null,
   constraint PK_GENERO primary key (GENERO_ID)
);

/*==============================================================*/
/* Table: PERSONA                                               */
/*==============================================================*/
create table PERSONA 
(
   PERSONA_ID           NUMBER(10)         not null,
   GENERO_ID            NUMBER(10)           not null,
   NUMERO_IDENTIFICAION NUMBER(10)           not null,
   NOMBRE               VARCHAR(50)          not null,
   APELLIDO             VARCHAR(50)          not null,
   FECHA_NAC            DATE                 not null,
   PAIS_NAC             VARCHAR(50)          not null,
   CIUDAD_NAC           VARCHAR(50)          not null,
   constraint PK_PERSONA primary key (PERSONA_ID)
);

alter table PERSONA
   add constraint FK_PERSONA_TIENE_GENERO foreign key (GENERO_ID)
      references GENERO (GENERO_ID);

/*==============================================================*/
/* Table: AZAFATA                                               */
/*==============================================================*/
create table AZAFATA 
(
   PERSONA_ID           NUMBER(10)         not null,
   AZAFATA_ID           NUMBER(10)         not null,
   VUELOS_ABORDADOS     NUMBER(10)           not null,
   IDIOMA_NATAL         VARCHAR(50)          not null,
   IDIOMA_SECUNDARIO    VARCHAR(50)          not null,
   constraint PK_AZAFATA primary key (AZAFATA_ID)
);
alter table AZAFATA
   add constraint FK_AZAFATA_ES_UNA_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);


/*==============================================================*/
/* Table: TIPO_LICENCIA                                         */
/*==============================================================*/
create table TIPO_LICENCIA 
(
   LICENCIA_ID          NUMBER(10)           not null,
   LICENCIA             VARCHAR(50)          not null,
   constraint PK_TIPO_LICENCIA primary key (LICENCIA_ID)
);

/*==============================================================*/
/* Table: PILOTO                                                */
/*==============================================================*/
create table PILOTO 
(
   PERSONA_ID           NUMBER(10)           not null,
   PILOTO_ID            NUMBER(10)           not null,
   LICENCIA_ID          NUMBER(10)           not null,
   VUELOS               NUMBER(10)           not null,
   EMISION_LICENCIA     VARCHAR(50)          not null,
   VENCIMIENTO_LICENCIA VARCHAR(50)          not null,
   constraint PK_PILOTO primary key (PILOTO_ID)
);
alter table PILOTO
   add constraint FK_PILOTO_ES_UN2_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);

alter table PILOTO
   add constraint FK_PILOTO_TIENE_3_TIPO_LIC foreign key (LICENCIA_ID)
      references TIPO_LICENCIA (LICENCIA_ID);

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
   constraint PK_PASAJERO primary key (PASAJERO_ID)
);
alter table PASAJERO
   add constraint FK_PASAJERO_ACOMPANIA_PASAJERO foreign key (COMPANION_ID)
      references PASAJERO (PASAJERO_ID);

alter table PASAJERO
   add constraint FK_PASAJERO_ES_UN4_PERSONA foreign key (PERSONA_ID)
      references PERSONA (PERSONA_ID);
      
/*==============================================================*/
/* Table: PILOTA                                                */
/*==============================================================*/
create table PILOTA 
(
   PILOTO_ID            NUMBER(10)               not null,
   AVION_ID             NUMBER(10)               not null,
   FECHA_INICIO         DATE                     not null,
   FECHA_FIN            DATE                     not null,
   constraint PK_PILOTA primary key (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
);


alter table PILOTA
   add constraint FK_PILOTA_PILOTA_PILOTO foreign key (PILOTO_ID)
      references PILOTO (PILOTO_ID);

alter table PILOTA
   add constraint FK_PILOTA_PILOTA_AVION foreign key (AVION_ID)
      references AVION (AVION_ID);

/*==============================================================*/
/* Table: EQUIPAJE                                              */
/*==============================================================*/
create table EQUIPAJE_BODEGA 
(
   EQUIPAJE_ID          NUMBER(10)           not null,
   PASAJERO_ID          NUMBER(10)           not null,
   PESO                 NUMBER(10)           not null,
   constraint PK_EQUIPAJE_BODEGA primary key (EQUIPAJE_ID)
);
alter table EQUIPAJE_BODEGA
   add constraint FK_EQUIPAJE_TIENE_1_PASAJERO foreign key (PASAJERO_ID)
      references PASAJERO (PASAJERO_ID);


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

/*==============================================================*/
/* Table: SE_ASIGNA                                             */
/*==============================================================*/
create table SE_ASIGNA 
(
   AZAFATA_ID           NUMBER(10)           not null,
   VUELO_ID             NUMBER(10)           not null,
   constraint PK_SE_ASIGNA primary key (AZAFATA_ID, VUELO_ID)
);

alter table SE_ASIGNA
   add constraint FK_SE_ASIGN_SE_ASIGNA_AZAFATA foreign key (AZAFATA_ID)
      references AZAFATA (AZAFATA_ID);

alter table SE_ASIGNA
   add constraint FK_SE_ASIGN_SE_ASIGNA_VUELO foreign key (VUELO_ID)
      references VUELO (VUELO_ID);

/*==============================================================*/
/* Table: REALIZA                                               */
/*==============================================================*/
create table REALIZA 
(
   VUELO_ID             NUMBER(10)           not null,
   PASAJERO_ID          NUMBER(10)           not null,
   constraint PK_REALIZA primary key (VUELO_ID, PASAJERO_ID)
);

alter table REALIZA
   add constraint FK_REALIZA_REALIZA_PASAJERO foreign key (PASAJERO_ID)
      references PASAJERO (PASAJERO_ID);

alter table REALIZA
   add constraint FK_REALIZA_REALIZA2_VUELO foreign key (VUELO_ID)
      references VUELO (VUELO_ID);

--aeropuerto
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (1, 'Aeropuerto 1', 'Pais 1', 'Ciudad 1');
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (2, 'Aeropuerto 2', 'Pais 2', 'Ciudad 2');
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (3, 'Aeropuerto 3', 'Pais 3', 'Ciudad 3');
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (4, 'Aeropuerto 4', 'Pais 4', 'Ciudad 4');
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (5, 'Aeropuerto 5', 'Pais 5', 'Ciudad 5');
INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
VALUES (6, 'Aeropuerto 6', 'Pais 6', 'Ciudad 6');

--tipo avion
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION)
VALUES (1, 'TipoAvion1');
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION)
VALUES (2, 'TipoAvion2');
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION)
VALUES (3, 'TipoAvion3');
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION)
VALUES (4, 'TipoAvion4');
INSERT INTO TIPO_AVION (TIPO_ID, TIPO_AVION)
VALUES (5, 'TipoAvion5');

--avion
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA)
VALUES (1, 1, 150, 3000, 10000, 500, 200);
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA)
VALUES (2, 2, 200, 4000, 12000, 550, 250);
INSERT INTO AVION (AVION_ID, TIPO_ID, CAPACIDAD_PASAJEROS, DISTANCIA_MAXIMA, CAPACIDAD_COMBUSTIBLE, VELOCIDAD_CRUCERO, CAPACIDAD_BODEGA)
VALUES (3, 1, 180, 3500, 11000, 520, 230);

--genero
INSERT INTO GENERO (GENERO_ID, GENERO)
VALUES (1, 'Masculino');
INSERT INTO GENERO (GENERO_ID, GENERO)
VALUES (2, 'Femenino');

--persona
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (1, 1, 123456789, 'Juan', 'P�rez', TO_DATE('2000-01-15', 'YYYY-MM-DD'), 'Pa�s', 'Ciudad');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (2, 2, 987654321, 'Mar�a', 'L�pez', TO_DATE('1998-05-20', 'YYYY-MM-DD'), 'OtroPa�s', 'OtraCiudad');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (3, 1, 555555555, 'Pedro', 'Gonz�lez', TO_DATE('1995-09-10', 'YYYY-MM-DD'), 'DistintoPa�s', 'DistintaCiudad');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (4, 2, 111111111, 'Luisa', 'Mart�nez', TO_DATE('1990-03-25', 'YYYY-MM-DD'), 'OtroPais2', 'OtraCiudad2');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (5, 1, 999999999, 'Carlos', 'Ram�rez', TO_DATE('1987-11-30', 'YYYY-MM-DD'), 'OtroPais3', 'OtraCiudad3');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (6, 2, 888888888, 'Mar�a', 'L�pez', TO_DATE('1992-05-14', 'YYYY-MM-DD'), 'Pa�sX', 'CiudadX');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (7, 1, 777777777, 'Pedro', 'Gonz�lez', TO_DATE('1990-09-20', 'YYYY-MM-DD'), 'Pa�sY', 'CiudadY');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (8, 2, 666666666, 'Luisa', 'Mart�nez', TO_DATE('1988-04-25', 'YYYY-MM-DD'), 'Pa�sZ', 'CiudadZ');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (9, 1, 555555555, 'Miguel', 'Hern�ndez', TO_DATE('1985-12-30', 'YYYY-MM-DD'), 'Pa�sA', 'CiudadA');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (10, 2, 444444444, 'Ana', 'S�nchez', TO_DATE('1983-06-10', 'YYYY-MM-DD'), 'Pa�sB', 'CiudadB');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (11, 1, 333333333, 'Santiago', 'P�rez', TO_DATE('1980-02-18', 'YYYY-MM-DD'), 'Pa�sC', 'CiudadC');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (12, 2, 222222222, 'Carmen', 'G�mez', TO_DATE('1978-08-05', 'YYYY-MM-DD'), 'Pa�sD', 'CiudadD');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (13, 1, 111111111, 'Javier', 'Fern�ndez', TO_DATE('1975-04-15', 'YYYY-MM-DD'), 'Pa�sE', 'CiudadE');
INSERT INTO PERSONA (PERSONA_ID, GENERO_ID, NUMERO_IDENTIFICAION, NOMBRE, APELLIDO, FECHA_NAC, PAIS_NAC, CIUDAD_NAC)
VALUES (14, 2, 99999999, 'Isabel', 'Ortega', TO_DATE('1973-10-25', 'YYYY-MM-DD'), 'Pa�sF', 'CiudadF');


--azafata
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO)
VALUES (1, 1, 100, 'Espa�ol', 'Ingl�s');
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO)
VALUES (2, 2, 75, 'Franc�s', 'Alem�n');
INSERT INTO AZAFATA (PERSONA_ID, AZAFATA_ID, VUELOS_ABORDADOS, IDIOMA_NATAL, IDIOMA_SECUNDARIO)
VALUES (3, 3, 120, 'Ingl�s', 'Espa�ol');

--tipo licencia
INSERT INTO TIPO_LICENCIA (LICENCIA_ID, LICENCIA)
VALUES (1, 'LicenciaTipo1');
INSERT INTO TIPO_LICENCIA (LICENCIA_ID, LICENCIA)
VALUES (2, 'LicenciaTipo2');

--piloto
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(4, 1, 1, 100, '2023-01-01', '2024-01-01');
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(5, 2, 2, 120, '2023-02-01', '2024-02-01');
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(6, 3, 1, 80, '2023-03-01', '2024-03-01');
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(7, 4, 2, 90, '2023-04-01', '2024-04-01');
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(8, 5, 1, 110, '2023-05-01', '2024-05-01');
INSERT INTO PILOTO (PERSONA_ID, PILOTO_ID, LICENCIA_ID, VUELOS, EMISION_LICENCIA, VENCIMIENTO_LICENCIA)
VALUES(9, 6, 1, 110, '2023-05-01', '2024-05-01');

--pilota
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (1, 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (2, 1, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (3, 2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (4, 2, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (5, 3, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));
INSERT INTO PILOTA (PILOTO_ID, AVION_ID, FECHA_INICIO, FECHA_FIN)
VALUES (6, 3, TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));

--vuelo
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS)
VALUES(1, 1, 2, 1, 'Destino1', TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-05', 'YYYY-MM-DD'), 100);
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS)
VALUES(2, 3, 4, 2, 'Destino2', TO_DATE('2023-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-05', 'YYYY-MM-DD'), 120);
INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS)
VALUES(3, 5, 6, 3, 'Destino3', TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2023-03-05', 'YYYY-MM-DD'), 80);

--se asigna
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID)
VALUES (1, 1);
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID)
VALUES (2, 1);
INSERT INTO SE_ASIGNA (AZAFATA_ID, VUELO_ID)
VALUES (3, 1);

--pasajero
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO)
VALUES (10, 1, 500, 'Destino1');
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO)
VALUES (11, 2, 600, 'Destino2');
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO)
VALUES (12, 3, 450, 'Destino3');
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COMPANION_ID, COSTO, DESTINO)
VALUES (13, 4, 1, 550, 'Destino4');
INSERT INTO PASAJERO (PERSONA_ID, PASAJERO_ID, COSTO, DESTINO)
VALUES (14, 5, 700, 'Destino5');

--realiza
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID)
VALUES (1, 1);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID)
VALUES (1, 2);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID)
VALUES (2, 3);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID)
VALUES (2, 4);
INSERT INTO REALIZA (VUELO_ID, PASAJERO_ID)
VALUES (2, 5);

--equipaje
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO)
VALUES (1, 2, 20);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO)
VALUES (2, 2, 25);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO)
VALUES (3, 3, 18);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO)
VALUES (4, 4, 22);
INSERT INTO EQUIPAJE_BODEGA (EQUIPAJE_ID, PASAJERO_ID, PESO)
VALUES (5, 5, 30);

--CRUDS
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
        ciudad aeropuerto.ciudad%TYPE
    );
    
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
        p_vuelos_llegada OUT SYS_REFCURSOR,
        p_vuelos_salida OUT SYS_REFCURSOR
    );

    -- Procedimiento para crear un nuevo aeropuerto
    PROCEDURE crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    );
        
    PROCEDURE leer_aeropuertos(p_aeropuertos OUT SYS_REFCURSOR);
    
    -- Procedimiento para actualizar informaci�n de un aeropuerto
    PROCEDURE actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    );
    
    -- Procedimiento para eliminar un aeropuerto
    PROCEDURE eliminar_aeropuerto(p_aeropuerto_id IN NUMBER);
END aeropuerto_crud;
/
CREATE OR REPLACE PACKAGE BODY aeropuerto_crud AS
    PROCEDURE obtener_info(
        p_aeropuerto_id IN aeropuerto.aeropuerto_id%TYPE,
        p_aeropuerto_info OUT aeropuerto%ROWTYPE,
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

    -- Implementaci�n de procedimiento para crear un aeropuerto
    PROCEDURE crear_aeropuerto(
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO AEROPUERTO (AEROPUERTO_ID, NOMBRE, PAIS, CIUDAD)
        VALUES (aeropuertos_seq.NEXTVAL, p_nombre, p_pais, p_ciudad);
        COMMIT;
    END crear_aeropuerto;
    
    PROCEDURE leer_aeropuertos(
        p_aeropuertos OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_aeropuertos FOR
        SELECT * 
        FROM aeropuerto;
    END;
    
    
    -- Implementaci�n de procedimiento para actualizar un aeropuerto
    PROCEDURE actualizar_aeropuerto(
        p_aeropuerto_id IN NUMBER,
        p_nombre IN VARCHAR2,
        p_pais IN VARCHAR2,
        p_ciudad IN VARCHAR2
    ) IS
    BEGIN
        UPDATE AEROPUERTO
        SET NOMBRE = p_nombre, PAIS = p_pais, CIUDAD = p_ciudad
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
        COMMIT;
    END actualizar_aeropuerto;
    
    -- Implementaci�n de procedimiento para eliminar un aeropuerto
    PROCEDURE eliminar_aeropuerto(p_aeropuerto_id IN NUMBER) IS
    BEGIN
        DELETE FROM AEROPUERTO
        WHERE AEROPUERTO_ID = p_aeropuerto_id;
    END eliminar_aeropuerto;
    
END aeropuerto_crud;
/

--PARA VUELO
DROP SEQUENCE vuelo_seq;
CREATE SEQUENCE vuelo_seq
    START WITH 4
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
/ 
CREATE OR REPLACE PACKAGE vuelo_crud AS
    PROCEDURE crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE, 
        p_fecha_llegada IN DATE
    );
    
    PROCEDURE obtener_info_para_crear(
        p_aeropuertos OUT SYS_REFCURSOR,
        p_aviones OUT SYS_REFCURSOR
    );

    PROCEDURE leer_vuelo(
        p_vuelo_id IN NUMBER,
        p_info OUT vuelo%ROWTYPE
    );
    
    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR
    );

    PROCEDURE actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
    );

    PROCEDURE eliminar_vuelo(
        p_vuelo_id IN NUMBER
    );
END vuelo_crud;
/
CREATE OR REPLACE PACKAGE BODY vuelo_crud AS
    PROCEDURE crear_vuelo(
        p_aeropuerto_salida_id IN NUMBER,
        p_aeropuerto_llegada_id IN NUMBER,
        p_avion_id IN NUMBER,
        p_destino IN VARCHAR2,
        p_fecha_salida IN DATE,
        p_fecha_llegada IN DATE
    ) IS
    BEGIN
        INSERT INTO VUELO (VUELO_ID, AEROPUERTO_SALIDA_ID, AEROPUERTO_LLEGADA_ID, AVION_ID, DESTINO, FECHA_SALIDA, FECHA_LLEGADA, CANTIDAD_PASAJEROS)
        VALUES (vuelo_seq.NEXTVAL, p_aeropuerto_salida_id, p_aeropuerto_llegada_id, p_avion_id, p_destino, p_fecha_salida, p_fecha_llegada, 0);
        COMMIT;
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
        p_info OUT vuelo%ROWTYPE
    ) IS
    BEGIN
        SELECT * 
        INTO p_info
        FROM VUELO 
        WHERE VUELO_ID = p_vuelo_id;
    END leer_vuelo;

    PROCEDURE leer_vuelos(
        p_vuelos OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_vuelos FOR
        SELECT 
            v.vuelo_id,
            v.aeropuerto_salida_id,
            v.aeropuerto_llegada_id,
            a.nombre aeropuerto_llegada,
            b.nombre aeropuerto_salida,
            v.destino,
            v.fecha_llegada,
            v.fecha_salida,
            v.cantidad_pasajeros
        FROM vuelo v
        INNER JOIN aeropuerto a
        ON v.aeropuerto_salida_id = a.aeropuerto_id
        INNER JOIN aeropuerto b
        ON v.aeropuerto_llegada_id = b.aeropuerto_id;
    END;

    PROCEDURE actualizar_vuelo(
        p_vuelo_id IN NUMBER,
        p_cantidad_pasajeros IN NUMBER,
        p_destino IN VARCHAR2
    ) IS
    BEGIN
        UPDATE VUELO
        SET CANTIDAD_PASAJEROS = p_cantidad_pasajeros,
            DESTINO = p_destino
        WHERE VUELO_ID = p_vuelo_id;
    END actualizar_vuelo;

    PROCEDURE eliminar_vuelo(
        p_vuelo_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM VUELO WHERE VUELO_ID = p_vuelo_id;
    END eliminar_vuelo;
END vuelo_crud;
/