<h1>Full information of a card in the Database</h1>

<?php
    //Connects to database
    include 'connection.php';
    //Shows user info and make sure they are logged in
    include 'dashboard.php';

    // If there is a card id set that is not null
    if(isset($_GET['card_id']) && !empty($_GET['card_id']))
    {
        //Santizes card id to protect against script injection
        $card_id = htmlspecialchars($_GET['card_id']);

        //Checks to make sure that the card is from Magic the Gathering and if not sends them back to the home page also protects against going to card ids not in the database as they do not have a game associated with them
        $game = "SELECT g.game_id FROM games g
        JOIN card_sets cs ON cs.game_id = g.game_id
        JOIN cards c ON c.card_set_id= cs.card_set_id WHERE c.card_id = $card_id";
        $gameresult = $conn->query($game);
        $gameresult = $gameresult->fetch_assoc();
        if ($gameresult["game_id"] != 1) {
                header("Location: index.php");
                exit();
        }
        
        //Shows card name, card rarity, card artist, and the card image for selected card
        $cards = "SELECT c.name, mc.rarity, mc.artist, mc.image_url FROM cards c 
        JOIN magic_cards mc ON c.card_id = mc.card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        $fetchedcard = $cardresult->fetch_assoc();
        echo "Name: " . $fetchedcard["name"]. "<br>". "Rarity: " . $fetchedcard["rarity"]. "<br>". "Artist: " . $fetchedcard["artist"]. "<br>"."Image: ". "<img src=". $fetchedcard["image_url"]. "/>". "<br>";
        
        //Shows Set name for selected card
        $cards = "SELECT cs.name from card_sets cs 
        JOIN cards c ON c.card_set_id = cs.card_set_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        $fetchedcard = $cardresult->fetch_assoc();
        echo "Set: ". $fetchedcard["name"]. "<br>";
    
        //Gets Card Type for selected card id
        $cards = "SELECT mcct.card_type  FROM cards c
        JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
        JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // If there is no card type it prints nothing
        if ($cardresult->num_rows > 0) {
            echo "Card Type: ";
            //Loops because some cards can have multiple card types
            while($row = $cardresult->fetch_assoc()) {
                echo $row["card_type"]. " ";
            }
            echo "<br>";
        }

        //Gets Subtype for selected card
        $cards = "SELECT mcst.subtype
        FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
        JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
        WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // If there is no subtype it prints nothing
        if ($cardresult->num_rows > 0) {
            echo "Subtype: ";
            //Loops because some cards can have multiple  subtypes
            while($row = $cardresult->fetch_assoc()) {
                echo $row["subtype"]. " ";
            }
            echo "<br>";
        }

        //Gets the mana cost of the selected card
        $cards = "SELECT mcmc.color, mcmc.quantity
        FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_cards_mana_costs_relations mcmcr ON mcmcr.magic_card_id = mc.magic_card_id
        JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if there is no mana cost
        if ($cardresult->num_rows > 0) {
            echo "Mana Cost: ";
            // Cards can have multiple kinds of mana for their cost so it loops to get all of them
            while($row = $cardresult->fetch_assoc()) {
                echo $row["quantity"]. "-" . $row["color"]. " ";
            }
            echo "<br>";
        }

        //Gets the stats of the selected card
        $cards = "SELECT mcc.power, mcc.toughness FROM cards c 
        JOIN magic_cards mc ON c.card_id = mc.card_id 
        JOIN magic_card_creatures mcc ON mcc.magic_card_id = mc.magic_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card does not have power or toughness
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Stats: ". $cardresult["power"]. "/". $cardresult["toughness"]. "<br>";
        }

        //Grabs the effect of the selected cards
        $cards = "SELECT mcet.text, mcet.tap, mcet.magic_card_effect_text_id, mc.magic_card_id 
        FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id 
        WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);

        //Grabs the effects mana values of the selected card
        $manaCards = "SELECT mcmc.color, mcmc.quantity, macer.magic_card_effect_text_id, mc.magic_card_id 
        FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id 
        JOIN mana_costs_card_effect_relations macer ON macer.magic_card_effect_text_id = mcet.magic_card_effect_text_id
        JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = macer.magic_card_mana_costs_id
        WHERE c.card_id = $card_id";
        $cardresultmana = $conn->query($manaCards);

        // Fetch mana costs into an associative array grouped by `magic_card_effect_text_id`
        $manaData = [];
        while ($row2 = $cardresultmana->fetch_assoc()) {
            $effectId = $row2['magic_card_effect_text_id'];
            $manaData[$effectId][] = $row2; // Group by `magic_card_effect_text_id`
        }
        //If the card has no effect this is skipped
        if ($cardresult->num_rows > 0) {
            //Loops because cards can have multiple effects
            while ($row = $cardresult->fetch_assoc()) {
                $effectId = $row["magic_card_effect_text_id"];
                // Display colors and quantities for this effect ID as quantity-color
                if (isset($manaData[$effectId])) {
                    foreach ($manaData[$effectId] as $manaRow) {
                      echo $manaRow["quantity"] . "-" . $manaRow["color"] . " ";
                    }
                }

                //If the card does not have a tap effect then it does not display tap before showing the text
                if ($row["tap"] == 0)
                {
                echo "Effect Text: " . $row["text"] . "<br>";
                } else {
                    echo "Effect Text: Tap. " . $row["text"] . "<br>";
                }
            }
    }
        //Gets the flavor text of the selected card
        $cards = "SELECT mcft.f_text
        FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
        JOIN magic_card_flavor_text mcft ON mcft.magic_card_id = mc.magic_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // Not every card has flavor text so it might be skipped
        if ($cardresult->num_rows > 0) {
            $cardresult = $cardresult->fetch_assoc();   
            echo "Flavor Text: " . $cardresult["f_text"]. "<br>";    
            
        }
  }
?>
<!-- Button for adding selected card to collection -->
<form method='post'>
<input type='submit' name = "add" value='Add to collection'/>
</form>
<?php
// If the button is pushed adds it to colection of the signed in user
if(isset($_POST['add']))
{
    //Gets the user
    $user = $_SESSION['user_id'];
    //Gets the card id
    $card_id = $_GET['card_id'];
    //Grabs the collection of that user
    $collection = "SELECT * FROM user_collections WHERE user_id = $user";
    $collection_result = $conn->query($collection);
    //Preps the variable to add the card to the collection
    $add_to_collection = "INSERT INTO user_collections (user_id, card_id, quantity) VALUES ($user, $card_id  , 1)";
    // Checks the collection to see if the card is already in the collection
    if ($collection_result->num_rows > 0) {
        while ($row = $collection_result->fetch_assoc()) {
            //If the card is in the collection change $add_to_collection to instead update the collection to increase the qunatity by 1 
            if($row['card_id'] == $card_id)
            {
                $quantity = $row['quantity'] + 1;
                $add_to_collection = "UPDATE user_collections SET quantity=$quantity WHERE card_id = $card_id AND user_id = $user";
            }
        }
    }

    // Execute the query
    if ($conn->query($add_to_collection) === TRUE) {
        echo "Card added to your collection!<br>";
    } else {
        echo "Error: " . $conn->error . "<br>";
    }
}
?>
<!-- Link back to home page -->
<a href="index.php">Home</a>
