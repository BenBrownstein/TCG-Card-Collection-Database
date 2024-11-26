<!-- Background Color -->
<style>
    body {
    background-color:#52d1eb ;
    }
</style>
<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';
?>
<!-- Lets the user know that their password was updated and brings them back to the index from the link -->
<h1>Password Updated Successfully</h1>
<p>Your password has been updated. You can now return to <a href="index.php">home</a>.</p>
