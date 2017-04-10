----------------------------------------------------------------------------------------------------
---- Zadania przygotowuj�ce do egzaminu po kursie "J�zyk SQL - kurs podstawowy" na UO - zestaw B --- rozwi�zania
----------------------------------------------------------------------------------------------------

------------- tworzenie schematu -------------------------------------------------------------------

 --drop table Filmy
 --drop table Gatunki

create table Gatunki
(id int primary key,
nazwa varchar(20)
)

create table Filmy
(id int primary key identity(1,1),
tytul varchar(40),
gatunek int references Gatunki(Id),
cena money,
czas int,
rezyser varchar(30),
produkcja varchar(20)
)

insert into Gatunki
values(1,	'sensacyjny')
insert into Gatunki
values(2,	'dramat')
insert into Gatunki
values(3,	'komedia')
insert into Gatunki
values(4,	'biograficzny')

insert into Filmy
values('Olivier, Olivier',	2,	54,	110,	'Agnieszka Holland', 'Francja')
insert into Filmy
values('Spioch',	3,	50,	110,	'Woody Allen', 'USA')
insert into Filmy
values('Leon Zawodowiec',	1,	60,	100,	'Luc Besson', 'Francja')
insert into Filmy
values('Sprzedawcy',	3,	41,	90,	'Kevin Smith', null)
insert into Filmy
values('W pogoni za Amy',	3,	40,	 125,	'Kevin Smith', 'USA')


select * from Gatunki
select * from Filmy


------------- Zadania SELECT -------------------------------------------------------------------

-- 1. Podaj tytu�y film�w wyre�yserowanych przez Kevina Smitha lub Woody Allena w cenie powy�ej 40 z�; posortuj alfabetycznie wed�ug tytu�u.

	select tytul
	from Filmy
	where (rezyser = 'Kevin Smith' or rezyser = 'Woody Allen') and cena > 40
	order by tytul

-- 2. Dla ka�dego film podaj jego tytu�, kraj produkcji i nazw� gatunku. Dla warto�ci brakuj�cych (null) wy�wietl 'brak danych'

	select tytul, ISNULL(produkcja, 'brak danych') produkcja, nazwa
	from Filmy join Gatunki
	on Filmy.gatunek = Gatunki.id

-- 3. Podaj tytu�y i ceny komedii.
	-- a) z��czenie 

	select f.tytul, f.cena
	from Filmy f join Gatunki g
	on f.gatunek = g.id
	where g.nazwa = 'komedia'

	-- b) podzapytanie

	select tytul, cena
	from Filmy
	where gatunek =  (select id from Gatunki where nazwa = 'komedia')

-- 4. Podaj tytu�y film�w trwaj�cych d�u�ej (czas) ni� film "Leon zawodowiec"
	-- a) z��czenie 
	select f1.tytul
	from Filmy f1 join Filmy f2
	on f1.czas > f2.czas
	and f2.tytul = 'Leon zawodowiec'

	-- b) podzapytanie

	select tytul
	from Filmy
	where czas > (select czas from Filmy where tytul = 'Leon zawodowiec')


-- 5. Podaj informacj� o tych gatunkach filmowych, kt�rych nie ma obecnie w wypo�yczalni. 
	-- a) z��czenie 

	select g.nazwa
	from Filmy f right join Gatunki g
	on f.gatunek = g.id
	where f.tytul is null;

	-- b) podzapytanie

	select nazwa
	from Gatunki
	where id not in (select gatunek from Filmy)


-- 6. Dla ka�dego gatunku podaj jego nazw� i liczb� film�w tego gatunku

	select g.nazwa, COUNT(f.tytul) liczba
	from Filmy f join Gatunki g
	on f.gatunek = g.id
	group by g.nazwa

	-- lub

	select g.nazwa, COUNT(f.tytul) liczba
	from Filmy f right join Gatunki g
	on f.gatunek = g.id
	group by g.nazwa


-- 7. Podaj tytu� najdro�szego filmu. (podzapytanie i funkcje agregujace, bez TOP)

	select tytul
	from Filmy
	where cena = (select MAX(cena) from Filmy)

-- 8. Podaj tytu� najdro�szej komedii.

	select tytul
	from Filmy
	where cena = (select MAX(cena) from Filmy where gatunek = (select id from Gatunki where nazwa = 'komedia')) 
	and gatunek = (select id from Gatunki where nazwa = 'komedia')


------------- Zadania DDL -------------------------------------------------------------------

-- Utw�rz tabel� Egzemplarze o atrybutach:
	-- id_egzemplarza - liczba, klucz podstawowy
	-- nosnik - typ znakowy, przyjmuje warto�ci 'DVD', 'Blu-ray', 'Video CD'
	-- status_egz - bit, domyslna warto�� 1 (oznacza - dost�pny)
	-- id_filmu - klucz obcy do Filmu

	create table Egzemplarz
	(id_egzemplarza int primary key,
	nosnik varchar(10) check (nosnik in ('DVD', 'Blu-ray', 'Video CD')),
	status_egz bit default 1,
	id_filmu int references Filmy(id)
	)


------------- Zadania DML -------------------------------------------------------------------

-- Napisz polecenie wstawiaj�ce nowy egzemplarz filmu 'Leon Zawodowiec' na DVD

	insert into Egzemplarz
	values (1, 'DVD', DEFAULT, (select ID from Filmy where tytul = 'Leon zawodowiec'))

-- Napisz polecenie, kt�re obni�a cen� wszystkich komedii o 5 z�.

	update Filmy
	set cena = cena - 5
	where gatunek = (select id from Gatunki where nazwa = 'komedia')

-- Napisz polecenie/polecenia usuwaj�ce film 'Leon Zawodowiec' z bazy danych

	delete from Egzemplarz
	where id_filmu = (select id from Filmy where tytul = 'Leon zawodowiec')

	delete from Filmy 
	where tytul = 'Leon zawodowiec'

	
