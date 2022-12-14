USE [master]
GO
/****** Object:  Database [BankKrwi]    Script Date: 02.02.2022 19:42:29 ******/
CREATE DATABASE [BankKrwi]
 CONTAINMENT = NONE
ALTER DATABASE [BankKrwi] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BankKrwi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BankKrwi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BankKrwi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BankKrwi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BankKrwi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BankKrwi] SET ARITHABORT OFF 
GO
ALTER DATABASE [BankKrwi] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BankKrwi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BankKrwi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BankKrwi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BankKrwi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BankKrwi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BankKrwi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BankKrwi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BankKrwi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BankKrwi] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BankKrwi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BankKrwi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BankKrwi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BankKrwi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BankKrwi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BankKrwi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BankKrwi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BankKrwi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BankKrwi] SET  MULTI_USER 
GO
ALTER DATABASE [BankKrwi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BankKrwi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BankKrwi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BankKrwi] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BankKrwi] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BankKrwi] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BankKrwi] SET QUERY_STORE = OFF
GO
USE [BankKrwi]
GO
/****** Object:  UserDefinedFunction [dbo].[BilansTransportów]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BilansTransportów] 
	(@Miesiąc int,
	@Rok int)
RETURNS INT
AS
BEGIN

	DECLARE @Bilans int
	SET @Bilans = (
					SELECT (SELECT SUM(LiczbaJednostek) FROM Transporty WHERE CzyWychodzący = 0 AND YEAR(DataTransportu)=@Rok AND MONTH(DataTransportu)=@Miesiąc)
					- (SELECT SUM(LiczbaJednostek) FROM Transporty WHERE CzyWychodzący = 1 AND YEAR(DataTransportu)=@Rok AND MONTH(DataTransportu)=@Miesiąc)
				)
	RETURN @Bilans
END
GO
/****** Object:  Table [dbo].[Donacje]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Donacje](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KrwiodawcaID] [int] NOT NULL,
	[DataDonacji] [date] NOT NULL,
	[PracownikID] [int] NOT NULL,
	[CzyUkończono] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Krwiodawcy]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Krwiodawcy](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[DataUrodzenia] [date] NOT NULL,
	[Email] [nvarchar](100) NULL,
	[NumerTelefonu] [nvarchar](50) NULL,
	[Adres] [nvarchar](250) NOT NULL,
	[GrupaKrwiID] [tinyint] NOT NULL,
	[Płeć] [char](1) NOT NULL,
 CONSTRAINT [PK_Krwiodawcy] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_DonacjeWgGrupyKrwi2021]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE VIEW [dbo].[V_DonacjeWgGrupyKrwi2021]

	as

	SELECT COUNT(Krwiodawcy.ID) AS "GrupaKrwi" FROM Krwiodawcy 
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 1 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 2 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 3 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 4 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 5 AND YEAR(DataDonacji) = 2021
	UNION ALL
	(SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 6 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 7 AND YEAR(DataDonacji) = 2021
	UNION ALL
	SELECT COUNT(Krwiodawcy.ID) FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = 8 AND YEAR(DataDonacji) = 2021)
GO
/****** Object:  UserDefinedFunction [dbo].[PokażDonacjeDawcy]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PokażDonacjeDawcy]
	(@IDDawcy int,
	@DataPoczatkowa date,
	@DataKoncowa date)
RETURNS TABLE
AS
RETURN

	SELECT * FROM Donacje
	WHERE KrwiodawcaID = @IDDawcy AND DataDonacji BETWEEN @DataPoczatkowa AND @DataKoncowa
GO
/****** Object:  View [dbo].[V_KrwiodawcyKraków]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ALTER PROCEDURE DodajBiorce (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Biorcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO */

/* CREATE PROCEDURE DodajZapasy
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
INSERT INTO ZapasyKrwi (GrupaKrwiID, LiczbaJednostek)
VALUES (@GrupaKrwiID, @LiczbaJednostek) */


/*ALTER PROCEDURE DodajDonacje
@KrwiodawcaID int,
@DataDonacji date,
@PracownikID int,
@CzyUkończono bit
AS
INSERT INTO Donacje (KrwiodawcaID, DataDonacji, PracownikID, CzyUkończono)
VALUES (@KrwiodawcaID, @DataDonacji, @PracownikID, @CzyUkończono)
DECLARE @GrupaKrwiodawcy tinyint = (SELECT GrupaKrwiID FROM Krwiodawcy WHERE ID = @KrwiodawcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + 1
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaKrwiodawcy
GO */

/* CREATE PROCEDURE DodajTransfuzje
@BiorcaID int,
@PrzetoczonoJednostek tinyint,
@DataTransfuzji datetime
AS
INSERT INTO Transfuzje (BiorcaID, PrzetoczonoJednostek, DataTransfuzji)
VALUES (@BiorcaID, @PrzetoczonoJednostek, @DataTransfuzji)
DECLARE @GrupaBiorcy tinyint = (SELECT GrupaKrwiID FROM Biorcy WHERE ID = @BiorcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek =  LiczbaJednostek - @PrzetoczonoJednostek
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaBiorcy
GO */

CREATE VIEW [dbo].[V_KrwiodawcyKraków]
AS
SELECT * FROM Krwiodawcy WHERE Adres LIKE '%Kraków'
GO
/****** Object:  View [dbo].[V_Donacje2020]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ALTER PROCEDURE DodajBiorce (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Biorcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO */

