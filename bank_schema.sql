--------------------------------------
-- BANK
--------------------------------------


--drop table operacje
--drop table konta
--drop table Klienci_banku
--go


CREATE TABLE Klienci_banku
(
pesel char(11) primary key,
imie varchar(50) NOT NULL,
nazwisko varchar(100) NOT NULL,
telefon char(9)
)

CREATE TABLE Konta
(
nr_konta char(10) primary key,
wlasciciel char(11) NOT NULL references Klienci_banku(pesel),
data_utworzenia date NOT NULL,
rodzaj varchar(15) NOT NULL check (rodzaj in ('ROR', 'oszczêdnoœciowy', 'lokata'))
)

CREATE TABLE Operacje
(
id_operacji int primary key identity(1,1),
nr_konta char(10) NOT NULL references Konta(nr_konta),
data date NOT NULL, 
kwota money NOT NULL,
typ varchar(10) check (typ in ('wp³ata', 'wyp³ata'))
)
GO


insert into Klienci_banku (pesel, imie, nazwisko, telefon) values
('91120811199',	'Maciej', 'Ziêba', '607223344'),
('71020254544',	'Zenon', 'Jaœkowiak', '505112233'),
('66120811163',	'Renata', 'Kowal', '600887766')

insert into Konta (nr_konta, wlasciciel, data_utworzenia, rodzaj) values
('11-1111111', '66120811163', '1999-01-02', 'ROR'),
('22-2222222', '71020254544', '1995-01-05', 'ROR'),
('33-3333333', '71020254544', '2005-01-10', 'oszczêdnoœciowy'),
('44-4444444', '91120811199', '2002-01-01', 'ROR'),
('55-5555555', '66120811163', '2004-01-12', 'oszczêdnoœciowy'),
('66-6666666', '66120811163', '2014-01-12', 'lokata')

insert into Operacje (nr_konta, data, kwota, typ) values
('22-2222222', '2015-04-03', 4500, 'wp³ata'),
('22-2222222', '2015-04-05', -500, 'wyp³ata'),
('22-2222222', '2015-04-13', -155, 'wyp³ata'),
('22-2222222', '2015-04-15', 100, 'wp³ata'),
('22-2222222', '2015-04-23', -780, 'wyp³ata'),
('22-2222222', '2015-04-29', -200, 'wyp³ata'),
('22-2222222', '2015-05-04', 4500, 'wp³ata'),
('22-2222222', '2015-05-10', 100, 'wp³ata'),
('22-2222222', '2015-05-16', -1200, 'wyp³ata'),
('22-2222222', '2015-05-20', -780, 'wyp³ata'),

('11-1111111', '2015-04-03', 2500, 'wp³ata'),
('11-1111111', '2015-04-05', 500, 'wp³ata'),
('11-1111111', '2015-04-13', -155, 'wyp³ata'),
('11-1111111', '2015-04-15', -700, 'wyp³ata'),
('11-1111111', '2015-04-29', 20, 'wp³ata'),
('11-1111111', '2015-05-04', 2500, 'wp³ata'),
('11-1111111', '2015-05-10', -100, 'wyp³ata'),
('11-1111111', '2015-05-16', -1200, 'wyp³ata'),
('11-1111111', '2015-05-16', -100, 'wyp³ata'),

('33-3333333', '2015-04-05', 500, 'wp³ata'),
('33-3333333', '2015-05-20', 500, 'wp³ata'),
('33-3333333', '2015-05-27', -1000, 'wyp³ata'),
('33-3333333', '2015-05-29', -300, 'wyp³ata'),

('44-4444444', '2015-04-03', 1500, 'wp³ata'),
('44-4444444', '2015-04-08', -150, 'wyp³ata'),
('44-4444444', '2015-04-10', 200, 'wp³ata'),
('44-4444444', '2015-04-15', -355, 'wyp³ata'),
('44-4444444', '2015-04-28', -50, 'wyp³ata'),
('44-4444444', '2015-04-29', -50, 'wyp³ata'),
('44-4444444', '2015-05-10', 200, 'wp³ata'),
('44-4444444', '2015-05-10', -50, 'wyp³ata'),
('44-4444444', '2015-05-15', -355, 'wyp³ata'),
('44-4444444', '2015-05-16', 900, 'wp³ata'),
('44-4444444', '2015-05-16', -100, 'wyp³ata'),
('44-4444444', '2015-05-30', -150, 'wyp³ata'),

('55-5555555', '2015-04-05', 100, 'wp³ata'),
('55-5555555', '2015-05-20', 100, 'wp³ata'),
('55-5555555', '2015-05-25', 100, 'wp³ata'),
('55-5555555', '2015-05-27', -100, 'wyp³ata'),
('55-5555555', '2015-05-30', -500, 'wyp³ata')

go
---------------------------

select * from Klienci_banku
select * from Konta
select * from Operacje

