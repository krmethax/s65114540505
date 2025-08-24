-- ตาราง Members
CREATE TABLE IF NOT EXISTS Members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    profile_image TEXT,
    address TEXT,
    province VARCHAR(100),
    amphure VARCHAR(100),
    tambon VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง Pet_Sitters
CREATE TABLE IF NOT EXISTS Pet_Sitters (
    sitter_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    profile_image TEXT,
    address TEXT,
    province VARCHAR(100),
    amphure VARCHAR(100),
    tambon VARCHAR(100),
    experience TEXT,
    rating DECIMAL(3,2),
    verification_status VARCHAR(20) DEFAULT 'pending',
    face_image TEXT,
    id_card_image TEXT,
    reviewed_by INT,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง Pet_Types
CREATE TABLE IF NOT EXISTS Pet_Types (
    pet_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง Service_Types
CREATE TABLE IF NOT EXISTS Service_Types (
    service_type_id SERIAL PRIMARY KEY,
    short_name VARCHAR(50) NOT NULL,
    full_description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ตาราง Sitter_Services
CREATE TABLE IF NOT EXISTS Sitter_Services (
    sitter_service_id SERIAL PRIMARY KEY,
    sitter_id INT NOT NULL,
    service_type_id INT NOT NULL,
    pet_type_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    pricing_unit VARCHAR(20) NOT NULL,
    duration INT,
    description TEXT,
    service_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE,
    FOREIGN KEY (service_type_id) REFERENCES Service_Types(service_type_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_type_id) REFERENCES Pet_Types(pet_type_id) ON DELETE CASCADE
);

-- ตาราง Bookings
CREATE TABLE IF NOT EXISTS Bookings (
    booking_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    sitter_id INT NOT NULL,
    pet_type_id INT NOT NULL,
    pet_breed VARCHAR(50) NOT NULL,
    sitter_service_id INT NOT NULL,
    service_type_id INT NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    agreement_status VARCHAR(50) DEFAULT 'pending',
    total_price DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'unpaid',
    slip_image TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE,
    FOREIGN KEY (pet_type_id) REFERENCES Pet_Types(pet_type_id) ON DELETE CASCADE,
    FOREIGN KEY (sitter_service_id) REFERENCES Sitter_Services(sitter_service_id) ON DELETE CASCADE,
    FOREIGN KEY (service_type_id) REFERENCES Service_Types(service_type_id) ON DELETE CASCADE
);

-- ตาราง Payments
CREATE TABLE IF NOT EXISTS Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL, -- เปลี่ยนจาก INT เป็น DECIMAL
    payment_method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending',
    transaction_id VARCHAR(255) UNIQUE,
    payment_initiated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- ตาราง Reviews
CREATE TABLE IF NOT EXISTS Reviews (
    review_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    member_id INT NOT NULL,
    sitter_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- ตาราง Verify_OTP
CREATE TABLE IF NOT EXISTS Verify_OTP (
    otp_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- ตาราง Verify_OTP_Sitter
CREATE TABLE IF NOT EXISTS Verify_OTP_Sitter (
    otp_id SERIAL PRIMARY KEY,
    sitter_id INT NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- ตาราง Confirm_Email
CREATE TABLE IF NOT EXISTS Confirm_Email (
    email_verify_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    verification_token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- ตาราง Favorite_Sitters
CREATE TABLE IF NOT EXISTS Favorite_Sitters (
    favorite_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    sitter_id INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- ตาราง Payment_Methods
CREATE TABLE IF NOT EXISTS Payment_Methods (
    payment_method_id SERIAL PRIMARY KEY,
    sitter_id INT NOT NULL,
    promptpay_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- =============================
-- ตัวอย่างข้อมูล Members
-- =============================
INSERT INTO Members (first_name, last_name, email, password, phone, address, province, amphure, tambon)
VALUES
('Somchai', 'Prasert', 'somchai@example.com', 'hashedpassword1', '0812345671', '123/1 Bangkok St', 'Bangkok', 'Bangkok', 'Bangkok'),
('Nattapong', 'Sukjai', 'nattapong@example.com', 'hashedpassword2', '0812345672', '456/2 Chiang Mai Rd', 'Chiang Mai', 'Mueang', 'Si Phum'),
('Kanya', 'Thongchai', 'kanya@example.com', 'hashedpassword3', '0812345673', '789/3 Phuket St', 'Phuket', 'Mueang', 'Talad Yai'),
('Anucha', 'Jaroensuk', 'anucha@example.com', 'hashedpassword4', '0812345674', '101/4 Khon Kaen Rd', 'Khon Kaen', 'Mueang', 'Nai Mueang');

-- =============================
-- ตัวอย่างข้อมูล Pet_Sitters
-- =============================
INSERT INTO Pet_Sitters (first_name, last_name, email, password, phone, experience, rating, verification_status)
VALUES
('Supatra', 'Boonmee', 'supatra@example.com', 'hashedpassword5', '0898765431', '5 years taking care of dogs and cats', 4.8, 'verified'),
('Somnuk', 'Chaiyaporn', 'somnuk@example.com', 'hashedpassword6', '0898765432', '10 years experience in pet care', 4.9, 'verified'),
('Pimchanok', 'Srisuk', 'pimchanok@example.com', 'hashedpassword7', '0898765433', '3 years caring for birds and reptiles', 4.6, 'pending');

-- =============================
-- ตัวอย่างข้อมูล Pet_Types
-- =============================
INSERT INTO Pet_Types (type_name, description)
VALUES
('Dog', 'All breeds of dogs'),
('Cat', 'All breeds of cats'),
('Bird', 'Parrots, Canaries, Finches'),
('Reptile', 'Turtles, Snakes, Lizards');

-- =============================
-- ตัวอย่างข้อมูล Service_Types
-- =============================
INSERT INTO Service_Types (short_name, full_description)
VALUES
('Dog Walking', 'Take dogs for a walk and exercise'),
('Pet Sitting', 'Look after pets at home'),
('Pet Grooming', 'Bathing, trimming and grooming pets'),
('Pet Training', 'Training pets for behavior and tricks');

-- =============================
-- ตัวอย่างข้อมูล Sitter_Services
-- =============================
INSERT INTO Sitter_Services (sitter_id, service_type_id, pet_type_id, price, pricing_unit, duration, description)
VALUES
(1, 1, 1, 300.00, 'per hour', 1, 'Walking dogs for 1 hour'),
(1, 2, 2, 500.00, 'per day', 1, 'Pet sitting for cats'),
(2, 3, 1, 700.00, 'per session', 1, 'Grooming dogs'),
(3, 2, 3, 400.00, 'per day', 1, 'Sitting for birds');

-- =============================
-- ตัวอย่างข้อมูล Bookings
-- =============================
INSERT INTO Bookings (member_id, sitter_id, pet_type_id, pet_breed, sitter_service_id, service_type_id, start_date, end_date, total_price, payment_status)
VALUES
(1, 1, 1, 'Golden Retriever', 1, 1, NOW(), NOW() + INTERVAL '1 hour', 300.00, 'unpaid'),
(2, 1, 2, 'Siamese', 2, 2, NOW(), NOW() + INTERVAL '1 day', 500.00, 'paid'),
(3, 2, 1, 'Bulldog', 3, 3, NOW(), NOW() + INTERVAL '2 hours', 700.00, 'pending'),
(4, 3, 3, 'Parakeet', 4, 2, NOW(), NOW() + INTERVAL '1 day', 400.00, 'unpaid');

-- =============================
-- ตัวอย่างข้อมูล Payments
-- =============================
INSERT INTO Payments (booking_id, member_id, amount, payment_method, payment_status, transaction_id)
VALUES
(1, 1, 300.00, 'PromptPay', 'pending', 'TXN001'),
(2, 2, 500.00, 'Credit Card', 'paid', 'TXN002'),
(3, 3, 700.00, 'PromptPay', 'pending', 'TXN003'),
(4, 4, 400.00, 'Bank Transfer', 'unpaid', 'TXN004');
