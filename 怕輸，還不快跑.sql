

/*
 * 地點(新增）
 * 主鍵：LocationID
 */
CREATE TABLE Location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    LocationName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(50),
    Address VARCHAR(200)
);

/*
工作人員
主鍵：StaffID
Role：確保資料一致性 
*/
CREATE TABLE Staff (
    StaffID VARCHAR(10) PRIMARY KEY,
    StaffName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Role ENUM('管理員', '賽事組', '系統維護') DEFAULT '賽事組'
);

/*
馬拉松賽事
主鍵：EventID
外鍵：LocationID、OrganizerID
*/
CREATE TABLE MarathonEvent (
    EventID VARCHAR(10) PRIMARY KEY,  
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    SignupDeadline DATE NOT NULL,
    LocationID INT NOT NULL,
    OrganizerID VARCHAR(10),
    CONSTRAINT fk_event_location FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
    CONSTRAINT fk_event_organizer FOREIGN KEY (OrganizerID) REFERENCES Staff(StaffID)
);

/*
參賽者
主鍵：RunnerID
*/
CREATE TABLE Runner (
    RunnerID INT PRIMARY KEY,  
    Name VARCHAR(100) NOT NULL,
    Gender ENUM('M', 'F') NOT NULL,
    BirthDate DATE NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    CHECK (Gender IN ('M', 'F'))
);
/*
報名紀錄
主鍵：RegID
外鍵：RunnerID、EventID
*/
CREATE TABLE Registration (
    RegID INT AUTO_INCREMENT PRIMARY KEY,
    RunnerID INT NOT NULL,
    EventID VARCHAR(10) NOT NULL,
    RegTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    SuccessFlag BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (RunnerID) REFERENCES Runner(RunnerID) ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES MarathonEvent(EventID) ON DELETE CASCADE
);

/*
付款方式(增）

主鍵：MethodName
 */
CREATE TABLE PaymentData (
    MethodName VARCHAR(20) PRIMARY KEY
);


/*
付款紀錄(更）
主鍵：PayID
外鍵：RegID
RegID: 對應報名紀錄
PayTime: 付款時間
Method: 信用卡、轉帳、LinePay、現金
Status: 已付款、未付款、處理中
*/
CREATE TABLE Payment (
    PayID INT AUTO_INCREMENT PRIMARY KEY,
    RegID INT NOT NULL,
    PayTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Method VARCHAR(20) NOT NULL,
    Status ENUM('已付款', '未付款', '處理中') DEFAULT '未付款',
    FOREIGN KEY (RegID) REFERENCES Registration(RegID) ON DELETE CASCADE,
    FOREIGN KEY (Method) REFERENCES PaymentData(MethodName)
);

/*
退款處理
*/
CREATE TABLE Refund (
    RefundID INT AUTO_INCREMENT PRIMARY KEY,
    PayID INT NOT NULL,
    RefundTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10,2) NOT NULL,
    Status ENUM('申請中', '已退款', '拒絕退款') DEFAULT '申請中',
    Reason TEXT,
    FOREIGN KEY (PayID) REFERENCES Payment(PayID) ON DELETE CASCADE
);

/*
成績排名（更）
主鍵：ResultID
外鍵：RegID
*/
CREATE TABLE ResultRecord (
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    RegID INT NOT NULL,
    FinishTime TIME,
    Rank INT,
    FOREIGN KEY (RegID) REFERENCES Registration(RegID) ON DELETE CASCADE
);

/*
插入地點資料
 */
 INSERT INTO Location (LocationName, City, Address) VALUES
