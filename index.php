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



  $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mcct.card_type
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
  ?>

  

<form action="" method="GET">
    <label for="card">Card Name:</label>
    <input type="text" name="card" value="">
    <input type="submit" value="Search">
</form>
<?php
  //Search bar code
  if (isset($_GET['card']) && !empty($_GET['card']))
  {
    $cards = htmlspecialchars($_GET['card']);  
    $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mcct.card_type
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
    JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
	where name LIKE '%$cards%'" ;    
    $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "Name: " . $row["name"]. ", Card Type: ". $row["card_type"]. "<br>";
    }
  } else {

    echo "0 results";

  }
    }
  ?>

<form action="" method="GET">
    <label for="subtype">Subtype Name:</label>
    <input type="text" name="subtype" value="">
    <input type="submit" value="Search">
</form>
<?php
  //Search bar code
  if (isset($_GET['subtype']) && !empty($_GET['subtype']))
  {
    $subtypes = htmlspecialchars($_GET['subtype']);  
    $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mcct.card_type, mcst.subtype
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
    JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
    JOIN magic_cards_subtypes_relations mcstr ON mcstr.magic_card_id = mc.magic_card_id
    JOIN magic_card_subtypes mcst ON mcst.magic_card_subtype_id = mcstr.magic_card_subtype_id
    where subtype LIKE '%$subtypes%'" ;    
    $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "Name: " . $row["name"]. ", Card Type: ". $row["card_type"].  ", Subtype: " . $row["subtype"]. "<br>";
    }
  } else {

    echo "0 results";

  }
    }
  ?>

<!-- <?php
  //Search bar code with Effect and flavor text
  if (isset($_GET['card']) && !empty($_GET['card']))
  {
    $cards = htmlspecialchars($_GET['card']);  
    $sql = "SELECT c.name, mc.rarity, mc.artist, mc.image_url, mcct.card_type, mcft.f_text, mcet.text
	-- mcet.tap, mcmc.color, mcmc.quantity
    FROM cards c JOIN magic_cards mc ON c.card_id = mc.card_id
    JOIN magic_cards_card_types_relations mcctr ON mcctr.magic_card_id = mc.magic_card_id
    JOIN magic_card_card_types mcct ON mcct.magic_card_card_type_id = mcctr.magic_card_card_type_id 
	JOIN magic_card_flavor_text mcft ON mcft.magic_card_id = mc.magic_card_id
	JOIN magic_card_effect_text mcet ON mcet.magic_card_id = mc.magic_card_id
	-- JOIN mana_costs_card_effect_relations macer ON macer.magic_card_effect_text_id = mcet.magic_card_effect_text_id
	-- JOIN magic_card_mana_costs mcmc ON mcmc.magic_card_mana_costs_id = macer.magic_card_mana_costs_id
	where name LIKE '%$cards%'" ;    
    $result = $conn->query($sql);
  if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "Name: " . $row["name"]. "<br>". " Card Type: ". $row["card_type"]. "<br>". "Effect Text: ".$row["text"]. "<br>"."Flavor Text: ".$row["f_text"]. "<br>" ."<img src=". $row["image_url"]. "/>". "<br>";
    }
  } else {

    echo "0 results";

  }
    }
  ?> -->