<head>
<link rel="stylesheet" href="style.css">

</head>

<h1>Full information of a card in the Database</h1>

<?php
    //Connects to database
    include 'connection.php';
    //Shows user info and make sure they are logged in
    include 'dashboard.php';

    // If there is a card id set that is not null
    if(isset($_GET['card_id']) && !empty($_GET['card_id']))
    {
        $card_id = htmlspecialchars($_GET['card_id']);
        $cards = "SELECT * FROM cards c 
        JOIN magic_cards mc ON c.card_id = mc.card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        $fetchedcard = $cardresult->fetch_assoc();
        echo "Name: " . $fetchedcard["name"]. "<br>". "Rarity: " . $fetchedcard["rarity"]. "<br>". "Artist: " . $fetchedcard["artist"]. "<br>"."Image: ". "<img src=". $fetchedcard["image_url"]. "/>". "<br>";
    
    $cards = "SELECT cs.name from card_sets cs 
    JOIN cards c ON c.card_set_id = cs.card_set_id WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
    $fetchedcard = $cardresult->fetch_assoc();
    echo "Set: ". $fetchedcard["name"]. "<br>";
    
    $cards = "SELECT *  from card_sets cs 
    JOIN cards c ON c.card_set_id = cs.card_set_id 
    JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
    JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
    if ($cardresult->num_rows > 0) {

        // output data of each row
        echo "Card Type: ";
        while($row = $cardresult->fetch_assoc()) {
    
          echo $row["card_type"]. " ";
    
        }
        echo "<br>";
    }
    $cards = "SELECT mcst.subtype
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
    JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
    WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
     if ($cardresult->num_rows > 0) {
 
         // output data of each row
         echo "Subtype: ";
         while($row = $cardresult->fetch_assoc()) {
     
           echo $row["subtype"]. " ";
     
         }
         echo "<br>";
     }

    $cards = "SELECT mcmc.color, mcmc.quantity
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_mana_costs_relations mcmcr ON mcmcr.magic_card_id = mc.magic_card_id
    JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = mcmcr.magic_card_mana_costs_id WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
    if ($cardresult->num_rows > 0) {
        echo "Mana Cost: ";

        while($row = $cardresult->fetch_assoc()) {
    
          echo $row["quantity"]. "-" . $row["color"]. " ";
        }
        echo "<br>";

    }

    $cards = "SELECT mcc.power, mcc.toughness FROM cards c 
    JOIN magic_cards mc ON c.card_id = mc.card_id 
    JOIN magic_card_creatures mcc ON mcc.magic_card_id = mc.magic_card_id WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
    //Looping so it only shows up on cards with stats not that cards can have multiple powers and toughnesses
    if ($cardresult->num_rows > 0) {    
        while($row = $cardresult->fetch_assoc()) {
            echo "Stats: ". $row["power"]. "/". $row["toughness"]. "<br>";
        }
    }

    $cards = "SELECT mcet.text, mcet.tap, mcet.magic_card_effect_text_id, mc.magic_card_id 
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id 
    WHERE c.card_id = $card_id";
$cardresult = $conn->query($cards);

$manaCards = "SELECT mcet.text, mcet.tap, mcmc.color, mcmc.quantity, macer.magic_card_effect_text_id, mc.magic_card_id 
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

if ($cardresult->num_rows > 0) {
    while ($row = $cardresult->fetch_assoc()) {
            if ($row["tap"] == 0)
            {
                $tap = 'False';
            } 
            $effectId = $row["magic_card_effect_text_id"];
        
        // Display colors and quantities for this effect ID
        if (isset($manaData[$effectId])) {
            foreach ($manaData[$effectId] as $manaRow) {
                echo $manaRow["quantity"] . "-" . $manaRow["color"] . " ";
            }
        }

        if ($row["tap"] == 0)
        {
        echo "Effect Text: " . $row["text"] . "<br>";
        } else {
            echo "Effect Text: Tap. " . $row["text"] . "<br>";
        }
    }
}

    $cards = "SELECT mcft.f_text
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_card_flavor_text mcft ON mcft.magic_card_id = mc.magic_card_id WHERE c.card_id = $card_id";
    $cardresult = $conn->query($cards);
    if ($cardresult->num_rows > 0) {

        while($row = $cardresult->fetch_assoc()) {
    
          echo "Flavor Text: " . $row["f_text"]. "<br>";
    
        }
    }
  }


?>
<form method='post'>
<input type='submit' name = "add" value='Add to collection'/>
</form>
<?php
if(isset($_POST['add']))
{
    $user = $_SESSION['user_id'];
    $card_id = $_GET['card_id'];
    $collection = "SELECT * FROM user_collections WHERE user_id = $user";
    $collection_result = $conn->query($collection);
    $add_to_collection = "INSERT INTO user_collections (user_id, card_id, quantity) VALUES ($user, $card_id  , 1)";
    if ($collection_result->num_rows > 0) {
        while ($row = $collection_result->fetch_assoc()) {
            if($row['card_id'] == $card_id)
            {
                $quantity = $row['quantity'] + 1;
                $add_to_collection = "UPDATE user_collections SET quantity=$quantity WHERE card_id = $card_id";
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
<a href="index.php">Home</a>