('台北市政府前', '台北市', '信義路五段123號'),
('淡水河', '新北市', '淡水區'),
('台中洲際棒球場', '台中市', '台中市北區崇德路三段二號'),
('高雄駁二特區', '高雄市', '鹽埕區大勇路1號'),
('花蓮七星潭', '花蓮縣', '花蓮市七星街'),
('冬山河親水公園', '宜蘭縣', '冬山鄉中山路二段'),
('屏東體育場', '屏東縣', '屏東市自由路100號'),
('台南安平古堡', '台南市', '安平區古堡街'),
('新竹市政府前', '新竹市', '東區中華路'),
('阿里山森林遊樂區', '嘉義縣', '阿里山鄉樂野村東阿里山25號');

/*
 工作人員10筆資料
 */
INSERT INTO Staff (StaffID, StaffName, Phone, Role) VALUES
('S101', '張安琪', '0962079792', '管理員'),
('S102', '李信宏', '0958349876', '賽事組'),
('S103', '黃偉哲', '0989765432', '系統維護'),
('S104', '張雅筑', '0977456123', '賽事組'),
('S105', '趙子翔', '0965123789', '管理員'),
('S106', '林淑芬', '0911876543', '賽事組'),
('S107', '吳俊傑', '0989761234', '系統維護'),
('S108', '周怡婷', '0958765432', '賽事組'),
('S109', '許偉民', '0911234987', '管理員'),
('S110', '蔡美芳', '0965123498', '系統維護');

/*
 馬拉松賽事10筆資料
 */
INSERT INTO MarathonEvent (EventID, EventName, EventDate, SignupDeadline, LocationID, OrganizerID) VALUES
('E1001', '海綿寶寶馬拉松', '2025-12-08', '2025-11-01', 1, 'S101'),
('E1002', '淡水跳河馬拉松', '2025-09-15', '2025-08-10', 2, 'S102'),
('E1003', '台中慶記路跑', '2025-11-10', '2025-10-01', 3, 'S103'),
('E1004', '高雄發大財半程馬拉松', '2025-10-20', '2025-09-15', 4, 'S104'),
('E1005', '花蓮太平洋馬拉松', '2025-12-01', '2025-10-20', 5, 'S105'),
('E1006', '宜蘭慈父親子馬拉松', '2025-11-17', '2025-10-05', 6, 'S106'),
('E1007', '屏東熱血馬拉松', '2025-10-06', '2025-09-01', 7, 'S107'),
('E1008', '台南古都馬拉松', '2025-11-24', '2025-10-10', 8, 'S108'),
('E1009', '新竹風城半馬', '2025-09-29', '2025-08-20', 9, 'S109'),
('E1010', '嘉義阿里山登山路跑', '2025-12-15', '2025-11-10', 10, 'S110');

/*
 參賽者30筆資料
 */
INSERT INTO Registration (RunnerID, EventID, RegTime, SuccessFlag) VALUES
(3001, 'E1006', '2025-04-18 09:10:56', TRUE),
(3002, 'E1006', '2025-05-17 19:40:24', TRUE),
(3003, 'E1004', '2025-05-28 17:07:25', TRUE),
(3004, 'E1006', '2025-05-24 00:46:38', FALSE),
(3005, 'E1010', '2025-05-03 00:17:28', TRUE),
(3006, 'E1004', '2025-04-30 12:40:32', TRUE),
(3007, 'E1003', '2025-06-05 06:38:35', FALSE),
(3008, 'E1001', '2025-05-13 21:39:28', TRUE),
(3009, 'E1006', '2025-04-14 08:44:04', FALSE),
(3010, 'E1004', '2025-04-14 13:07:13', FALSE),
(3011, 'E1003', '2025-05-06 22:57:38', TRUE),
(3012, 'E1007', '2025-05-27 16:32:23', TRUE),
(3013, 'E1008', '2025-06-06 15:40:20', TRUE),
(3014, 'E1004', '2025-05-25 07:53:58', FALSE),
(3015, 'E1006', '2025-05-07 09:11:41', FALSE),
(3016, 'E1004', '2025-05-31 17:55:58', TRUE),
(3017, 'E1001', '2025-04-10 10:24:27', TRUE),
(3018, 'E1007', '2025-04-20 01:50:20', FALSE),
(3019, 'E1005', '2025-05-21 11:29:14', TRUE),
(3020, 'E1005', '2025-04-22 15:26:37', FALSE),
(3006, 'E1006', '2025-05-05 07:37:09', TRUE),
(3017, 'E1008', '2025-05-15 03:40:35', FALSE),
(3011, 'E1008', '2025-05-18 19:00:10', TRUE),
(3001, 'E1004', '2025-05-15 04:02:55', FALSE),
(3021, 'E1007', '2025-04-14 00:46:30', TRUE),
(3009, 'E1010', '2025-05-18 12:46:32', TRUE),
(3011, 'E1009', '2025-04-14 14:33:31', TRUE),
(3011, 'E1006', '2025-06-04 00:12:19', FALSE),
(3017, 'E1006', '2025-06-03 04:28:51', FALSE),
(3001, 'E1008', '2025-04-28 12:55:57', FALSE);

