<h1>These are the Magic Cards that have been added to the Database</h1>



<?php
  
  $servername = "localhost";

  $username   = "root";

  $password   = "";

  $dbname     = "card_collection";

  

  // Create connection object

  $conn = new mysqli($servername, $username, $password, $dbname);



  // Check connection

  if ($conn->connect_error) {

    die("Connection failed: " . $conn->connect_error);

  }


  $sql = "SELECT c.card_id, c.name FROM cards c";

  $result = $conn->query($sql);

  include 'dashboard.php';

  if ($result->num_rows > 0) {

    // output data of each row

    while($row = $result->fetch_assoc()) {
      echo "Name: ". "<a href='card_info.php?card_id=".$row["card_id"]."'>". $row["name"]. "</a> <br>";

    }

  } else {

    echo "No results". "<br>";

  }
  ?>

    <?php
    $selectedSearchType = isset($_GET['search_by']) ? htmlspecialchars($_GET['search_by']) : '';
    $searchQuery = isset($_GET['query']) ? htmlspecialchars($_GET['query']) : '';
    ?>

    <form action="" method="GET">
        <label for="search_by">Search by:</label>
        <select name="search_by" id="search_by">
            <option value="name" <?php if ($selectedSearchType === 'name') echo 'selected'; ?>>Name</option>
            <option value="subtype" <?php if ($selectedSearchType === 'subtype') echo 'selected'; ?>>Subtype</option>
            <option value="effect" <?php if ($selectedSearchType === 'effect') echo 'selected'; ?>>Effect</option>
            <option value="set" <?php if ($selectedSearchType === 'set') echo 'selected'; ?>>Set</option>
        </select>
        <label for="query">Search term:</label>
        <input type="text" id="query" name="query" value="<?php echo $searchQuery; ?>">
        <input type="submit" value="Search">
    </form>

    <?php
    if (!empty($searchQuery) && !empty($selectedSearchType)) {
        $sql = "";
        switch ($selectedSearchType) {
            case 'name':
                $sql = "SELECT c.card_id, c.name, mcct.card_type
                        FROM cards c 
                        JOIN magic_cards mc ON c.card_id = mc.card_id
                        JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                        JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
                        WHERE c.name LIKE '%$searchQuery%'";
                break;

            case 'subtype':
                $sql = "SELECT c.card_id, c.name, mcct.card_type, mcst.subtype
                        FROM cards c 
                        JOIN magic_cards mc ON c.card_id = mc.card_id
                        JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                        JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id
                        JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
                        JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
                        WHERE mcst.subtype LIKE '%$searchQuery%'";
                break;

            case 'effect':
                $sql = "SELECT c.card_id, c.name, mcct.card_type, mcet.text
                        FROM cards c 
                        JOIN magic_cards mc ON c.card_id = mc.card_id
                        JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id 
                        JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
                        JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id
                        WHERE mcet.text LIKE '%$searchQuery%'";
                break;

            case 'set':
              $sql = "SELECT cs.name AS card_set_name, c.card_id, c.name, mcct.card_type
              FROM card_sets cs
              JOIN cards c ON c.card_set_id = cs.card_set_id
              JOIN magic_cards mc ON c.card_id = mc.card_id
              JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
              JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
              WHERE cs.name LIKE '%$searchQuery%'";
              break;
        }

        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                echo "Name: <a href='card_info.php?card_id=" . $row["card_id"] . "'>" . $row["name"] . "</a>" .", Card Type: " . $row["card_type"];
                
                if (isset($row["subtype"])) {
                    echo ", Subtype: " . $row["subtype"];
                }
                if (isset($row["text"])) {
                    echo ", Effect: " . $row["text"];
                }
                if (isset($row["card_set_name"]))
                {
                  echo ", Set: ". $row["card_set_name"];
                }
                echo "<br>";
            }
        } else {
            echo "No results found."."<br>";
        }
    }
    ?>

<br>
<a href="sets.php">Sets</a>
<a href="user_collection.php">Collection</a>

