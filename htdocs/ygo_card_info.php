<h1>Full information of a Yu-Gi-Oh card in the Database</h1>

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

        //Checks to make sure that the card is from Yu-Gi-Oh and if not sends them back to the home page also protects against going to card ids not in the database as they do not have a game associated with them
        $game = "SELECT g.game_id FROM games g
        JOIN card_sets cs ON cs.game_id = g.game_id
        JOIN cards c ON c.card_set_id= cs.card_set_id WHERE c.card_id = $card_id";
        $gameresult = $conn->query($game);
        $gameresult = $gameresult->fetch_assoc();
        if ($gameresult["game_id"] != 2) {
                header("Location: index.php");
                exit();
        }
        
        //Shows card name, card rarity, card type, and the card image for selected card
        $cards = "SELECT c.name, yc.rarity, yc.image_url, yc.card_type FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        $fetchedcard = $cardresult->fetch_assoc();
        echo "Name: " . $fetchedcard["name"].  "<br>"."<img src=". $fetchedcard["image_url"]. ">"."<br>". "Card Type: ". $fetchedcard["card_type"]. "<br>"."Rarity: " . $fetchedcard["rarity"]. "<br>";
    
        //Gets Card Type for selected card id
        $cards = "SELECT cs.name from card_sets cs 
        JOIN cards c ON c.card_set_id = cs.card_set_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        $fetchedcard = $cardresult->fetch_assoc();
        echo "Set: ". $fetchedcard["name"]. "<br>";

        //Gets Subtype for selected card
        $cards = "SELECT ycst.subtype
        FROM cards c JOIN ygo_cards yc ON c.card_id = yc.card_id
        JOIN ygo_cards_subtypes_relations ycstr ON ycstr.ygo_card_id = yc.ygo_card_id
        JOIN ygo_cards_subtypes ycst ON ycst.ygo_card_subtype_id = ycstr.ygo_card_subtype_id
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
    

        //Gets the ATK, attribute, and type of the selected card
        $cards = "SELECT ycmc.attribute, ycmc.type, ycmc.atk FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id 
        JOIN ygo_card_monster_cards ycmc ON ycmc.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card is not a monster
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Attribute: ". $cardresult["attribute"]. "<br>". "Type: ".$cardresult["type"]. "<br>". "ATK: ".$cardresult["atk"]. "<br>";
        }

        //Gets the DEF of the card if it is a monster card
        $cards = "SELECT ycmcd.def FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id 
        JOIN ygo_card_monster_cards_defense ycmcd ON ycmcd.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card is not a monster or does not have DEF
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "DEF: ". $cardresult["def"]. "<br>";
        }

        //Gets the Level of the card if it is a monster card
        $cards = "SELECT ycmcl.level FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id 
        JOIN ygo_card_monster_cards_level ycmcl ON ycmcl.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card is not a monster or does not have a Level
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Level: ". $cardresult["level"]. "<br>";
        }

        //Gets the Rank of the card if it is a monster card
        $cards = "SELECT ycxyz.ranks FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id 
        JOIN ygo_card_xyz_monster_cards_rank ycxyz ON ycxyz.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card is not a monster or does not have a Rank
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Rank: ". $cardresult["ranks"]. "<br>";
        }

        //Gets the required summoning materials of the card if it is a monster card
        $cards = "SELECT ycmcm.material FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id 
        JOIN ygo_card_monster_cards_material ycmcm ON ycmcm.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        //Skips if the card is not a monster or does not have required summoning materials
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Material: ". $cardresult["material"]. "<br>";
        }

        //Gets the flavor text of the selected card
        $cards = "SELECT ycft.f_text FROM cards c 
        JOIN ygo_cards yc ON c.card_id = yc.card_id         
        JOIN ygo_card_flavor_text ycft ON ycft.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // Only Normal Monsters have flavor text
        if ($cardresult->num_rows > 0) {
            $cardresult = $cardresult->fetch_assoc();   
            echo "Flavor Text: " . $cardresult["f_text"]. "<br>";         
        }

        //Gets Effects for selected card
        $cards = "SELECT ycet.text
        FROM cards c JOIN ygo_cards yc ON c.card_id = yc.card_id
        JOIN ygo_card_effect_text ycet ON ycet.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // If there is no effect it prints nothing
        if ($cardresult->num_rows > 0) {
            echo "Effect: ";
            //Loops because some cards can have multiple  subtypes
            while($row = $cardresult->fetch_assoc()) {
                echo $row["text"]. " ";
            }
            echo "<br>";
        }

        //Gets the values for a selected Link Monster card
        $cards = "SELECT yclmc.link_rating, yclmc.top_left, yclmc.top_center, yclmc.top_right, yclmc.middle_left, yclmc.middle_right, yclmc.bottom_left, yclmc.bottom_center, yclmc.bottom_right
        FROM cards c JOIN ygo_cards yc ON c.card_id = yc.card_id
        JOIN ygo_card_link_monster_cards yclmc ON yclmc.ygo_card_id = yc.ygo_card_id WHERE c.card_id = $card_id";
        $cardresult = $conn->query($cards);
        // If the monster is not a link monster it prints nothing
        if ($cardresult->num_rows > 0) { 
            $cardresult = $cardresult->fetch_assoc();   
            echo "Link Rating: ". $cardresult["link_rating"]. "<br>";
            echo "Link Arrows: ";
            if ($cardresult["top_left"] == 1)
            {
                echo "Top Left ";
            }
            if ($cardresult["top_center"] == 1)
            {
                echo "Top Center ";
            }
            if ($cardresult["top_right"] == 1)
            {
                echo "Top Right ";
            }
            if ($cardresult["middle_left"] == 1)
            {
                echo "Middle Left ";
            }
            if ($cardresult["middle_right"] == 1)
            {
                echo "Middle Right ";
            }
            if ($cardresult["bottom_left"] == 1)
            {
                echo "Bottom Left ";
            }
            if ($cardresult["bottom_center"] == 1)
            {
                echo "Bottom Center ";
            }
            if ($cardresult["bottom_right"] == 1)
            {
                echo "Bottom Right ";
            }
        }
} ?>


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
