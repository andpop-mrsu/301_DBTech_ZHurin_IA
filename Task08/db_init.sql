PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS appointment_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS masters;


CREATE TABLE masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    phone TEXT,
    specialization TEXT NOT NULL CHECK (specialization IN ('MALE', 'FEMALE', 'UNIVERSAL')),
    commission_percent REAL NOT NULL CHECK (commission_percent >= 0 AND commission_percent <= 1.0),
    is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);


CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    target_gender TEXT NOT NULL CHECK (target_gender IN ('MALE', 'FEMALE')),
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    price REAL NOT NULL CHECK (price >= 0)
);


CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    phone TEXT,
    gender TEXT NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    email TEXT
);


CREATE TABLE schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    work_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,

    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE,
    UNIQUE(master_id, work_date)
);


CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    client_id INTEGER NOT NULL,
    start_datetime TEXT NOT NULL,
    end_datetime TEXT NOT NULL,

    status TEXT NOT NULL DEFAULT 'SCHEDULED' 
        CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED')),
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE RESTRICT
);


CREATE TABLE appointment_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    fixed_price REAL NOT NULL CHECK (fixed_price >= 0),

    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);


INSERT INTO masters (full_name, phone, specialization, commission_percent, is_active)
VALUES 
('Алексей Морозов', '+79001112233', 'MALE', 0.40, 1),
('Вероника Гончарова', '+79004445566', 'UNIVERSAL', 0.50, 1),
('Татьяна Лебедева', '+79007778899', 'FEMALE', 0.45, 0),
('Дмитрий Соколов', '+79001112244', 'MALE', 0.42, 1),
('Анна Петрова', '+79004445577', 'FEMALE', 0.48, 1),
('Михаил Иванов', '+79007778800', 'UNIVERSAL', 0.45, 1),
('Екатерина Смирнова', '+79001112255', 'FEMALE', 0.46, 1),
('Андрей Кузнецов', '+79004445588', 'MALE', 0.41, 0);


INSERT INTO services (title, target_gender, duration_min, price) VALUES
('Мужская стрижка', 'MALE', 45, 1200.00),
('Оформление бороды', 'MALE', 30, 800.00),
('Женская стрижка', 'FEMALE', 60, 1800.00),
('Окрашивание', 'FEMALE', 120, 5000.00),
('Укладка', 'FEMALE', 40, 1500.00);


INSERT INTO clients (full_name, phone, gender) VALUES
('Сергей Орлов', '+79990000001', 'MALE'),
('Дарья Литвинова', '+79990000002', 'FEMALE'),
('Никита Волков', '+79990000003', 'MALE'),
('Мария Козлова', '+79990000004', 'FEMALE'),
('Иван Новиков', '+79990000005', 'MALE'),
('Ольга Федорова', '+79990000006', 'FEMALE'),
('Павел Морозов', '+79990000007', 'MALE'),
('Елена Соколова', '+79990000008', 'FEMALE'),
('Александр Лебедев', '+79990000009', 'MALE'),
('Наталья Волкова', '+79990000010', 'FEMALE');


