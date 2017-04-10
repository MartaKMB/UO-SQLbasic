----------------------------------------------------------------------------------------------------
---- Zadania przygotowuj¹ce do egzaminu po kursie "Jêzyk SQL - kurs podstawowy" na UO - zestaw C ---
----------------------------------------------------------------------------------------------------

-- Dana jest baza zawieraj¹ca: listê przelotów oraz biletów wykupionych na te przeloty pzres pasa¿erów

------------- tworzenie schematu

--drop table bilety
--drop table przeloty

create table Przeloty
(id int primary key,
skad varchar(10),
dokad varchar(10),
dzien varchar(10),
przewoznik varchar(10))

create table Bilety
(numer int primary key,
nazwisko varchar(15),
przelot int references Przeloty(id),
data date,
cena money)

insert into przeloty
values(111, 'Poznan', 'Warszawa', 'wtorek', 'LOT'),
(222, 'Poznan', 'Berlin', 'czwartek', 'LOT'),
(333, 'Poznan', 'Barcelona', 'wtorek', 'LOT'),
(444, 'Berlin', 'Toronto', 'czwartek', 'Lufthansa'),
(555, 'Barcelona', 'Madryt', 'sobota', 'Iberia');

insert into Bilety
values(1, 'Kowalski', 111, '11-05-2013', 120),
(2, 'Adamczak', 222, '01-02-2013', 235),
(3, 'Janas', 222, '05-05-2013', 255),
(4, 'Adamczak', 222, '07-06-2013', 310),
(5, 'Smith', 444, '08-08-2013',2500),
(6, 'Kwiatkowska', 111, '10-11-2013', 120);


select * from przeloty
select * from bilety



------------- Zadania SELECT 

-- 1. Podaj nazwiska wszystkich osób, które we wtorek wylatuj¹ z Poznania. Posortuj malej¹co po nazwisku.
	-- a) z³¹czenie
	-- b) podzapytanie

	-- a)
	select Bilety.nazwisko 
	from Przeloty join Bilety
	on Przeloty.id = Bilety.przelot
	where Przeloty.dzien = 'wtorek'
	and Przeloty.skad = 'Poznan'
	order by Bilety.nazwisko desc

	-- b)
	select nazwisko
	from Bilety
	where przelot in (select id from Przeloty
					 where dzien = 'wtorek'
					 and skad = 'Poznan')
	order by nazwisko desc

nazwisko
---------------
Kwiatkowska
Kowalski


-- 2. Podaj nazwiska wszystkich osób, które kupi³y bilet do Berlina 
	-- a) z³¹czenie
	-- b) podzapytanie

	select distinct Bilety.nazwisko 
	from Przeloty join Bilety
	on Przeloty.id = Bilety.przelot
	where Przeloty.dokad = 'Berlin'

	-- b)
	select distinct nazwisko
	from Bilety
	where przelot in (select id from Przeloty
					 where dokad = 'Berlin')
	
nazwisko
---------------
Adamczak
Janas

-- 3. Dla ka¿dego przelotu podaj liczbê zakupionych biletów i ich ³¹czn¹ cenê.

	select przelot, COUNT(*) licz_biletow, SUM(cena) sum_cena
	from Bilety
	group by przelot

przelot     licz_biletow sum_cena
----------- ------------ ---------------------
111         2            240,00
222         3            800,00
444         1            2500,00

-- 4. Podaj numery przelotów, na które nie wykupiono ¿adnego biletu.
	-- a) z³¹czenie zewnêtrzne 
	-- b) podzapytanie "not in")

	select Przeloty.id
	from Przeloty left outer join Bilety
	on Przeloty.id = Bilety.przelot
	where Bilety.numer is null

	select ID
	from Przeloty
	where id not in (select przelot from Bilety)
ID
-----------
333
555

-- 5. Podaj nazwisko osoby, która kupi³a najdro¿szy bilet (bez TOP)

	select nazwisko
	from Bilety
	where cena = (select MAX(cena) from Bilety)

nazwisko
---------------
Smith
	
