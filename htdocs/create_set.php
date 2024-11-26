<h1>Create a Set for a Card Game</h1>

<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';

  //Grabs the games name and id that are in the database
  $sql = "SELECT g.name, g.game_id FROM games g";
  $result = $conn->query($sql);

  //Displays the games in the database as well as their id
  if ($result->num_rows > 0) {
    echo "Games in the Database and their ID. <br>";
    while($row = $result->fetch_assoc()) {
      echo "Game Name: ". $row["name"]. " Game ID: " . $row["game_id"]. "<br>";
    }
  }
?>
<br>
<br>
<!-- Form for creating a set -->
<form action="" method="POST">
        <label for="set">Set:</label>
        <input type="text" id="set" name="set"required>
        <br>
        <label for="total_cards">Total Cards in Set:</label>
        <input type="number" id="total_cards" name="total_cards" required>
        <br>
        <label for="game">Game_ID:</label>
        <input type="number" id="game" name="game" required>
        <br>
        <input type="submit" value="Confirm">
</form>

<?php
    // Takes the user inputs if they have pressed submit
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        // sanitizes the code
        $set = htmlspecialchars(trim($_POST['set']));
        $total_cards = htmlspecialchars(trim($_POST['total_cards']));
        $game = htmlspecialchars(trim($_POST['game']));
        //Initializes at 0 to check if the game id is in the data base
        $game_in_db = 0;
        // Grabs the Game ids in the database
        $sql = "SELECT g.game_id FROM games g";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
          while($row = $result->fetch_assoc()) {
            // Checks the game ids in database and changes to 1 to confirm game is in database
            if ($game == $row['game_id'])
            {
                $game_in_db = 1;
            }
          }
        }
        
        if ($game_in_db != 1){
            echo "Game is not in the Database";
        } else {
            //Adds the set to the database
            $query = "INSERT INTO card_sets (name, total_cards, game_id) VALUES ('$set', '$total_cards', '$game')";
            $result = $conn->query($query);
    
            // Execute the query
            if ($result) {
                echo "Created set.";
            } else {
                echo "Failed to create set.";
            }
        }
       
    }
?>

<!-- Links back to home page -->
<a href="index.php">Home</a>