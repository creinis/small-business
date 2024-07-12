-- Create database
CREATE DATABASE small_business
    WITH OWNER = carlosreinis
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';

\connect small_business

-- Habilitar extensão pgcrypto
CREATE EXTENSION pgcrypto;

-- Table users / loggin
CREATE TABLE public.users (
    user_id serial PRIMARY KEY,
    username varchar(50) NOT NULL UNIQUE,
    password varchar(255) NOT NULL,
    role varchar(10) NOT NULL, -- 'master' ou 'user'
    created_at timestamp DEFAULT current_timestamp
);

-- Table employees
CREATE TABLE public.employees (
    employee_id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    phone varchar(15) NOT NULL UNIQUE,
    email varchar(50) NOT NULL UNIQUE,
    job_title varchar(25) NOT NULL,
    hire_date date,
    birthday date,
    salary numeric(8, 2)
);

-- Dados dos Employees
INSERT INTO employees (name, phone, email, job_title, hire_date, salary) VALUES 
('Alice Santos', '11987654321', 'alice.santos@beautysalon.com', 'Cabeleireira', '2019-01-15', 3500),
('Bruno Silva', '11987654322', 'bruno.silva@beautysalon.com', 'Manicure', '2020-03-10', 2500),
('Carla Souza', '11987654323', 'carla.souza@beautysalon.com', 'Esteticista', '2018-05-20', 3000),
('Diego Oliveira', '11987654324', 'diego.oliveira@beautysalon.com', 'Barbeiro', '2021-07-01', 3200),
('Elena Costa', '11987654325', 'elena.costa@beautysalon.com', 'Maquiadora', '2017-11-25', 2800),
('Fernando Lima', '11987654326', 'fernando.lima@beautysalon.com', 'Depilador', '2022-02-15', 2600);

-- Table customers
CREATE TABLE public.customers (
    customer_id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    phone varchar(15) NOT NULL UNIQUE,
    email varchar(50) NOT NULL UNIQUE,
    birthday date
);

-- Dados dos Clientes
INSERT INTO customers (name, phone, email, birthday) VALUES
('Cliente 1', '11912345601', 'cliente1@example.com', '1990-01-01'),
('Cliente 2', '11912345602', 'cliente2@example.com', '1991-02-02'),
('Cliente 3', '11912345603', 'cliente3@example.com', '1992-03-03'),
('Cliente 4', '11912345604', 'cliente4@example.com', '1993-04-04'),
('Cliente 5', '11912345605', 'cliente5@example.com', '1994-05-05'),
('Cliente 6', '11912345606', 'cliente6@example.com', '1995-06-06'),
('Cliente 7', '11912345607', 'cliente7@example.com', '1996-07-07'),
('Cliente 8', '11912345608', 'cliente8@example.com', '1997-08-08'),
('Cliente 9', '11912345609', 'cliente9@example.com', '1998-09-09'),
('Cliente 10', '11912345610', 'cliente10@example.com', '1999-10-10'),
('Cliente 11', '11912345611', 'cliente11@example.com', '1980-01-11'),
('Cliente 12', '11912345612', 'cliente12@example.com', '1981-02-12'),
('Cliente 13', '11912345613', 'cliente13@example.com', '1982-03-13'),
('Cliente 14', '11912345614', 'cliente14@example.com', '1983-04-14'),
('Cliente 15', '11912345615', 'cliente15@example.com', '1984-05-15'),
('Cliente 16', '11912345616', 'cliente16@example.com', '1985-06-16'),
('Cliente 17', '11912345617', 'cliente17@example.com', '1986-07-17'),
('Cliente 18', '11912345618', 'cliente18@example.com', '1987-08-18'),
('Cliente 19', '11912345619', 'cliente19@example.com', '1988-09-19'),
('Cliente 20', '11912345620', 'cliente20@example.com', '1989-10-20'),
('Cliente 21', '11912345621', 'cliente21@example.com', '1990-11-21'),
('Cliente 22', '11912345622', 'cliente22@example.com', '1991-12-22'),
('Cliente 23', '11912345623', 'cliente23@example.com', '1992-01-23'),
('Cliente 24', '11912345624', 'cliente24@example.com', '1993-02-24'),
('Cliente 25', '11912345625', 'cliente25@example.com', '1994-03-25'),
('Cliente 26', '11912345626', 'cliente26@example.com', '1995-04-26'),
('Cliente 27', '11912345627', 'cliente27@example.com', '1996-05-27'),
('Cliente 28', '11912345628', 'cliente28@example.com', '1997-06-28'),
('Cliente 29', '11912345629', 'cliente29@example.com', '1998-07-29'),
('Cliente 30', '11912345630', 'cliente30@example.com', '1999-08-30'),
('Cliente 31', '11912345631', 'cliente31@example.com', '1980-09-01'),
('Cliente 32', '11912345632', 'cliente32@example.com', '1981-10-02'),
('Cliente 33', '11912345633', 'cliente33@example.com', '1982-11-03'),
('Cliente 34', '11912345634', 'cliente34@example.com', '1983-12-04'),
('Cliente 35', '11912345635', 'cliente35@example.com', '1984-01-05'),
('Cliente 36', '11912345636', 'cliente36@example.com', '1985-02-06'),
('Cliente 37', '11912345637', 'cliente37@example.com', '1986-03-07'),
('Cliente 38', '11912345638', 'cliente38@example.com', '1987-04-08');