-- 6. Podaj nazwy wszystkich miast, do ktorych mozna doleciec z Poznania z dok³adnie jedn¹ przesiadk¹ tego samego dnia. (podzapytanie skorelowane)
	-- a) z³¹czenie (self-join)
	-- b) podzapytanie (skorelowane - nie bêdzie na egzaminie)
	
	select dokad
	from Przeloty p1
	where skad in (select dokad from Przeloty p2 where skad = 'Poznan' and p1.dzien = p2.dzien)

	select p2.dokad
	from Przeloty p1 join Przeloty p2
	on p1.dokad = p2.skad
	where p1.skad = 'Poznan'
	and p1.dzien = p2.dzien

dokad
----------
Toronto

-- 7. Podaj nazwy wszystkich miast, do których mozna we wtorek doleciec LOT-em bezpoœrednio z Poznania. Posortuj alfabetycznie.
	
	select dokad
	from Przeloty
	where skad = 'Poznan'
	and przewoznik = 'LOT'
	order by dokad

dokad
----------
Barcelona
Berlin
Warszawa


-- 8. Podaj nazwy przewoŸników, którzy w 2013 roku zarobili na biletach przynajmniej 2000 z³. (having - nie bêdzie na egzaminie)

	select Przeloty.przewoznik, SUM(bilety.cena) dochody_z_biletow
	from Przeloty join Bilety
	on Przeloty.id = Bilety.przelot
	group by Przeloty.przewoznik
	having SUM(bilety.cena) >= 2000




-------- zadanie DDL

-- Z danym biletem mo¿e byæ powi¹zane kilka baga¿y, które chcemy rejestrowaæ w bazie danych

-- Utwórz tabelê BAGA¯E o atrybutach:
	-- numer_bagazu - klucz podstawowy
	-- numer_biletu - klucz obcy do biletu
	-- wymiar_X - w centymetrach; nie mo¿e przekroczyæ 150 cm
	-- wymiar_Y - w centymetrach; nie mo¿e przekroczyæ 150 cm
	-- wymiar_Z - w centymetrach; nie mo¿e przekroczyæ 150 cm
	-- waga - w kg; nie mo¿e przekroczyæ 100
	-- typ - mo¿e przyjmowaæ wartoœci "podreczny", "standard", "ekstra"; wartoœæ domyœlna - "standard"

	drop table Bagaze

	CREATE TABLE Bagaze
	(numer_bagazu int primary key,
	 numer_biletu int references Bilety(numer),
	 wymiar_X_cm int check (wymiar_X_cm <=150),
	 wymiar_Y_cm int check (wymiar_Y_cm <=150),
	 wymiar_Z_cm int check (wymiar_Z_cm <=150),
	 waga_kg int check (waga_kg <=100),
	 typ varchar(50) check (typ in ('podreczny', 'standard', 'ekstra')) default 'standard'
	)

-------- zadanie DML

-- Dodaj baga¿ o wymiarach 28 x 59 x 35 cm, wadze 23 kg, standardowy, do biletu nr 4

	insert into Bagaze
	values (1, 4, 28, 59, 35, 23, DEFAULT)

-- Zmodyfikuj termin przelotu LOT-u z Poznania do Barcelony z wtorku na sobotê

	update Przeloty
	set dzien = 'sobota'
	where dzien = 'wtorek'
	and przewoznik = 'LOT'
	and skad = 'Poznan'
	and dokad = 'Barcelona'
		
-- Dodaj nowy bilet na przelot Iberi¹ z Barcelony do Madrytu w sobotê na nazwisko 'Smith', w cenie 450, na 25 marca 2017

	insert into Bilety
	values ((select MAX(numer)+1 from Bilety), 'Smith', (select ID from Przeloty where przewoznik = 'Iberia' and skad = 'Barcelona' and dokad = 'Madryt' and dzien = 'sobota'), '2017-03-25', 450)

-- Usuñ przelot 111; jakie operacje trzeba wykonaæ?

	
	update Bilety
	set przelot = null
	where przelot = 111

	delete from Przeloty
	where id = 111
