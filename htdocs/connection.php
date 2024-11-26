<?php
  // Connection details
  $servername = "localhost";
  $username   = "root";
  $password   = "";
  $dbname     = "card_collection";

  // Create connection object
  $conn = new mysqli($servername, $username, $password, $dbname);
  
  // Makes it so quotes and dashes appear
  mysqli_set_charset($conn, 'utf8mb4');

  // Check connection
  if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
  }
?>