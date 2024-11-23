<h1>Cards in the User's Collection</h1>

<?php
include 'connection.php';
include 'dashboard.php';
$user = $_SESSION['user_id'];
$collection = "SELECT c.name, u.username, uc.quantity FROM users u
JOIN user_collections uc ON uc.user_id = u.user_id
JOIN cards c ON c.card_id = uc.card_id WHERE u.user_id = $user";
$collection_result = $conn->query($collection);
if ($collection_result->num_rows > 0) {
    while ($row = $collection_result->fetch_assoc()) {
        echo "Card: " . $row["name"] . " Quantity: " . $row["quantity"] . "<br>";
    }
} else 
{
    echo "No cards found in your collection.";
}
?>
<br>
<a href="index.php">Home</a>
