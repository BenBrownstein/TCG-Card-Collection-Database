<!-- Background Color -->
<style>
    body {
    background-color:#52d1eb ;
    }
</style>
<!-- Makes sure that there is no session in use -->
<?php
    //Connects to database
    include 'connection.php';
    // Makes sure the session exists
    session_start();
    session_destroy(); // Destroy the session
?>

<!-- Lets the user know that an account has been deleted and redirects them to log in from the link or create a new account-->
<h1>Account Deleted Successfully</h1>
<p>Your account has been deleted. You can now <a href="login.php">log in</a>. Or create a <a href="account_creation.php">new account</a>. </p>