-- Table services
CREATE TABLE public.services (
    service_id serial PRIMARY KEY,
    name varchar(50) NOT NULL,
    price numeric(8, 2) NOT NULL,
    service_class varchar(20) NOT NULL,
    gender varchar(10) NOT NULL,
    UNIQUE (name, service_class, gender)
);

-- Insert initial services
INSERT INTO public.services (name, price, service_class, gender)
VALUES 
    ('cut (female)', 50.00, 'hair', 'female'),
    ('cut (male)', 40.00, 'hair', 'male'),
    ('color (female)', 80.00, 'hair', 'female'),
    ('color (male)', 70.00, 'hair', 'male'),
    ('perm (female)', 100.00, 'hair', 'female'),
    ('perm (male)', 90.00, 'hair', 'male'),
    ('make-up', 60.00, 'beauty', 'female'),
    ('nails hand (female)', 40.00, 'beauty', 'female'),
    ('nails hand (male)', 35.00, 'beauty', 'male'),
    ('nails feet (female)', 50.00, 'beauty', 'female'),
    ('nails feet (male)', 45.00, 'beauty', 'male'),
    ('face mask', 30.00, 'beauty', 'female'),
    ('others', 50.00, 'others', 'all');

-- Table appointments
CREATE TABLE public.appointments (
    appointment_id serial PRIMARY KEY,
    customer_id integer REFERENCES public.customers(customer_id),
    employee_id integer REFERENCES public.employees(employee_id),
    service_id integer REFERENCES public.services(service_id),
    appointment_date date NOT NULL,
    appointment_time varchar(5) NOT NULL,
    confirmed boolean DEFAULT false,
    CONSTRAINT appointment_unique UNIQUE (employee_id, appointment_date, appointment_time)
);

-- Table days
CREATE TABLE public.days (
    day_id serial PRIMARY KEY,
    day integer UNIQUE NOT NULL CHECK (day >= 1 AND day <= 31)
);

INSERT INTO public.days (day)
VALUES 
    (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), 
    (11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
    (21), (22), (23), (24), (25), (26), (27), (28), (29), (30),
    (31);
    
-- Table months
CREATE TABLE public.months (
    month_id serial PRIMARY KEY,
    month integer UNIQUE NOT NULL CHECK (month >= 1 AND month <= 12)
);

INSERT INTO public.months (month)
VALUES 
    (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
    (11), (12);

-- Table years
CREATE TABLE public.years (
    year_id serial PRIMARY KEY,
    year integer UNIQUE NOT NULL CHECK (year >= 2023)
);

INSERT INTO public.years (year)
VALUES 
    (2024), (2025), (2026), (2027), (2028), (2029), (2030), 
    (2031), (2032), (2033), (2034), (2035), (2036), (2037),
    (2038), (2039), (2040), (2041), (2042), (2043), (2044), 
    (2045), (2046), (2047), (2048), (2049), (2050);

-- Table times
CREATE TABLE public.times (
    time_id serial PRIMARY KEY,
    time_interval varchar(10) UNIQUE NOT NULL
);

-- Insert default times
INSERT INTO public.times (time_interval)
VALUES 
    ('10:00'), ('10:30'), ('11:00'), ('11:30'), 
    ('12:00'), ('12:30'), ('13:00'), ('13:30'),
    ('14:00'), ('14:30'), ('15:00'), ('15:30'),
    ('16:00'), ('16:30'), ('17:00'), ('17:30'),
    ('18:00'), ('18:30'), ('19:00'), ('19:30'),
    ('20:00'), ('20:30'), ('21:00'), ('21:30');

-- Table purchases
CREATE TABLE public.purchases (
    purchase_id serial PRIMARY KEY,
    appointment_id integer UNIQUE,
    customer_id integer REFERENCES public.customers(customer_id),
    employee_id integer REFERENCES public.employees(employee_id),
    service_id integer REFERENCES public.services(service_id),
    purchase_date date NOT NULL DEFAULT current_date,
    price numeric(8, 2) NOT NULL,
    payment_method varchar(50)
);

-- Table payment_methods
CREATE TABLE public.payment_methods (
    method_id serial PRIMARY KEY,
    method_name varchar(50) NOT NULL UNIQUE
);

-- Insert initial payment methods
INSERT INTO public.payment_methods (method_name)
VALUES ('Credit Card'), ('Cash'), ('Debit Card'), ('Bank Transfer');

-- Table promotions
CREATE TABLE public.promotions (
    promo_id serial PRIMARY KEY,
    service_id integer REFERENCES public.services(service_id),
    employee_id integer REFERENCES public.employees(employee_id),
    customer_id integer REFERENCES public.customers(customer_id),
    multiplier numeric(5, 2) NOT NULL
);

-- Add indexes for performance optimization
CREATE INDEX idx_appointments_employee_id ON public.appointments(employee_id);
CREATE INDEX idx_purchases_customer_id ON public.purchases(customer_id);
