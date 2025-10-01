-- DROP TABLES IF THEY EXIST
DROP TABLE IF EXISTS ATTACHMENT;
DROP TABLE IF EXISTS TICKET;
DROP TABLE IF EXISTS SUBCATEGORY;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS INCIDENTORIGIN;
DROP TABLE IF EXISTS PRIORITY;
DROP TABLE IF EXISTS STATUS;
DROP TABLE IF EXISTS USERSGROUP;
DROP TABLE IF EXISTS GROUPS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS DEPARTMENT;
DROP TABLE IF EXISTS ROLES;

-- ========================================
-- CREATE TABLES
-- ========================================

CREATE TABLE ROLES (
    ROLE_ID VARCHAR(10) PRIMARY KEY,
    ROLE_TYP VARCHAR(25),
    ROLE_PERM VARCHAR(50)
);

CREATE TABLE DEPARTMENT (
    DPT_ID VARCHAR(10) PRIMARY KEY,
    DPT_NAME VARCHAR(50)
);

CREATE TABLE USERS (
    USER_ID VARCHAR(10) PRIMARY KEY,
    USER_FST_NAME VARCHAR(50),
    USER_LST_NAME VARCHAR(50),
    USER_EML VARCHAR(50) UNIQUE,
    USER_PHONE VARCHAR(20),
    DPT_ID VARCHAR(10),
    ROLE_ID VARCHAR(10),
    USER_PWD NVARCHAR(100) NOT NULL DEFAULT 'changeme123',
    FOREIGN KEY (DPT_ID) REFERENCES DEPARTMENT(DPT_ID),
    FOREIGN KEY (ROLE_ID) REFERENCES ROLES(ROLE_ID)
);

CREATE TABLE GROUPS (
    GRP_ID VARCHAR(5) PRIMARY KEY,
    GRP_NAME VARCHAR(50)
);

CREATE TABLE USERSGROUP (
    USER_ID VARCHAR(10),
    GRP_ID VARCHAR(5),
    PRIMARY KEY (USER_ID, GRP_ID),
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (GRP_ID) REFERENCES GROUPS(GRP_ID)
);

CREATE TABLE STATUS (
    STS_ID VARCHAR(5) PRIMARY KEY,
    STS_TYP VARCHAR(20)
);

CREATE TABLE PRIORITY (
    PRI_ID VARCHAR(5) PRIMARY KEY,
    PRI_TYP VARCHAR(20)
);

CREATE TABLE INCIDENTORIGIN (
    INC_ORI_ID VARCHAR(5) PRIMARY KEY,
    INC_ORI_TYP VARCHAR(20)
);

CREATE TABLE CATEGORY (
    CAT_ID VARCHAR(5) PRIMARY KEY,
    CAT_NAME VARCHAR(40)
);

CREATE TABLE SUBCATEGORY (
    SUB_CAT_ID VARCHAR(6) PRIMARY KEY,
    SUB_CAT_NAME VARCHAR(40),
    CAT_ID VARCHAR(5),
    FOREIGN KEY (CAT_ID) REFERENCES CATEGORY(CAT_ID)
);

CREATE TABLE TICKET (
    TKT_ID VARCHAR(5) PRIMARY KEY,
    TKT_SUBJ VARCHAR(50),
    TKT_DES VARCHAR(200),
    STS_ID VARCHAR(5),
    PRI_ID VARCHAR(5),
    INC_ORI_ID VARCHAR(5),
    CAT_ID VARCHAR(5),
    SUB_CAT_ID VARCHAR(6),
    ASS_TO_USER_ID VARCHAR(10),
    REQ_BY_USER_ID VARCHAR(10),
    CRD_DATE DATE,
    RES_DATE DATE,
    FOREIGN KEY (STS_ID) REFERENCES STATUS(STS_ID),
    FOREIGN KEY (PRI_ID) REFERENCES PRIORITY(PRI_ID),
    FOREIGN KEY (INC_ORI_ID) REFERENCES INCIDENTORIGIN(INC_ORI_ID),
    FOREIGN KEY (CAT_ID) REFERENCES CATEGORY(CAT_ID),
    FOREIGN KEY (SUB_CAT_ID) REFERENCES SUBCATEGORY(SUB_CAT_ID),
    FOREIGN KEY (ASS_TO_USER_ID) REFERENCES USERS(USER_ID),
    FOREIGN KEY (REQ_BY_USER_ID) REFERENCES USERS(USER_ID),
    CHECK (CRD_DATE <= RES_DATE)
);

