-- powtorka do egzaminu

select * from edycje

update Edycje set cena = (select cena from edycje where idE = '4442015Z') where idE = '4442016L'

select * from autorzy

-- zajecia 8 (14.03)

-- insert
-- z selectem wyciagajacym pesel Karola Nowaka

insert into Certyfikaty
(numer, uczestnik, kurs, data_wystawienia, wynik, waznosc)
values  (123, 
		(select pesel from Uczestnicy where nazwisko = 'Nowak' and imie = 'Karol'),
		(select id from Kursy where nazwa = 'Analiza danych'),
		default,
		'B',
		default)

insert into Kursy (id, nazwa, liczba_dni)
values (
(select MAX(id) + 111 from Kursy), 'Jezyk SQL - kurs podstawowy', 8)

select * from Kursy

-- zeby nie wstawic juz wykorzystanego id
-- select MAX(id) + 111 from Kursy

-- drop - ponizsze sie nie powiedzie, bo tabela jest powiazana z innymi, sa klucze obce

drop table Kursy

-- alter dodaje nowy atrybut do istniejacej tabeli
-- tinyint od 0 do 250

alter table Certyfikaty
add
waznosc tinyint check (waznosc between 0 and 20) default 5

-- tworzenie tabeli
-- odwolanie jest mozliwe tylko do tabeli, ktora istnieje - czyli kolejnosc ma znaczenie
-- w zadaniu skrocona wersja kurs char(8) foreign key references Edycje(idE),
-- domyslna data default getdate()

create table Certyfikaty
(
numer int primary key,
uczestnik char(11) references Uczestnicy(pesel),
kurs int references Kursy(id),
data_wystawienia date default getdate(),
wynik char(1) check (wynik in('A', 'B', 'C', 'D', 'E'))
)

select * from Certyfikaty

-- zajecia 7 (07.03)

-- nazwy kursow zawierajace w sobie SQL
select nazwa 
from Kursy 
where nazwa like '%SQL%'

-- sumaryczna kwota wplacone przez uczestnikow z kazdej edycji
select uczestnik, edycja, SUM(kwota) suma, COUNT(*) 'ile rat'
from Oplaty
group by uczestnik, edycja order by uczestnik

-- aby bylo rowniez nazwisko
select Uczestnicy.nazwisko, edycja, SUM(kwota) suma, COUNT(Oplaty.numer_raty) 'ile rat'
from Oplaty right join Uczestnicy
on Oplaty.uczestnik = Uczestnicy.pesel
group by Oplaty.uczestnik, Oplaty.edycja, Uczestnicy.nazwisko 
order by uczestnik

-- dla kazdego uczestnika informacja w ilu edycjach bral udzial
-- pogrupowanie danych po uczestniku i dla kazdego agregacja po COUNT

-- mozemy wyswietlac tylko to po czym grupujemy
-- w ramach nazwisk grupowanie po peselu, gdyby kilka osob o tym samym nazwisku
-- odfiltrowac te osoby, ktore wziely udzial w min 2
select Uczestnicy.nazwisko, Uczestnicy.imie, 
COUNT(*) 'liczba_edycji'
from Udzial join Uczestnicy
on Udzial.uczestnik = Uczestnicy.pesel
GROUP BY Uczestnicy.pesel, Uczestnicy.nazwisko, Uczestnicy.imie
HAVING COUNT(*) >= 2

-- przygotowanie
select COUNT(*)
from Udzial
where uczestnik = '78020806063'

-- najnowsza edycja analizy danych
select *
from Edycje join Kursy
on Edycje.idK = Kursy.id
where data_start = (select MAX(data_start) 
				from Edycje join Kursy
				on Edycje.idK = Kursy.id
				where Kursy.nazwa = 'Analiza danych')
and Kursy.nazwa = 'Analiza danych'

-- moje podejscie
select MAX(data_start) 
from Edycje 
where idK in 
		(select id from Kursy 
		where nazwa = 'Analiza danych')

