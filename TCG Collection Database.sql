-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- 1.5 Games Collected
Create Table games (
	game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL
);

-- 2. Card Sets Table
CREATE TABLE card_sets (
    set_id INT AUTO_INCREMENT PRIMARY KEY,
    set_name VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    total_cards INT NOT NULL,
    game_id INT,
	FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

-- 3. Card Table
Create table cards (
	card_id INT AUTO_INCREMENT PRIMARY KEY,
	card_name VARCHAR(100) NOT NULL,
	set_id INT,
    FOREIGN KEY (set_id) REFERENCES card_sets(set_id) ON DELETE CASCADE
);

-- 3. Cards Table
CREATE TABLE magic_cards (
    magic_card_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type VARCHAR(50) NOT NULL,
    rarity VARCHAR(20) NOT NULL,
    mana_cost VARCHAR(50),
    power INT,
    toughness INT,
    artist VARCHAR(100),
    image_url VARCHAR(255)
);

-- 4. User Collection Table
CREATE TABLE user_collection (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    card_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    acquired_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- 5. Trades Table
CREATE TABLE trades (
    trade_id INT AUTO_INCREMENT PRIMARY KEY,
    initiator_user_id INT,
    receiver_user_id INT,
    status ENUM('pending', 'accepted', 'declined', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (initiator_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 6. Trade Items Table
CREATE TABLE trade_items (
    trade_item_id INT AUTO_INCREMENT PRIMARY KEY,
    trade_id INT,
    user_id INT,
    card_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    is_offered BOOLEAN NOT NULL,
    FOREIGN KEY (trade_id) REFERENCES trades(trade_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- Optional Indexes for performance
CREATE INDEX idx_user_id ON user_collection(user_id);
CREATE INDEX idx_card_id ON user_collection(card_id);
CREATE INDEX idx_trade_status ON trades(status);