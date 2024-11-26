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
    total_cards INT NOT NULL,
    game_id INT NOT NULL,
	FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

-- 3. Card Table
CREATE TABLE cards (
	card_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	card_set_id INT NOT NULL,
    FOREIGN KEY (card_set_id) REFERENCES card_sets(card_set_id) ON DELETE CASCADE
);

-- 3.1 Magic Cards Table 
CREATE TABLE magic_cards (
    magic_card_id INT AUTO_INCREMENT PRIMARY KEY,
    rarity VARCHAR(20) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    card_id INT NOT NULL,
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
    magic_card_id INT NOT NULL,
    magic_card_mana_costs_id INT NOT NULL,
    PRIMARY KEY (magic_card_id, magic_card_mana_costs_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_mana_costs_id) REFERENCES magic_card_mana_costs(magic_card_mana_costs_id) ON DELETE CASCADE
);

-- 3.2.1 Creature Stats Table
CREATE TABLE magic_card_creatures (
	magic_card_creature_id INT AUTO_INCREMENT PRIMARY KEY,
    power INT NOT NULL,
    toughness INT NOT NULL,
	magic_card_id INT NOT NULL,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE

);
 -- 3.3.1 Subtype Table
 CREATE TABLE magic_card_subtypes (
	magic_card_subtype_id INT AUTO_INCREMENT PRIMARY KEY,
    subtype VARCHAR(100) NOT NULL
 );
 
 -- 3.3.2 Subtype Junction Table
 CREATE TABLE magic_cards_subtypes_relations (
    magic_card_id INT NOT NULL,
    magic_card_subtype_id INT NOT NULL,
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
    magic_card_id INT NOT NULL,
    magic_card_card_type_id INT NOT NULL,
    PRIMARY KEY (magic_card_id, magic_card_card_type_id),
    FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_card_type_id) REFERENCES magic_card_card_types(magic_card_card_type_id) ON DELETE CASCADE
);

-- 3.5.1 Card Flavor Text Table
  CREATE TABLE magic_card_flavor_text (
	magic_card_flavor_text_id INT AUTO_INCREMENT PRIMARY KEY,
    f_text LONG NOT NULL,
	magic_card_id INT NOT NULL,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE
 );
 
-- 3.6.1 Card Effect Text Table
  CREATE TABLE magic_card_effect_text (
	magic_card_effect_text_id INT AUTO_INCREMENT PRIMARY KEY,
    text LONG NOT NULL,
    tap BOOLEAN NOT NULL,
	magic_card_id INT NOT NULL,
	FOREIGN KEY (magic_card_id) REFERENCES magic_cards(magic_card_id) ON DELETE CASCADE
 );

-- 3.6.2 Card Effect Mana Cost Junction Table
 CREATE TABLE mana_costs_card_effect_relations (
    magic_card_effect_text_id INT NOT NULL,
    magic_card_mana_costs_id INT NOT NULL,
    PRIMARY KEY (magic_card_effect_text_id, magic_card_mana_costs_id),
    FOREIGN KEY (magic_card_effect_text_id) REFERENCES magic_card_effect_text(magic_card_effect_text_id) ON DELETE CASCADE,
    FOREIGN KEY (magic_card_mana_costs_id) REFERENCES magic_card_mana_costs(magic_card_mana_costs_id) ON DELETE CASCADE
);
 
