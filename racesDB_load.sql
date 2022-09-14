CREATE DATABASE racesdb;
USE racesdb;

DROP TABLE IF EXISTS RacesCSV;
CREATE TABLE RacesCSV (
    raceId INT NOT NULL,
    year INT NULL,
    round INT NULL,
    circuitId INT NULL,
    name VARCHAR (255) NULL,
    date DATE NULL,
    time TIME NULL,
    url VARCHAR (255) NULL,
    PRIMARY KEY (raceId)
);

LOAD DATA
INFILE '/var/lib/mysql-files/races.csv'
INTO TABLE RacesCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;

/* ==================================================== */
DROP TABLE IF EXISTS circuitidCSV;
CREATE TABLE circuitidCSV (
    circuitid INT NOT NULL,
    circuitRef VARCHAR (255) NULL,
    name VARCHAR (255) NULL,
    location VARCHAR (255) NULL,
    country VARCHAR (255) NULL,
    lat VARCHAR (20) NULL,
    lng VARCHAR (50) NULL,
    alt INT NULL,
    url VARCHAR (255) NULL,
    PRIMARY KEY (circuitid)
);

LOAD DATA
INFILE '/var/lib/mysql-files/circuits.csv'
INTO TABLE circuitidCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;
/* ==================================================== */

DROP TABLE IF EXISTS constructorsCSV;
CREATE TABLE constructorsCSV (
    constructorId INT NOT NULL,
    constructorRef VARCHAR (100) NOT NULL,
    name VARCHAR (100) NULL,
    nationality VARCHAR (100) NULL,
    url VARCHAR (255) NULL,
    PRIMARY KEY (constructorId)
);

LOAD DATA
INFILE '/var/lib/mysql-files/constructors.csv'
INTO TABLE constructorsCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;
/* ==================================================== */

DROP TABLE IF EXISTS driversCSV;
CREATE TABLE driversCSV (
    driverid INT NOT NULL,
    driverRef  VARCHAR (100) NULL,
    number VARCHAR (10) NULL,
    code VARCHAR (10) NULL,
    name  VARCHAR (50) NULL,
    surname  VARCHAR (50) NULL,
    dob DATE NULL,
    nationality  VARCHAR (100) NULL,
    url  VARCHAR (250) NULL,
    PRIMARY KEY (driverid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA
INFILE '/var/lib/mysql-files/drivers.csv'
INTO TABLE driversCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;

/* ==================================================== */

DROP TABLE IF EXISTS pit_stopsCSV;
CREATE TABLE pit_stopsCSV (
    raceid INT NOT NULL,
    driverid INT NOT NULL,
    stop INT NULL,
    lap INT NULL,
    tiempo TIME NULL,
    duration FLOAT null,
    milliseconds INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA
INFILE '/var/lib/mysql-files/pit_stops.csv'
INTO TABLE pit_stopsCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;
/* ==================================================== */

DROP TABLE IF EXISTS resultsCSV;
CREATE TABLE resultsCSV (
    resultid INT NOT NULL,
    raceid INT NULL,
    driverid INT NULL,
    constructorid INT NULL,
    number INT NULL,
    grid INT NULL,
    position INT NULL,
    positionTex VARCHAR (10) NULL,
    positionOrder INT NULL,
    points INT NULL,
    laps INT NULL,
    time INT NULL,
    milliseconds INT NULL,
    fastestlap INT NULL,
    ranking INT NULL,
    fastestLapTime TIME NULL,
    fastestLapSpeed FLOAT NULL,
    statusid INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

LOAD DATA
INFILE '/var/lib/mysql-files/results.csv'
INTO TABLE resultsCSV
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;


/*     Año con más carreras     */
SELECT year, COUNT(year) AS Total_Carreras
FROM RacesCSV
GROUP BY year
ORDER BY Total_Carreras DESC
LIMIT 1;

/* Piloto con mayor cantidad de primeros puestos */
SELECT d.driverid, COUNT(d.driverid) AS C_Ganadas, CONCAT(d.name, ' ', 
      d.surname) AS Piloto, r.position 
FROM driversCSV AS d
INNER JOIN  resultsCSV AS r ON d.driverid = r.driverid
WHERE r.position = 1
GROUP BY d.driverid
ORDER BY C_Ganadas DESC
LIMIT 1;

/* Nombre del circuito más corrido */
SELECT r.circuitId, COUNT(r.circuitId) AS Veces_Corridas,
    c.name, c.location, c.country
FROM RacesCSV AS r
INNER JOIN circuitidCSV as c ON r.circuitId = c.circuitid
GROUP BY r.circuitId
ORDER BY Veces_Corridas DESC
LIMIT 1;

/* Piloto con mayor cantidad de puntos en total, cuyo constructor sea de nacionalidad sea American o British */
SELECT r.driverid, CONCAT(d.name,' ',d.surname) AS Piloto,
        SUM(r.points) AS Puntos_Totales
FROM resultsCSV AS r
LEFT JOIN driversCSV as  d
GROUP BY r.driverid
ORDER BY Puntos_Totales DESC;

/* Para solucionar error 1055 */
SELECT @@sql_mode;
/* 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */
SET sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
