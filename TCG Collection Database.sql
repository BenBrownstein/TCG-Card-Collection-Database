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

-- 3.1.2 Mana Cost Junction Table
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
 -- 3.3.1 Subtype Table
 create table magic_card_subtype (
	subtype_id INT AUTO_INCREMENT PRIMARY KEY,
    subtype varchar(100) not null
 );
 
 -- 3.3.2 Subtype Junction Table
 CREATE TABLE magic_card_subtype_relation (
    magic_card_id INT,
    subtype_id INT,
    PRIMARY KEY (magic_card_id, subtype_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (subtype_id) REFERENCES magic_card_subtype(subtype_id) ON DELETE CASCADE
);

 -- 3.4.1 Cardtype Table
  create table magic_card_card_type (
	card_type_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type varchar(100) not null
 );
 -- 3.4.2 Cardtype Junction Table
  CREATE TABLE magic_card_card_type_relation (
    magic_card_id INT,
    card_type_id INT,
    PRIMARY KEY (magic_card_id, card_type_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (card_type_id) REFERENCES magic_card_card_type(card_type_id) ON DELETE CASCADE
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
Insert into card_sets (set_name,release_date, total_cards) values ('Test Set', 2024, 8);
Insert into cards (card_name, set_id) values ('Plains', 1);
INSERT INTO magic_cards (rarity, artist, image_url, isLegendary, card_id)
VALUES ('Common', 'Marco Gorlei', 'https://cards.scryfall.io/large/front/1/b/1b499b37-efaf-4484-95e8-a70a9778c804.jpg?1726286908', false, 1);
Insert into magic_card_card_type (card_type) values ('Land');
insert into magic_card_card_type_relation (magic_card_id, card_type_id) Values (1, 1);
Insert into cards (card_name, set_id) values ('Atris, Oracle of Half-Truths', 1);
INSERT INTO magic_cards (rarity, artist, image_url, isLegendary, card_id)
VALUES ('Rare', 'Bastien L. Deharme', 'https://cards.scryfall.io/large/front/d/b/db6c91ec-df14-460f-967c-f182562fe7d8.jpg?1581480984', true, 2);
Insert into magic_card_card_type (card_type) values ('Creature');
insert into magic_card_card_type_relation (magic_card_id, card_type_id) Values (2, 2);
insert into magic_card_creature (power, toughness, magic_card_id) values (3 ,2, 2);
insert into magic_card_mana_cost (color, quantity) values ('Generic', 2);
insert into magic_card_mana_cost (color, quantity) values ('Blue', 1);
insert into magic_card_mana_cost (color, quantity) values ('Black', 1);
insert into magic_card_mana_cost_relation (magic_card_id, mana_cost_id) values (2, 1);
insert into magic_card_mana_cost_relation (magic_card_id, mana_cost_id) values (2, 2);
insert into magic_card_mana_cost_relation (magic_card_id, mana_cost_id) values (2, 3);
insert into magic_card_subtype (subtype) values ('Human');
insert into magic_card_subtype (subtype) values ('Advisor');
insert into magic_card_subtype_relation (magic_card_id, subtype_id) values (2, 1);
insert into magic_card_subtype_relation (magic_card_id, subtype_id) values (2, 2);



select c.card_name, mc.rarity, mc.artist, mc.image_url, mc.isLegendary, mcct.card_type
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_card_card_type_relation mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_type mcct on mcct.card_type_id = mcctr.card_type_id;

select c.card_name, mc.rarity, mc.artist, mc.image_url, mc.isLegendary, mcct.card_type, mcc.power, mcc.toughness, mcmc.color, mcmc.quantity, mcst.subtype
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_card_card_type_relation mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_type mcct on mcct.card_type_id = mcctr.card_type_id  
join magic_card_creature mcc on mcc.magic_card_id = mc.magic_card_id
join magic_card_mana_cost_relation mcmcr on mcmcr.magic_card_id = mc.magic_card_id
join magic_card_mana_cost mcmc on mcmc.mana_cost_id = mcmcr.mana_cost_id
join magic_card_subtype_relation mcstr on mcstr.magic_card_id = mc.magic_card_id
join magic_card_subtype mcst on mcst.subtype_id = mcstr.subtype_id; 