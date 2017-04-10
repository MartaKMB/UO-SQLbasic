----------------------------------------------------------------------------------------------------
---- Zadania przygotowuj¹ce do egzaminu po kursie "Jêzyk SQL - kurs podstawowy" na UO - zestaw A ---
----------------------------------------------------------------------------------------------------

------------- tworzenie schematu

--drop table ksiazki
--drop table autorzy
--go

create table autorzy
(id_autor int primary key,
 nazwisko varchar(30),
 kraj varchar(10));

create table ksiazki
(id_ksiazki int identity(1,1) primary key,
 id_autor int references autorzy(id_autor),
 tytul varchar(50),
 cena float,
 rok_wydania int,
 dzial varchar(30));

go

insert into autorzy
values(1, 'Abiteboul', 'USA');
insert into autorzy
values(2, 'Szekspir', 'Anglia');
insert into autorzy
values(3, 'Sapkowski', 'Polska');
insert into autorzy
values(4, 'Yen' ,'USA');
insert into autorzy
values(5, 'Cervantes' ,'Hiszpania');


insert into ksiazki
values(1, 'Quering XML', 60, 1997, 'informatyka');
insert into ksiazki
values(1, 'Data on the web', 75, 2000, 'informatyka');
insert into ksiazki
values(2, 'Poskromienie z³oœnicy', 32, 1999, null);
insert into ksiazki
values( 3, 'Ostatnie ¿yczenie', 25, 1993 ,'sf');
insert into ksiazki
values(3, 'Wie¿a jaskó³ki', 30, 1997, 'sf');
insert into ksiazki
values(3, 'Narrenturm', 20, 2002, 'sf');
insert into ksiazki
values(4, 'Fuzzy Logic', 55, 2010, 'informatyka');


select * from autorzy
select * from ksiazki

------------- Zadania SELECT

-- 1. Podaj nazwiska autorow spoza Polski; uporzadkuj alfabetycznie wedlug nazwisk

	select *
	from autorzy
	where kraj <> 'Polska'
	order by nazwisko

id_autor    nazwisko                       kraj
----------- ------------------------------ ----------
1           Abiteboul                      USA
5           Cervantes                      Hiszpania
2           Szekspir                       Anglia
4           Yen                            USA


-- 2. Dla ka¿dej ksi¹¿ki wyœwietl jej tytu³, nazwisko autora i dzia³. W przypadku braku danych wyœwietl 'brak danych'

	select tytul, nazwisko, isnull(dzial, 'brak danych') dzial
	from ksiazki join autorzy
	on ksiazki.id_autor = autorzy.id_autor

tytul                                              nazwisko                       dzial
-------------------------------------------------- ------------------------------ ------------------------------
Quering XML                                        Abiteboul                      informatyka
Data on the web                                    Abiteboul                      informatyka
Poskromienie z³oœnicy                              Szekspir                       brak danych
Ostatnie ¿yczenie                                  Sapkowski                      sf
Wie¿a jaskó³ki                                     Sapkowski                      sf
Narrenturm                                         Sapkowski                      sf
Fuzzy Logic                                        Yen                            informatyka

-- 3. Podaj ksiazki zawierajace ci¹g 'XML' w tytule

	select * 
	from ksiazki
	where tytul like '%XML%'

id_autor    tytul                                              cena                   rok_wydania dzial
----------- -------------------------------------------------- ---------------------- ----------- ------------------------------
1           Quering XML                                        60                     1997        informatyka

-- 4. Znajdz ksiazki drozsze od 'Fuzzy Logic'
	-- a) z³¹czenie 

	select k1.tytul, k1.cena
	from ksiazki k1 join ksiazki k2
	on k1.cena > k2.cena
	and k2.tytul = 'fuzzy logic'

	-- b) podzapytanie

	select tytul, cena
	from ksiazki
	where cena > (select cena from ksiazki where tytul = 'fuzzy logic')

tytul                                              cena
-------------------------------------------------- ----------------------
Quering XML                                        60
Data on the web                                    75


-- 5. Podaj autorow ksiazek z informatyki

	-- a) z³¹czenie 
	select distinct nazwisko 
	from autorzy a join ksiazki k
	on a.id_autor = k.id_autor
	where k.dzial = 'informatyka'

	-- b) podzapytanie
	select nazwisko 
	from autorzy a 
	where id_autor in 
			(select id_autor
			from ksiazki
			where dzial = 'informatyka')