-- najkrotszy kurs
select nazwa from Kursy where liczba_dni =
		(select MIN(liczba_dni) from Kursy)

-- podaj nazwe najdrozszego kursu / z tabeli edycje
-- zlaczenie
select IDE, Kursy.nazwa
from Edycje join Kursy
on Edycje.idK = Kursy.id
where cena = (select MAX(cena) 
			from Edycje)
-- podzapytanie
select nazwa from Kursy where id in
						(select idK from Edycje where cena =
												(select MAX(cena) from Edycje))

-- to zapytanie zadziala tylko w systemie Microsoft (nie dziala)
select top 1
from Edycje
order by cena desc

-------------------------------------------------------------------------------------
-- zad.dom
-- liczba i suma rat K.N.

select COUNT(*) liczba, SUM(kwota) suma
from Oplaty
where uczestnik = (select pesel from Uczestnicy
where imie = 'Karol' and nazwisko = 'Nowak')

-- najnowsza edycja
-- select MAX(data_start)

-- podzapytanie: najpierw pesel konkretnej osoby, dalej jakie ma konta i dla tych kont podliczam operacje

-- wyciaganie roku z daty year(data_utworzenia)

-------------------------------------------------------------------------------------
-- zajecia 6 (28.02)

-- funkcje agregujace

-- minimalna, maksymalna i srednia cena edycji
-- moje podejscie
select MIN(cena) 'cena minimalna',
MAX(cena) 'cena maksymalna',
AVG(cena) 'srednia cena za kurs'
from Edycje

-- distinct po miastach, wiec w tych samych miastach
select COUNT(*) 'ilu uczestnikow', 
COUNT(distinct adres) 'ile miast',
COUNT(adres)
from Uczestnicy

-- count nie zlicza null'i, wiec
-- liczba wierszy w tabeli, na pewno, to:
select COUNT(pesel) 'ile uczestnikow'
from Uczestnicy

-- edycje na ktore nikt sie nie zapisal  z exist
select *
from Edycje E
where not exists (select * from Udzial Ud 
where Ud.edycja = E.idE)

-- edycje w ktorych wzielo udzial wiecej niz dwie osoby
-- podzapytanie skorelowane - czyli nie jest samodzielnie istniejacym zapytaniem
select *
from Edycje E
where (select COUNT(*)
from Udzial U
where U.edycja = E.idE) > 2

-- uczestnicy nie ukonczyli z sukcesem edycji
select nazwisko
from Uczestnicy
where pesel not in (select uczestnik from Udzial where status_kod = 1)

-- polaczenie z uzialem, ktory zakonczyl sie sukcesem
-- czyli and status_kod =1
-- moje podejscie
-- where Udzial.uczestnik is null
select Uczestnicy.nazwisko
from Uczestnicy left join Udzial
on Uczestnicy.pesel = Udzial.uczestnik
and status_kod = 1
where Udzial.uczestnik is null

-- uczestnicy, ktorzy nie wniesli zadnej oplaty
-- uczestnicy, ktorych nie ma w tabeli oplaty
select nazwisko
from Uczestnicy
where pesel not in (select uczestnik from Oplaty)

-- edycje w ktorych nikt nie uczestniczyl z podzapytaniem
-- edycje ktorych nie ma w tabeli udzial
select *
from Edycje
where idE not in (select edycja from Udzial)

----------------------------------------------------
-- zad.dom - moje proby/wspolnie
-- firma szkoleniowa
-- 1)
select *
from Kursy left join Edycje
on Kursy.id = Edycje.idK
where Edycje.idE is null 

-- 2) nieoplacone udzialy
-- udzial z oplata lacza sie po 2 atrybutach; klucz obcy jest dwu-atrybutowy
-- nie szukamy kwoty, ktora jest pusta - nie ma calego wiersza
-- dlatego wybieramy klucz podstawowy - nie moze byc pusty
-- wspolnie:
select *
from Udzial left join Oplaty
on Udzial.uczestnik = Oplaty.uczestnik
and Udzial.edycja = Oplaty.edycja
where Oplaty.idO is null

