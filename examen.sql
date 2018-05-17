create database ahorcado;
use ahorcado;

create table dificultad_palabra(
id int identity(1,1) primary key,
dificultad varchar (30),
);
create table estado_juego(
id_estado int identity(1,1)primary key,
nombre varchar(10)
);
create table nivel_jugador(
id_nivel int identity (1,1)primary key,
nombre_nivel varchar (30)
);
create table jugador(
id_jugador int identity(1,1)primary key,
nombre varchar (30),
apellido varchar (50),
nivel int foreign key references nivel_jugador(id_nivel),
puntaje int,
);
create table palabras(
id_palabra int identity(1,1) primary key,
palabra varchar (30),
id_dificultad int foreign key references dificultad_palabra(id)
);
create table palabras_jugador(
id_jugador int foreign key references jugador(id_jugador),
id_palabra int foreign key references palabras(id_palabra)
);
create table juego(
id_juego int identity(1,1) primary key,
tipo_juego int,
jugador1 int foreign key references jugador(id_jugador),
jugador2 int foreign key references jugador(id_jugador) null,
id_palabra int foreign key references palabras(id_palabra),
numintento int,
estado int foreign key references estado_juego(id_estado)
);
create table partida (
jugador1 int foreign key references jugador(id_jugador),
jugador2 int foreign key references jugador(id_jugador) null,
tipo_juego int,
palabraconrayas varchar (30),
id_juego int foreign key references juego(id_juego),
estado int foreign key references estado_juego(id_estado)
);
create table intento(
id_intento int identity(1,1) primary key,
id_juego int foreign key references juego(id_juego),
id_jugador int foreign key references jugador(id_jugador),
respuesta varchar (30),
acierto bit 
);

insert into dificultad_palabra values ('facil ');
insert into dificultad_palabra values ('medio');
insert into dificultad_palabra values ('dificil');
insert into dificultad_palabra values ('muy dificil');
insert into dificultad_palabra values ('ultra mega dificil');

insert into estado_juego values('activo');
insert into estado_juego values('pausado');
insert into estado_juego values('finalizado');

insert into nivel_jugador values('novato');
insert into nivel_jugador values('intermedio');
insert into nivel_jugador values('avanzado');
insert into nivel_jugador values('experto');
insert into nivel_jugador values('dios');

insert into palabras values ('dona',1);
insert into palabras values ('diva',1);
insert into palabras values ('ella',1);
insert into palabras values ('cojo',1);
insert into palabras values ('hola',1);
insert into palabras values ('taza',1);
insert into palabras values ('sol',1);
insert into palabras values ('luz',1);
insert into palabras values ('gota',1);
insert into palabras values ('vela',1);
insert into palabras values ('oso',1);
insert into palabras values ('gato',1);
insert into palabras values ('ave',1);
insert into palabras values ('foza',1);
insert into palabras values ('buda',1);
insert into palabras values ('cura',1);
insert into palabras values ('uno',1);
insert into palabras values ('eva',1);
insert into palabras values ('gil',1);
insert into palabras values ('feo',1);

insert into palabras values ('arpon',2);
insert into palabras values ('redes',2);
insert into palabras values ('lente',2);
insert into palabras values ('perro',2);
insert into palabras values ('aires',2);
insert into palabras values ('buena',2);
insert into palabras values ('aries',2);
insert into palabras values ('arbol',2);
insert into palabras values ('atlas',2);
insert into palabras values ('cesar',2);
insert into palabras values ('bolsa',2);
insert into palabras values ('raton',2);
insert into palabras values ('cacao',2);
insert into palabras values ('dados',2);
insert into palabras values ('hacia',2);
insert into palabras values ('ideas',2);
insert into palabras values ('nadie',2);
insert into palabras values ('rabia',2);
insert into palabras values ('queso',2);
insert into palabras values ('xenon',2);

insert into palabras values ('abejas',3);
insert into palabras values ('cables',3);
insert into palabras values ('gacela',3);
insert into palabras values ('antena',3);
insert into palabras values ('habano',3);
insert into palabras values ('labios',3);
insert into palabras values ('jabali',3);
insert into palabras values ('pajaro',3);
insert into palabras values ('macaco',3);
insert into palabras values ('maleta',3);
insert into palabras values ('puerta',3);
insert into palabras values ('objeto',3);
insert into palabras values ('obispo',3);
insert into palabras values ('quemar',3);
insert into palabras values ('rabano',3);
insert into palabras values ('yogurt',3);
insert into palabras values ('sabado',3);
insert into palabras values ('martes',3);
insert into palabras values ('vacuno',3);
insert into palabras values ('ulcera',3);

insert into palabras values ('damasco',4);
insert into palabras values ('verdura',4);
insert into palabras values ('iconico',4);
insert into palabras values ('laboral',4);
insert into palabras values ('alcohol',4);
insert into palabras values ('necrosis',4);
insert into palabras values ('cabalgar',4);
insert into palabras values ('dalmatas',4);
insert into palabras values ('objecion',4);
insert into palabras values ('sabatico',4);
insert into palabras values ('ejecucion',4);
insert into palabras values ('hipofisis',4);
insert into palabras values ('Epilepsia',4);
insert into palabras values ('xenofobia',4);
insert into palabras values ('idealsimo',4);
insert into palabras values ('serigrafia',4);
insert into palabras values ('Peyorativo ',4);
insert into palabras values ('hipotalamo ',4);
insert into palabras values ('Ventriculo ',4);
insert into palabras values ('esclerosis ',4);

insert into palabras values ('filantropia ',5);
insert into palabras values ('paralelepipedo',5);
insert into palabras values ('caleidoscopio',5);
insert into palabras values ('misantropia',5);
insert into palabras values ('electromagnetismo ',5);
insert into palabras values ('carbonificación ',5);
insert into palabras values ('electrocardiograma',5);
insert into palabras values ('subcontinental',5);
insert into palabras values ('constitucional',5);
insert into palabras values ('arqueologia',5);
insert into palabras values ('revolucionario',5);
insert into palabras values ('reconstructivo',5);
insert into palabras values ('instrumentacion',5);
insert into palabras values ('transcripcion',5);
insert into palabras values ('electrodomestico',5);
insert into palabras values ('fragmentacion',5);
insert into palabras values ('trascendencia',5);
insert into palabras values ('otorrinolaringologo',5);
insert into palabras values ('extraterrestre',5);
insert into palabras values ('esternocleidomastoideo',5);





