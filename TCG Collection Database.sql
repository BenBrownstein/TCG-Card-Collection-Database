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
CREATE TABLE games (
	game_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- 2. Card Sets Table
CREATE TABLE card_sets (
    card_set_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    total_cards INT NOT NULL,
    game_id INT,
	FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

-- 3. Card Table
CREATE TABLE cards (
	card_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	card_set_id INT,
    FOREIGN KEY (card_set_id) REFERENCES card_sets(card_set_id) ON DELETE CASCADE
);

-- 3.1 Magic Cards Table 
CREATE TABLE magic_cards (
    magic_card_id INT AUTO_INCREMENT PRIMARY KEY,
    rarity VARCHAR(20) NOT NULL,
    artist VARCHAR(100),
    image_url VARCHAR(255),
    card_id INT,
    is_Legendary BOOLEAN,
	FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- 3.1.1 Mana Cost Table
CREATE TABLE magic_card_mana_costs (
	magic_card_mana_costs_id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL,
    quantity INT NOT NULL
);

-- 3.1.2 Mana Cost Junction Table
CREATE TABLE magic_cards_mana_costs_relations (
    magic_card_id INT,
    magic_card_mana_costs_id INT,
    PRIMARY KEY (magic_card_id, magic_card_mana_costs_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_mana_costs_id) REFERENCES magic_card_mana_costs(magic_card_mana_costs_id) ON DELETE CASCADE
);

-- 3.2.1 Creature Stats Table
CREATE TABLE magic_card_creatures (
	magic_card_creature_id INT AUTO_INCREMENT PRIMARY KEY,
    power INT,
    toughness INT,
	magic_card_id INT,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE

);
 -- 3.3.1 Subtype Table
 CREATE TABLE magic_card_subtypes (
	magic_card_subtype_id INT AUTO_INCREMENT PRIMARY KEY,
    subtype VARCHAR(100) NOT NULL
 );
 
 -- 3.3.2 Subtype Junction Table
 CREATE TABLE magic_cards_subtypes_relations (
    magic_card_id INT,
    magic_card_subtype_id INT,
    PRIMARY KEY (magic_card_id, magic_card_subtype_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_subtype_id) REFERENCES magic_card_subtypes(magic_card_subtype_id) ON DELETE CASCADE
);

 -- 3.4.1 Cardtype Table
  CREATE TABLE magic_card_card_types (
	magic_card_card_type_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type VARCHAR(100) NOT NULL
 );
 -- 3.4.2 Cardtype Junction Table
  CREATE TABLE magic_cards_card_types_relations (
    magic_card_id INT,
    magic_card_card_type_id INT,
    PRIMARY KEY (magic_card_id, magic_card_card_type_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_card_type_id) REFERENCES magic_card_card_types(magic_card_card_type_id) ON DELETE CASCADE
);
 
-- 4. User Collection Table
CREATE TABLE user_collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    card_id INT,
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
CREATE INDEX idx_user_id ON user_collections(user_id);
CREATE INDEX idx_card_id ON user_collections(card_id);
CREATE INDEX idx_trade_status ON trades(status);

-- Testing
INSERT INTO games (name) VALUES ('Magic the Gathering');
INSERT INTO card_sets (name,release_date, total_cards) VALUES ('Test Set', 2024, 8);
INSERT INTO cards (name, card_set_id) VALUES ('Plains', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Common', 'Marco Gorlei', 'https://cards.scryfall.io/large/front/1/b/1b499b37-efaf-4484-95e8-a70a9778c804.jpg?1726286908', false, 1);
INSERT INTO magic_card_card_types (card_type) VALUES ('Land');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (1, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Atris, Oracle of Half-Truths', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Bastien L. Deharme', 'https://cards.scryfall.io/large/front/d/b/db6c91ec-df14-460f-967c-f182562fe7d8.jpg?1581480984', true, 2);
INSERT INTO magic_card_card_types (card_type) VALUES ('Creature');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (2, 2);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (3 ,2, 2);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 2);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Blue', 1);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Black', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (2, 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (2, 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (2, 3);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Human');
INSERT INTO magic_card_subtypes (subtype) VALUES ('Advisor');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (2, 1);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (2, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Bosh, Iron Golem', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Brom', 'https://cards.scryfall.io/large/front/9/b/9bfe325c-8d3d-4543-9fcd-214525d4ab2a.jpg?1610664155', true, 3);
INSERT INTO magic_card_card_types (card_type) VALUES ('Artifact');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (3, 2);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (3, 3);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (6 , 7, 3);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 8);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (3, 4);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Golem');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (3, 3);
INSERT INTO cards (name, card_set_id) VALUES ('Time Wipe', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Svetlin Velinov', 'https://cards.scryfall.io/large/front/2/1/2198907e-a13a-42e4-ad79-ac7efba4e610.jpg?1726285269', false, 4);
INSERT INTO magic_card_card_types (card_type) VALUES ('Sorcery');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (4, 4);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 2);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('White', 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 5);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 6);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Millstone', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Uncommon', 'Yeong-Hao Han', 'https://cards.scryfall.io/large/front/c/2/c2051fd0-99cf-4e11-a625-8294e6767e5b.jpg?1562304298', false, 5);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (5, 3);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (5, 5);
INSERT INTO cards (name, card_set_id) VALUES ('Feral Invocation', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Common', 'Mathias Kollros', 'https://cards.scryfall.io/large/front/1/9/190ad379-1a0f-4598-b5b1-453955846597.jpg?1601082585', false, 6);
INSERT INTO magic_card_card_types (card_type) VALUES ('Enchantment');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (6, 5);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Green', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (6, 5);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (6, 7);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Aura');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (6, 4);
INSERT INTO cards (name, card_set_id) VALUES ('Spectral Shift', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'John Avon', 'https://cards.scryfall.io/large/front/b/1/b1a3f75d-9a79-4c16-8f50-43a18add4579.jpg?1562879230', false, 7);
INSERT INTO magic_card_card_types (card_type) VALUES ('Instant');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (7, 6);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (7, 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (7, 8);
INSERT INTO cards (name, card_set_id) VALUES ('Selesnya Guildmage', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Uncommon', 'Mark Zug', 'https://cards.scryfall.io/large/front/9/5/954b8e86-284a-4a6f-ac35-896afd414f8a.jpg?1706240171', false, 8);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (8, 2);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (2, 2, 8);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Green/White', 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (8, 9);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Elf');
INSERT INTO magic_card_subtypes (subtype) VALUES ('Wizard');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (8, 5);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (8, 6);




-- Land Table
SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type
FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id
WHERE mcct.card_type = 'Land';

-- Creature Table
SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcc.power, mcc.toughness, mcmc.color, mcmc.quantity, mcst.subtype
FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
JOIN magic_card_creatures mcc ON mcc.magic_card_id = mc.magic_card_id
JOIN magic_cards_mana_costs_relations mcmcr ON mcmcr.magic_card_id = mc.magic_card_id
JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
WHERE mcct.card_type = 'Creature'; 

-- Instant Sorcery Artifact Enchantment Table
SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcmc.color, mcmc.quantity
FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
JOIN magic_cards_mana_costs_relations mcmcr ON mcmcr.magic_card_id = mc.magic_card_id
JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
WHERE mcct.card_type = 'Instant' or mcct.card_type = 'Sorcery' or mcct.card_type = 'Artifact'  or mcct.card_type = 'Enchantment';

-- Enchantment with Subtype Table
SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcmc.color, mcmc.quantity, mcst.subtype
FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
JOIN magic_cards_mana_costs_relations mcmcr ON mcmcr.magic_card_id = mc.magic_card_id
JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
WHERE mcct.card_type = 'Enchantment'; 