-- 4. User Collection Table
CREATE TABLE user_collections (
    collection_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    card_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- Example Cards
INSERT INTO games (name) VALUES ('Magic the Gathering');
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Duskmourn: House of Horror', 417, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Plains', 1);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Common', 'Marco Gorlei', 'https://cards.scryfall.io/large/front/1/b/1b499b37-efaf-4484-95e8-a70a9778c804.jpg?1726286908', 1);
INSERT INTO magic_card_card_types (card_type) VALUES ('Land');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (1, 1);
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Theros Beyond Death', 358,1);
INSERT INTO cards (name, card_set_id) VALUES ('Atris, Oracle of Half-Truths', 2);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Rare', 'Bastien L. Deharme', 'https://cards.scryfall.io/large/front/d/b/db6c91ec-df14-460f-967c-f182562fe7d8.jpg?1581480984', 2);
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
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Mirrodin', 306, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Bosh, Iron Golem', 3);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Rare', 'Brom', 'https://cards.scryfall.io/large/front/9/b/9bfe325c-8d3d-4543-9fcd-214525d4ab2a.jpg?1610664155', 3);
INSERT INTO magic_card_card_types (card_type) VALUES ('Artifact');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (3, 2);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (3, 3);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (6 , 7, 3);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 8);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (3, 4);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Golem');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (3, 3);
INSERT INTO card_sets (name, total_cards,game_id) VALUES ('Duskmourn: House of Horror Commander', 373, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Time Wipe', 4);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Rare', 'Svetlin Velinov', 'https://cards.scryfall.io/large/front/2/1/2198907e-a13a-42e4-ad79-ac7efba4e610.jpg?1726285269', 4);
INSERT INTO magic_card_card_types (card_type) VALUES ('Sorcery');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (4, 4);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('X', 2);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('White', 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 6);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (4, 2);
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Core Set 2019', 314, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Millstone', 5);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Uncommon', 'Yeong-Hao Han', 'https://cards.scryfall.io/large/front/c/2/c2051fd0-99cf-4e11-a625-8294e6767e5b.jpg?1562304298', 5);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (5, 3);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (5, 1);
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Jumpstart', 497, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Feral Invocation', 6);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Common', 'Mathias Kollros', 'https://cards.scryfall.io/large/front/1/9/190ad379-1a0f-4598-b5b1-453955846597.jpg?1601082585', 6);
INSERT INTO magic_card_card_types (card_type) VALUES ('Enchantment');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (6, 5);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Green', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (6, 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (6, 7);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Aura');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (6, 4);
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Fifth Dawn', 165, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Spectral Shift', 7);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Rare', 'John Avon', 'https://cards.scryfall.io/large/front/b/1/b1a3f75d-9a79-4c16-8f50-43a18add4579.jpg?1562879230', 7);
INSERT INTO magic_card_card_types (card_type) VALUES ('Instant');
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (7, 6);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (7, 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (7, 8);
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Ravnica: Clue Edition', 284, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Selesnya Guildmage', 8);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Uncommon', 'Mark Zug', 'https://cards.scryfall.io/large/front/9/5/954b8e86-284a-4a6f-ac35-896afd414f8a.jpg?1706240171', 8);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (8, 2);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (2, 2, 8);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Green/White', 2);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (8, 9);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Elf');
INSERT INTO magic_card_subtypes (subtype) VALUES ('Wizard');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (8, 5);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (8, 6);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Plains');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (1, 7);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Legendary');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (2, 8);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (3, 8);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Menance', False, 2);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('When Atris, Oracle of Half-Truths enters the battlefield, target opponent looks at the top three cards of your library and separates them into a face-down pile and a face-up pile. Put one pile into your hand and the other into your graveyard.', False, 2);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Trample', False, 3);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ("Sacrifice an artifact: Bosh, the Iron Golem deals damage equal to the sacrificed artifact's converted mana cost to target creature or player.", False, 3);
INSERT INTO magic_card_flavor_text (f_text, magic_card_id) VALUES ('As Glissa searches for the truth about Memnarch, Bosh searches to unearth the secrets buried deep in his memory.', 3);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Red', 1);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Generic', 3);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (4, 10);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (4, 11);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Create a 1/1 green Saproling creature token.', False, 8);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (5, 11);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (5, 7);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES (' Creatures you control get +1/+1 until end of turn.', False, 8);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (6, 11);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('White', 1);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (6, 12);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Target player mills two cards.', True, 5);
INSERT INTO magic_card_flavor_text (f_text, magic_card_id) VALUES ("Minds, like mountains, are never so grand and mighty that they can't be reduced to dust.", 5);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (7, 1);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ("Return a creature you control to its owner's hand, then destroy all creatures.", False, 4);
INSERT INTO magic_card_flavor_text (f_text, magic_card_id) VALUES ('"To comprehend the full answer requires years of temporal study. In short, they were now never born in the first place."
—Tefer', 4);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Flash', False, 6);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Enchant Creature', False, 6);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Enchanted creature gets +2/+2.', False, 6);
INSERT INTO magic_card_flavor_text (f_text, magic_card_id) VALUES ("Nylea's sacred lynx guards those who honor the Nessian Wood and hunts those who don't.", 6);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Choose one', False, 7);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Change the text of target spell or permanent by replacing all instances of one basic land type with another. (This effect lasts indefinitely.)', False, 7);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Change the text of target spell or permanent by replacing all instances of one color word with another. (This effect lasts indefinitely.)', False, 7);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Entwine', False, 7);
INSERT INTO mana_costs_card_effect_relations (magic_card_effect_text_id, magic_card_mana_costs_id) VALUES (15, 1);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Bloomburrow', 281, 1);
INSERT INTO cards (name, card_set_id) VALUES ('Mockingbird', 9);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Rare', 'Aurore Folny', 'https://cards.scryfall.io/large/front/a/d/ade32396-8841-4ba4-8852-d11146607f21.jpg?1722388218', 9);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (9, 2);
INSERT INTO magic_card_creatures (power, toughness, magic_card_id) VALUES (1, 1, 9);
INSERT INTO magic_card_mana_costs (color, quantity) VALUES ('Variable', 1);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (9, 13);
INSERT INTO magic_cards_mana_costs_relations (magic_card_id, magic_card_mana_costs_id) VALUES (9, 2);
INSERT INTO magic_card_subtypes (subtype) VALUES ('Bird');
INSERT INTO magic_card_subtypes (subtype) VALUES ('Bard');
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (9, 9);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (9, 10);
INSERT INTO magic_card_flavor_text (f_text, magic_card_id) VALUES ("“Laughing at you? No, no, I’m laughing as you!”", 9);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('Flying', False, 9);
INSERT INTO magic_card_effect_text (text, tap, magic_card_id) VALUES ('You may have Mockingbird enter as a copy of any creature on the battlefield with mana value less than or equal to the amount of mana spent to cast Mockingbird, except it’s a Bird in addition to its other types and it has flying.', False, 9);
INSERT INTO cards (name, card_set_id) VALUES ('Plains', 9);
INSERT INTO magic_cards (rarity, artist, image_url, card_id)
VALUES ('Common', 'Carlos Palma Cruchaga', 'https://cards.scryfall.io/large/front/3/6/3663ff0c-d02f-49ac-bb88-6f0dbd684337.jpg?1721427370', 10);
INSERT INTO magic_cards_card_types_relations (magic_card_id, magic_card_card_type_id) VALUES (10, 1);
INSERT INTO magic_cards_subtypes_relations (magic_card_id, magic_card_subtype_id) VALUES (10, 7);