INSERT INTO schedules (master_id, work_date, start_time, end_time) VALUES
-- График для мастера 1 (Алексей Морозов)
(1, '2025-11-01', '10:00', '20:00'),
(1, '2025-11-02', '10:00', '20:00'),
(1, '2025-11-03', '10:00', '20:00'),
(1, '2025-11-05', '10:00', '20:00'),
(1, '2025-11-06', '10:00', '20:00'),
-- График для мастера 2 (Вероника Гончарова)
(2, '2025-11-01', '09:00', '18:00'),
(2, '2025-11-02', '09:00', '18:00'),
(2, '2025-11-03', '09:00', '18:00'),
(2, '2025-11-04', '09:00', '18:00'),
(2, '2025-11-05', '09:00', '18:00'),
-- График для мастера 3 (Татьяна Лебедева - уволенная)
(3, '2025-10-15', '10:00', '19:00'),
(3, '2025-10-16', '10:00', '19:00'),
-- График для мастера 4 (Дмитрий Соколов)
(4, '2025-11-01', '11:00', '21:00'),
(4, '2025-11-02', '11:00', '21:00'),
(4, '2025-11-04', '11:00', '21:00'),
(4, '2025-11-05', '11:00', '21:00'),
-- График для мастера 5 (Анна Петрова)
(5, '2025-11-01', '08:00', '17:00'),
(5, '2025-11-02', '08:00', '17:00'),
(5, '2025-11-03', '08:00', '17:00'),
(5, '2025-11-06', '08:00', '17:00'),
-- График для мастера 6 (Михаил Иванов)
(6, '2025-11-01', '09:00', '19:00'),
(6, '2025-11-03', '09:00', '19:00'),
(6, '2025-11-04', '09:00', '19:00'),
(6, '2025-11-05', '09:00', '19:00'),
-- График для мастера 7 (Екатерина Смирнова)
(7, '2025-11-01', '10:00', '18:00'),
(7, '2025-11-02', '10:00', '18:00'),
(7, '2025-11-04', '10:00', '18:00'),
(7, '2025-11-05', '10:00', '18:00'),
(7, '2025-11-06', '10:00', '18:00'),
-- График для мастера 8 (Андрей Кузнецов - уволенный)
(8, '2025-10-20', '10:00', '20:00'),
(8, '2025-10-21', '10:00', '20:00');


-- Записи для мастера 1 (Алексей Морозов)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 1, '2025-11-01 10:00:00', '2025-11-01 10:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 3, '2025-11-01 12:00:00', '2025-11-01 13:15:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price) VALUES
((SELECT last_insert_rowid()), 1, 1200.00),
((SELECT last_insert_rowid()), 2, 800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 5, '2025-11-02 14:00:00', '2025-11-02 14:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 7, '2025-11-03 16:00:00', '2025-11-03 16:30:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 2, 800.00);

-- Записи для мастера 2 (Вероника Гончарова)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 2, '2025-11-01 09:00:00', '2025-11-01 10:00:00', 'CANCELLED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 4, '2025-11-01 11:00:00', '2025-11-01 12:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 6, '2025-11-02 13:00:00', '2025-11-02 15:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 4, 5000.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 8, '2025-11-03 10:00:00', '2025-11-03 10:40:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 5, 1500.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 2, '2025-11-04 14:00:00', '2025-11-04 15:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

-- Записи для мастера 3 (Татьяна Лебедева - уволенная)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (3, 2, '2025-10-15 14:00:00', '2025-10-15 16:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 4, 5000.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (3, 4, '2025-10-16 10:00:00', '2025-10-16 11:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

-- Записи для мастера 4 (Дмитрий Соколов)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (4, 1, '2025-11-01 12:00:00', '2025-11-01 12:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (4, 5, '2025-11-02 15:00:00', '2025-11-02 15:30:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 2, 800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (4, 9, '2025-11-04 18:00:00', '2025-11-04 18:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

-- Записи для мастера 5 (Анна Петрова)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (5, 6, '2025-11-01 09:00:00', '2025-11-01 10:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (5, 8, '2025-11-02 11:00:00', '2025-11-02 13:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 4, 5000.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (5, 10, '2025-11-03 14:00:00', '2025-11-03 14:40:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 5, 1500.00);

-- Записи для мастера 6 (Михаил Иванов)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (6, 3, '2025-11-01 10:00:00', '2025-11-01 10:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (6, 4, '2025-11-03 11:00:00', '2025-11-03 12:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (6, 6, '2025-11-04 15:00:00', '2025-11-04 15:40:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 5, 1500.00);

-- Записи для мастера 7 (Екатерина Смирнова)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (7, 2, '2025-11-01 12:00:00', '2025-11-01 13:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (7, 8, '2025-11-02 14:00:00', '2025-11-02 16:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 4, 5000.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (7, 10, '2025-11-04 11:00:00', '2025-11-04 11:40:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 5, 1500.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (7, 6, '2025-11-05 15:00:00', '2025-11-05 16:00:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 3, 1800.00);

-- Записи для мастера 8 (Андрей Кузнецов - уволенный)
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (8, 1, '2025-10-20 11:00:00', '2025-10-20 11:45:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (8, 7, '2025-10-21 14:00:00', '2025-10-21 14:30:00', 'COMPLETED');
INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 2, 800.00);

COMMIT;
