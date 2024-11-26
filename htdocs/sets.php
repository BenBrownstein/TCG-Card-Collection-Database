<h1>These are the Sets that have been added to the Database</h1>
<?php
    include 'connection.php';
    include 'dashboard.php';
    $sets = "SELECT * from card_sets WHERE game_id = 1";
    

    $setresult = $conn->query($sets);   

    if ($setresult->num_rows > 0) {

        // output data of each row
        echo "<h2>Magic the Gathering Sets</h2>";
        while($row = $setresult->fetch_assoc()) {
    
          echo "Name: " . $row["name"]. "<form method='post'> <input type='submit' name='". $row["card_set_id"] ."' value='Display Cards in Set'/></form>" ."<br>";
          if(isset($_POST[$row["card_set_id"]])) {
            $cards = "SELECT * FROM cards c";
            $result = $conn->query($cards);
            $setid = $row["card_set_id"];
            if ($result->num_rows > 0) {
              // output data of each row
              while($row = $result->fetch_assoc()) {
                if ($row["card_set_id"] == $setid){
                  echo "Name: ". "<a href='card_info.php?card_id=".$row["card_id"]."'>". $row["name"]. "</a> <br>";
                }
              }      
            }
        }
        }
    
      } else {
    
        echo "No results";
    
      }
  ?>

<a href="index.php">Home</a>
