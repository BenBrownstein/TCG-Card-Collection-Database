<h1>These are the cards that have been added to the Database</h1>
<h2>More coming soon</h2>


<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';

  //Grabs all cards and card names
  $sql = "SELECT c.card_id, c.name, cs.name AS set_name, g.name AS game_name FROM games g 
  JOIN card_sets cs ON cs.game_id = g.game_id
  JOIN cards c ON  c.card_set_id= cs.card_set_id";
  $result = $conn->query($sql);

  if ($result->num_rows > 0) {
    // output data of each row
    echo "Cards in the database by added order. <br>";
    while($row = $result->fetch_assoc()) {
      //Display card name that links to a card info page for the card based off card id
      echo "Game: ". $row["game_name"].", Name: ". "<a href='card_info.php?card_id=".$row["card_id"]."'>". $row["name"]. "</a>".", Set: ".$row["set_name"]." <br>";
    }
  } else {
    //Shows if database if empty
    echo "No results". "<br>";
  }
  ?>
    <br>

    <!-- Search bar code -->
    <?php
    //Variables to store search type and what was searched so it is saved between page loads
    $selectedSearchType = isset($_GET['search_by']) ? htmlspecialchars($_GET['search_by']) : '';
    $searchQuery = isset($_GET['query']) ? htmlspecialchars($_GET['query']) : '';
    ?>
    <!-- Search bar -->
    <form action="" method="GET">
        <label for="search_by">Search Magic Cards by:</label>
        <select name="search_by" id="search_by">
            <!-- If $selectedSearchType is saved set that option to be the selected option -->
            <!-- Searches by name, subtype, effect, and set -->
            <option value="name" <?php if ($selectedSearchType === 'name') echo 'selected'; ?>>Name</option>
            <option value="subtype" <?php if ($selectedSearchType === 'subtype') echo 'selected'; ?>>Subtype</option>
            <option value="effect" <?php if ($selectedSearchType === 'effect') echo 'selected'; ?>>Effect</option>
            <option value="set" <?php if ($selectedSearchType === 'set') echo 'selected'; ?>>Set</option>
        </select>
        <label for="query">Search term:</label>
        <!-- If $searchQuery has anything than saved then it will be in the text bar -->
        <input type="text" id="query" name="query" value="<?php echo $searchQuery; ?>">
        <input type="submit" value="Search">
    </form>    
    <?php
    // If there is a query and search type selected perform the search
    if (!empty($searchQuery) && !empty($selectedSearchType)) {
        // Empty variable that is predeclared
        $sql = "";
        switch ($selectedSearchType) {
            // If name is selected do a call based off what will be shown for the name search based off $searchQuery
            case 'name':
                $sql = "SELECT cs.name AS card_set_name, c.card_id, c.name, mcct.card_type
                FROM card_sets cs
                JOIN cards c ON c.card_set_id = cs.card_set_id
                JOIN magic_cards mc ON c.card_id = mc.card_id
                JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
                WHERE c.name LIKE '%$searchQuery%' AND game_id = 1 ";
                break;

            case 'subtype':
                // If name is selected do a call based off what will be shown for the subtype search based off $searchQuery
                $sql = "SELECT cs.name AS card_set_name, c.card_id, c.name, mcct.card_type, mcst.subtype
                FROM card_sets cs
                JOIN cards c ON c.card_set_id = cs.card_set_id
                JOIN magic_cards mc ON c.card_id = mc.card_id
                JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id
                JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
                JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
                WHERE mcst.subtype LIKE '%$searchQuery%' AND game_id = 1";
                break;

            case 'effect':
                // If name is selected do a call based off what will be shown for the effect search based off $searchQuery
                $sql = "SELECT cs.name AS card_set_name, c.card_id, c.name, mcct.card_type, mcet.text
                FROM card_sets cs
                JOIN cards c ON c.card_set_id = cs.card_set_id
                JOIN magic_cards mc ON c.card_id = mc.card_id
                JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id 
                JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
                WHERE mcet.text LIKE '%$searchQuery%' AND game_id = 1";
                break;

            case 'set':
                // If name is selected do a call based off what will be shown for the set search based off $searchQuery
                $sql = "SELECT cs.name AS card_set_name, c.card_id, c.name, mcct.card_type
                FROM card_sets cs
                JOIN cards c ON c.card_set_id = cs.card_set_id
                JOIN magic_cards mc ON c.card_id = mc.card_id
                JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
                WHERE cs.name LIKE '%$searchQuery%' AND game_id = 1";
                break;
        }

        //Queries the database based off the statement choosen above
        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                // Displays the name and card type of the cards that meet the criteria
                echo "Name: <a href='card_info.php?card_id=" . $row["card_id"] . "'>" . $row["name"] . "</a>" .", Card Type: " . $row["card_type"].", Set: ". $row["card_set_name"];
                
                if (isset($row["subtype"])) {
                    // Displays the subtype of the cards that meet the criteria if subtype is selected
                    echo ", Subtype: " . $row["subtype"];
                }
                if (isset($row["text"])) {
                    // Displays the subtype of the cards that meet the criteria if text is selected
                    echo ", Effect: " . $row["text"];
                }
                echo "<br>";
            }
        } else {
            //Nothing matched the query based on criteria
            echo "No results found."."<br>";
        }
    }
    ?>

<br>
<!-- Links to other pages -->
<a href="sets.php">Sets</a>
<a href="user_collection.php">Collection</a>