-- 5 Yu-Gi-Oh Tables
-- 5.1 Yugioh Card
CREATE TABLE ygo_cards (
	ygo_card_id INT AUTO_INCREMENT PRIMARY KEY,
    card_type VARCHAR(50) NOT NULL,
    rarity VARCHAR(50) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    card_id INT NOT NULL,
	FOREIGN KEY (card_id) REFERENCES cards(card_id) ON DELETE CASCADE
);

-- 5.2.1 Subtype Table
CREATE TABLE ygo_cards_subtypes(
	ygo_card_subtype_id INT AUTO_INCREMENT PRIMARY KEY,
	subtype VARCHAR(100) NOT NULL
);

 -- 5.2.2 Subtype Junction Table
 CREATE TABLE ygo_cards_subtypes_relations (
    ygo_card_id INT NOT NULL,
    ygo_card_subtype_id INT NOT NULL,
    PRIMARY KEY (ygo_card_id, ygo_card_subtype_id),
    FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE,
    FOREIGN KEY (ygo_card_subtype_id) REFERENCES ygo_cards_subtypes(ygo_card_subtype_id) ON DELETE CASCADE
);

-- 5.3 Card Flavor Text Table
  CREATE TABLE ygo_card_flavor_text (
	ygo_card_flavor_text_id INT AUTO_INCREMENT PRIMARY KEY,
    f_text LONG NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
 );
 
-- 5.4 Card Effect Text Table
  CREATE TABLE ygo_card_effect_text (
	ygo_card_effect_text_id INT AUTO_INCREMENT PRIMARY KEY,
    text LONG NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
 );
 
-- 5.5.1 Monster Card Table
CREATE TABLE ygo_card_monster_cards(
	ygo_card_monster_cards_id INT AUTO_INCREMENT PRIMARY KEY,
	attribute VARCHAR(100) NOT NULL,
	type VARCHAR(100) NOT NULL,
    atk INT NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);

-- 5.5.2 Monster Card Defense Table
CREATE TABLE ygo_card_monster_cards_defense(
	ygo_card_monster_cards_defense_id INT AUTO_INCREMENT PRIMARY KEY,
    def INT NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);

-- 5.5.3 Monster Card Level Table
CREATE TABLE ygo_card_monster_cards_level(
	ygo_card_monster_cards_level_id INT AUTO_INCREMENT PRIMARY KEY,
    level INT NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);

-- 5.5.3 Monster Card Material Table
CREATE TABLE ygo_card_monster_cards_material(
	ygo_card_monster_cards_material_id INT AUTO_INCREMENT PRIMARY KEY,
    material LONG NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);

