<h1>Cards in the User's Collection</h1>

<?php
//Start output buffering added due to error when not in
ob_start();

include 'connection.php';
include 'dashboard.php';
$user = $_SESSION['user_id'];
$collection = "SELECT c.name, u.username, uc.quantity, c.card_id, cs.name AS card_set_name, g.name AS game_name FROM users u
JOIN user_collections uc ON uc.user_id = u.user_id
JOIN cards c ON c.card_id = uc.card_id 
JOIN card_sets cs ON cs.card_set_id = c.card_set_id 
JOIN games g ON g.game_id = cs.game_id
WHERE u.user_id = $user";
$collection_result = $conn->query($collection);

if ($collection_result->num_rows > 0) {
    while ($row = $collection_result->fetch_assoc()) {
        echo "Card:  <a href='card_info.php?card_id=" . $row["card_id"] . "'>" . $row["name"] . "</a>" .", Set: " . $row["card_set_name"].", Game: " . $row["game_name"].", Quantity: " . $row["quantity"] . "<br>";
        echo "<form method='post'>
                <input type='hidden' name='card_id' value='".$row["card_id"]."'/>
                <input type='submit' name='add_quantity' value='Add 1 to collection'/>
                <input type='submit' name='remove_quantity' value='Remove 1 from collection'/>
                <input type='submit' name='delete' value='Delete Card from collection'/>
              </form>";
        echo "<br>";
    }
} else {
    echo "No cards found in your collection.";
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['add_quantity'])) {
    $card_id = $_POST['card_id'];
    $update_query = "UPDATE user_collections SET quantity = quantity + 1 WHERE card_id = $card_id AND user_id = $user";
    if ($conn->query($update_query)) {
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['remove_quantity'])) {
    $card_id = $_POST['card_id'];
    $update_query1 = "UPDATE user_collections SET quantity = quantity - 1 WHERE card_id = $card_id AND user_id = $user";
    $conn->query($update_query1);
    $update_query2 = "DELETE FROM user_collections WHERE quantity = 0";
    if ($conn->query($update_query2)) {
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete'])) {
    $card_id = $_POST['card_id'];
    $update_query = "DELETE FROM user_collections WHERE card_id = $card_id AND user_id = $user";
    if ($conn->query($update_query)) {
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}
?>


<br>
<a href="index.php">Home</a>

<?php
// End output buffering
ob_end_flush();
?>