CREATE TABLE ATTACHMENT (
    ATT_ID CHAR(5) PRIMARY KEY,
    TKT_ID VARCHAR(5),
    ATT_FILE_NAME VARCHAR(50),
    ATT_FILE_TYP CHAR(5),
    ATT_UPL_DATE DATE,
    FOREIGN KEY (TKT_ID) REFERENCES TICKET(TKT_ID)
);

-- ========================================
-- INSERT SEED DATA
-- ========================================

-- 1. ROLES
INSERT INTO ROLES VALUES
('R1', 'Admin', 'Full Access'),
('R2', 'User', 'View Only'),
('R3', 'Support', 'Ticket Management');

-- 2. DEPARTMENTS
INSERT INTO DEPARTMENT VALUES
('D1', 'Operations'), ('D2', 'Maintenance'), ('D3', 'Customer Service'),
('D4', 'Signal and Communications'), ('D5', 'Control Center'),
('D6', 'Safety and Security'), ('D7', 'Human Resources'),
('D8', 'Finance'), ('D9', 'Information Technology');

-- 3. GROUPS
INSERT INTO GROUPS VALUES
('G1', 'Hardware Support Team'), ('G2', 'Network Team'),
('G3', 'Software Development Team'), ('G4', 'Cybersecurity Team'),
('G5', 'Database Administration Team'), ('G6', 'Help Desk Support Team');

-- 4. STATUS
INSERT INTO STATUS VALUES
('S1', 'New'), ('S2', 'Assigned'), ('S3', 'Awaiting Input'),
('S4', 'On Hold'), ('S5', 'Resolved'), ('S6', 'Closed');

-- 5. PRIORITY
INSERT INTO PRIORITY VALUES
('P1', 'Critical'), ('P2', 'High'), ('P3', 'Medium'),
('P4', 'Low'), ('P5', 'None');

-- 6. INCIDENT ORIGIN
INSERT INTO INCIDENTORIGIN VALUES
('IO1', 'Email'), ('IO2', 'Web'), ('IO3', 'Portal');

-- 7. CATEGORY
INSERT INTO CATEGORY VALUES
('CAT1', 'Hardware'), ('CAT2', 'Applications'),
('CAT3', 'Networking'), ('CAT4', 'Security');

-- 8. SUBCATEGORY
INSERT INTO SUBCATEGORY VALUES
('SUBC1', 'Workstations', 'CAT1'), ('SUBC2', 'Servers', 'CAT1'),
('SUBC3', 'Peripheral Devices', 'CAT1'), ('SUBC4', 'Network Equipment', 'CAT1'),
('SUBC5', 'Ticketing Hardware', 'CAT1'), ('SUBC6', 'POS Systems', 'CAT1'),
('SUBC7', 'Ticketing Systems', 'CAT2'), ('SUBC8', 'Train Dispatch Software', 'CAT2'),
('SUBC9', 'Control Center Software', 'CAT2'), ('SUBC10', 'Mobile Applications', 'CAT2'),
('SUBC11', 'Maintenance Management System', 'CAT2'), ('SUBC12', 'Wi-Fi', 'CAT3'),
('SUBC13', 'LAN', 'CAT3'), ('SUBC14', 'WAN', 'CAT3'), ('SUBC15', 'VPN', 'CAT3'),
('SUBC16', 'Surveillance Systems', 'CAT3'), ('SUBC17', 'Cybersecurity Threats', 'CAT4'),
('SUBC18', 'Access Control Systems', 'CAT4'), ('SUBC19', 'Firewall Issues', 'CAT4'),
('SUBC20', 'Encryption Issues', 'CAT4'), ('SUBC21', 'User Authentication', 'CAT4');