-- 5.5.4 XYZ Rank Table
CREATE TABLE ygo_card_xyz_monster_cards_rank(
	ygo_card_xyz_monster_cards_rank_id INT AUTO_INCREMENT PRIMARY KEY,
    ranks INT NOT NULL, -- Mechanic is called Rank but using ranks to avoid an error
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);

-- 5.5.4 Link Monster Table
CREATE TABLE ygo_card_link_monster_cards(
	ygo_card_link_monster_cards_id INT AUTO_INCREMENT PRIMARY KEY,
    link_rating INT NOT NULL,
    top_left BOOLEAN NOT NULL,
	top_center BOOLEAN NOT NULL,
	top_right BOOLEAN NOT NULL,
    middle_left BOOLEAN NOT NULL,
    middle_right BOOLEAN NOT NULL,
    bottom_left BOOLEAN NOT NULL,
    bottom_center BOOLEAN NOT NULL,
    bottom_right BOOLEAN NOT NULL,
	ygo_card_id INT NOT NULL,
	FOREIGN KEY (ygo_card_id) REFERENCES ygo_cards(ygo_card_id) ON DELETE CASCADE
);
INSERT INTO games (name) VALUES ('Yu-Gi-Oh');
INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Legend of Blue Eyes White Dragon', 126, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Pot of Greed', 10);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Spell', 'Rare', 'https://ms.yugipedia.com//thumb/2/23/PotofGreed-TBC1-EN-UPR-LE.png/300px-PotofGreed-TBC1-EN-UPR-LE.png' , 11);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ('Draw 2 cards', 1);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Metal Raiders', 144, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Mirror Force', 11);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Trap', 'Ultra Rare', 'https://ms.yugipedia.com//thumb/d/de/MirrorForce-RA03-EN-PlScR-1E.png/300px-MirrorForce-RA03-EN-PlScR-1E.png' , 12);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("When an opponent's monster declares an attack: Destroy all your opponent's Attack Position monsters.", 2);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Raging Battle', 100, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Forbidden Chalice', 12);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Spell', 'Ultra Rare', 'https://ms.yugipedia.com//thumb/0/0f/ForbiddenChalice-OP19-EN-SR-UE.png/300px-ForbiddenChalice-OP19-EN-SR-UE.png' , 13);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Quick-Play');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (3,1);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("Target 1 face-up monster on the field; until the end of this turn, that target gains 400 ATK, but its effects are negated.", 3);

INSERT INTO cards (name, card_set_id) VALUES ('Solemn Judgment', 11);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Trap', 'Ultra Rare', 'https://ms.yugipedia.com//thumb/6/65/SolemnJudgment-RA02-EN-SR-1E.png/300px-SolemnJudgment-RA02-EN-SR-1E.png' , 14);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Counter');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (4,2);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("When a monster(s) would be Summoned, OR a Spell/Trap Card is activated: Pay half your LP; negate the Summon or activation, and if you do, destroy that card.", 4);

INSERT INTO cards (name, card_set_id) VALUES ('Blue-Eyes White Dragon', 10);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Ultra Rare', 'https://yugipedia.com/thumb.php?f=BlueEyesWhiteDragon-RA03-EN-PlScR-1E.png&w=300' , 15);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Light', 'Dragon', 3000, 5);
INSERT INTO ygo_card_monster_cards_defense (def, ygo_card_id) VALUES (2500, 5);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Normal');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (5,3);
INSERT INTO ygo_card_flavor_text (f_text, ygo_card_id) VALUES ("This legendary dragon is a powerful engine of destruction. Virtually invincible, very few have faced this awesome creature and lived to tell the tale.", 5);
INSERT INTO ygo_card_monster_cards_level (level, ygo_card_id) VALUES (8, 5);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Darkwing Blast', 100, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Bystial Druiswurm', 13);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Super Rare', 'https://ms.yugipedia.com//thumb/5/59/BystialDruiswurm-MP23-EN-PScR-1E.png/300px-BystialDruiswurm-MP23-EN-PScR-1E.png' , 16);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Dark', 'Dragon', 2500, 6);
INSERT INTO ygo_card_monster_cards_defense (def, ygo_card_id) VALUES (2000, 6);
INSERT INTO ygo_card_monster_cards_level (level, ygo_card_id) VALUES (6, 6);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Effect');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (6,4);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("You can target 1 LIGHT or DARK monster in either GY; banish it, and if you do, Special Summon this card from your hand. This is a Quick Effect if your opponent controls a monster.", 6);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("If this card is sent from the field to the GY: You can target 1 Special Summoned monster your opponent controls; send it to the GY.", 6);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ('You can only use each effect of "Bystial Druiswurm" once per turn.', 6);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('The Duelist Genesis', 100, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Krebons', 14);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Common', 'https://ms.yugipedia.com//thumb/a/af/Krebons-RA03-EN-PlScR-1E.png/300px-Krebons-RA03-EN-PlScR-1E.png' , 17);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Dark', 'Psychic', 1200, 7);
INSERT INTO ygo_card_monster_cards_defense (def, ygo_card_id) VALUES (400, 7);
INSERT INTO ygo_card_monster_cards_level (level, ygo_card_id) VALUES (2, 7);
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (7,4);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Tuner');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (7,5);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("When this card is targeted for an attack: You can pay 800 LP; negate the attack.", 7);

