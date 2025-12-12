PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS appointment_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS masters;

----------------------------------------
-- Таблица мастеров
----------------------------------------
CREATE TABLE masters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    phone TEXT,
    specialization TEXT NOT NULL CHECK (specialization IN ('MALE', 'FEMALE', 'UNIVERSAL')),
    commission_percent REAL NOT NULL CHECK (commission_percent >= 0 AND commission_percent <= 1.0),
    is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1))
);

----------------------------------------
-- Таблица услуг
----------------------------------------
CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    target_gender TEXT NOT NULL CHECK (target_gender IN ('MALE', 'FEMALE')),
    duration_min INTEGER NOT NULL CHECK (duration_min > 0),
    price REAL NOT NULL CHECK (price >= 0)
);

----------------------------------------
-- Таблица клиентов
----------------------------------------
CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    phone TEXT,
    gender TEXT NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    email TEXT
);

----------------------------------------
-- Таблица расписаний мастеров
----------------------------------------
CREATE TABLE schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    master_id INTEGER NOT NULL,
    work_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    end_time TEXT NOT NULL,

    FOREIGN KEY (master_id) REFERENCES masters(id) ON DELETE CASCADE,
    UNIQUE(master_id, work_date)
);

----------------------------------------
-- Таблица записей
----------------------------------------
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

----------------------------------------
-- Услуги в записи
----------------------------------------
CREATE TABLE appointment_services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    fixed_price REAL NOT NULL CHECK (fixed_price >= 0),

    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

----------------------------------------
-- Данные мастеров (новые имена)
----------------------------------------
INSERT INTO masters (full_name, phone, specialization, commission_percent, is_active)
VALUES 
('Алексей Морозов', '+79001112233', 'MALE', 0.40, 1),
('Вероника Гончарова', '+79004445566', 'UNIVERSAL', 0.50, 1),
('Татьяна Лебедева', '+79007778899', 'FEMALE', 0.45, 0);

----------------------------------------
-- Данные услуг
----------------------------------------
INSERT INTO services (title, target_gender, duration_min, price) VALUES
('Мужская стрижка', 'MALE', 45, 1200.00),
('Оформление бороды', 'MALE', 30, 800.00),
('Женская стрижка', 'FEMALE', 60, 1800.00),
('Окрашивание', 'FEMALE', 120, 5000.00),
('Укладка', 'FEMALE', 40, 1500.00);

----------------------------------------
-- Клиенты (новые имена)
----------------------------------------
INSERT INTO clients (full_name, phone, gender) VALUES
('Сергей Орлов', '+79990000001', 'MALE'),
('Дарья Литвинова', '+79990000002', 'FEMALE'),
('Никита Волков', '+79990000003', 'MALE');

----------------------------------------
-- Расписания
----------------------------------------
INSERT INTO schedules (master_id, work_date, start_time, end_time) VALUES
(1, '2023-11-01', '10:00', '20:00'),
(2, '2023-11-01', '09:00', '18:00');

----------------------------------------
-- Запись №1 (мастер Алексей Морозов → клиент Орлов)
----------------------------------------
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 1, '2023-11-01 10:00:00', '2023-11-01 10:45:00', 'COMPLETED');

INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (last_insert_rowid(), 1, 1200.00);

----------------------------------------
-- Запись №2
----------------------------------------
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (1, 3, '2023-11-01 12:00:00', '2023-11-01 13:15:00', 'SCHEDULED');

INSERT INTO appointment_services (appointment_id, service_id, fixed_price) VALUES
(2, 1, 1200.00),
(2, 2, 800.00);

----------------------------------------
-- Запись №3 (уволенный мастер тоже сохраняется)
----------------------------------------
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (3, 2, '2023-10-15 14:00:00', '2023-10-15 16:00:00', 'COMPLETED');

INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (3, 4, 5000.00);

----------------------------------------
-- Запись №4 (отмена)
----------------------------------------
INSERT INTO appointments (master_id, client_id, start_datetime, end_datetime, status)
VALUES (2, 2, '2023-11-01 09:00:00', '2023-11-01 10:00:00', 'CANCELLED');

INSERT INTO appointment_services (appointment_id, service_id, fixed_price)
VALUES (4, 3, 1800.00);

COMMIT;
