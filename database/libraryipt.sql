-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2026 at 09:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `libraryipt`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `Admin_ID` int(11) NOT NULL,
  `Admin_Username` varchar(50) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`Admin_ID`, `Admin_Username`, `Password`) VALUES
(1, 'admin', '$2y$10$H4C3diXwRbrXo4HBoiP9OOZk6MQvKxK0sp/fEGvrIExyel/OhZUSS'),
(2, 'admin2', '$2y$10$rV.IwRovE0i95xkL7o2QGO2gQ.tG4f1OxXThvlDG2iVISVHSwDVca'),
(3, 'admin3', '$2y$10$bRF64vnWiwlmCkN4a60G1.jiMnmpJSMdR5FUYl/tFUwZowVS1bIcS');

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `Author_ID` int(11) NOT NULL,
  `Author_Name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`Author_ID`, `Author_Name`) VALUES
(1, 'James Clear'),
(2, 'George Orwell'),
(3, 'J.D. Salinger'),
(4, 'Robert C. Martin'),
(5, 'Kyle Simpson'),
(6, 'Stephen Hawking'),
(7, 'Kristhan Amir'),
(8, 'Ashleigh Mahuagay');

-- --------------------------------------------------------

--
-- Table structure for table `bookcopy`
--

CREATE TABLE `bookcopy` (
  `BookCopy_ID` int(11) NOT NULL,
  `Book_ID` int(11) DEFAULT NULL,
  `Book_Status_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookcopy`
--

INSERT INTO `bookcopy` (`BookCopy_ID`, `Book_ID`, `Book_Status_ID`) VALUES
(8, 1, 1),
(9, 1, 1),
(10, 1, 1),
(11, 1, 1),
(12, 2, 1),
(13, 2, 1),
(15, 4, 1),
(16, 4, 1),
(17, 5, 1),
(18, 5, 1),
(20, 7, 1),
(21, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `Book_ID` int(11) NOT NULL,
  `Book_Title` varchar(255) DEFAULT NULL,
  `Publication_Year` year(4) DEFAULT NULL,
  `Author_ID` int(11) DEFAULT NULL,
  `Category_ID` int(11) DEFAULT NULL,
  `Isbn` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`Book_ID`, `Book_Title`, `Publication_Year`, `Author_ID`, `Category_ID`, `Isbn`) VALUES
(1, 'Atomic Habits', '2018', 1, 4, 21474836),
(2, '1984', '1949', 2, 16, 2147483647),
(4, 'Clean Code', '2008', 4, 5, 2147483647),
(5, 'You Don’t Know JS', '2015', 5, 5, 214748364),
(7, 'The Great Gatsby', '2023', 7, 1, 2147483647);

-- --------------------------------------------------------

--
-- Table structure for table `book_status`
--

CREATE TABLE `book_status` (
  `Book_Status_ID` int(11) NOT NULL,
  `Book_Status_Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_status`
--

INSERT INTO `book_status` (`Book_Status_ID`, `Book_Status_Name`) VALUES
(1, 'Available'),
(2, 'Borrowed');

-- --------------------------------------------------------

--
-- Table structure for table `borrowdetails`
--

CREATE TABLE `borrowdetails` (
  `BorrowDetails_ID` int(11) NOT NULL,
  `Borrow_ID` int(11) DEFAULT NULL,
  `BookCopy_ID` int(11) DEFAULT NULL,
  `Return_Date` date DEFAULT NULL,
  `Borrow_Status_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `borrowrecord`
--

CREATE TABLE `borrowrecord` (
  `Borrow_ID` int(11) NOT NULL,
  `Member_ID` int(11) DEFAULT NULL,
  `Borrow_Date` date DEFAULT NULL,
  `Due_Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrowrecord`
--

INSERT INTO `borrowrecord` (`Borrow_ID`, `Member_ID`, `Borrow_Date`, `Due_Date`) VALUES
(2, 3, '2026-04-28', '2026-05-12');

-- --------------------------------------------------------

--
-- Table structure for table `borrow_status`
--

CREATE TABLE `borrow_status` (
  `Borrow_Status_ID` int(11) NOT NULL,
  `Borrow_Status_Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrow_status`
--

INSERT INTO `borrow_status` (`Borrow_Status_ID`, `Borrow_Status_Name`) VALUES
(1, 'Borrowed'),
(2, 'Returned'),
(3, 'Overdue');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `Category_ID` int(11) NOT NULL,
  `Category_Name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`Category_ID`, `Category_Name`) VALUES
(1, 'Fiction'),
(2, 'Fiction'),
(3, 'Non-Fiction'),
(4, 'Fantasy'),
(5, 'Science'),
(6, 'Technology'),
(7, 'Programming'),
(8, 'Education'),
(9, 'History'),
(10, 'Romance'),
(11, 'Filipino Literature'),
(12, 'Mystery'),
(13, 'Thriller'),
(14, 'Biography'),
(15, 'Self-Help'),
(16, 'Philosophy');

-- --------------------------------------------------------

--
-- Table structure for table `fines`
--

CREATE TABLE `fines` (
  `Fines_ID` int(11) NOT NULL,
  `BorrowDetails_ID` int(11) DEFAULT NULL,
  `Fine_Amount` decimal(10,2) DEFAULT NULL,
  `Fine_Status_ID` int(11) DEFAULT NULL,
  `Issued_Date` date DEFAULT NULL,
  `Paid_Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fine_status`
--

CREATE TABLE `fine_status` (
  `Fine_Status_ID` int(11) NOT NULL,
  `Fine_Status_Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fine_status`
--

INSERT INTO `fine_status` (`Fine_Status_ID`, `Fine_Status_Name`) VALUES
(1, 'Unpaid'),
(2, 'Paid');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `Member_ID` int(11) NOT NULL,
  `Member_Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Contact_Number` varchar(20) DEFAULT NULL,
  `Date_Joined` date DEFAULT NULL,
  `Member_Status_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`Member_ID`, `Member_Name`, `Email`, `Contact_Number`, `Date_Joined`, `Member_Status_ID`) VALUES
(2, 'Kristhan Amir Lope', 'kristhanlope@gmail.com', '092313123123', '2026-04-27', 1),
(3, 'Dave Matthew Laman', 'davelaman@gmail.com', '09192837122', '2026-04-27', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member_status`
--

CREATE TABLE `member_status` (
  `Member_Status_ID` int(11) NOT NULL,
  `Member_Status_Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `member_status`
--

INSERT INTO `member_status` (`Member_Status_ID`, `Member_Status_Name`) VALUES
(1, 'Active'),
(2, 'Restricted');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`Admin_ID`);

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`Author_ID`);