INSERT INTO cards (name, card_set_id) VALUES ('Tilting Entrainment', 13);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Common', 'https://ms.yugipedia.com//thumb/7/7d/TiltingEntrainment-DABL-EN-C-1E.png/300px-TiltingEntrainment-DABL-EN-C-1E.png' , 18);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Earth', 'Machine', 2800, 8);
INSERT INTO ygo_card_monster_cards_defense (def, ygo_card_id) VALUES (1600, 8);
INSERT INTO ygo_card_monster_cards_level (level, ygo_card_id) VALUES (8, 8);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Synchro');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (8,6);
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (8,4);
INSERT INTO ygo_card_monster_cards_material (material, ygo_card_id) VALUES ('1 Tuner + 1+ non-Tuner monsters', 8);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("If this card is Synchro Summoned: You can Special Summon 1 Level 4 or lower Pendulum Monster from your hand or face-up from your Extra Deck.", 8);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("At the end of the Damage Step, when this card or your Pendulum Monster battles an opponent's monster, but the opponent's monster was not destroyed by the battle: You can destroy that opponent's monster.", 8);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ('You can only use each effect of "Tilting Entrainment" once per turn.', 8);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Battle Pack: Epic Dawn', 220, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Gem-Knight Pearl', 15);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Rare', 'https://ms.yugipedia.com//4/46/GemKnightPearl-DEM4-EN-C-UE.png' , 19);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Earth', 'Rock', 2600, 9);
INSERT INTO ygo_card_monster_cards_defense (def, ygo_card_id) VALUES (1900, 9);
INSERT INTO ygo_card_xyz_monster_cards_rank (ranks, ygo_card_id) VALUES (4, 9);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('XYZ');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (9,7);
INSERT INTO ygo_card_monster_cards_material (material, ygo_card_id) VALUES ('2 Level 4 monsters', 9);

INSERT INTO card_sets (name, total_cards, game_id) VALUES ('Battle of Chaos', 100, 2);
INSERT INTO cards (name, card_set_id) VALUES ('Dharc the Dark Charmer, Gloomy', 16);
INSERT INTO ygo_cards (card_type, rarity, image_url, card_id) VALUES ('Monster', 'Super Rare', 'https://ms.yugipedia.com//thumb/a/ac/DharctheDarkCharmerGloomy-RA03-EN-SR-1E.png/300px-DharctheDarkCharmerGloomy-RA03-EN-SR-1E.png' , 20);
INSERT INTO ygo_card_monster_cards (attribute, type, atk, ygo_card_id) VALUES ('Dark', 'Spellcaster', 1850, 10);
INSERT INTO ygo_card_link_monster_cards (link_rating, top_left, top_center, top_right, middle_left, middle_right, bottom_left, bottom_center, bottom_right, ygo_card_id) VALUES (2, false , false, false ,false ,false , true, false , true, 10);
INSERT INTO ygo_cards_subtypes (subtype) VALUES ('Link');
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (10,8);
INSERT INTO ygo_cards_subtypes_relations (ygo_card_id, ygo_card_subtype_id) VALUES (10,4);
INSERT INTO ygo_card_monster_cards_material (material, ygo_card_id) VALUES ('2 monsters, including a DARK monster', 10);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ('(This card is always treated as a "Familiar-Possessed" card.)', 10);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("You can target 1 DARK monster in your opponent's GY; Special Summon it to your zone this card points to.", 10);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ("If this Link Summoned card is destroyed by battle, or is destroyed by an opponent's card effect while in its owner's Monster Zone: You can add 1 DARK monster with 1500 or less DEF from your Deck to your hand. ", 10);
INSERT INTO ygo_card_effect_text (text, ygo_card_id) VALUES ('You can only use each effect of "Dharc the Dark Charmer, Gloomy" once per turn.', 10);
