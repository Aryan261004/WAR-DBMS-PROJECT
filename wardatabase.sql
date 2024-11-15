-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 15, 2024 at 06:22 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wardatabase`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `active_soldiers`
-- (See below for the actual view)
--
CREATE TABLE `active_soldiers` (
`soldier_id` int(50)
,`name` varchar(50)
,`rank` varchar(50)
,`status` varchar(50)
,`war_name` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `alliance`
--

CREATE TABLE `alliance` (
  `Alliance_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Formation_Date` date NOT NULL,
  `Country1_ID` int(50) NOT NULL,
  `Country2_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ammunation`
--

CREATE TABLE `ammunation` (
  `Type` varchar(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `ExpirationDate` date NOT NULL,
  `Weapon_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ammunation`
--

INSERT INTO `ammunation` (`Type`, `Quantity`, `ExpirationDate`, `Weapon_ID`) VALUES
('bullet', 200, '2024-12-19', 1);

--
-- Triggers `ammunation`
--
DELIMITER $$
CREATE TRIGGER `prevent_expired_ammunition` BEFORE INSERT ON `ammunation` FOR EACH ROW BEGIN
    IF NEW.ExpirationDate < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add expired ammunition';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `battle`
--

CREATE TABLE `battle` (
  `Battle_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Location` varchar(50) NOT NULL,
  `Date` date NOT NULL,
  `Outcome` varchar(50) NOT NULL,
  `War_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `battle`
--

INSERT INTO `battle` (`Battle_ID`, `Name`, `Location`, `Date`, `Outcome`, `War_ID`) VALUES
(1, 'kargil', 'dsad', '2023-10-11', 'won', 1);

-- --------------------------------------------------------

--
-- Table structure for table `casualty`
--

CREATE TABLE `casualty` (
  `Casualty_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Date_Of_Death` date NOT NULL,
  `Cause_Of_Death` varchar(50) NOT NULL,
  `War_ID` int(50) NOT NULL,
  `Country_ID` int(50) NOT NULL,
  `Soldier_ID` int(50) NOT NULL,
  `Battle_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `casualty`
--

INSERT INTO `casualty` (`Casualty_ID`, `Name`, `Date_Of_Death`, `Cause_Of_Death`, `War_ID`, `Country_ID`, `Soldier_ID`, `Battle_ID`) VALUES
(1, 'rohit', '2024-11-14', 'bombs', 1, 1, 1, 1),
(2, 'parth', '2024-12-11', 'bombs', 1, 1, 2, 1);

--
-- Triggers `casualty`
--
DELIMITER $$
CREATE TRIGGER `prevent_duplicate_casualty` BEFORE INSERT ON `casualty` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM casualty WHERE soldier_id = NEW.soldier_id AND battle_id = NEW.battle_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Soldier is already recorded as a casualty in this battle';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_soldier_status` AFTER INSERT ON `casualty` FOR EACH ROW BEGIN
    UPDATE soldier
    SET status = 'Deceased'
    WHERE soldier_id = NEW.soldier_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `Country_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Continent` varchar(50) NOT NULL,
  `Leader` varchar(50) NOT NULL,
  `Population` varchar(50) NOT NULL,
  `Military_Strength` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`Country_ID`, `Name`, `Continent`, `Leader`, `Population`, `Military_Strength`) VALUES
(1, 'INDIA', 'ASIA', 'Narendra Modi', '141 Crore', '1.4 Million'),
(2, 'USA', ' North America', 'Trumph', '33.5 Crore', '1.4 Million');

-- --------------------------------------------------------

--
-- Table structure for table `dependent`
--