/* CREATE PROCEDURE DodajZapasy
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
INSERT INTO ZapasyKrwi (GrupaKrwiID, LiczbaJednostek)
VALUES (@GrupaKrwiID, @LiczbaJednostek) */


/*ALTER PROCEDURE DodajDonacje
@KrwiodawcaID int,
@DataDonacji date,
@PracownikID int,
@CzyUkończono bit
AS
INSERT INTO Donacje (KrwiodawcaID, DataDonacji, PracownikID, CzyUkończono)
VALUES (@KrwiodawcaID, @DataDonacji, @PracownikID, @CzyUkończono)
DECLARE @GrupaKrwiodawcy tinyint = (SELECT GrupaKrwiID FROM Krwiodawcy WHERE ID = @KrwiodawcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + 1
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaKrwiodawcy
GO */

/* CREATE PROCEDURE DodajTransfuzje
@BiorcaID int,
@PrzetoczonoJednostek tinyint,
@DataTransfuzji datetime
AS
INSERT INTO Transfuzje (BiorcaID, PrzetoczonoJednostek, DataTransfuzji)
VALUES (@BiorcaID, @PrzetoczonoJednostek, @DataTransfuzji)
DECLARE @GrupaBiorcy tinyint = (SELECT GrupaKrwiID FROM Biorcy WHERE ID = @BiorcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek =  LiczbaJednostek - @PrzetoczonoJednostek
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaBiorcy
GO */

/* CREATE VIEW V_KrwiodawcyKraków
AS
SELECT * FROM Krwiodawcy WHERE Adres LIKE '%Kraków' */

CREATE VIEW [dbo].[V_Donacje2020]
AS
SELECT * FROM Donacje WHERE DataDonacji BETWEEN '2020-01-01' AND '2020-12-31'
GO
/****** Object:  Table [dbo].[Placówki]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Placówki](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nazwa] [nvarchar](250) NOT NULL,
	[Adres] [nvarchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[V_Szpitale]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ALTER PROCEDURE DodajBiorce (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Biorcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO */

/* CREATE PROCEDURE DodajZapasy
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
INSERT INTO ZapasyKrwi (GrupaKrwiID, LiczbaJednostek)
VALUES (@GrupaKrwiID, @LiczbaJednostek) */


/*ALTER PROCEDURE DodajDonacje
@KrwiodawcaID int,
@DataDonacji date,
@PracownikID int,
@CzyUkończono bit
AS
INSERT INTO Donacje (KrwiodawcaID, DataDonacji, PracownikID, CzyUkończono)
VALUES (@KrwiodawcaID, @DataDonacji, @PracownikID, @CzyUkończono)
DECLARE @GrupaKrwiodawcy tinyint = (SELECT GrupaKrwiID FROM Krwiodawcy WHERE ID = @KrwiodawcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + 1
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaKrwiodawcy
GO */

/* CREATE PROCEDURE DodajTransfuzje
@BiorcaID int,
@PrzetoczonoJednostek tinyint,
@DataTransfuzji datetime
AS
INSERT INTO Transfuzje (BiorcaID, PrzetoczonoJednostek, DataTransfuzji)
VALUES (@BiorcaID, @PrzetoczonoJednostek, @DataTransfuzji)
DECLARE @GrupaBiorcy tinyint = (SELECT GrupaKrwiID FROM Biorcy WHERE ID = @BiorcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek =  LiczbaJednostek - @PrzetoczonoJednostek
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaBiorcy
GO */

/* CREATE VIEW V_KrwiodawcyKraków
AS
SELECT * FROM Krwiodawcy WHERE Adres LIKE '%Kraków' */

/* CREATE VIEW V_Donacje2020
AS
SELECT * FROM Donacje WHERE DataDonacji BETWEEN '2020-01-01' AND '2020-12-31' */

CREATE VIEW [dbo].[V_Szpitale]
AS
SELECT * FROM Placówki WHERE Nazwa NOT LIKE '%RCKiK%'


/* SELECT Krwiodawcy.ID, Imię, Nazwisko, COUNT(Donacje.KrwiodawcaID) FROM Krwiodawcy
INNER JOIN Donacje
ON Krwiodawcy.ID = KrwiodawcaID
GROUP BY Imię, Nazwisko, */

GO
/****** Object:  View [dbo].[V_CentraKrwiodawstwa]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ALTER PROCEDURE DodajBiorce (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Biorcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO */

/* CREATE PROCEDURE DodajZapasy
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
INSERT INTO ZapasyKrwi (GrupaKrwiID, LiczbaJednostek)
VALUES (@GrupaKrwiID, @LiczbaJednostek) */


/*ALTER PROCEDURE DodajDonacje
@KrwiodawcaID int,
@DataDonacji date,
@PracownikID int,
@CzyUkończono bit
AS
INSERT INTO Donacje (KrwiodawcaID, DataDonacji, PracownikID, CzyUkończono)
VALUES (@KrwiodawcaID, @DataDonacji, @PracownikID, @CzyUkończono)
DECLARE @GrupaKrwiodawcy tinyint = (SELECT GrupaKrwiID FROM Krwiodawcy WHERE ID = @KrwiodawcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + 1
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaKrwiodawcy
GO */