-- zle
select *
from Uczestnicy left join Oplaty
on Uczestnicy.pesel = Oplaty.uczestnik
where Oplaty.numer_raty is null

-- towary
-- 3)
select *
from Producenci join Towary
on Producenci.adres = Towary.producent

-- 4) towary drozsze od klapki
-- podzapytanie nieskorelowane - uwaga aby zwrocilo jedna wartosc
-- wspolnie:
select nazwa
from Towary
where cena > (select cena from Towary where nazwa = 'klapki')

-- dobrze!
select Towary.nazwa
from Towary
where Towary.cena > (select Towary.cena from Towary where Towary.nazwa = 'klapki')

-- bank
-- 5)
select Konta.nr_konta, Klienci_banku.nazwisko
from Konta join Klienci_banku
on Konta.wlasciciel = Klienci_banku.pesel

-- 6)
select *
from Konta left join Operacje
on Konta.nr_konta = Operacje.nr_konta

-- 7)
select Operacje.data, Operacje.kwota
from Operacje join Konta
on Operacje.nr_konta = Konta.nr_konta
from Konta join Klienci_banku
on Konta.wlasciciel = Klienci_banku.pesel
where Klienci_banku.nazwisko = 'Jaskowiak'

-- 8)
select Operacje.kwota
from Operacje
where Operacje.typ = 'wplata' (select * from Konta where Konta.rodzaj = 'oszczednosciowe')

-------------------------------------------
-- zajecia 5 (21.02)

-- zad 7)
-- zad na anty-zlaczenie, sa 3 sposoby
select *
from Edycje left join Udzial
on Edycje.idE = Udzial.edycja
-- wszystkie kolumny z tabeli udzial sa puste

select idE, data_start
from Edycje left join Udzial
on Edycje.idE = Udzial.edycja
where Udzial.uczestnik is null

-- zad 8)
-- uczestnikow i kursy w ktorych brali udzial, jesli nie bral w zadnm wyswietl brak w nazwie kursu
select distinct u.nazwisko, isnull(k.nazwa, 'brak') 'kurs'
from Uczestnicy u 
left join Udzial ud
on u.pesel = ud.uczestnik
left join Edycje e
on ud.edycja = e.idE
left join Kursy k
on e.idK = k.id

--zaawansowane
select distinct u.nazwisko, isnull(k.nazwa, 'brak') 'kurs'
from Uczestnicy u 
left join (Udzial ud
		join (Edycje e
			join Kursy k
			on e.idK = k.id)
		on ud.edycja = e.idE)
	on u.pesel = ud.uczestnik

-- zad 10)
-- uczestnicy, ktorzy nie wniesli zadnej oplaty
select *
from Uczestnicy u left join Oplaty o
on u.pesel = o.uczestnik
where idO is null

-- modyfikacje, spr czy uczestnik zapisal sie i nie zaplacil
select *
from Uczestnicy inner join Udzial
on Uczestnicy.pesel = Udzial.uczestnik
left join Oplaty
on Uczestnicy.pesel = Oplaty.uczestnik
where idO is null

---------------------------------------
-- zadanie domowe

-- oplaty wniesione przez k.nowaka
select numer_raty, edycja, kwota
from Oplaty join Uczestnicy
on Uczestnicy.pesel = Oplaty.uczestnik
where Uczestnicy.nazwisko = 'Nowak'
order by edycja, numer_raty

-- edycje pokrywajace sie w czasie
select e1.ide, e2.ide
from Edycje e1 join Edycje e2
on e1.idE <> e2.idE
where (e1.data_start <= e2. data_start
and e1.data_koniec >= e2.data_start)

------------------------------------------------------------------------------------------
-- zajecia 4 (14.02)

-- zadania
--1) moze byc inner join, moze byc sam join
select distinct k.nazwa
from Kursy k join Edycje e 
on e.idK = k.id
where e.cena > 2000
and (month(e.data_start) in (10,11)
or month(e.data_koniec) in (10,11))