/*
 付款方式
 */
INSERT INTO PaymentData (MethodName) VALUES
('信用卡'),
('轉帳'),
('LinePay'),
('現金');

/*
付款紀錄
 */
 INSERT INTO Payment (RegID, PayTime, Method, Status) VALUES
(1, '2025-05-27 05:48:49', '轉帳', '已付款'),
(2, '2025-06-05 11:59:40', '現金', '未付款'),
(3, '2025-05-23 15:41:18', '轉帳', '未付款'),
(4, '2025-05-13 05:06:49', 'LinePay', '已付款'),
(5, '2025-05-28 09:34:19', '信用卡', '已付款'),
(6, '2025-06-03 02:56:35', '轉帳', '已付款'),
(7, '2025-05-31 12:08:38', 'LinePay', '已付款'),
(8, '2025-06-05 08:04:22', '現金', '未付款'),
(9, '2025-05-23 05:20:28', '現金', '未付款'),
(10, '2025-06-08 07:21:35', '轉帳', '未付款'),
(11, '2025-05-15 09:52:04', 'LinePay', '已付款'),
(12, '2025-05-15 21:20:48', 'LinePay', '已付款'),
(13, '2025-05-14 08:05:06', '轉帳', '未付款'),
(14, '2025-05-28 18:22:26', '轉帳', '處理中'),
(15, '2025-05-27 18:15:02', '轉帳', '已付款'),
(16, '2025-05-26 02:30:21', '轉帳', '處理中'),
(17, '2025-06-05 17:21:51', '信用卡', '已付款'),
(18, '2025-05-27 09:24:19', '轉帳', '未付款'),
(19, '2025-05-16 15:31:36', '現金', '已付款'),
(20, '2025-05-19 07:21:44', '轉帳', '已付款'),
(21, '2025-06-07 21:21:47', '信用卡', '處理中'),
(22, '2025-06-03 08:36:49', '信用卡', '未付款'),
(23, '2025-05-29 03:05:34', '轉帳', '已付款'),
(24, '2025-06-02 22:04:33', '現金', '已付款'),
(25, '2025-05-11 14:20:36', '轉帳', '處理中'),
(26, '2025-05-11 20:13:31', '信用卡', '已付款'),
(27, '2025-05-11 12:46:52', '現金', '未付款'),
(28, '2025-05-16 07:06:07', 'LinePay', '處理中'),
(29, '2025-05-25 19:27:48', '現金', '未付款'),
(30, '2025-06-01 15:23:41', '現金', '處理中');

/*
 退款處理狀態
 */
INSERT INTO Refund (PayID, RefundTime, Amount, Status, Reason) VALUES
(1, '2025-06-01 10:15:00', 1000.00, '申請中', '臨時有事無法參賽'),
(2, '2025-06-02 11:30:00', 1200.00, '已退款', '身體不適提出申請'),

/*
成績排名
 */
