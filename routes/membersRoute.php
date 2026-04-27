<?php
require_once '../database/db.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$action = $_GET['action'] ?? '';

switch ($action) {
    case 'getActiveMembers':
         try {
        $stmt = $pdo->prepare("
            SELECT Member_ID, Member_Name, Member_Status_ID
            FROM members
            WHERE Member_Status_ID = 1
            ORDER BY Member_Name ASC
        ");
        $stmt->execute();

        $membersActive = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "status" => "success",
            "data" => $membersActive
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }

    break;
    
case 'getAllMembers':

    try {


        $stmt = $pdo->prepare("
            UPDATE borrowdetails bd
            INNER JOIN borrowrecord br 
                ON bd.Borrow_ID = br.Borrow_ID
            SET bd.Borrow_Status_ID = 3
            WHERE 
                bd.Borrow_Status_ID = 1
                AND bd.Return_Date IS NULL
                AND br.Due_Date < CURDATE()
        ");
        $stmt->execute();



        $stmt = $pdo->prepare("
            SELECT 
                bd.BorrowDetails_ID,
                DATEDIFF(CURDATE(), br.Due_Date) AS overdue_days
            FROM borrowdetails bd
            INNER JOIN borrowrecord br 
                ON bd.Borrow_ID = br.Borrow_ID
            WHERE 
                bd.Borrow_Status_ID IN (1, 3)
                AND bd.Return_Date IS NULL
                AND br.Due_Date < CURDATE()
        ");
        $stmt->execute();
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($rows as $row) {

            $id   = $row['BorrowDetails_ID'];
            $days = (int)$row['overdue_days'];

            if ($days <= 0) continue;

            $fine = $days * 5;

            $check = $pdo->prepare("
                SELECT Fines_ID, Fine_Status_ID 
                FROM fines 
                WHERE BorrowDetails_ID = ?
            ");
            $check->execute([$id]);
            $existing = $check->fetch(PDO::FETCH_ASSOC);

            if ($existing) {

                if ((int)$existing['Fine_Status_ID'] === 1) {

                    $update = $pdo->prepare("
                        UPDATE fines
                        SET Fine_Amount = ?, Issued_Date = CURDATE()
                        WHERE BorrowDetails_ID = ?
                    ");
                    $update->execute([$fine, $id]);
                }

            } else {

                $insert = $pdo->prepare("
                    INSERT INTO fines 
                    (BorrowDetails_ID, Fine_Amount, Fine_Status_ID, Issued_Date, Paid_Date)
                    VALUES (?, ?, 1, CURDATE(), NULL)
                ");
                $insert->execute([$id, $fine]);
            }
        }



        $stmt = $pdo->prepare("
            SELECT 
                m.Member_ID,
                m.Member_Name,
                m.Email,
                m.Contact_Number,
                m.Date_Joined,
                m.Member_Status_ID,
                ms.Member_Status_Name,

                -- 📚 COUNT BORROWED + OVERDUE (NOT RETURNED)
                (
                    SELECT COUNT(*)
                    FROM borrowdetails bd
                    INNER JOIN borrowrecord br 
                        ON bd.Borrow_ID = br.Borrow_ID
                    WHERE 
                        br.Member_ID = m.Member_ID
                        AND bd.Borrow_Status_ID IN (1, 3)
                        AND bd.Return_Date IS NULL
                ) AS Books_Out

            FROM members m
            INNER JOIN member_status ms 
                ON m.Member_Status_ID = ms.Member_Status_ID

            ORDER BY m.Member_Name ASC
        ");

        $stmt->execute();
        $membersAll = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            "status" => "success",
            "data" => $membersAll
        ]);
        exit;

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
        exit;
    }

break;
case 'getMemberFines':

    $memberId = $_GET['Member_ID'] ?? null;

    if (!$memberId) {
        echo json_encode(["status" => "error", "message" => "Missing Member_ID"]);
        exit;
    }

    $stmt = $pdo->prepare("
        SELECT 
            f.*,
            b.Book_Title
        FROM fines f
        JOIN borrowdetails bd ON f.BorrowDetails_ID = bd.BorrowDetails_ID
        JOIN borrowrecord br ON bd.Borrow_ID = br.Borrow_ID
        JOIN bookcopy bc ON bd.BookCopy_ID = bc.BookCopy_ID
        JOIN books b ON bc.Book_ID = b.Book_ID
        WHERE br.Member_ID = ?
        ORDER BY f.Issued_Date DESC
    ");

    $stmt->execute([$memberId]);

    echo json_encode([
        "status" => "success",
        "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)
    ]);

break;
//         case 'getAllMembers':
//     try {
//         $stmt = $pdo->prepare("
//             SELECT 
//                 m.Member_ID,
//                 m.Member_Name,
//                 m.Email,
//                 m.Contact_Number,
//                 m.Date_Joined,
//                 m.Member_Status_ID, 
//                 ms.Member_Status_Name,

//                 -- ✅ COUNT BOOKS OUT
//                 COUNT(bd.BorrowDetails_ID) AS Books_Out

//             FROM members m

//             LEFT JOIN member_status ms 
//                 ON m.Member_Status_ID = ms.Member_Status_ID

//             LEFT JOIN borrowrecord br 
//                 ON m.Member_ID = br.Member_ID

//             LEFT JOIN borrowdetails bd 
//                 ON br.Borrow_ID = bd.Borrow_ID
//                 AND bd.Borrow_Status_ID != 2

//             GROUP BY m.Member_ID

//             ORDER BY m.Member_Name ASC
//         ");

//         $stmt->execute();

//         $membersAll = $stmt->fetchAll(PDO::FETCH_ASSOC);

//         echo json_encode([
//             "status" => "success",
//             "data" => $membersAll
//         ]);

//     } catch (PDOException $e) {
//         echo json_encode([
//             "status" => "error",
//             "message" => $e->getMessage()
//         ]);
//     }
// break;
case 'getMemberBorrowed':

    $memberId = $_GET['Member_ID'] ?? null;

    if (!$memberId) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing Member ID"
        ]);
        exit;
    }

    try {

        $stmt = $pdo->prepare("
            SELECT 
                bc.BookCopy_ID,
                b.Book_Title,
                a.Author_Name,
                c.Category_Name,
                br.Borrow_Date,
                br.Due_Date,
                bd.Borrow_Status_ID
            FROM borrowdetails bd
            JOIN borrowrecord br ON bd.Borrow_ID = br.Borrow_ID
            JOIN bookcopy bc ON bd.BookCopy_ID = bc.BookCopy_ID
            JOIN books b ON bc.Book_ID = b.Book_ID
            JOIN author a ON b.Author_ID = a.Author_ID
            JOIN category c ON b.Category_ID = c.Category_ID
            WHERE br.Member_ID = ?
            AND bd.Borrow_Status_ID != 2
            ORDER BY br.Borrow_Date DESC
        ");

        $stmt->execute([$memberId]);

        echo json_encode([
            "status" => "success",
            "data" => $stmt->fetchAll(PDO::FETCH_ASSOC)
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }

break;
case 'toggleStatus':

    $memberId = $data['Member_ID'] ?? null;
    $statusId = $data['Member_Status_ID'] ?? null;

    if (!$memberId || !$statusId) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing fields",
            "debug" => $data
        ]);
        exit;
    }

    try {

        $check = $pdo->prepare("SELECT * FROM members WHERE Member_ID = ?");
        $check->execute([$memberId]);
        $member = $check->fetch(PDO::FETCH_ASSOC);

        if (!$member) {
            echo json_encode([
                "status" => "error",
                "message" => "Member not found",
                "debug" => ["Member_ID" => $memberId]
            ]);
            exit;
        }

        $stmt = $pdo->prepare("
            UPDATE members
            SET Member_Status_ID = ?
            WHERE Member_ID = ?
        ");
        $stmt->execute([$statusId, $memberId]);

        $rows = $stmt->rowCount();

        echo json_encode([
            "status" => "success",
            "message" => "Member status Updated successfully",
            "debug" => [
                "Member_ID" => $memberId,
                "Old_Status" => $member['Member_Status_ID'],
                "New_Status" => $statusId
            ]
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }

break;
case 'addMember':

    $name    = $data['Member_Name'] ?? '';
    $email   = $data['Email'] ?? '';
    $contact = $data['Contact_Number'] ?? '';

    if (!$name) {
        echo json_encode([
            "status" => "error",
            "message" => "Name is required"
        ]);
        exit;
    }

    if (!$email && !$contact) {
        echo json_encode([
            "status" => "error",
            "message" => "Provide at least Email or Contact Number"
        ]);
        exit;
    }

    try {

        if ($email) {
            $stmt = $pdo->prepare("SELECT Member_ID FROM members WHERE Email = ?");
            $stmt->execute([$email]);

            if ($stmt->fetch()) {
                echo json_encode([
                    "status" => "error",
                    "message" => "Email already exists"
                ]);
                exit;
            }
        }

        if ($contact) {
            $stmt = $pdo->prepare("SELECT Member_ID FROM members WHERE Contact_Number = ?");
            $stmt->execute([$contact]);

            if ($stmt->fetch()) {
                echo json_encode([
                    "status" => "error",
                    "message" => "Contact number already exists"
                ]);
                exit;
            }
        }

        $stmt = $pdo->prepare("
            INSERT INTO members (Member_Name, Email, Contact_Number, Member_Status_ID, Date_Joined)
            VALUES (?, ?, ?, 1, NOW())
        ");

        $stmt->execute([$name, $email, $contact]);

        echo json_encode([
            "status" => "success",
            "message" => "Member added successfully"
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }

break;

case 'updateMember':

    $data = json_decode(file_get_contents("php://input"), true);

    $id      = $data['Member_ID'] ?? null;
    $name    = trim($data['Member_Name'] ?? '');
    $email   = trim($data['Email'] ?? '');
    $contact = trim($data['Contact_Number'] ?? '');

    if (!$id || !$name) {
        echo json_encode([
            "status" => "error",
            "message" => "Name is required"
        ]);
        exit;
    }

    if (!$email && !$contact) {
        echo json_encode([
            "status" => "error",
            "message" => "Provide Email or Contact Number"
        ]);
        exit;
    }

    try {

        if ($email) {
            $stmt = $pdo->prepare("
                SELECT Member_ID FROM members 
                WHERE Email = ? AND Member_ID != ?
            ");
            $stmt->execute([$email, $id]);

            if ($stmt->fetch()) {
                echo json_encode([
                    "status" => "error",
                    "message" => "Email already exists"
                ]);
                exit;
            }
        }

        if ($contact) {
            $stmt = $pdo->prepare("
                SELECT Member_ID FROM members 
                WHERE Contact_Number = ? AND Member_ID != ?
            ");
            $stmt->execute([$contact, $id]);

            if ($stmt->fetch()) {
                echo json_encode([
                    "status" => "error",
                    "message" => "Contact number already exists"
                ]);
                exit;
            }
        }

        $stmt = $pdo->prepare("
            UPDATE members
            SET 
                Member_Name = ?,
                Email = ?,
                Contact_Number = ?
            WHERE Member_ID = ?
        ");

        $stmt->execute([$name, $email, $contact, $id]);

        echo json_encode([
            "status" => "success",
            "message" => "Member updated successfully"
        ]);
        exit;

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
        exit;
    }

break;

case 'deleteMember':

    $memberId = $data['Member_ID'] ?? null;

    if (!$memberId) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing Member ID"
        ]);
        exit;
    }

    try {

        $stmt = $pdo->prepare("
            SELECT COUNT(*) as total
            FROM borrowdetails bd
            JOIN borrowrecord br ON bd.Borrow_ID = br.Borrow_ID
            WHERE br.Member_ID = ?
            AND bd.Borrow_Status_ID != 2
        ");
        $stmt->execute([$memberId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row['total'] > 0) {
            echo json_encode([
                "status" => "error",
                "message" => "Member has borrowed books"
            ]);
            exit;
        }

        $stmt = $pdo->prepare("DELETE FROM members WHERE Member_ID = ?");
        $stmt->execute([$memberId]);

        echo json_encode([
            "status" => "success",
            "message" => "Member removed successfully"
        ]);

    } catch (PDOException $e) {
        echo json_encode([
            "status" => "error",
            "message" => $e->getMessage()
        ]);
    }

break;
}

?>