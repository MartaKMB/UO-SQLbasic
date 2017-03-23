-------------------
-- usun tabele

IF OBJECT_ID('Oplaty', 'U') IS NOT NULL 
        drop table Oplaty
IF OBJECT_ID('Udzial', 'U') IS NOT NULL 
        drop table Udzial
IF OBJECT_ID('Edycje', 'U') IS NOT NULL 
        drop table Edycje
IF OBJECT_ID('Kursy', 'U') IS NOT NULL 
        drop table Kursy
IF OBJECT_ID('Uczestnicy', 'U') IS NOT NULL 
        drop table Uczestnicy
IF OBJECT_ID('Statusy', 'U') IS NOT NULL 
        drop table Statusy

-------------------
-- utworz tabele

create table Kursy
(id int primary key,
nazwa nvarchar(100) unique,
liczba_dni smallint);

create table Edycje
(idE char(8) primary key,
idK int references Kursy(id),
data_start date,
data_koniec date,
cena money);

create table Statusy
(status_kod smallint primary key,
status_opis nvarchar(50));

create table Uczestnicy
(pesel char(11) primary key CHECK(ISNUMERIC(PESEL) = 1 and len(Pesel)=11),
imie nvarchar(30),
nazwisko nvarchar(50),
adres nvarchar(30));

create table Udzial
(uczestnik char(11) references Uczestnicy(pesel),
edycja char(8) references Edycje(idE),
status_kod smallint references Statusy(status_kod),
primary key (uczestnik, edycja));

create table Oplaty
(idO int primary key,
numer_raty int,
uczestnik char(11),
edycja char(8),
kwota money,
constraint fk_oplaty_udzial foreign key (uczestnik, edycja) references Udzial(uczestnik, edycja));

-------------------
-- wstaw wiersze

insert into Kursy values 
(111,	'Administracja MySQL',	3),
(222,	'Analiza danych',	3),
(333,	'MS Access (zaawansowany)',	2),
(444,	'SQL Server dla pocz¹tkuj¹cych',	2),
(555,	'SQL Server dla programistów',	1),
(666,	'Programowanie VBA w Accessie',	null);


insert into Edycje values 
('1112014Z', 111, '2014-10-10',  '2014-10-12',  2900),
('2222014Z', 222, '2014-11-01',  '2014-11-03',  3200),
('3332014L', 333, '2014-05-23',  '2014-05-24',  1200),
('1112015Z', 111, '2015-10-10',  '2015-10-12',  2900),
('2222015Z', 222, '2015-11-05',  '2015-11-07',  3300),
('3332015L', 333, '2015-04-12',  '2015-04-13',  1500),
('4442015Z', 444, '2015-11-01',  '2015-11-02',  2000),
('5552015L', 555, '2015-04-01',  '2015-04-01',  870),
('4442016L', 444, null, null, null);


insert into Uczestnicy values 
('75010106222',	'Tomasz',	'Górski',	'Poznañ'),
('78020806063',	'Karol',	'Nowak',	'P-ñ'),
('80120811199',	'Maciej',	'Ziêba',	'Kraków'),
('81020254544',	'Zenon',	'Jankowiak',	'Poznañ'),
('81120811163',	'Renata',	'Kowal',	null),
('88021816060',	'Joanna',	'Maliñska',	'Olkusz'),
('90101022233',	'Aneta',	'Romanowska',	'Kraków');


insert into Statusy values 
(0,	'nie ukoñczony'),
(1,	'ukoñczony'),
(2,	'w toku');


insert into Udzial values 
('75010106222',		'1112014Z',	1),
('78020806063',		'1112014Z',	1),
('78020806063',		'2222014Z',	0),
('78020806063',		'2222015Z',	1),
('78020806063',		'5552015L',	0),
('80120811199',		'2222014Z',	1),
('80120811199',		'4442015Z',	2),
('81120811163',		'1112014Z',	1),
('88021816060',		'4442015Z',	2),
('88021816060',		'3332014L',	1),
('88021816060',		'5552015L',	1),
('90101022233',		'4442015Z',	2),
('90101022233',		'5552015L',	0);

insert into Oplaty values 
(1, 1, '75010106222',		'1112014Z', 2900),
(2, 1, '78020806063',		'1112014Z', 1450),
(3, 2, '78020806063',		'1112014Z', 1450),
(4, 1, '78020806063',		'2222014Z', 800),
(5, 2, '78020806063',		'2222014Z', 800),
(6, 3, '78020806063',		'2222014Z', 800),
(7, 4, '78020806063',		'2222014Z', 800),
(8, 1, '78020806063',		'2222015Z', 3300),
(9, 1, '78020806063',		'5552015L', 870),
(10, 1, '80120811199',		'2222014Z', 800),
(11, 2, '80120811199',		'2222014Z', 800),
(12, 3, '80120811199',		'2222014Z', 800),
(13, 4, '80120811199',		'2222014Z', 800),
(14, 1, '80120811199',		'4442015Z', 1000),
(15, 1, '81120811163',		'1112014Z', 2900),
(16, 1, '88021816060',		'4442015Z', 1000),
(17, 1, '88021816060',		'3332014L', 1200),
(18, 1, '88021816060',		'5552015L', 500),
(19, 1, '90101022233',		'4442015Z', 1000),
(20, 1, '90101022233',		'5552015L',	500),
(21, 2, '90101022233',		'5552015L',	470);


-----------------------------------
-- wyœwietl tabele

select * from Kursy;
select * from Edycje;
select * from Uczestnicy;
select * from Udzial;
select * from Statusy;
select * from Oplaty;

