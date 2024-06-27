-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 06, 2023 at 11:10 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `airport`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailableAircraftStands` ()   BEGIN
    SELECT AircraftStandID
    FROM aircraftstand
    WHERE Status = 'Avail';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetEmployeeDepartmentSummary` ()   BEGIN
    SELECT d.DepartmentName, COUNT(ae.EmployeeID) AS NumberOfEmployees
    FROM department d
    LEFT JOIN airportemployee ae ON d.DepartmentID = ae.DepartmentID
    GROUP BY d.DepartmentName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPassengerFlightHistory` (IN `p_PassengerID` INT)   BEGIN
    SELECT pf.PassengerID, pf.FlightID, f.DepartureDate, f.ArrivalDate, f.ArrivalAirport, pf.NumberOfBags
    FROM flight AS f
    JOIN passengerflight AS pf ON pf.FlightID = f.FlightID
    WHERE pf.PassengerID = p_PassengerID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateFlightStatus` (IN `p_FlightID` VARCHAR(10), IN `p_Status` VARCHAR(10))   BEGIN
    UPDATE flight
    SET ArrivalCountry = p_Status
    WHERE FlightID = p_FlightID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `aircraftstand`
--

CREATE TABLE `aircraftstand` (
  `AircraftStandID` varchar(7) NOT NULL,
  `Status` varchar(5) DEFAULT NULL,
  `Size` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aircraftstand`
--

INSERT INTO `aircraftstand` (`AircraftStandID`, `Status`, `Size`) VALUES
('S1', 'Avail', 3),
('S2', 'Occup', 35),
('S3', 'Avail', 1),
('S4', 'Avail', 10),
('S5', 'Occup', 12);

-- --------------------------------------------------------

--
-- Table structure for table `airline`
--

CREATE TABLE `airline` (
  `AirlineID` int(11) NOT NULL,
  `AirlineName` varchar(10) DEFAULT NULL,
  `Country` varchar(10) DEFAULT NULL,
  `Email` varchar(30) DEFAULT NULL,
  `PhoneNumber` varchar(20) DEFAULT '+962 000-000-000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airline`
--

INSERT INTO `airline` (`AirlineID`, `AirlineName`, `Country`, `Email`, `PhoneNumber`) VALUES
(1, 'Example Ai', 'United Sta', 'contact@exampleairlines.com', '+962 783-456-949'),
(2, 'SkyLink Ai', 'Canada', 'info@skylinkairways.com', '+962 799-055-437'),
(3, 'AeroConnec', 'France', 'info@aeroconnectintl.com', '+962 771-222-112'),
(4, 'Global Win', 'United Kin', 'contact@globalwings.com', '+962 777-888-843'),
(5, 'Mediterran', 'Greece', 'info@mediterraneansky.com', '+962 799-888-341');

-- --------------------------------------------------------

--
-- Table structure for table `airportemployee`
--

CREATE TABLE `airportemployee` (
  `EmployeeID` varchar(15) NOT NULL,
  `EmployeeFirstName` varchar(10) DEFAULT NULL,
  `EMployeeLastName` varchar(10) DEFAULT NULL,
  `JobTitle` varchar(10) DEFAULT NULL,
  `DepartmentID` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airportemployee`
--

INSERT INTO `airportemployee` (`EmployeeID`, `EmployeeFirstName`, `EMployeeLastName`, `JobTitle`, `DepartmentID`) VALUES
('101', 'John', 'Smith', 'Flight Att', '1'),
('102', 'Emily', 'Johnson', 'Customer S', '2'),
('103', 'Michael', 'Williams', 'Security O', '3'),
('104', 'Sarah', 'Brown', 'Accountant', '5'),
('105', 'David', 'Miller', 'IT Special', '4');

-- --------------------------------------------------------

--
-- Table structure for table `airportemployee_phonenumber`
--

CREATE TABLE `airportemployee_phonenumber` (
  `EmployeeID` varchar(15) NOT NULL,
  `PhoneNumber` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airportemployee_phonenumber`
--

INSERT INTO `airportemployee_phonenumber` (`EmployeeID`, `PhoneNumber`) VALUES
('101', '+962 785-123-753'),
('102', '+962 784-987-281'),
('103', '+962 790-525-111'),
('104', '+962 795-153-021'),
('105', '+962 784-333-321');

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `DepartmentID` varchar(15) NOT NULL,
  `DepartmentName` varchar(10) DEFAULT NULL,
  `NumberOfEmployee` int(11) DEFAULT NULL,
  `MangerID` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`DepartmentID`, `DepartmentName`, `NumberOfEmployee`, `MangerID`) VALUES
('1', 'Flights ', 50, '104'),
('2', 'Passenger ', 30, '103'),
('3', 'Security', 20, '105'),
('4', 'Finance', 15, '101'),
('5', 'Informatio', 25, '101');

-- --------------------------------------------------------

--
-- Stand-in structure for view `employee_details`
-- (See below for the actual view)
--
CREATE TABLE `employee_details` (
`EmployeeID` varchar(15)
,`EmployeeFirstName` varchar(10)
,`EMployeeLastName` varchar(10)
,`DepartmentID` varchar(15)
,`DepartmentName` varchar(10)
,`MangerID` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `flight`
--

CREATE TABLE `flight` (
  `FlightID` varchar(10) NOT NULL,
  `DepartureDate` date DEFAULT NULL,
  `DepartureTime` time DEFAULT NULL,
  `ArrivalDate` date DEFAULT NULL,
  `ArrivalTime` time DEFAULT NULL,
  `ArrivalCountry` varchar(10) DEFAULT NULL,
  `ArrivalAirport` varchar(30) DEFAULT NULL,
  `Registeredby` varchar(15) DEFAULT NULL,
  `AirlineID` int(11) DEFAULT NULL,
  `GateID` varchar(7) DEFAULT NULL,
  `AircraftstandID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flight`
--

INSERT INTO `flight` (`FlightID`, `DepartureDate`, `DepartureTime`, `ArrivalDate`, `ArrivalTime`, `ArrivalCountry`, `ArrivalAirport`, `Registeredby`, `AirlineID`, `GateID`, `AircraftstandID`) VALUES
('1', '2023-08-25', '11:00:00', '2023-08-25', '12:00:00', 'Amman', 'JFK', '101', 1, 'A1', 'S1'),
('2', '2023-08-25', '14:30:00', '2023-08-25', '17:00:00', 'United Kin', 'LHR', '102', 2, 'B2', 'S2'),
('3', '2023-08-26', '09:15:00', '2023-08-26', '12:30:00', 'France', 'CDG', '103', 1, 'C3', 'S3'),
('4', '2023-08-26', '17:45:00', '2023-08-26', '20:15:00', 'United Ara', 'DXB', '104', 3, 'D4', 'S4'),
('5', '2023-08-27', '08:00:00', '2023-08-27', '11:30:00', 'Japan', 'HND', '105', 4, 'E5', 'S5');

-- --------------------------------------------------------

--
-- Stand-in structure for view `flight_details`
-- (See below for the actual view)
--
CREATE TABLE `flight_details` (
`FlightID` varchar(10)
,`Registeredby` varchar(15)
,`ArrivalAirport` varchar(30)
,`AirlineID` int(11)
,`AirlineName` varchar(10)
,`GateID` varchar(7)
,`Status` varchar(5)
);

-- --------------------------------------------------------

--
-- Table structure for table `passenger`
--

CREATE TABLE `passenger` (
  `PassengerID` int(11) NOT NULL,
  `PassengerFirstName` varchar(10) DEFAULT NULL,
  `PassengerLastName` varchar(10) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `PassportID` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passenger`
--

INSERT INTO `passenger` (`PassengerID`, `PassengerFirstName`, `PassengerLastName`, `DateOfBirth`, `Email`, `PassportID`) VALUES
(1, 'John', 'Doee', '1990-05-15', 'john.doe@example.com', 'AB123456'),
(2, 'Jane', 'Smith', '1985-09-20', 'jane.smith@example.com', 'CD789012'),
(3, 'Michael', 'Johnson', '1982-03-10', 'michael.johnson@example.com', 'EF345678'),
(4, 'Emily', 'Brown', '1998-11-28', 'emily.brown@example.com', 'GH567890'),
(100, 'Hamza', 'Osama', '2003-05-26', 'example@gmail.com', '3FFG25'),
(325, 'Mohammad', 'Al-Risheq', '2000-07-05', 'mohammd@example.com', '42DGW332');

-- --------------------------------------------------------

--
-- Table structure for table `passengerflight`
--

CREATE TABLE `passengerflight` (
  `PassengerID` int(11) NOT NULL,
  `FlightID` varchar(10) NOT NULL,
  `NumberOfBags` int(11) DEFAULT NULL CHECK (`NumberOfBags` >= 0),
  `SeatNumber` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passengerflight`
--

INSERT INTO `passengerflight` (`PassengerID`, `FlightID`, `NumberOfBags`, `SeatNumber`) VALUES
(100, '1', 2, 'S2');

-- --------------------------------------------------------

--
-- Table structure for table `passengernationality`
--

CREATE TABLE `passengernationality` (
  `PassengerID` int(11) NOT NULL,
  `PassengerNationality` varchar(13) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passengernationality`
--

INSERT INTO `passengernationality` (`PassengerID`, `PassengerNationality`) VALUES
(1, 'Canada'),
(1, 'USA'),
(2, 'UK'),
(3, 'France'),
(4, 'Germany'),
(325, 'Jordanian'),
(325, 'Palestanian ');

-- --------------------------------------------------------

--
-- Table structure for table `passengerphonenumber`
--

CREATE TABLE `passengerphonenumber` (
  `PassengerID` int(11) NOT NULL,
  `PhoneNumber` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passengerphonenumber`
--

INSERT INTO `passengerphonenumber` (`PassengerID`, `PhoneNumber`) VALUES
(1, '+962 945-693-899'),
(2, '+962 555-555-087'),
(3, '+1 336-888-888'),
(4, '+1 336-332-564'),
(325, '+962 778-230-929');

-- --------------------------------------------------------

--
-- Stand-in structure for view `passengers_flights_details`
-- (See below for the actual view)
--
CREATE TABLE `passengers_flights_details` (
`PassengerID` int(11)
,`PassengerFirstName` varchar(10)
,`PassengerLastName` varchar(10)
,`PassportID` varchar(25)
,`FlightID` varchar(10)
,`NumberOfBags` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `passengers_phonenumbers`
-- (See below for the actual view)
--
CREATE TABLE `passengers_phonenumbers` (
`PassengerID` int(11)
,`PassengerFirstName` varchar(10)
,`PassengerLastName` varchar(10)
,`PassportID` varchar(25)
,`PhoneNumber` varchar(20)
);

-- --------------------------------------------------------

--
-- Table structure for table `planegate`
--

CREATE TABLE `planegate` (
  `GateID` varchar(7) NOT NULL,
  `Status` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `planegate`
--

INSERT INTO `planegate` (`GateID`, `Status`) VALUES
('A1', 'Avail'),
('B2', 'Occup'),
('C3', 'Avail'),
('D4', 'Occup'),
('E5', 'Avail');

-- --------------------------------------------------------

--
-- Structure for view `employee_details`
--
DROP TABLE IF EXISTS `employee_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `employee_details`  AS SELECT `ae`.`EmployeeID` AS `EmployeeID`, `ae`.`EmployeeFirstName` AS `EmployeeFirstName`, `ae`.`EMployeeLastName` AS `EMployeeLastName`, `ae`.`DepartmentID` AS `DepartmentID`, `d`.`DepartmentName` AS `DepartmentName`, `d`.`MangerID` AS `MangerID` FROM (`airportemployee` `ae` join `department` `d` on(`ae`.`DepartmentID` = `d`.`DepartmentID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `flight_details`
--
DROP TABLE IF EXISTS `flight_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `flight_details`  AS SELECT `f`.`FlightID` AS `FlightID`, `f`.`Registeredby` AS `Registeredby`, `f`.`ArrivalAirport` AS `ArrivalAirport`, `ar`.`AirlineID` AS `AirlineID`, `ar`.`AirlineName` AS `AirlineName`, `pg`.`GateID` AS `GateID`, `pg`.`Status` AS `Status` FROM ((`flight` `f` join `airline` `ar` on(`f`.`AirlineID` = `ar`.`AirlineID`)) join `planegate` `pg` on(`f`.`GateID` = `pg`.`GateID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `passengers_flights_details`
--
DROP TABLE IF EXISTS `passengers_flights_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `passengers_flights_details`  AS SELECT `p`.`PassengerID` AS `PassengerID`, `p`.`PassengerFirstName` AS `PassengerFirstName`, `p`.`PassengerLastName` AS `PassengerLastName`, `p`.`PassportID` AS `PassportID`, `pf`.`FlightID` AS `FlightID`, `pf`.`NumberOfBags` AS `NumberOfBags` FROM (`passenger` `p` join `passengerflight` `pf` on(`p`.`PassengerID` = `pf`.`PassengerID`)) ;

-- --------------------------------------------------------

--
-- Structure for view `passengers_phonenumbers`
--
DROP TABLE IF EXISTS `passengers_phonenumbers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `passengers_phonenumbers`  AS SELECT `p`.`PassengerID` AS `PassengerID`, `p`.`PassengerFirstName` AS `PassengerFirstName`, `p`.`PassengerLastName` AS `PassengerLastName`, `p`.`PassportID` AS `PassportID`, `ph`.`PhoneNumber` AS `PhoneNumber` FROM (`passenger` `p` join `passengerphonenumber` `ph` on(`p`.`PassengerID` = `ph`.`PassengerID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aircraftstand`
--
ALTER TABLE `aircraftstand`
  ADD PRIMARY KEY (`AircraftStandID`);

--
-- Indexes for table `airline`
--
ALTER TABLE `airline`
  ADD PRIMARY KEY (`AirlineID`);

--
-- Indexes for table `airportemployee`
--
ALTER TABLE `airportemployee`
  ADD PRIMARY KEY (`EmployeeID`),
  ADD KEY `employee_fk` (`DepartmentID`);

--
-- Indexes for table `airportemployee_phonenumber`
--
ALTER TABLE `airportemployee_phonenumber`
  ADD PRIMARY KEY (`EmployeeID`,`PhoneNumber`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`DepartmentID`),
  ADD KEY `mangerID_FK` (`MangerID`);

--
-- Indexes for table `flight`
--
ALTER TABLE `flight`
  ADD PRIMARY KEY (`FlightID`),
  ADD KEY `AirlineID_FK` (`AirlineID`),
  ADD KEY `RegisteredBy_FK` (`Registeredby`),
  ADD KEY `GateID_FK` (`GateID`),
  ADD KEY `AircraftstandID_FK` (`AircraftstandID`);

--
-- Indexes for table `passenger`
--
ALTER TABLE `passenger`
  ADD PRIMARY KEY (`PassengerID`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- Indexes for table `passengerflight`
--
ALTER TABLE `passengerflight`
  ADD PRIMARY KEY (`PassengerID`,`FlightID`),
  ADD KEY `FlightID_FK` (`FlightID`);

--
-- Indexes for table `passengernationality`
--
ALTER TABLE `passengernationality`
  ADD PRIMARY KEY (`PassengerID`,`PassengerNationality`);

--
-- Indexes for table `passengerphonenumber`
--
ALTER TABLE `passengerphonenumber`
  ADD PRIMARY KEY (`PassengerID`,`PhoneNumber`);

--
-- Indexes for table `planegate`
--
ALTER TABLE `planegate`
  ADD PRIMARY KEY (`GateID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `airportemployee`
--
ALTER TABLE `airportemployee`
  ADD CONSTRAINT `employee_fk` FOREIGN KEY (`DepartmentID`) REFERENCES `department` (`DepartmentID`);

--
-- Constraints for table `airportemployee_phonenumber`
--
ALTER TABLE `airportemployee_phonenumber`
  ADD CONSTRAINT `employeeID_FK4` FOREIGN KEY (`EmployeeID`) REFERENCES `airportemployee` (`EmployeeID`);

--
-- Constraints for table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `mangerID_FK` FOREIGN KEY (`MangerID`) REFERENCES `airportemployee` (`EmployeeID`);

--
-- Constraints for table `flight`
--
ALTER TABLE `flight`
  ADD CONSTRAINT `AircraftstandID_FK` FOREIGN KEY (`AircraftstandID`) REFERENCES `aircraftstand` (`AircraftStandID`),
  ADD CONSTRAINT `AirlineID_FK` FOREIGN KEY (`AirlineID`) REFERENCES `airline` (`AirlineID`),
  ADD CONSTRAINT `GateID_FK` FOREIGN KEY (`GateID`) REFERENCES `planegate` (`GateID`),
  ADD CONSTRAINT `RegisteredBy_FK` FOREIGN KEY (`Registeredby`) REFERENCES `airportemployee` (`EmployeeID`);

--
-- Constraints for table `passengerflight`
--
ALTER TABLE `passengerflight`
  ADD CONSTRAINT `FlightID_FK` FOREIGN KEY (`FlightID`) REFERENCES `flight` (`FlightID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `passengerID_FK3` FOREIGN KEY (`PassengerID`) REFERENCES `passenger` (`PassengerID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `passengernationality`
--
ALTER TABLE `passengernationality`
  ADD CONSTRAINT `passenger__ID_FK` FOREIGN KEY (`PassengerID`) REFERENCES `passenger` (`PassengerID`);

--
-- Constraints for table `passengerphonenumber`
--
ALTER TABLE `passengerphonenumber`
  ADD CONSTRAINT `passengerID_FK` FOREIGN KEY (`PassengerID`) REFERENCES `passenger` (`PassengerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `passengerphonenumber_ibfk_1` FOREIGN KEY (`PassengerID`) REFERENCES `passenger` (`PassengerID`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
