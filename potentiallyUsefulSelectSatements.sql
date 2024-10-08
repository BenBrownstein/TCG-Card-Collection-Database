-- Shows all Card names in set 1
select card_name from cards where card_id = 1;

-- Shows all magic cards and creature stats sorting by creature power
SELECT * FROM magic_cards 
JOIN 
magic_card_creature on magic_card_id = magic_card_creature.magic_card_id
Order by magic_card_creature.power;

-- Shows all magic cards and mana color sorting by cost
SELECT * FROM magic_cards 
JOIN 
    magic_card_mana_cost_relation ON magic_cards.magic_card_id = magic_card_mana_cost_relation.magic_card_id
JOIN 
    magic_card_mana_cost ON magic_card_mana_cost_relation.mana_cost_id = magic_card_mana_cost.mana_cost_id
Order by magic_card_mana_cost.quanity;

-- Displays all Game ids that have sets in the database
Select Distinct game_id from card_sets;

