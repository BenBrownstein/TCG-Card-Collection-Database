<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';
?>

<!-- Welcomes User to the page -->
<h1>Welcome <?php echo htmlspecialchars($_SESSION['username']); ?></h1>
<!-- Links to other pages -->
<a href="index.php">Home</a>
<br>
<br>
<a href="create_set.php">Create a Set</a>
<br>
<br>
<a href="update_password.php">Update Password</a>
<br>
<br>
<a href="delete_account.php">Delete Account</a>
<br>
<br>