INSERT INTO ResultRecord (RegID, FinishTime, Rank) VALUES
(1, '05:57:10', 96),
(2, '05:28:16', 97),
(3, '03:53:40', 36),
(4, '06:31:40', 31),
(5, '04:28:04', 92),
(6, '04:15:17', 43),
(7, '04:57:34', 11),
(8, '03:09:14', 50),
(9, '03:45:13', 9),
(10, '05:26:21', 70),
(11, '05:26:03', 27),
(12, '05:24:57', 99),
(13, '06:44:01', 98),
(14, '06:24:30', 1),
(15, '04:19:48', 50),
(16, '05:34:47', 95),
(17, '06:51:38', 29),
(18, '05:14:17', 56),
(19, '05:01:24', 44),
(20, '05:46:10', 60),
(21, '03:39:34', 4),
(22, '05:37:36', 85),
(23, '02:05:41', 55),
(24, '03:55:29', 24),
(25, '02:16:24', 42),
(26, '03:29:20', 44),
(27, '05:17:48', 54),
(28, '04:53:05', 61),
(29, '02:47:34', 7),
(30, '04:14:41', 9);

/*
索引建立

名次查詢索引
 */
 CREATE INDEX idx_rank ON ResultRecord(Rank);

/*
 利用索引查詢成績按照名次
 */
 SELECT ResultID, RegID, FinishTime, Rank
FROM ResultRecord
ORDER BY Rank ASC;

/*
付款狀態索引
 */
 CREATE INDEX idx_payment_status_method ON Payment(Status, Method);

/*
 利用索引查詢付款狀態
 */
SELECT *
FROM Payment
WHERE Status = '未付款';

/*
 增加地點索引
說明：分別為City、LocationName增加索引以便之後查詢
*/
CREATE INDEX idx_location_city ON Location(City);

CREATE INDEX idx_location_name ON Location(LocationName);

/*
  利用索引查詢地點
 */
SELECT E.EventName, L.LocationName, L.City
FROM MarathonEvent E
JOIN Location L ON E.LocationID = L.LocationID
WHERE L.City = '台北市';

/*
交易 (Transaction) 機制

COMMIT
 */
START TRANSACTION;


INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (3030, 'E1001', TRUE);

SET @lastRegID = LAST_INSERT_ID();

INSERT INTO Payment (RegID, Method, Status)
VALUES (@lastRegID, '信用卡', '已付款');

COMMIT;

/*
 ROLLBACK
 */
START TRANSACTION;

-- 故意輸入錯誤的外鍵值（觸發錯誤）
INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (9999, 'E1001', TRUE);  -- RunnerID 不存在

-- 此行會因前面錯誤而不執行
INSERT INTO Payment (RegID, Method, Status)
VALUES (LAST_INSERT_ID(), '信用卡', '已付款');

-- 回滾所有變更
ROLLBACK;

/*
進階SQL功能應用
複雜查詢與子查詢：聚合函數、GROUP BY、HAVING、視圖 (View)。
1. 聚合函數 + GROUP BY：每場賽事報名人數統計
*/
SELECT 
    E.EventName,
    COUNT(R.RegID) AS TotalRegistrations
FROM 
    MarathonEvent E
JOIN 
    Registration R ON E.EventID = R.EventID
GROUP BY 
    E.EventName;

 /*
   加上 HAVING 條件：只顯示報名超過 3 人的賽事
*/
 SELECT 
    E.EventName,
    COUNT(R.RegID) AS TotalRegistrations
FROM 
    MarathonEvent E
JOIN 
    Registration R ON E.EventID = R.EventID
GROUP BY 
    E.EventName
HAVING 
    COUNT(R.RegID) > 3;

   /*
    子查詢：查詢所有有付款成功的跑者資訊
    */
   SELECT *
FROM Runner
WHERE RunnerID IN (
    SELECT RunnerID
    FROM Registration
    WHERE RegID IN (
        SELECT RegID
        FROM Payment
        WHERE Status = '已付款'
    )
);

