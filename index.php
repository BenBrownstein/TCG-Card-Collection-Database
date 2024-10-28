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



  $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type
  FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
  JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
  JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id";
  

  $result = $conn->query($sql);

  

  if ($result->num_rows > 0) {

    // output data of each row

    while($row = $result->fetch_assoc()) {

      echo "Name: " . $row["name"]. "<br>";

    }

  } else {

    echo "0 results";

  }

  //Search bar code
  if (isset($_GET['card']) && !empty($_GET['card']))
  {
    $cards = htmlspecialchars($_GET['card']);  
    $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mc.is_Legendary, mcct.card_type
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
    JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id where name LIKE '%$cards%'" ;    
    $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "Name: " . $row["name"]. "<br>". " Card Type: ". $row["card_type"]. "<br>". "Image: ". "<img src=". $row["image_url"]. "/>". "<br>";
    }
  } else {

    echo "0 results";

  }
    }

  ?>
<form action="" method="GET">
    <label for="card">Card Name:</label>
    <input type="text" name="card" value="">
    <input type="submit" value="Search">
</form>