/* CREATE PROCEDURE DodajTransfuzje
@BiorcaID int,
@PrzetoczonoJednostek tinyint,
@DataTransfuzji datetime
AS
INSERT INTO Transfuzje (BiorcaID, PrzetoczonoJednostek, DataTransfuzji)
VALUES (@BiorcaID, @PrzetoczonoJednostek, @DataTransfuzji)
DECLARE @GrupaBiorcy tinyint = (SELECT GrupaKrwiID FROM Biorcy WHERE ID = @BiorcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek =  LiczbaJednostek - @PrzetoczonoJednostek
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaBiorcy
GO */

/* CREATE VIEW V_KrwiodawcyKraków
AS
SELECT * FROM Krwiodawcy WHERE Adres LIKE '%Kraków' */

/* CREATE VIEW V_Donacje2020
AS
SELECT * FROM Donacje WHERE DataDonacji BETWEEN '2020-01-01' AND '2020-12-31' */

/* CREATE VIEW V_Szpitale
AS
SELECT * FROM Placówki WHERE Nazwa NOT LIKE '%RCKiK%' */

CREATE VIEW [dbo].[V_CentraKrwiodawstwa]
AS
SELECT * FROM Placówki WHERE Nazwa LIKE '%RCKiK%'

/* SELECT Krwiodawcy.ID, Imię, Nazwisko, COUNT(Donacje.KrwiodawcaID) FROM Krwiodawcy
INNER JOIN Donacje
ON Krwiodawcy.ID = KrwiodawcaID
GROUP BY Imię, Nazwisko, */

