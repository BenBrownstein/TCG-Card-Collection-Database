<h1>These are the Yu-Gi-Oh that have been added to the Database</h1>
<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in  
  include 'dashboard.php';

  //Selects everything from sets where the game is set to Yu-Gi-Oh
  $sets = "SELECT * from card_sets WHERE game_id = 2";
  $setresult = $conn->query($sets);   

  //Checks to make sure there are sets for that game
  if ($setresult->num_rows > 0) {
    //Header for sets
    echo "<h2>Magic the Gathering Sets</h2>";
    //Loops the following code for each set
    while($row = $setresult->fetch_assoc()) {
      //Displays the name of the set then a button which will display the cards in the set
      echo "<br>Name: " . $row["name"]. "<form method='post'> <input type='submit' name='". $row["card_set_id"] ."' value='Display Cards in Set'/></form>" ."<br>";
      
      //If the button is pressed display all cards in the database that are in that set
      if(isset($_POST[$row["card_set_id"]])) {
        //Selects the cards in the set
        $cards = "SELECT * FROM cards";
        $result = $conn->query($cards);
        //Gets the set id of the button that is pushed
        $setid = $row["card_set_id"];
        // If that value is not 0 then check the set ids of the cards
        if ($result->num_rows > 0) {
          while($row = $result->fetch_assoc()) {
            //If the set id of a card is equal to the pushed buttons set id it displays the card name as a link to its card info page
            if ($row["card_set_id"] == $setid){
                echo "Name: ". "<a href='ygo_card_info.php?card_id=".$row["card_id"]."'>". $row["name"]. "</a> <br>";
            }
          }      
        }
      }
    }
  // If there are no sets it displays No results
  } else {
    echo "No results";
  }
?>
<br>
<!-- Links back to home page -->
<a href="index.php">Home</a>
