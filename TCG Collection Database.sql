-- Create a database for the Card Collection
DROP DATABASE IF EXISTS card_collection;
CREATE DATABASE card_collection;
USE card_collection;

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

-- 3.1 Magic Cards Table
CREATE TABLE magic_cards (
    magic_card_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type VARCHAR(50) NOT NULL,
    rarity VARCHAR(20) NOT NULL,
    artist VARCHAR(100),
    image_url VARCHAR(255),
    card_id INT,
    isLegendary boolean,
	FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- 3.1.1 Mana Cost Table
Create table magic_card_mana_cost (
	mana_cost_id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL,
    quantity INT
);

-- 3.1.2 Junction Table
CREATE TABLE magic_card_mana_cost_relation (
    magic_card_id INT,
    mana_cost_id INT,
    PRIMARY KEY (magic_card_id, mana_cost_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (mana_cost_id) REFERENCES magic_card_mana_cost(mana_cost_id) ON DELETE CASCADE
);

-- 3.2.1 Creature Stats Table
Create table magic_card_creature (
	creature_id INT AUTO_INCREMENT PRIMARY KEY,
    power INT,
    toughness INT,
	magic_card_id INT,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE

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

-- Testing
Insert into games (game_name) values ('Magic the Gathering');
Insert into card_sets (set_name,release_date, total_cards) values ('Test Set', 2024, 20);
Insert into cards (card_name) values ('Test Card 1');
INSERT INTO magic_cards (card_type, rarity, artist, image_url, isLegendary)
VALUES ('Creature', 'Rare', 'John Doe', 'image_url_1', false);
INSERT INTO magic_card_mana_cost (color, quantity)
VALUES ('Red', 2), ('Blue', 1);
INSERT INTO magic_card_mana_cost_relation (magic_card_id, mana_cost_id)
VALUES (1, 1), -- Magic card 1 has Red mana cost
       (1, 2); -- Magic card 1 also has Blue mana cost

SELECT * FROM magic_cards 
JOIN 
    magic_card_mana_cost_relation ON magic_cards.magic_card_id = magic_card_mana_cost_relation.magic_card_id
JOIN 
    magic_card_mana_cost ON magic_card_mana_cost_relation.mana_cost_id = magic_card_mana_cost.mana_cost_id
Order by magic_card_mana_cost.color;