--
-- Indexes for table `bookcopy`
--
ALTER TABLE `bookcopy`
  ADD PRIMARY KEY (`BookCopy_ID`),
  ADD KEY `Book_ID` (`Book_ID`),
  ADD KEY `Book_Status_ID` (`Book_Status_ID`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`Book_ID`),
  ADD KEY `Author_ID` (`Author_ID`),
  ADD KEY `Category_ID` (`Category_ID`);

--
-- Indexes for table `book_status`
--
ALTER TABLE `book_status`
  ADD PRIMARY KEY (`Book_Status_ID`);

--
-- Indexes for table `borrowdetails`
--
ALTER TABLE `borrowdetails`
  ADD PRIMARY KEY (`BorrowDetails_ID`),
  ADD KEY `Borrow_ID` (`Borrow_ID`),
  ADD KEY `BookCopy_ID` (`BookCopy_ID`),
  ADD KEY `Borrow_Status_ID` (`Borrow_Status_ID`);

--
-- Indexes for table `borrowrecord`
--
ALTER TABLE `borrowrecord`
  ADD PRIMARY KEY (`Borrow_ID`),
  ADD KEY `Member_ID` (`Member_ID`);

--
-- Indexes for table `borrow_status`
--
ALTER TABLE `borrow_status`
  ADD PRIMARY KEY (`Borrow_Status_ID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`Category_ID`);

--
-- Indexes for table `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`Fines_ID`),
  ADD KEY `BorrowDetails_ID` (`BorrowDetails_ID`),
  ADD KEY `Fine_Status_ID` (`Fine_Status_ID`);

--
-- Indexes for table `fine_status`
--
ALTER TABLE `fine_status`
  ADD PRIMARY KEY (`Fine_Status_ID`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`Member_ID`),
  ADD KEY `Member_Status_ID` (`Member_Status_ID`);

--
-- Indexes for table `member_status`
--
ALTER TABLE `member_status`
  ADD PRIMARY KEY (`Member_Status_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `Admin_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `Author_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `bookcopy`
--
ALTER TABLE `bookcopy`
  MODIFY `BookCopy_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `Book_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `book_status`
--
ALTER TABLE `book_status`
  MODIFY `Book_Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `borrowdetails`
--
ALTER TABLE `borrowdetails`
  MODIFY `BorrowDetails_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `borrowrecord`
--
ALTER TABLE `borrowrecord`
  MODIFY `Borrow_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `borrow_status`
--
ALTER TABLE `borrow_status`
  MODIFY `Borrow_Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `Category_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `fines`
--
ALTER TABLE `fines`
  MODIFY `Fines_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fine_status`
--
ALTER TABLE `fine_status`
  MODIFY `Fine_Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `member_status`
--
ALTER TABLE `member_status`
  MODIFY `Member_Status_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookcopy`
--
ALTER TABLE `bookcopy`
  ADD CONSTRAINT `bookcopy_ibfk_1` FOREIGN KEY (`Book_ID`) REFERENCES `books` (`Book_ID`),
  ADD CONSTRAINT `bookcopy_ibfk_2` FOREIGN KEY (`Book_Status_ID`) REFERENCES `book_status` (`Book_Status_ID`);

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`Author_ID`) REFERENCES `author` (`Author_ID`),
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`Category_ID`) REFERENCES `category` (`Category_ID`);

--
-- Constraints for table `borrowdetails`
--
ALTER TABLE `borrowdetails`
  ADD CONSTRAINT `borrowdetails_ibfk_1` FOREIGN KEY (`Borrow_ID`) REFERENCES `borrowrecord` (`Borrow_ID`),
  ADD CONSTRAINT `borrowdetails_ibfk_2` FOREIGN KEY (`BookCopy_ID`) REFERENCES `bookcopy` (`BookCopy_ID`),
  ADD CONSTRAINT `borrowdetails_ibfk_3` FOREIGN KEY (`Borrow_Status_ID`) REFERENCES `borrow_status` (`Borrow_Status_ID`);

--
-- Constraints for table `borrowrecord`
--
ALTER TABLE `borrowrecord`
  ADD CONSTRAINT `borrowrecord_ibfk_1` FOREIGN KEY (`Member_ID`) REFERENCES `members` (`Member_ID`);

--
-- Constraints for table `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fines_ibfk_1` FOREIGN KEY (`BorrowDetails_ID`) REFERENCES `borrowdetails` (`BorrowDetails_ID`),
  ADD CONSTRAINT `fines_ibfk_2` FOREIGN KEY (`Fine_Status_ID`) REFERENCES `fine_status` (`Fine_Status_ID`);

--
-- Constraints for table `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_ibfk_1` FOREIGN KEY (`Member_Status_ID`) REFERENCES `member_status` (`Member_Status_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
