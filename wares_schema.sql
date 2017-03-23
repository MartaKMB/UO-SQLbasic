
create table Producenci
(id int primary key,
nazwa varchar(30),
adres varchar(30)
)

create table Towary
(id int primary key,
nazwa varchar(30) unique,
cena money,
producent int references Producenci(id),
typ varchar(20)
)


insert into Producenci
values(10,	'Ecco',	'Poznan')
insert into Producenci
values(20,	'Hortex',	'Poznan')
insert into Producenci
values(30,	'Wojtas',	'Wroclaw')
insert into Producenci
values(40,	'Bartex',	'Swarzedz')

insert into Towary
values(1,	'sandaly',	150,	10,	'obuwie')
insert into Towary
values(2,	'klapki',	100,	10,	'obuwie')
insert into Towary
values(3,	'marchewkowy',	3,	20,	'soki')
insert into Towary
values(4,	'polbuty',	230,	30,	'obuwie')
insert into Towary
values(5,	'pasta czarna',	10,	10,	'chemia')
insert into Towary
values(6,	'malinowy',	15,	20,	'soki')
insert into Towary
values(7,	'impregnat',	25,	10,	'chemia')