/*
 子查詢 + 聚合：找出報名最多人的賽事名稱
 */
SELECT EventName
FROM MarathonEvent
WHERE EventID = (
    SELECT EventID
    FROM Registration
    GROUP BY EventID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

/*
 視圖（View）：建立一個報名成功並完成付款的總覽視圖
*/
CREATE VIEW v_RegistrationSummary AS
SELECT 
    R.RegID,
    Ru.Name AS RunnerName,
    E.EventName,
    R.RegTime,
    P.Method,
    P.Status
FROM Registration R
JOIN Runner Ru ON R.RunnerID = Ru.RunnerID
JOIN MarathonEvent E ON R.EventID = E.EventID
LEFT JOIN Payment P ON R.RegID = P.RegID
WHERE R.SuccessFlag = TRUE;

SELECT * FROM v_RegistrationSummary;

/*
 Stored Procedure / Function：實作商業邏輯或報表計算。
 
1. Stored Procedure：查詢某賽事的付款狀況報表
 */
CREATE PROCEDURE GetPaymentSummaryByEvent(IN inputEventName VARCHAR(100))
BEGIN
    SELECT 
        E.EventName,
        P.Status,
        P.Method,
        COUNT(*) AS TotalCount
    FROM MarathonEvent E
    JOIN Registration R ON E.EventID = R.EventID
    JOIN Payment P ON R.RegID = P.RegID
    WHERE E.EventName = inputEventName
    GROUP BY P.Status, P.Method;
END;

CALL GetPaymentSummaryByEvent('高雄發大財半程馬拉松');


/*
  Function：計算單一跑者的成功報名次數
*/
CREATE FUNCTION CountSuccessfulRegistrations(runner_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM Registration
    WHERE RunnerID = runner_id AND SuccessFlag = TRUE;

    RETURN total;
END;

SELECT 
    RunnerID,
    Name,
    CountSuccessfulRegistrations(RunnerID) AS SuccessCount
FROM Runner
ORDER BY SuccessCount DESC;


/*
 Stored Procedure：依賽事統計 FinishTime 的平均與最短時間
 */
CREATE PROCEDURE GetEventFinishStats(IN inputEventName VARCHAR(100))
BEGIN
    SELECT 
        E.EventName,
        SEC_TO_TIME(AVG(TIME_TO_SEC(RR.FinishTime))) AS AvgFinishTime,
        MIN(RR.FinishTime) AS BestFinishTime
    FROM MarathonEvent E
    JOIN Registration R ON E.EventID = R.EventID
    JOIN ResultRecord RR ON R.RegID = RR.RegID
    WHERE E.EventName = inputEventName
    GROUP BY E.EventName;
END;

CALL GetEventFinishStats('海綿寶寶馬拉松');

/*
 Trigger：自動處理插入、更新、刪除事件
 
1.防止重複報名
 */
DELIMITER $$

CREATE TRIGGER trg_prevent_duplicate_registration
BEFORE INSERT ON Registration
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM Registration
    WHERE RunnerID = NEW.RunnerID AND EventID = NEW.EventID
  ) THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = '該參賽者已報名此賽事，無法重複報名';
  END IF;
END$$

DELIMITER ;

/*
報名取消就自動把付款狀態設為已退款
-檢查是否有「已付款」付款紀錄
-將付款狀態直接改為「已退款」
-插入 Refund 紀錄，狀態為「已退款」
*/

DELIMITER $$

CREATE TRIGGER trg_cancel_and_refund_immediate
AFTER UPDATE ON Registration
FOR EACH ROW
BEGIN
  IF NEW.IsCanceled = TRUE AND OLD.IsCanceled = FALSE THEN
    IF EXISTS (
      SELECT 1
      FROM Payment
      WHERE RegID = NEW.RegID AND Status = '已付款'
    ) THEN

      UPDATE Payment
      SET Status = '已退款'
      WHERE RegID = NEW.RegID AND Status = '已付款';

      INSERT INTO Refund (PayID, Status, Reason)
      SELECT PayID, '已退款', '使用者取消報名'
      FROM Payment
      WHERE RegID = NEW.RegID AND Status = '已退款';

    END IF;

  END IF;
END $$

DELIMITER ;


/*
功能查詢清單：設計並附上 SQL 與執行結果。

1. 報名成功次數最多的跑者
說明： 使用自定義的 Function 計算跑者成功報名次數，排序找出最多的。
*/
SELECT 
    RunnerID, Name,
    CountSuccessfulRegistrations(RunnerID) AS SuccessCount
FROM Runner
ORDER BY SuccessCount DESC;

/*
 2. 各賽事報名總數
說明： GROUP BY 搭配 COUNT，用於統計每場賽事的報名人數。
 */
SELECT 
    E.EventName,
    COUNT(R.RegID) AS TotalRegistrations
FROM 
    MarathonEvent E
JOIN 
    Registration R ON E.EventID = R.EventID
GROUP BY 
    E.EventName;

/*
   3. 超過 3 人報名的賽事
說明: 加入 HAVING 篩選報名超過三人的賽事。
   */
 SELECT 
    E.EventName,
    COUNT(R.RegID) AS TotalRegistrations
FROM 
    MarathonEvent E
JOIN 
    Registration R ON E.EventID = R.EventID
GROUP BY 
    E.EventName
HAVING 
    COUNT(R.RegID) > 3;

   /*
   4. 跑者成功付款過的紀錄
說明： 巢狀子查詢，篩選成功付款的跑者名單。
   */
   
   SELECT *
FROM Runner
WHERE RunnerID IN (
    SELECT RunnerID
    FROM Registration
    WHERE RegID IN (
        SELECT RegID
        FROM Payment
        WHERE Status = '已付款'
    )
);

/*
5. 最多人報名的賽事
說明: 找出報名人數最多的賽事。
*/
SELECT EventName
FROM MarathonEvent
WHERE EventID = (
    SELECT EventID
    FROM Registration
    GROUP BY EventID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

/*
 6. 賽事付款狀況報表
說明: 使用 Stored Procedure 依賽事名稱統計付款狀況（Method + Status + 總數）。
*/

CALL GetPaymentSummaryByEvent('高雄發大財半程馬拉松');


/*
7. 賽事平均與最短完賽時間
說明: 查詢某賽事的平均與最短 FinishTime。
*/

CALL GetEventFinishStats('海綿寶寶馬拉松');

/*
 8. 建立檢視表查詢成功報名者摘要
說明: 從檢視表 v_RegistrationSummary 查詢所有成功報名者的基本資料與付款資訊。
 */

SELECT * FROM v_RegistrationSummary;

/*
9. 查詢指定城市的所有賽事資訊
說明： 針對城市篩選賽事，利用已建索引加速查詢。
*/

SELECT E.EventName, L.LocationName, L.City
FROM MarathonEvent E
JOIN Location L ON E.LocationID = L.LocationID
WHERE L.City = '台北市';


/*
 10. 查詢付款狀態為未付款的紀錄
說明: 查詢所有付款狀態為「未付款」的紀錄，使用複合索引。
*/
SELECT *
FROM Payment
WHERE Status = '未付款';

/*
11. 查詢成績排行榜
說明： 由 Rank 排序的成績列表。
*/
SELECT 
    RR.ResultID,
    R.RegID,
    Ru.Name AS RunnerName,
    E.EventName,
    R.RegTime,
    RR.FinishTime,
    RR.Rank
FROM ResultRecord RR
JOIN Registration R ON RR.RegID = R.RegID
JOIN Runner Ru ON R.RunnerID = Ru.RunnerID
JOIN MarathonEvent E ON R.EventID = E.EventID
ORDER BY RR.Rank ASC;

/*
12. 測試交易提交與回滾機制

成功插入交易 + COMMIT
*/
START TRANSACTION;
INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (3030, 'E1001', TRUE);
SET @lastRegID = LAST_INSERT_ID();
INSERT INTO Payment (RegID, Method, Status)
VALUES (@lastRegID, '信用卡', '已付款');
COMMIT;

/*
失敗插入測試 + ROLLBACK
*/
START TRANSACTION;
INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (9999, 'E1001', TRUE);  -- 無效 RunnerID
INSERT INTO Payment (RegID, Method, Status)
VALUES (LAST_INSERT_ID(), '信用卡', '已付款');
ROLLBACK;

/*
資料一致性與異常情況測試：外鍵約束、Transaction Rollback。
目標： 測試當 Registration 或 Payment 插入的資料違反外鍵限制時，是否會阻止插入。

一、外鍵約束測試：確認外部資料一致性

測試1:插入不存在的 RunnerID
*/
-- RunnerID = 9999 並不存在，應觸發外鍵錯誤
START TRANSACTION;

INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (9999, 'E1001', TRUE);  -- 錯誤：外鍵衝突

-- 如果第一行失敗，這一行也不會執行
INSERT INTO Payment (RegID, Method, Status)
VALUES (LAST_INSERT_ID(), '信用卡', '已付款');

ROLLBACK;

/*
測試2:插入不存在的 Payment Method
*/

-- 嘗試插入不存在的付款方式
START TRANSACTION;

INSERT INTO Payment (RegID, Method, Status)
VALUES (1, '比特幣', '已付款');  -- 錯誤：外鍵衝突

ROLLBACK;

/*
二、Transaction Rollback 測試：一連串操作失敗後全部撤銷
目標： 模擬系統錯誤或輸入錯誤時的回滾操作，確保不會留下不一致資料。

測試3：多筆操作中的一筆失敗，導致整個回滾
*/

START TRANSACTION;

-- 正確插入
INSERT INTO Registration (RunnerID, EventID, SuccessFlag)
VALUES (3030, 'E1001', TRUE);

-- 錯誤插入：付款方式錯誤
INSERT INTO Payment (RegID, Method, Status)
VALUES (LAST_INSERT_ID(), 'PayPal', '已付款');  -- 'PayPal' 不存在

-- 因上方發生錯誤，這邊不會提交
COMMIT;

/*
三、實作結果驗證

檢查 Registration 是否插入失敗
*/
SELECT *
FROM Registration
WHERE RunnerID = 3030 AND EventID = 'E1001'
ORDER BY RegTime DESC
LIMIT 5;

/*
檢查 Payment 是否插入失敗
*/
SELECT *
FROM Payment
WHERE Method = 'PayPal';

/*
效能測試：比較索引前後查詢時間。
一、測試目標
透過查詢 Payment 資料表中的 Status = '未付款' 紀錄：

比較「有無索引」時的查詢時間差異。
使用 EXPLAIN 與 SHOW PROFILE 工具檢視執行計畫與時間成本。
二、測試步驟

取消索引（移除複合索引）
*/

DROP INDEX idx_payment_status_method ON Payment;

/*
執行查詢（無索引狀況）
*/
-- 開啟執行分析
SET profiling = 1;

-- 查詢未付款紀錄
SELECT * FROM Payment
WHERE Status = '未付款';

-- 查看查詢時間
SHOW PROFILES;

/*
建立複合索引
*/
CREATE INDEX idx_payment_status_method ON Payment(Status, Method);

/*
執行查詢（有索引狀況）
*/
-- 開啟執行分析
SET profiling = 1;

-- 相同查詢再次執行
SELECT * FROM Payment
WHERE Status = '未付款';

-- 查看查詢時間
SHOW PROFILES;

/*
額外工具：使用 EXPLAIN 分析查詢計畫
*/
EXPLAIN SELECT * FROM Payment WHERE Status = '未付款';