-- 9. USERS (Includes Passwords Now)
INSERT INTO USERS (USER_ID, USER_FST_NAME, USER_LST_NAME, USER_EML, USER_PHONE, DPT_ID, ROLE_ID, USER_PWD) VALUES
('U001', 'Alice', 'Johnson', 'alice.johnson@email.com', '212-555-0101', 'D1', 'R1', 'admin123'),
('U002', 'Bob', 'Smith', 'bob.smith@email.com', '646-555-0112', 'D1', 'R2', 'staff123'),
('U003', 'Carol', 'White', 'carol.white@email.com', '347-555-0147', 'D3', 'R3', 'support123'),
('U004', 'David', 'Lee', 'david.lee@email.com', '917-555-0133', 'D4', 'R2', 'changeme123'),
('U005', 'Eva', 'Green', 'eva.green@email.com', '929-555-0189', 'D2', 'R3', 'changeme123'),
('U006', 'Frank', 'Brown', 'frank.brown@email.com', '718-555-0177', 'D5', 'R2', 'changeme123');

-- 10. USERSGROUP
INSERT INTO USERSGROUP VALUES
('U001', 'G1'), ('U002', 'G1'), ('U003', 'G2'),
('U004', 'G3'), ('U005', 'G3'), ('U006', 'G2');

INSERT INTO TICKET (
    TKT_ID, TKT_SUBJ, TKT_DES, STS_ID, PRI_ID, INC_ORI_ID, CAT_ID,
    SUB_CAT_ID, ASS_TO_USER_ID, REQ_BY_USER_ID, CRD_DATE, RES_DATE
) VALUES
('T001', 'Wi-Fi Issue', 'Intermittent connection in Room 205', 'S1', 'P2', 'IO1', 'CAT1', 'SUBC1', 'U001', 'U002', '2024-06-01', '2024-06-05'),
('T002', 'Computer Won’t Boot', 'Reception PC fails to power up', 'S2', 'P1', 'IO2', 'CAT1', 'SUBC2', 'U002', 'U004', '2024-06-07', '2024-06-08'),
('T003', 'Email Not Syncing', 'Emails not updating on Outlook', 'S3', 'P2', 'IO3', 'CAT3', 'SUBC11', 'U003', 'U005', '2024-06-10', '2024-06-11'),
('T004', 'Projector Flickering', 'Boardroom projector flickers', 'S2', 'P3', 'IO1', 'CAT2', 'SUBC6', 'U004', 'U003', '2024-06-15', '2024-06-17'),
('T005', 'Printer Out of Ink', 'Low ink warning in Admin Office', 'S4', 'P4', 'IO3', 'CAT1', 'SUBC4', 'U005', 'U001', '2024-06-20', '2024-06-22'),
('T006', 'Firewall Failure', 'Firewall dropping external packets', 'S5', 'P1', 'IO1', 'CAT4', 'SUBC19', 'U006', 'U002', '2024-06-25', '2024-06-27'),
('T007', 'VPN Not Connecting', 'Remote employees unable to access VPN.', 'S1', 'P1', 'IO2', 'CAT3', 'SUBC15', 'U003', 'U001', '2024-07-01', '2024-07-03'),
('T008', 'Projector Overheating', 'Overheating during long meetings.', 'S2', 'P2', 'IO1', 'CAT2', 'SUBC6', 'U004', 'U002', '2024-07-02', '2024-07-05'),
('T009', 'Forgotten Password', 'User unable to log into portal.', 'S3', 'P4', 'IO3', 'CAT4', 'SUBC21', 'U005', 'U003', '2024-07-03', '2024-07-03'),
('T010', 'Computer Slow', 'Computer performance degraded over time.', 'S1', 'P3', 'IO1', 'CAT1', 'SUBC1', 'U006', 'U004', '2024-07-04', '2024-07-06');



-- 12. ATTACHMENTS
INSERT INTO ATTACHMENT VALUES
('A001', 'T001', 'wifi_report.pdf', 'PDF', '2024-06-01'),
('A002', 'T002', 'boot_failure_log.txt', 'TXT', '2024-06-07'),
('A003', 'T004', 'projector_flicker.jpg', 'JPG', '2024-06-15'),
('A004', 'T006', 'firewall_diagnostic.zip', 'ZIP', '2024-06-25');