CREATE TABLE `dependent` (
  `Name` varchar(50) NOT NULL,
  `Date_Of_Birth` date NOT NULL,
  `Relationship` varchar(50) NOT NULL,
  `Soldier_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `general`
--

CREATE TABLE `general` (
  `General_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Rank` varchar(50) NOT NULL,
  `Experience_Years` int(50) NOT NULL,
  `Country_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `general`
--

INSERT INTO `general` (`General_ID`, `Name`, `Rank`, `Experience_Years`, `Country_ID`) VALUES
(1, 'rohit', 'major', 5, 1),
(2, 'parth', 'major', 4, 1),
(3, 'aryan', 'major', 3, 1),
(4, 'ansh', 'major', 5, 2),
(5, 'virat', 'major', 6, 2);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`username`, `password`) VALUES
('admin', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `soldier`
--

CREATE TABLE `soldier` (
  `Soldier_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Age` int(50) NOT NULL,
  `Rank` varchar(50) NOT NULL,
  `Status` varchar(50) NOT NULL,
  `Salary` int(50) NOT NULL,
  `Country_ID` int(50) NOT NULL,
  `War_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `soldier`
--

INSERT INTO `soldier` (`Soldier_ID`, `Name`, `Age`, `Rank`, `Status`, `Salary`, `Country_ID`, `War_ID`) VALUES
(1, 'rohit', 21, 'major', 'Deceased', 20000, 1, 1),
(2, 'parth', 20, 'major', 'Deceased', 200000, 1, 1),
(3, 'aryan', 20, 'major', 'active', 200000, 1, 1);

--
-- Triggers `soldier`
--
DELIMITER $$
CREATE TRIGGER `check_soldier_rank` BEFORE INSERT ON `soldier` FOR EACH ROW BEGIN
    IF NOT NEW.rank IN ('Private', 'Sergeant', 'Lieutenant', 'Captain', 'Major', 'Colonel', 'General') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid rank. Allowed ranks are: Private, Sergeant, Lieutenant, Captain, Major, Colonel, General';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supply`
--

CREATE TABLE `supply` (
  `Supply_ID` int(50) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Quantity` int(50) NOT NULL,
  `Supply_Date` date NOT NULL,
  `War_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supply`
--

INSERT INTO `supply` (`Supply_ID`, `Type`, `Quantity`, `Supply_Date`, `War_ID`) VALUES
(1, 'guns', 252, '2023-12-11', 1);

-- --------------------------------------------------------

--
-- Table structure for table `supplyshipment`
--

CREATE TABLE `supplyshipment` (
  `Quantity` int(50) NOT NULL,
  `ShipmentDate` date NOT NULL,
  `ConditionUponArrival` varchar(50) NOT NULL,
  `Supply_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplyshipment`
--

INSERT INTO `supplyshipment` (`Quantity`, `ShipmentDate`, `ConditionUponArrival`, `Supply_ID`) VALUES
(200, '2022-11-11', 'bad', 1);

--
-- Triggers `supplyshipment`
--
DELIMITER $$
CREATE TRIGGER `track_supply_quantity` BEFORE INSERT ON `supplyshipment` FOR EACH ROW BEGIN
    DECLARE total_supply INT;
    SELECT quantity INTO total_supply FROM supply WHERE supply_id = NEW.supply_id;

    IF NEW.quantity > total_supply THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Shipment quantity exceeds available supply';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_supply_quantity` AFTER INSERT ON `supplyshipment` FOR EACH ROW BEGIN
    UPDATE supply
    SET quantity = quantity + NEW.quantity
    WHERE supply_id = NEW.supply_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `war`
--

CREATE TABLE `war` (
  `War_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Location` varchar(50) NOT NULL,
  `Result` varchar(50) NOT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date NOT NULL,
  `Outcome` varchar(50) NOT NULL,
  `General_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `war`
--

INSERT INTO `war` (`War_ID`, `Name`, `Location`, `Result`, `Start_Date`, `End_Date`, `Outcome`, `General_ID`) VALUES
(1, 'kargil', 'ass', 'aasa', '2001-11-01', '2002-11-01', 'Stalemate', 1);

--
-- Triggers `war`
--
DELIMITER $$
CREATE TRIGGER `auto_set_war_outcome` BEFORE INSERT ON `war` FOR EACH ROW BEGIN
    IF NEW.result = 'Victory' THEN
        SET NEW.outcome = 'Won';
    ELSEIF NEW.result = 'Defeat' THEN
        SET NEW.outcome = 'Lost';
    ELSE
        SET NEW.outcome = 'Stalemate';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_war_dates` BEFORE INSERT ON `war` FOR EACH ROW BEGIN
    IF NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'End date cannot be before start date';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_battle_outcome_on_war_change` AFTER UPDATE ON `war` FOR EACH ROW BEGIN
    UPDATE battle
    SET outcome = NEW.outcome
    WHERE war_id = NEW.war_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `war_casualties`
-- (See below for the actual view)
--
CREATE TABLE `war_casualties` (
`war_name` varchar(50)
,`country_name` varchar(50)
,`total_casualties` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `weapon`
--

CREATE TABLE `weapon` (
  `Weapon_ID` int(50) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Range_` int(50) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Calibre` int(50) NOT NULL,
  `Country_ID` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weapon`
--

INSERT INTO `weapon` (`Weapon_ID`, `Name`, `Range_`, `Type`, `Calibre`, `Country_ID`) VALUES
(1, 'AK-47', 375, 'Rifel', 7, 1);

-- --------------------------------------------------------

--
-- Structure for view `active_soldiers`
--
DROP TABLE IF EXISTS `active_soldiers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `active_soldiers`  AS SELECT `s`.`Soldier_ID` AS `soldier_id`, `s`.`Name` AS `name`, `s`.`Rank` AS `rank`, `s`.`Status` AS `status`, `w`.`Name` AS `war_name` FROM (`soldier` `s` join `war` `w` on(`s`.`War_ID` = `w`.`War_ID`)) WHERE `s`.`Status` = 'active' ;

-- --------------------------------------------------------

--
-- Structure for view `war_casualties`
--
DROP TABLE IF EXISTS `war_casualties`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `war_casualties`  AS SELECT `w`.`Name` AS `war_name`, `c`.`Name` AS `country_name`, count(`casualty`.`Casualty_ID`) AS `total_casualties` FROM ((`casualty` join `country` `c` on(`casualty`.`Country_ID` = `c`.`Country_ID`)) join `war` `w` on(`casualty`.`War_ID` = `w`.`War_ID`)) GROUP BY `w`.`Name`, `c`.`Name` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alliance`
--
ALTER TABLE `alliance`
  ADD PRIMARY KEY (`Alliance_ID`),
  ADD KEY `Foreign key7` (`Country1_ID`),
  ADD KEY `Foreign Key8` (`Country2_ID`);

--
-- Indexes for table `ammunation`
--
ALTER TABLE `ammunation`
  ADD KEY `Foreign key6` (`Weapon_ID`);

--
-- Indexes for table `battle`
--
ALTER TABLE `battle`
  ADD PRIMARY KEY (`Battle_ID`),
  ADD KEY `Foreign Key10` (`War_ID`);

--
-- Indexes for table `casualty`
--
ALTER TABLE `casualty`
  ADD PRIMARY KEY (`Casualty_ID`),
  ADD KEY `Foreign Key11` (`Country_ID`),
  ADD KEY `Foreign Key12` (`War_ID`),
  ADD KEY `Foreign Key13` (`Soldier_ID`),
  ADD KEY `Foreign Key14` (`Battle_ID`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`Country_ID`);

--
-- Indexes for table `dependent`
--
ALTER TABLE `dependent`
  ADD KEY `Foreign Key3` (`Soldier_ID`);

--
-- Indexes for table `general`
--
ALTER TABLE `general`
  ADD PRIMARY KEY (`General_ID`),
  ADD KEY `Foreign key9` (`Country_ID`);

--
-- Indexes for table `soldier`
--
ALTER TABLE `soldier`
  ADD PRIMARY KEY (`Soldier_ID`),
  ADD KEY `Foreign Key1` (`Country_ID`),
  ADD KEY `Foreign Key2` (`War_ID`);

--
-- Indexes for table `supply`
--
ALTER TABLE `supply`
  ADD PRIMARY KEY (`Supply_ID`),
  ADD KEY `Foreign key15` (`War_ID`);

--
-- Indexes for table `supplyshipment`
--
ALTER TABLE `supplyshipment`
  ADD KEY `Foreign key16` (`Supply_ID`);

--
-- Indexes for table `war`
--
ALTER TABLE `war`
  ADD PRIMARY KEY (`War_ID`),
  ADD KEY `Foreign key4` (`General_ID`);

--
-- Indexes for table `weapon`
--
ALTER TABLE `weapon`
  ADD PRIMARY KEY (`Weapon_ID`),
  ADD KEY `Foreign key5` (`Country_ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alliance`
--
ALTER TABLE `alliance`
  ADD CONSTRAINT `Foreign Key8` FOREIGN KEY (`Country2_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Foreign key7` FOREIGN KEY (`Country1_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ammunation`
--
ALTER TABLE `ammunation`
  ADD CONSTRAINT `Foreign key6` FOREIGN KEY (`Weapon_ID`) REFERENCES `weapon` (`Weapon_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `battle`
--
ALTER TABLE `battle`
  ADD CONSTRAINT `Foreign Key10` FOREIGN KEY (`War_ID`) REFERENCES `war` (`War_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `casualty`
--
ALTER TABLE `casualty`
  ADD CONSTRAINT `Foreign Key11` FOREIGN KEY (`Country_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Foreign Key12` FOREIGN KEY (`War_ID`) REFERENCES `war` (`War_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Foreign Key13` FOREIGN KEY (`Soldier_ID`) REFERENCES `soldier` (`Soldier_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Foreign Key14` FOREIGN KEY (`Battle_ID`) REFERENCES `battle` (`Battle_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `dependent`
--
ALTER TABLE `dependent`
  ADD CONSTRAINT `Foreign Key3` FOREIGN KEY (`Soldier_ID`) REFERENCES `soldier` (`Soldier_ID`);

--
-- Constraints for table `general`
--
ALTER TABLE `general`
  ADD CONSTRAINT `Foreign key9` FOREIGN KEY (`Country_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `soldier`
--
ALTER TABLE `soldier`
  ADD CONSTRAINT `Foreign Key1` FOREIGN KEY (`Country_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Foreign Key2` FOREIGN KEY (`War_ID`) REFERENCES `war` (`War_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supply`
--
ALTER TABLE `supply`
  ADD CONSTRAINT `Foreign key15` FOREIGN KEY (`War_ID`) REFERENCES `war` (`War_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supplyshipment`
--
ALTER TABLE `supplyshipment`
  ADD CONSTRAINT `Foreign key16` FOREIGN KEY (`Supply_ID`) REFERENCES `supply` (`Supply_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `war`
--
ALTER TABLE `war`
  ADD CONSTRAINT `Foreign key4` FOREIGN KEY (`General_ID`) REFERENCES `general` (`General_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `weapon`
--
ALTER TABLE `weapon`
  ADD CONSTRAINT `Foreign key5` FOREIGN KEY (`Country_ID`) REFERENCES `country` (`Country_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
