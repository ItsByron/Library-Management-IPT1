<?php
require_once '../database/db.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

$data = json_decode(file_get_contents("php://input"), true);
$action = $_GET['action'] ?? '';

switch ($action) {
case 'payFine':

    $data = json_decode(file_get_contents("php://input"), true);
    $fineId = $data['Fines_ID'] ?? null;

    if (!$fineId) {
        echo json_encode([
            "status" => "error",
            "message" => "Missing Fines_ID"
        ]);
        exit;
    }

    try {

        $stmt = $pdo->prepare("
            SELECT 
                bd.Return_Date,
                bd.Borrow_Status_ID
            FROM fines f
            JOIN borrowdetails bd ON f.BorrowDetails_ID = bd.BorrowDetails_ID
            WHERE f.Fines_ID = ?
        ");
        $stmt->execute([$fineId]);
        $checkReturn = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$checkReturn) {
            echo json_encode([
                "status" => "error",
                "message" => "Invalid fine record"
            ]);
            exit;
        }

        if ($checkReturn['Borrow_Status_ID'] != 2 || !$checkReturn['Return_Date']) {
            echo json_encode([
                "status" => "error",
                "message" => "Book must be returned before paying fine"
            ]);
            exit;
        }

        $stmt = $pdo->prepare("
            UPDATE fines
            SET 
                Fine_Status_ID = 2,
                Paid_Date = CURDATE()
            WHERE Fines_ID = ?
        ");
        $stmt->execute([$fineId]);

        $stmt = $pdo->prepare("
            SELECT br.Member_ID
            FROM fines f
            JOIN borrowdetails bd ON f.BorrowDetails_ID = bd.BorrowDetails_ID
            JOIN borrowrecord br ON bd.Borrow_ID = br.Borrow_ID
            WHERE f.Fines_ID = ?
        ");
        $stmt->execute([$fineId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row) {
            $memberId = $row['Member_ID'];

            $stmt = $pdo->prepare("
                SELECT COUNT(*) as unpaid
                FROM fines f
                JOIN borrowdetails bd ON f.BorrowDetails_ID = bd.BorrowDetails_ID
                JOIN borrowrecord br ON bd.Borrow_ID = br.Borrow_ID
                WHERE br.Member_ID = ?
                AND f.Fine_Status_ID = 1
            ");
            $stmt->execute([$memberId]);
            $check = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($check['unpaid'] == 0) {
                $stmt = $pdo->prepare("
                    UPDATE members
                    SET Member_Status_ID = 1
                    WHERE Member_ID = ?
                ");
                $stmt->execute([$memberId]);
            }
        }

        echo json_encode([
            "status" => "success",
            "message" => "Fine paid successfully"
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
}

?>