<h1>These are the Sets that have been added to the Database</h1>
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

    $sets = "SELECT * from card_sets";
    // JOIN cards c ON c.card_set_id = cs.card_set_id 
    

    $setresult = $conn->query($sets);   

    if ($setresult->num_rows > 0) {

        // output data of each row
    
        while($row = $setresult->fetch_assoc()) {
    
          echo "Name: " . $row["name"]. "<form method='post'> <input type='button' name='". $row["card_set_id"] ."' value='Display Cards in Set'/></form>" ."<br>";
        }
    
      } else {
    
        echo "0 results";
    
      }
  ?>

    <form method="post">
        <input type="submit" name="set1"
                value="Cards in Set 1"/>
        <input type="submit" name="set2"
                value="Cards in Set 2"/>       
    </form>

<?php
    
    if(isset($_POST['set1'])) {
        $cards = "SELECT * FROM cards";
        $result = $conn->query($cards);
        if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
            if ($row["card_set_id"] == 1){
                echo "Name: " . $row["name"]. "<br>";
            }
          }      
        }
    }
?>

<!-- Does not work for buttons created from fetch loop -->
<?php
    
    if(isset($_POST['2'])) {
        $cards = "SELECT * FROM cards";
        $result = $conn->query($cards);
        if ($result->num_rows > 0) {
          // output data of each row
          while($row = $result->fetch_assoc()) {
            if ($row["card_set_id"] == 1){
                echo "Name: " . $row["name"]. "<br>";
            }
          }      
        }
    }
?>

<a href="index.php">Home</a>
