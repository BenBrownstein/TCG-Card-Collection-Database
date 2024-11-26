<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';
?>
<h1>Account Deletion</h1>
<form action="" method="POST">
    <input type='submit' name='delete' value='Delete this Account'/>
</form>
<?php
    //Handles removing a card from the collection
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete'])) {
        $user = $_SESSION['user_id'];
        //Removes all cards from the logged in user's collection
        $update_query = "DELETE FROM user_collections WHERE user_id = $user";
        $conn->query($update_query);
        //Loads query and refreshes the page
        $update_query = "DELETE FROM users WHERE user_id = $user";
        if ($conn->query($update_query)) {
            header("Location: success_delete.php");
            exit;
        }
    }
?>
<br>
<!-- Links back to home page -->
<a href="index.php">Home</a>