nazwisko
------------------------------
Abiteboul
Yen

-- 6. ZnajdŸ autorów z tego samego kraju co Abiteboul

	-- a) z³¹czenie 

	select a1.nazwisko
	from autorzy a1 join autorzy a2
	on a1.kraj = a2.kraj
	where a2.nazwisko = 'Abiteboul'
	and a1.nazwisko <> 'Abiteboul'

	-- a) podzapytanie

	select nazwisko
	from autorzy
	where kraj = (select kraj from autorzy where nazwisko = 'Abiteboul')
	and nazwisko <> 'Abiteboul' 

nazwisko
------------------------------
Yen

-- 7. Podaj liczbê ksiazek w kazdym z dzia³ów (bez null-i)

	select dzial, COUNT(*) liczba
	from ksiazki
	where dzial is not null
	group by dzial

dzial                          liczba
------------------------------ -----------
informatyka                    3
sf                             3

-- 8. Podaj œredni¹ cen¹ ksiazek Sapkowskiego

	select AVG(cena) srednia
	from ksiazki
	where id_autor = (select id_autor
					from autorzy
					where nazwisko = 'Sapkowski')

srednia
----------------------
25

-- 9. Podaj tytu³ najtanszej ksiazki 

	select *
	from ksiazki
	where cena = (select min(cena) from ksiazki)

id_autor    tytul                                              cena                   rok_wydania dzial
----------- -------------------------------------------------- ---------------------- ----------- ------------------------------
3           Narrenturm                                         20                     2002        sf

-- 10. Podaj tytu³ najtanszej ksiazki z informatyki

	select *
	from ksiazki
	where cena = (select min(cena)
				  from ksiazki
				  where dzial = 'informatyka')
	and dzial = 'informatyka'

id_autor    tytul                                              cena                   rok_wydania dzial
----------- -------------------------------------------------- ---------------------- ----------- ------------------------------
4           Fuzzy Logic                                        55                     2010        informatyka


-- 10. Podaj autora, ktorego ksi¹¿ek nie ma w bazie 
	-- a) z³¹czenie 
	select nazwisko
	from autorzy a left outer join ksiazki k
	on a.id_autor = k.id_autor
	where k.tytul is null

	-- b) podzapytanie
	select nazwisko
	from autorzy
	where id_autor not in (select id_autor from ksiazki)

nazwisko
------------------------------
Cervantes

------------- Zadania DDL

-- Utwórz tabelê ZAMOWIENIE o atrybutach:
	-- id_zamowienia - liczbowy, klucz podstawowy
	-- ksi¹zka - klucz obcy do tabeli Ksiazki
	-- liczba_egzemplarzy - liczba, nie mo¿e byæ pusta
	-- data_zamowienia - data, domyœlnie dzisiejsza
	-- status_zam - mo¿e przyjmowaæ wartoœæ 'przyjete', 'w trakcie', 'zrealizowane', 'anulowane'

	create table Zamowienia
	(id_zamowienia int primary key,
	ksiazka int references ksiazki(id_ksiazki),
	liczba_egzemplarzy int not null,
	data_zamowienia date default getdate(),
	status_zam varchar(20) CHECK (status_zam in ('przyjete', 'w trakcie', 'zrealizowane', 'anulowane'))
	)

------------- Zadania DML

-- Napisz polecenie dodaj¹ce nowe zamówienie na 5 egzemplarzy 'Narrenturm' z domyœln¹ dat¹ i statusem 'przyjete'

	insert into Zamowienia
	values (1, (select id_ksiazki from ksiazki where tytul = 'Narrenturm'), 5, DEFAULT, 'przyjete')

-- Napisz polecenie zmieniaj¹ce status wszystkich przyjetych zamówieñ na 'w trakcie'

	update Zamowienia
	set status_zam = 'w trakcie'
	where status_zam = 'przyjete'

-- Napisz polecenie usuwaj¹ce wszystkie ksi¹¿ki Abiteboul-a

	delete from ksiazki
	where id_autor = (select id_autor from autorzy where nazwisko = 'Abiteboul')