GO
/****** Object:  UserDefinedFunction [dbo].[DawcyGrupyWRoku]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DawcyGrupyWRoku]
	(@Grupa tinyint,
	@Rok int)
RETURNS TABLE
AS
RETURN

	SELECT DISTINCT Krwiodawcy.ID, Imię, Nazwisko FROM Krwiodawcy
	JOIN Donacje ON Krwiodawcy.ID = Donacje.KrwiodawcaID
	WHERE Krwiodawcy.GrupaKrwiID = @Grupa AND YEAR(DataDonacji) = @Rok

GO
/****** Object:  Table [dbo].[Biorcy]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Biorcy](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[DataUrodzenia] [date] NOT NULL,
	[Email] [nchar](100) NULL,
	[NumerTelefonu] [nchar](20) NULL,
	[Adres] [nvarchar](250) NULL,
	[GrupaKrwiID] [tinyint] NOT NULL,
	[Płeć] [char](1) NOT NULL,
 CONSTRAINT [PK_Biorcy] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GrupaKrwi]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GrupaKrwi](
	[ID] [tinyint] NOT NULL,
	[Nazwa] [varchar](3) NOT NULL,
 CONSTRAINT [PK_GrupyKrwi] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personel]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Imię] [nvarchar](50) NOT NULL,
	[Nazwisko] [nvarchar](100) NOT NULL,
	[Stanowisko] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__Personel__3214EC27EE2B2C7B] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transfuzje]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transfuzje](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BiorcaID] [int] NOT NULL,
	[PrzetoczonoJednostek] [tinyint] NOT NULL,
	[DataTransfuzji] [datetime] NOT NULL,
 CONSTRAINT [PK_Transfuzje] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transporty]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transporty](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[GrupaKrwiID] [tinyint] NOT NULL,
	[PlacówkaID] [int] NOT NULL,
	[LiczbaJednostek] [int] NOT NULL,
	[DataTransportu] [date] NOT NULL,
	[CzyWychodzący] [bit] NOT NULL,
 CONSTRAINT [PK__Transpor__3214EC2740F05B5D] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ZapasyKrwi]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZapasyKrwi](
	[GrupaKrwiID] [tinyint] IDENTITY(1,1) NOT NULL,
	[LiczbaJednostek] [int] NOT NULL,
 CONSTRAINT [PK__ZapasyKr__3214EC276C9D3094] PRIMARY KEY CLUSTERED 
(
	[GrupaKrwiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Biorcy] ON 

INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (1, N'Andrzej', N'Przybylski', CAST(N'1969-05-06' AS Date), N'ap44371@mail.com                                                                                    ', N'+48 574637828       ', N'Chocimska 6, 80-003 Bydgoszcz', 1, N'M')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (2, N'Patryk', N'Zawadzki', CAST(N'1983-04-12' AS Date), N'pz994384@mail.com                                                                                   ', N'+48 995285939       ', N'Wiejska 9, 20-054 Kielce', 1, N'M')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (3, N'Ignacy', N'Wiśniewski', CAST(N'1990-09-19' AS Date), N'iw432219@mail.com                                                                                   ', N'+48 154637285       ', N'Prosta 19, 70-001 Szczecin', 3, N'M')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (4, N'Janusz', N'Jaworski', CAST(N'1975-03-03' AS Date), N'jj486910@mail.com                                                                                   ', N'+48 994385011       ', N'Aleja Pokoju 22, 30-001 Kraków', 3, N'M')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (5, N'Kornelia', N'Przybylska', CAST(N'1985-09-11' AS Date), N'kp5784932@mail.com                                                                                  ', N'+48 349201593       ', N'Zakole 55, 43-212 Katowice', 5, N'K')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (6, N'Zuzanna', N'Wojciechowska', CAST(N'1977-02-15' AS Date), N'zw543782@mail.com                                                                                   ', N'+48 783912953       ', N'Wodna 123, 11-315 Białystok', 6, N'K')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (7, N'Monika', N'Witkowska', CAST(N'1971-07-22' AS Date), N'mw58943@mail.com                                                                                    ', N'+48 668333901       ', N'Kamienna 1, 21-313 Lublin', 7, N'K')
INSERT [dbo].[Biorcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (8, N'Marlena', N'Kołodziej', CAST(N'1988-08-16' AS Date), N'mk96543@mail.com                                                                                    ', N'+48 448338992       ', N'Centralna 9, 60-315 Poznań', 8, N'K')
SET IDENTITY_INSERT [dbo].[Biorcy] OFF
GO
SET IDENTITY_INSERT [dbo].[Donacje] ON 

INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (1, 3, CAST(N'2020-01-03' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (2, 3, CAST(N'2020-06-07' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (3, 3, CAST(N'2020-12-13' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (4, 4, CAST(N'2019-02-07' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (5, 4, CAST(N'2020-11-01' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (6, 4, CAST(N'2022-01-15' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (7, 5, CAST(N'2018-03-03' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (8, 5, CAST(N'2019-03-07' AS Date), 6, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (9, 6, CAST(N'2019-05-08' AS Date), 6, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (10, 6, CAST(N'2020-04-13' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (11, 7, CAST(N'2019-05-08' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (12, 7, CAST(N'2019-10-15' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (13, 7, CAST(N'2020-06-03' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (14, 7, CAST(N'2020-11-06' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (15, 8, CAST(N'2019-04-08' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (16, 8, CAST(N'2019-07-15' AS Date), 11, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (17, 8, CAST(N'2020-02-03' AS Date), 6, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (18, 8, CAST(N'2020-08-06' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (19, 9, CAST(N'2022-01-25' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (20, 10, CAST(N'2019-01-25' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (21, 10, CAST(N'2019-05-08' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (22, 10, CAST(N'2019-11-15' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (23, 10, CAST(N'2020-02-28' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (24, 10, CAST(N'2020-06-08' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (25, 10, CAST(N'2021-04-17' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (26, 10, CAST(N'2021-09-30' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (27, 11, CAST(N'2020-10-25' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (28, 12, CAST(N'2020-10-25' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (29, 12, CAST(N'2021-02-03' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (30, 12, CAST(N'2021-05-25' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (31, 13, CAST(N'2020-03-03' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (32, 13, CAST(N'2021-08-03' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (33, 13, CAST(N'2021-12-06' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (34, 14, CAST(N'2021-01-12' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (35, 14, CAST(N'2022-01-16' AS Date), 10, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (36, 15, CAST(N'2020-07-12' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (37, 15, CAST(N'2021-07-16' AS Date), 10, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (38, 15, CAST(N'2022-01-05' AS Date), 10, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (39, 16, CAST(N'2020-09-12' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (40, 16, CAST(N'2021-04-16' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (41, 16, CAST(N'2021-11-05' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (42, 17, CAST(N'2020-08-12' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (43, 17, CAST(N'2021-07-16' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (44, 17, CAST(N'2021-12-05' AS Date), 10, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (45, 18, CAST(N'2021-05-13' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (46, 19, CAST(N'2020-01-23' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (47, 19, CAST(N'2020-04-23' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (48, 20, CAST(N'2020-02-23' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (49, 20, CAST(N'2020-06-23' AS Date), 2, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (50, 20, CAST(N'2020-06-30' AS Date), 2, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (51, 20, CAST(N'2020-07-13' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (52, 21, CAST(N'2020-06-13' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (53, 21, CAST(N'2021-08-02' AS Date), 4, 0)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (54, 22, CAST(N'2020-04-19' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (55, 22, CAST(N'2021-10-04' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (56, 23, CAST(N'2020-06-19' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (57, 23, CAST(N'2021-11-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (58, 24, CAST(N'2021-06-09' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (59, 24, CAST(N'2021-09-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (60, 24, CAST(N'2021-12-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (61, 25, CAST(N'2021-06-09' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (62, 25, CAST(N'2021-09-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (63, 25, CAST(N'2021-12-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (64, 26, CAST(N'2021-06-09' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (65, 26, CAST(N'2021-09-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (66, 27, CAST(N'2020-01-03' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (67, 27, CAST(N'2020-03-06' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (68, 27, CAST(N'2020-06-10' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (69, 27, CAST(N'2020-09-14' AS Date), 7, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (70, 27, CAST(N'2020-12-05' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (71, 27, CAST(N'2021-04-09' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (72, 27, CAST(N'2021-10-15' AS Date), 10, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (73, 28, CAST(N'2020-02-15' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (74, 28, CAST(N'2021-07-09' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (75, 28, CAST(N'2021-11-29' AS Date), 6, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (76, 29, CAST(N'2022-01-22' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (77, 30, CAST(N'2020-05-11' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (78, 30, CAST(N'2020-11-13' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (79, 30, CAST(N'2021-04-09' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (80, 31, CAST(N'2020-03-11' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (81, 31, CAST(N'2020-12-13' AS Date), 4, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (82, 31, CAST(N'2021-05-09' AS Date), 9, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (83, 31, CAST(N'2021-10-11' AS Date), 2, 1)
INSERT [dbo].[Donacje] ([ID], [KrwiodawcaID], [DataDonacji], [PracownikID], [CzyUkończono]) VALUES (84, 32, CAST(N'2020-11-30' AS Date), 2, 0)
SET IDENTITY_INSERT [dbo].[Donacje] OFF
GO
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (8, N'0-')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (7, N'0+')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (2, N'A-')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (1, N'A+')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (6, N'AB-')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (5, N'AB+')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (4, N'B-')
INSERT [dbo].[GrupaKrwi] ([ID], [Nazwa]) VALUES (3, N'B+')
GO
SET IDENTITY_INSERT [dbo].[Krwiodawcy] ON 

INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (3, N'Elżbieta', N'Nowak', CAST(N'1991-05-18' AS Date), N'en53426423643@mail.com', N'+48 141564408', N'Śliczna 2, 30-002 Kraków', 1, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (4, N'Lila', N'Mróz', CAST(N'1992-04-17' AS Date), N'lm64334@mail.com', N'+48 556622202', N'Sąsiedzka 5, 00-312 Warszawa', 4, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (5, N'Nikola', N'Jakubowska', CAST(N'1972-02-22' AS Date), N'nj64436@mail.com', N'+48 6624468241', N'Poprzeczna 19, 50-212 Wrocław', 2, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (6, N'Julianna', N'Czerwińska', CAST(N'1995-03-15' AS Date), N'jc532153@mail.com', N'+48 225588291', N'Prosta 11, 30-104 Kraków', 8, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (7, N'Daria', N'Głowacka', CAST(N'1985-08-11' AS Date), N'jc532153@mail.com', N'+48 228758215', N'Krzywa 78, 30-104 Kraków', 1, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (8, N'Daniela', N'Kołodziej', CAST(N'1971-11-28' AS Date), N'dk453263@mail.com', N'+48 439582164', N'Centralna 15, 30-524 Kraków', 1, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (9, N'Florencja', N'Zakrzewska', CAST(N'1969-05-21' AS Date), N'fz432892@mail.com', N'+48 992422151', N'Centralna 35, 30-524 Kraków', 1, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (10, N'Julita', N'Brzezińska', CAST(N'1973-09-01' AS Date), N'jb4388321@mail.com', N'+48 928372155', N'Hetmańska, 32-120 Wieliczka', 3, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (11, N'Aneta', N'Kaźmierczak', CAST(N'1999-03-12' AS Date), N'ak4325438@mail.com', N'+48 332958251', N'Długa 3, 30-211 Kraków', 3, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (12, N'Elżbieta', N'Szewczyk', CAST(N'2002-06-06' AS Date), N'es4522468@mail.com', N'+48 999234128', N'Bocheńska 22, 32-420 Gdów', 5, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (13, N'Iga', N'Laskowska', CAST(N'1983-05-15' AS Date), N'il4382940@mail.com', N'+48 483229187', N'Gdowska 19, 32-700 Bochnia', 6, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (14, N'Karolina', N'Kołodziej', CAST(N'1980-07-04' AS Date), N'kk395839@mail.com', N'+48 394857198', N'Centralna 15, 30-524 Kraków', 7, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (15, N'Elżbieta', N'Szewczyk', CAST(N'2002-06-06' AS Date), N'es4325438@mail.com', N'+48 999234128', N'Kalwaryjska 1, 30-001 Kraków', 3, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (16, N'Elwira', N'Głowacka', CAST(N'1989-12-14' AS Date), N'eg54373@mail.com', N'+48 928475869', N'Widokowa 33, 30-202 Kraków', 3, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (17, N'Anna', N'Borowska', CAST(N'1977-08-13' AS Date), N'ab87687568@mail.com', N'+48 784930482', N'Bronowicka 99, 30-652 Kraków', 3, N'K')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (18, N'Janusz', N'Kowalski', CAST(N'1983-01-18' AS Date), N'jk53426423643@mail.com', N'+48 987456321', N'Śliwkowa 2, 31-869 Kraków', 1, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (19, N'Arnold', N'Walczak', CAST(N'1972-02-17' AS Date), N'aw64334@mail.com', N'+48 132465798', N'Ostatnia 1, 31-444 Kraków', 4, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (20, N'Olgierd', N'Ostrowski', CAST(N'1965-02-22' AS Date), N'oo64436@mail.com', N'+48 213465798', N'Krzywa 2, 50-338', 2, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (21, N'Hubert', N'Szulc', CAST(N'1999-03-15' AS Date), N'hs532153@mail.com', N'+48 912876715', N'Kapelanka 6, 30-347 Kraków', 8, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (22, N'Aleksander', N'Szczepański', CAST(N'1977-03-11' AS Date), N'as353364@mail.com', N'+48 228758215', N'Wielomska 30, 87-100 Toruń', 1, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (23, N'Marcel', N'Kubiak', CAST(N'1988-04-28' AS Date), N'mk65344@mail.com', N'+48 211466844', N'Sołtysowska 5, 31-589 Kraków', 1, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (24, N'Adam', N'Kamiński', CAST(N'1999-04-21' AS Date), N'ak6433@mail.com', N'+48 348671098', N'Franciszkańska, 30-524 Kraków', 1, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (25, N'Edward', N'Szumowski', CAST(N'1996-05-01' AS Date), N'es432782@mail.com', N'+48 918237564', N'Praska 19, 89-120 Gdańsk', 3, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (26, N'Mirosław', N'Szewczyk', CAST(N'1969-06-12' AS Date), N'ms432786528@mail.com', N'+48 913245765', N'Kasztanowa 9, 32-700 Bochnia', 3, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (27, N'Eryk', N'Bąk', CAST(N'2002-07-06' AS Date), N'eb5437433@mail.com', N'+48 768432918', N'Gdowska 5, 32-002 Wieliczka', 5, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (28, N'Franciszek', N'Lis', CAST(N'1981-08-15' AS Date), N'fl543282@mail.com', N'+48 912564768', N'Prosta 5, 32-005 Niepołomice', 6, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (29, N'Konrad', N'Lewandowski', CAST(N'1980-09-04' AS Date), N'kl432728@mail.com', N'+48 562860187', N'Barska 3, 31-222 Kraków', 7, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (30, N'Łukasz', N'Mazurek', CAST(N'2000-10-06' AS Date), N'lm532782@mail.com', N'+48 599542158', N'Twardowskiego 5, 31-209 Kraków', 3, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (31, N'Maksymilian', N'Cieślak', CAST(N'1992-11-14' AS Date), N'mc43828232@mail.com', N'+48 528555432', N'Dworska 15, 30-248 Kraków', 3, N'M')
INSERT [dbo].[Krwiodawcy] ([ID], [Imię], [Nazwisko], [DataUrodzenia], [Email], [NumerTelefonu], [Adres], [GrupaKrwiID], [Płeć]) VALUES (32, N'Arkadiusz', N'Zieliński', CAST(N'1986-12-13' AS Date), N'az53728288@mail.com', N'+48 594285929', N'Grzegórzecka 12, 31-520 Kraków', 3, N'M')
SET IDENTITY_INSERT [dbo].[Krwiodawcy] OFF
GO
SET IDENTITY_INSERT [dbo].[Personel] ON 

INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (1, N'Dagmara', N'Gajewska', N'Lekarz')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (2, N'Barbara', N'Górecka', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (3, N'Krzysztof', N'Czarnecki', N'Lekarz')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (4, N'Alina', N'Nowak', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (5, N'Zygmunt', N'Mróz', N'Lekarz')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (6, N'Justyna', N'Przybylska', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (7, N'Kinga', N'Pietrzak', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (8, N'Olga', N'Wróblewska', N'Lekarz')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (9, N'Jadwiga', N'Jakubowska', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (10, N'Ewa', N'Wójcik', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (11, N'Izabela', N'Ziółkowska', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (12, N'Weronika', N'Jankowska', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (13, N'Daria', N'Mazur', N'Pielęgniarka')
INSERT [dbo].[Personel] ([ID], [Imię], [Nazwisko], [Stanowisko]) VALUES (14, N'Jolanta', N'Witkowska', N'Pielęgniarka')
SET IDENTITY_INSERT [dbo].[Personel] OFF
GO
SET IDENTITY_INSERT [dbo].[Placówki] ON 

INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (1, N'RCKiK Białystok', N'Marii Skłodowskiej-Curie 23, 15-950 Białystok')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (2, N'RCKiK Bydgoszcz', N'Księdza Ryszarda Markwarta 8, 85-015 Bydgoszcz')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (3, N'RCKiK Gdańsk', N'Józefa Hoene-Wrońskiego 4, 80-210 Gdańsk')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (4, N'RCKiK Kalisz', N'Kaszubska 9, 62-800 Kalisz')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (5, N'RCKiK Katowice', N'Raciborska 15, 40-074 Katowice')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (6, N'RCKiK Kielce', N'Jagiellońska 66, 25-734 Kielce')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (7, N'Uniwersytecki Szpital Dziecięcy w Krakowie', N'Wielicka 265, 30-663 Kraków')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (8, N'Wojskowy Instytut Medyczny', N'Szaserów 128, 04-141 Warszawa')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (9, N'Szpital Miejski im. Franciszka Raszei', N'Mickiewicza 2, 60-834 Poznań')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (10, N'Uniwersytecki Szpital Kliniczny', N'Curie-Skłodowskiej 58, 50-369 Wrocław')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (11, N'Samodzielny Publiczny Szpital Wojewódzki im. Jana Bożego', N'Mieczysława Biernackiego 9, 20-400 Lublin')
INSERT [dbo].[Placówki] ([ID], [Nazwa], [Adres]) VALUES (12, N'Samodzielny Publiczny Wojewódzki Szpital Zespolony', N'Arkońska 4, 71-455 Szczecin')
SET IDENTITY_INSERT [dbo].[Placówki] OFF
GO
SET IDENTITY_INSERT [dbo].[Transfuzje] ON 

INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (1, 1, 2, CAST(N'2020-05-13T21:40:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (2, 2, 1, CAST(N'2020-07-16T10:35:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (3, 7, 1, CAST(N'2021-10-30T15:05:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (4, 3, 3, CAST(N'2021-05-17T15:00:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (5, 4, 2, CAST(N'2020-01-30T15:00:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (8, 5, 1, CAST(N'2020-12-14T19:21:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (9, 6, 1, CAST(N'2021-01-20T16:13:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (10, 6, 1, CAST(N'2021-01-20T19:53:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (11, 8, 1, CAST(N'2020-03-20T16:13:00.000' AS DateTime))
INSERT [dbo].[Transfuzje] ([ID], [BiorcaID], [PrzetoczonoJednostek], [DataTransfuzji]) VALUES (12, 8, 1, CAST(N'2021-11-21T19:53:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Transfuzje] OFF
GO
SET IDENTITY_INSERT [dbo].[Transporty] ON 

INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (1, 1, 1, 10, CAST(N'2020-01-02' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (2, 1, 1, 10, CAST(N'2020-01-08' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (3, 7, 9, 10, CAST(N'2020-01-08' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (4, 5, 2, 14, CAST(N'2020-02-13' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (5, 3, 4, 93, CAST(N'2020-03-30' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (6, 6, 6, 55, CAST(N'2020-04-16' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (7, 1, 2, 43, CAST(N'2020-02-15' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (8, 4, 2, 16, CAST(N'2020-02-18' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (9, 2, 3, 21, CAST(N'2020-02-16' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (10, 6, 3, 3, CAST(N'2020-02-19' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (11, 3, 2, 11, CAST(N'2021-05-16' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (12, 8, 6, 5, CAST(N'2021-05-06' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (13, 7, 2, 51, CAST(N'2021-05-13' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (14, 1, 2, 3, CAST(N'2021-03-15' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (15, 2, 4, 5, CAST(N'2021-04-22' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (16, 2, 2, 11, CAST(N'2020-06-14' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (17, 5, 4, 5, CAST(N'2021-07-13' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (18, 8, 2, 67, CAST(N'2020-07-15' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (19, 3, 3, 45, CAST(N'2021-08-19' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (20, 5, 2, 15, CAST(N'2020-08-15' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (21, 4, 1, 12, CAST(N'2021-09-17' AS Date), 0)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (22, 3, 3, 2, CAST(N'2020-06-13' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (23, 3, 3, 2, CAST(N'2020-06-13' AS Date), 1)
INSERT [dbo].[Transporty] ([ID], [GrupaKrwiID], [PlacówkaID], [LiczbaJednostek], [DataTransportu], [CzyWychodzący]) VALUES (24, 3, 3, 2, CAST(N'2020-06-13' AS Date), 0)
SET IDENTITY_INSERT [dbo].[Transporty] OFF
GO
SET IDENTITY_INSERT [dbo].[ZapasyKrwi] ON 

INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (1, 4474)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (2, 1127)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (3, 4081)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (4, 831)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (5, 2467)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (6, 1026)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (7, 850)
INSERT [dbo].[ZapasyKrwi] ([GrupaKrwiID], [LiczbaJednostek]) VALUES (8, 570)
SET IDENTITY_INSERT [dbo].[ZapasyKrwi] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_GrupaKrwi_Nazwa]    Script Date: 02.02.2022 19:42:29 ******/
ALTER TABLE [dbo].[GrupaKrwi] ADD  CONSTRAINT [UK_GrupaKrwi_Nazwa] UNIQUE NONCLUSTERED 
(
	[Nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Biorcy]  WITH CHECK ADD  CONSTRAINT [FK_Biorcy_GrupaKrwi] FOREIGN KEY([GrupaKrwiID])
REFERENCES [dbo].[GrupaKrwi] ([ID])
GO
ALTER TABLE [dbo].[Biorcy] CHECK CONSTRAINT [FK_Biorcy_GrupaKrwi]
GO
ALTER TABLE [dbo].[Donacje]  WITH CHECK ADD  CONSTRAINT [FK_Donacje_Krwiodawcy] FOREIGN KEY([KrwiodawcaID])
REFERENCES [dbo].[Krwiodawcy] ([ID])
GO
ALTER TABLE [dbo].[Donacje] CHECK CONSTRAINT [FK_Donacje_Krwiodawcy]
GO
ALTER TABLE [dbo].[Donacje]  WITH CHECK ADD  CONSTRAINT [FK_Donacje_Personel] FOREIGN KEY([PracownikID])
REFERENCES [dbo].[Personel] ([ID])
GO
ALTER TABLE [dbo].[Donacje] CHECK CONSTRAINT [FK_Donacje_Personel]
GO
ALTER TABLE [dbo].[Transfuzje]  WITH CHECK ADD  CONSTRAINT [FK_Transfuzje_Biorcy] FOREIGN KEY([BiorcaID])
REFERENCES [dbo].[Biorcy] ([ID])
GO
ALTER TABLE [dbo].[Transfuzje] CHECK CONSTRAINT [FK_Transfuzje_Biorcy]
GO
ALTER TABLE [dbo].[Transporty]  WITH CHECK ADD  CONSTRAINT [FK_Transporty_GrupaKrwi] FOREIGN KEY([GrupaKrwiID])
REFERENCES [dbo].[GrupaKrwi] ([ID])
GO
ALTER TABLE [dbo].[Transporty] CHECK CONSTRAINT [FK_Transporty_GrupaKrwi]
GO
ALTER TABLE [dbo].[Transporty]  WITH CHECK ADD  CONSTRAINT [FK_Transporty_Placówki] FOREIGN KEY([PlacówkaID])
REFERENCES [dbo].[Placówki] ([ID])
GO
ALTER TABLE [dbo].[Transporty] CHECK CONSTRAINT [FK_Transporty_Placówki]
GO
ALTER TABLE [dbo].[ZapasyKrwi]  WITH CHECK ADD  CONSTRAINT [FK_ZapasyKrwi_GrupaKrwi] FOREIGN KEY([GrupaKrwiID])
REFERENCES [dbo].[GrupaKrwi] ([ID])
GO
ALTER TABLE [dbo].[ZapasyKrwi] CHECK CONSTRAINT [FK_ZapasyKrwi_GrupaKrwi]
GO
ALTER TABLE [dbo].[Biorcy]  WITH CHECK ADD  CONSTRAINT [CK_Biorcy] CHECK  (([Płeć]='M' OR [Płeć]='K'))
GO
ALTER TABLE [dbo].[Biorcy] CHECK CONSTRAINT [CK_Biorcy]
GO
ALTER TABLE [dbo].[GrupaKrwi]  WITH CHECK ADD  CONSTRAINT [CK_GrupaKrwi] CHECK  (([Nazwa]='A+' OR [Nazwa]='A-' OR [Nazwa]='B+' OR [Nazwa]='B-' OR [Nazwa]='AB+' OR [Nazwa]='AB-' OR [Nazwa]='0+' OR [Nazwa]='0-'))
GO
ALTER TABLE [dbo].[GrupaKrwi] CHECK CONSTRAINT [CK_GrupaKrwi]
GO
ALTER TABLE [dbo].[Krwiodawcy]  WITH CHECK ADD  CONSTRAINT [CK_Krwiodawcy_Płeć] CHECK  (([Płeć]='M' OR [Płeć]='K'))
GO
ALTER TABLE [dbo].[Krwiodawcy] CHECK CONSTRAINT [CK_Krwiodawcy_Płeć]
GO
/****** Object:  StoredProcedure [dbo].[DodajBiorce]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DodajBiorce] (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Biorcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO
/****** Object:  StoredProcedure [dbo].[DodajDonacje]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DodajDonacje]
@KrwiodawcaID int,
@DataDonacji date,
@PracownikID int,
@CzyUkończono bit
AS
INSERT INTO Donacje (KrwiodawcaID, DataDonacji, PracownikID, CzyUkończono)
VALUES (@KrwiodawcaID, @DataDonacji, @PracownikID, @CzyUkończono)
DECLARE @GrupaKrwiodawcy tinyint = (SELECT GrupaKrwiID FROM Krwiodawcy WHERE ID = @KrwiodawcaID)
IF (@CzyUkończono = 1)
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + 1
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaKrwiodawcy
GO
/****** Object:  StoredProcedure [dbo].[DodajKrwiodawce]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DodajKrwiodawce] (
	@Imię nvarchar(50),
	@Nazwisko nvarchar(100),
	@DataUrodzenia date,
	@Email nvarchar(100),
	@NumerTelefonu nvarchar(20),
	@Adres nvarchar(250),
	@GrupaKrwiID tinyint,
	@Płeć char(1))
AS
INSERT INTO Krwiodawcy (Imię, Nazwisko, DataUrodzenia, Email, NumerTelefonu, Adres, GrupaKrwiID, Płeć)
VALUES (@Imię, @Nazwisko, @DataUrodzenia, @Email, @NumerTelefonu, @Adres, @GrupaKrwiID, @Płeć)
GO
/****** Object:  StoredProcedure [dbo].[DodajPracownika]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajPracownika] (
@Imię nvarchar(50),
@Nazwisko nvarchar(100),
@Stanowisko nvarchar(50))
AS
INSERT INTO Personel (Imię, Nazwisko, Stanowisko)
VALUES (@Imię, @Nazwisko, @Stanowisko)
GO
/****** Object:  StoredProcedure [dbo].[DodajTransfuzje]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DodajTransfuzje]
@BiorcaID int,
@PrzetoczonoJednostek tinyint,
@DataTransfuzji datetime
AS
INSERT INTO Transfuzje (BiorcaID, PrzetoczonoJednostek, DataTransfuzji)
VALUES (@BiorcaID, @PrzetoczonoJednostek, @DataTransfuzji)
DECLARE @GrupaBiorcy tinyint = (SELECT GrupaKrwiID FROM Biorcy WHERE ID = @BiorcaID)
UPDATE ZapasyKrwi
SET LiczbaJednostek =  LiczbaJednostek - @PrzetoczonoJednostek
WHERE ZapasyKrwi.GrupaKrwiID = @GrupaBiorcy
GO
/****** Object:  StoredProcedure [dbo].[DodajTransport]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajTransport] (
	@GrupaKrwiID tinyint,
	@PlacówkaID smallint,
	@LiczbaJednostek int,
	@DataTransportu date,
	@CzyWychodzący bit)
AS
INSERT INTO Transporty (GrupaKrwiID, PlacówkaID, LiczbaJednostek, DataTransportu, CzyWychodzący)
VALUES (@GrupaKrwiID, @PlacówkaID, @LiczbaJednostek, @DataTransportu, @CzyWychodzący)
IF (@CzyWychodzący = 1)
UPDATE ZapasyKrwi SET
	LiczbaJednostek = LiczbaJednostek - @LiczbaJednostek
ELSE
UPDATE ZapasyKrwi SET
	LiczbaJednostek = LiczbaJednostek + @LiczbaJednostek
GO
/****** Object:  StoredProcedure [dbo].[DodajZapasy]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DodajZapasy]
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek + @LiczbaJednostek WHERE GrupaKrwiID = @GrupaKrwiID
GO
/****** Object:  StoredProcedure [dbo].[OdejmijZapasy]    Script Date: 02.02.2022 19:42:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[OdejmijZapasy]
@GrupaKrwiID tinyint,
@LiczbaJednostek int
AS
UPDATE ZapasyKrwi
SET LiczbaJednostek = LiczbaJednostek - @LiczbaJednostek WHERE GrupaKrwiID = @GrupaKrwiID

SELECT * FROM ZapasyKrwi
SELECT * FROM Transporty

GO
USE [master]
GO
ALTER DATABASE [BankKrwi] SET  READ_WRITE 
GO
