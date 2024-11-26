<?php
    // Starts the session to track user
    session_start();

    // If the user is logged in redirect the user to the login page
    if (!isset($_SESSION['user_id'])) {
       header("Location: login.php");
        exit();
    }
?>
<!-- Puts the login info in the upper right corner of the screen -->
<style>
    #login {
        margin: 0; /* Remove default margin */
        position: absolute; /* Allow positioning */
        top: 0; /* Align to top */
        right: 0; /* Align to right */
        padding: 10px; /* Add space inside the body */
    }
    /* Background Color */
    body {
    background-color:#52d1eb ;
    }
</style>
<section id="login">
    <!-- Lets user know that they are logged in with the account name -->
    <!-- Logs the user out from the a tag-->
    <p>Logged in as <?php echo htmlspecialchars($_SESSION['username']); ?>, <a href="logout.php">Logout</a></p>
</section>