--2) wiele do wiele, nie ma bezposredniego powiazania czyli
-- uczestnik -> udzial -> edycje -> kursy

select distinct u.nazwisko, k.nazwa
from Uczestnicy u join Udzial ud
on u.pesel = ud.uczestnik
join Edycje e
on ud.edycja = e.idE
join Kursy k
on e.idK = k.id

-- inner join
-- polaczenie edycji z kursem (wez edycje ktore dot tego kursu)
select distinct k.nazwa, e.cena
from Edycje e inner join Kursy k
on e.idK = k.id

-- cross join
select kursy.nazwa as nazwa_kursu, kalendarz.miesiac 
from kursy cross join 
	( select 'styczen' as miesiac, 1 as kwartal 
	UNION ALL select 'luty', 1 
	UNION ALL select 'marzec', 1 ) 
	as kalendarz

select * from Uczestnicy
union all
select * from Uczestnicy

-- nie podalismy elementu zlaczeniowego
select *
from Uczestnicy, Edycje

-------------------------------------------------------
-- zadanie domowe
-- 1)
select *
from Edycje
where cena < 3000
and DATEDIFF(yy, data_start, getdate()) <= 2
-- 2)
select nazwa,
case when liczba_dni is null then 'nie podano' 
	else cast(liczba_dni as char(3))
	end as 'nowy_atrybut'
from Kursy

-- 3)
-- select imie, nazwisko,
-- case when SUBSTRING(pesel, 3, 1) in (2,3) then YEAR(GETDATE()) - (SUBSTRING(pesel, 1, 2) - 2000
-- else YEAR(GETDATE()) - (SUBSTRING(pesel, 1, 2) - 1900
-- end as wiek
-- from Uczestnicy order by wiek
---
insert into Uczestnicy
values('05230311111', 'Antoni', 'Zalewski', 'Olkusz')

-----------------------------------------------------------------------------------------------------------
-- zajecia 3 (07.02)

select distinct idK from Edycje

-- wyœwietlanie uczestników z Poznania
select * 
from Uczestnicy 
where adres = 'Poznañ' 

select * 
from Uczestnicy 
where adres = 'Poznañ' or adres ='P-ñ'

select * 
from Uczestnicy 
where adres in ('Poznañ', 'P-ñ')

select * 
from Uczestnicy 
where adres like 'P%ñ'

-- edycje oferowane w kwietniu
select * 
from Edycje 
where  MONTH(data_start) = 4 

-- wyznaczyæ wiek uczestnika
select nazwisko, pesel, 
YEAR(getdate()) - (SUBSTRING(pesel, 1, 2) + 1900) as 'wiek'
from Uczestnicy

-- substring
print substring ('abcdefg', 2, 3)

-- getdate
print getdate()

-- ktorych liczba dni nalezy do zbioru (NULL nie mozna porownywac; NULL nie rowna sie null)
select * 
from Kursy
where liczba_dni not in (NULL, 1, 2)

-- ISNULL
select 100 + ISNULL(null, 0)
select 100 + COALESCE(null, 0)

---------------------------------------------------------------------------------------------------------------
-- zajêcia 2 (31.01.2017)

-- select from pracownicy
-- komentarz

insert into Kursy values 
(111,	'Administracja MySQL',	3)
-- informacja o b³êdzie, taki kurs ju¿ istnieje

delete from Kursy where id = 111
-- konflikt usuniêcie tabeli po³¹czonej kluczem obcym

insert into Edycje values ('9992014Z', 999, '2014-10-10', '2014-10-12', 2900)
-- konflikt, bo nie ma takiego kursu - nie ma odwo³añ do nieistniej¹cych kursów

-- SELECT
select 'napis', 3 + 4

select user_name(), GETDATE() 'aktualna data'
-- zmiana nazwy kolumny/przemianowanie/ nazwa po defincji kolumny