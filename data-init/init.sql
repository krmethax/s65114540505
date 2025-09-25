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

