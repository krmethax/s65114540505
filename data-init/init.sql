-- ??????????????? Members
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

-- ??????????????? Pet_Sitters
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

-- ??????????????? Pet_Types
CREATE TABLE IF NOT EXISTS Pet_Types (
    pet_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ??????????????? Service_Types
CREATE TABLE IF NOT EXISTS Service_Types (
    service_type_id SERIAL PRIMARY KEY,
    short_name VARCHAR(50) NOT NULL,
    full_description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ??????????????? Sitter_Services
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

-- ??????????????? Bookings
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

-- ??????????????? Payments
CREATE TABLE IF NOT EXISTS Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL, -- ?????????????????????????????? INT ???????????? DECIMAL
    payment_method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending',
    transaction_id VARCHAR(255) UNIQUE,
    payment_initiated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- ??????????????? Reviews
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

-- ??????????????? Verify_OTP
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

-- ??????????????? Verify_OTP_Sitter
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

-- ??????????????? Confirm_Email
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

-- ??????????????? Favorite_Sitters
CREATE TABLE IF NOT EXISTS Favorite_Sitters (
    favorite_id SERIAL PRIMARY KEY,
    member_id INT NOT NULL,
    sitter_id INT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- ??????????????? Payment_Methods
CREATE TABLE IF NOT EXISTS Payment_Methods (
    payment_method_id SERIAL PRIMARY KEY,
    sitter_id INT NOT NULL,
    promptpay_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sitter_id) REFERENCES Pet_Sitters(sitter_id) ON DELETE CASCADE
);

-- Mock data -----------------------------------------------------

INSERT INTO Members (member_id, first_name, last_name, email, password, phone, profile_image, address, province, amphure, tambon, created_at, updated_at)
VALUES
    (1, 'Thanakorn', 'Suwan', 'thanakorn@example.com', 'hashed_password_member1', '0812345678', 'https://cdn.example.com/images/members/thanakorn.jpg', '123/45 Sukhumvit Rd.', 'Bangkok', 'Watthana', 'Khlong Tan Nuea', '2024-09-01 02:00:00+00', '2024-09-01 02:00:00+00'),
    (2, 'Sasithorn', 'Kiatkul', 'sasithorn@example.com', 'hashed_password_member2', '0897654321', 'https://cdn.example.com/images/members/sasithorn.jpg', '88/9 Rama IX Rd.', 'Bangkok', 'Huai Khwang', 'Bang Kapi', '2024-09-05 02:00:00+00', '2024-09-05 02:00:00+00')
ON CONFLICT (member_id) DO NOTHING;

INSERT INTO Pet_Sitters (sitter_id, first_name, last_name, email, password, phone, profile_image, address, province, amphure, tambon, experience, rating, verification_status, face_image, id_card_image, reviewed_by, reviewed_at, created_at, updated_at)
VALUES
    (1, 'Chaiwat', 'Panas', 'chaiwat.sit@example.com', 'hashed_password_sitter1', '0823456789', 'https://cdn.example.com/images/sitters/chaiwat-profile.jpg', '55/101 Lat Phrao 26', 'Bangkok', 'Chatuchak', 'Chom Phon', 'Former vet assistant with 5 years of pet sitting experience.', 4.80, 'verified', 'https://cdn.example.com/images/sitters/chaiwat-face.jpg', 'https://cdn.example.com/images/sitters/chaiwat-id.jpg', 1, '2024-09-10 03:00:00+00', '2024-08-28 02:00:00+00', '2024-09-10 03:00:00+00'),
    (2, 'Natcha', 'Woranit', 'natcha.care@example.com', 'hashed_password_sitter2', '0861122334', 'https://cdn.example.com/images/sitters/natcha-profile.jpg', '200/12 Pracha Uthit 14', 'Bangkok', 'Huai Khwang', 'Din Daeng', 'Certified dog trainer specializing in small breeds.', 4.95, 'verified', 'https://cdn.example.com/images/sitters/natcha-face.jpg', 'https://cdn.example.com/images/sitters/natcha-id.jpg', 1, '2024-09-12 05:00:00+00', '2024-08-30 02:00:00+00', '2024-09-12 05:00:00+00')
ON CONFLICT (sitter_id) DO NOTHING;

INSERT INTO Pet_Types (pet_type_id, type_name, description, created_at, updated_at)
VALUES
    (1, 'Dog', 'Domestic dog breeds of all sizes.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00'),
    (2, 'Cat', 'Indoor and outdoor cats.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00'),
    (3, 'Small Animal', 'Rabbits, guinea pigs, and similar companions.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00')
ON CONFLICT (pet_type_id) DO NOTHING;

INSERT INTO Service_Types (service_type_id, short_name, full_description, created_at, updated_at)
VALUES
    (1, 'boarding', 'Overnight boarding with 24-hour supervision.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00'),
    (2, 'daycare', 'Daytime care including playtime and walks.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00'),
    (3, 'grooming', 'Basic grooming and hygiene services.', '2024-08-25 02:00:00+00', '2024-08-25 02:00:00+00')
ON CONFLICT (service_type_id) DO NOTHING;

INSERT INTO Sitter_Services (sitter_service_id, sitter_id, service_type_id, pet_type_id, price, pricing_unit, duration, description, service_image, created_at, updated_at)
VALUES
    (1, 1, 1, 1, 1500.00, 'night', 24, 'Boarding for medium to large dogs with two daily walks.', 'https://cdn.example.com/images/services/chaiwat-boarding.jpg', '2024-09-02 02:00:00+00', '2024-09-02 02:00:00+00'),
    (2, 1, 2, 1, 650.00, 'day', 12, 'Daycare for energetic dogs including agility play.', 'https://cdn.example.com/images/services/chaiwat-daycare.jpg', '2024-09-02 02:00:00+00', '2024-09-02 02:00:00+00'),
    (3, 2, 1, 2, 1200.00, 'night', 24, 'Cat boarding with separate quiet rooms and live camera access.', 'https://cdn.example.com/images/services/natcha-boarding.jpg', '2024-09-04 02:00:00+00', '2024-09-04 02:00:00+00')
ON CONFLICT (sitter_service_id) DO NOTHING;

INSERT INTO Bookings (booking_id, member_id, sitter_id, pet_type_id, pet_breed, sitter_service_id, service_type_id, start_date, end_date, status, agreement_status, total_price, payment_status, slip_image, created_at, updated_at)
VALUES
    (1, 1, 1, 1, 'Golden Retriever', 1, 1, '2024-10-15 08:00:00+07', '2024-10-17 10:00:00+07', 'confirmed', 'signed', 3000.00, 'paid', 'https://static.naewna.com/uploads/news/gallery/source/1107056.jpg', '2024-10-10 02:00:00+00', '2024-10-17 05:00:00+00'),
    (2, 2, 2, 2, 'British Shorthair', 3, 1, '2024-11-05 09:00:00+07', '2024-11-07 09:00:00+07', 'pending', 'waiting_sign', 2400.00, 'awaiting_payment', 'https://static.naewna.com/uploads/news/gallery/source/1107056.jpg', '2024-10-20 02:00:00+00', '2024-10-20 02:00:00+00')
ON CONFLICT (booking_id) DO NOTHING;

INSERT INTO Payments (payment_id, booking_id, member_id, amount, payment_method, payment_status, transaction_id, payment_initiated, created_at, updated_at)
VALUES
    (1, 1, 1, 3000.00, 'promptpay', 'completed', 'TXN-20241015-001', '2024-10-13 12:30:00+00', '2024-10-15 01:00:00+00', '2024-10-15 01:00:00+00'),
    (2, 2, 2, 2400.00, 'promptpay', 'pending', 'TXN-20241105-002', '2024-10-30 09:45:00+00', '2024-10-30 09:45:00+00', '2024-10-30 09:45:00+00')
ON CONFLICT (payment_id) DO NOTHING;

INSERT INTO Reviews (review_id, booking_id, member_id, sitter_id, rating, review_text, created_at, updated_at)
VALUES
    (1, 1, 1, 1, 5, 'Great service! My dog was very happy staying with Chaiwat.', '2024-10-18 04:00:00+00', '2024-10-18 04:00:00+00')
ON CONFLICT (review_id) DO NOTHING;

INSERT INTO Verify_OTP (otp_id, member_id, otp_code, expires_at, is_verified, created_at, updated_at)
VALUES
    (1, 1, '482913', '2024-09-01 02:15:00+00', true, '2024-09-01 02:00:00+00', '2024-09-01 02:05:00+00'),
    (2, 2, '730584', '2024-09-05 02:20:00+00', true, '2024-09-05 02:00:00+00', '2024-09-05 02:10:00+00')
ON CONFLICT (otp_id) DO NOTHING;

INSERT INTO Verify_OTP_Sitter (otp_id, sitter_id, otp_code, expires_at, is_verified, created_at, updated_at)
VALUES
    (1, 1, '119642', '2024-08-28 02:30:00+00', true, '2024-08-28 02:00:00+00', '2024-08-28 02:10:00+00'),
    (2, 2, '553201', '2024-08-30 02:30:00+00', true, '2024-08-30 02:00:00+00', '2024-08-30 02:10:00+00')
ON CONFLICT (otp_id) DO NOTHING;

INSERT INTO Confirm_Email (email_verify_id, member_id, email, verification_token, expires_at, is_verified, created_at, updated_at)
VALUES
    (1, 1, 'thanakorn@example.com', 'verify-token-member-1', '2024-09-02 02:00:00+00', true, '2024-09-01 02:00:00+00', '2024-09-01 02:05:00+00'),
    (2, 2, 'sasithorn@example.com', 'verify-token-member-2', '2024-09-06 02:00:00+00', true, '2024-09-05 02:00:00+00', '2024-09-05 02:05:00+00')
ON CONFLICT (email_verify_id) DO NOTHING;

INSERT INTO Favorite_Sitters (favorite_id, member_id, sitter_id, created_at)
VALUES
    (1, 1, 1, '2024-10-18 05:00:00+00'),
    (2, 1, 2, '2024-10-19 05:00:00+00')
ON CONFLICT (favorite_id) DO NOTHING;

INSERT INTO Payment_Methods (payment_method_id, sitter_id, promptpay_number, created_at, updated_at)
VALUES
    (1, 1, '0812345678', '2024-08-28 02:00:00+00', '2024-08-28 02:00:00+00'),
    (2, 2, '0861122334', '2024-08-30 02:00:00+00', '2024-08-30 02:00:00+00')
ON CONFLICT (payment_method_id) DO NOTHING;

SELECT setval('members_member_id_seq', COALESCE((SELECT MAX(member_id) FROM Members), 0));
SELECT setval('pet_sitters_sitter_id_seq', COALESCE((SELECT MAX(sitter_id) FROM Pet_Sitters), 0));
SELECT setval('pet_types_pet_type_id_seq', COALESCE((SELECT MAX(pet_type_id) FROM Pet_Types), 0));
SELECT setval('service_types_service_type_id_seq', COALESCE((SELECT MAX(service_type_id) FROM Service_Types), 0));
SELECT setval('sitter_services_sitter_service_id_seq', COALESCE((SELECT MAX(sitter_service_id) FROM Sitter_Services), 0));
SELECT setval('bookings_booking_id_seq', COALESCE((SELECT MAX(booking_id) FROM Bookings), 0));
SELECT setval('payments_payment_id_seq', COALESCE((SELECT MAX(payment_id) FROM Payments), 0));
SELECT setval('reviews_review_id_seq', COALESCE((SELECT MAX(review_id) FROM Reviews), 0));
SELECT setval('verify_otp_otp_id_seq', COALESCE((SELECT MAX(otp_id) FROM Verify_OTP), 0));
SELECT setval('verify_otp_sitter_otp_id_seq', COALESCE((SELECT MAX(otp_id) FROM Verify_OTP_Sitter), 0));
SELECT setval('confirm_email_email_verify_id_seq', COALESCE((SELECT MAX(email_verify_id) FROM Confirm_Email), 0));
SELECT setval('favorite_sitters_favorite_id_seq', COALESCE((SELECT MAX(favorite_id) FROM Favorite_Sitters), 0));
SELECT setval('payment_methods_payment_method_id_seq', COALESCE((SELECT MAX(payment_method_id) FROM Payment_Methods), 0));
