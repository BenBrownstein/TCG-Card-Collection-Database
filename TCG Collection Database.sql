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
Create table cards (
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
    is_Legendary boolean,
	FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- 3.1.1 Mana Cost Table
Create table magic_card_mana_costs (
	magic_card_mana_costs_id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL,
    quantity INT
);

-- 3.1.2 Mana Cost Junction Table
CREATE TABLE magic_cards_mana_costs_relation (
    magic_card_id INT,
    magic_card_mana_costs_id INT,
    PRIMARY KEY (magic_card_id, magic_card_mana_costs_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_mana_costs_id) REFERENCES magic_card_mana_costs(magic_card_mana_costs_id) ON DELETE CASCADE
);

-- 3.2.1 Creature Stats Table
Create table magic_card_creatures (
	magic_card_creature_id INT AUTO_INCREMENT PRIMARY KEY,
    power INT,
    toughness INT,
	magic_card_id INT,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE

);
 -- 3.3.1 Subtype Table
 create table magic_card_subtypes (
	magic_card_subtype_id INT AUTO_INCREMENT PRIMARY KEY,
    subtype varchar(100) not null
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
  create table magic_card_card_types (
	magic_card_card_type_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type varchar(100) not null
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
Insert into games (name) values ('Magic the Gathering');
Insert into card_sets (name,release_date, total_cards) values ('Test Set', 2024, 8);
Insert into cards (name, card_set_id) values ('Plains', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Common', 'Marco Gorlei', 'https://cards.scryfall.io/large/front/1/b/1b499b37-efaf-4484-95e8-a70a9778c804.jpg?1726286908', false, 1);
Insert into magic_card_card_types (card_type) values ('Land');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (1, 1);
Insert into cards (name, card_set_id) values ('Atris, Oracle of Half-Truths', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Bastien L. Deharme', 'https://cards.scryfall.io/large/front/d/b/db6c91ec-df14-460f-967c-f182562fe7d8.jpg?1581480984', true, 2);
Insert into magic_card_card_types (card_type) values ('Creature');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (2, 2);
insert into magic_card_creatures (power, toughness, magic_card_id) values (3 ,2, 2);
insert into magic_card_mana_costs (color, quantity) values ('Generic', 2);
insert into magic_card_mana_costs (color, quantity) values ('Blue', 1);
insert into magic_card_mana_costs (color, quantity) values ('Black', 1);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (2, 1);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (2, 2);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (2, 3);
insert into magic_card_subtypes (subtype) values ('Human');
insert into magic_card_subtypes (subtype) values ('Advisor');
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (2, 1);
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (2, 2);
Insert into cards (name, card_set_id) values ('Bosh, Iron Golem', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Brom', 'https://cards.scryfall.io/large/front/9/b/9bfe325c-8d3d-4543-9fcd-214525d4ab2a.jpg?1610664155', true, 3);
Insert into magic_card_card_types (card_type) values ('Artifact');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (3, 2);
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (3, 3);
insert into magic_card_creatures (power, toughness, magic_card_id) values (6 , 7, 3);
insert into magic_card_mana_costs (color, quantity) values ('Generic', 8);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (3, 4);
insert into magic_card_subtypes (subtype) values ('Golem');
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (3, 3);
Insert into cards (name, card_set_id) values ('Time Wipe', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'Svetlin Velinov', 'https://cards.scryfall.io/large/front/2/1/2198907e-a13a-42e4-ad79-ac7efba4e610.jpg?1726285269', false, 4);
Insert into magic_card_card_types (card_type) values ('Sorcery');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (4, 4);
insert into magic_card_mana_costs (color, quantity) values ('Generic', 2);
insert into magic_card_mana_costs (color, quantity) values ('White', 2);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (4, 5);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (4, 6);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (4, 2);
Insert into cards (name, card_set_id) values ('Millstone', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Uncommon', 'Yeong-Hao Han', 'https://cards.scryfall.io/large/front/c/2/c2051fd0-99cf-4e11-a625-8294e6767e5b.jpg?1562304298', false, 5);
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (5, 3);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (5, 5);
Insert into cards (name, card_set_id) values ('Feral Invocation', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Common', 'Mathias Kollros', 'https://cards.scryfall.io/large/front/1/9/190ad379-1a0f-4598-b5b1-453955846597.jpg?1601082585', false, 6);
Insert into magic_card_card_types (card_type) values ('Enchantment');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (6, 5);
insert into magic_card_mana_costs (color, quantity) values ('Green', 1);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (6, 5);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (6, 7);
insert into magic_card_subtypes (subtype) values ('Aura');
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (6, 4);
Insert into cards (name, card_set_id) values ('Spectral Shift', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Rare', 'John Avon', 'https://cards.scryfall.io/large/front/b/1/b1a3f75d-9a79-4c16-8f50-43a18add4579.jpg?1562879230', false, 7);
Insert into magic_card_card_types (card_type) values ('Instant');
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (7, 6);
insert into magic_card_mana_costs (color, quantity) values ('Generic', 1);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (7, 2);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (7, 8);
Insert into cards (name, card_set_id) values ('Selesnya Guildmage', 1);
INSERT INTO magic_cards (rarity, artist, image_url, is_Legendary, card_id)
VALUES ('Uncommon', 'Mark Zug', 'https://cards.scryfall.io/large/front/9/5/954b8e86-284a-4a6f-ac35-896afd414f8a.jpg?1706240171', false, 8);
insert into magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) Values (8, 2);
insert into magic_card_creatures (power, toughness, magic_card_id) values (2, 2, 8);
insert into magic_card_mana_costs (color, quantity) values ('Green/White', 2);
insert into magic_cards_mana_costs_relation (magic_card_id, magic_card_mana_costs_id) values (8, 9);
insert into magic_card_subtypes (subtype) values ('Elf');
insert into magic_card_subtypes (subtype) values ('Wizard');
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (8, 5);
insert into magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) values (8, 6);




-- Land Table
select c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_cards_card_types_relations mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_types mcct on mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id
where mcct.card_type = 'Land';

-- Creature Table
select c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcc.power, mcc.toughness, mcmc.color, mcmc.quantity, mcst.subtype
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_cards_card_types_relations mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_types mcct on mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
join magic_card_creatures mcc on mcc.magic_card_id = mc.magic_card_id
join magic_cards_mana_costs_relation mcmcr on mcmcr.magic_card_id = mc.magic_card_id
join magic_card_mana_costs mcmc on mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
join magic_cards_subtypes_relations mcstr on mcstr.magic_card_id = mc.magic_card_id
join magic_card_subtypes mcst on mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
where mcct.card_type = 'Creature'; 

-- Instant Sorcery Artifact Enchantment Table
select c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcmc.color, mcmc.quantity
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_cards_card_types_relations mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_types mcct on mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
join magic_cards_mana_costs_relation mcmcr on mcmcr.magic_card_id = mc.magic_card_id
join magic_card_mana_costs mcmc on mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
where mcct.card_type = 'Instant' or mcct.card_type = 'Sorcery' or mcct.card_type = 'Artifact'  or mcct.card_type = 'Enchantment';

-- Enchantment with Subtype Table
select c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type, mcmc.color, mcmc.quantity, mcst.subtype
from cards c join magic_cards mc on c.card_id = mc.card_id
join magic_cards_card_types_relations mcctr on mcctr.magic_card_id = mc.magic_card_id
join magic_card_card_types mcct on mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id  
join magic_cards_mana_costs_relation mcmcr on mcmcr.magic_card_id = mc.magic_card_id
join magic_card_mana_costs mcmc on mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id
join magic_cards_subtypes_relations mcstr on mcstr.magic_card_id = mc.magic_card_id
join magic_card_subtypes mcst on mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
where mcct.card_type = 'Enchantment'; 
