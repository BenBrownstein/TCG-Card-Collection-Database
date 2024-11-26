<?php
  //Connects to database
  include 'connection.php';
  //Shows user info and make sure they are logged in
  include 'dashboard.php';
?>

<h2>Update Password:</h2>
<!-- Form for updating password taking new and old password -->
<form action="" method="POST">
        <label for="old_password">Old Password:</label>
        <input type="password" id="old_password" name="old_password" required>
        <br>
        <label for="new_password">New Password:</label>
        <input type="password" id="new_password" name="new_password" required>
        <br>
        <input type="submit" value="Confirm">
</form>

<?php
    // Connects to database
    include 'connection.php';
    // Takes the user inputs if they have pressed submit
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        // Gets passwords from form and user that is logged in
        $old_password = $_POST['old_password'];
        $new_password = $_POST['new_password'];
        $user_id = $_SESSION['user_id'];

        //Hashes the new password
        $new_passwordHash = password_hash($new_password, PASSWORD_BCRYPT);

        //Gets all information of logged in user
        $query = "SELECT * FROM users WHERE user_id = $user_id";
        $result = $conn->query($query);
        if ($result && $user = $result->fetch_assoc()) {
            // Verify the old password and make sure it is not the same as new password
            if (password_verify($old_password, $user['password_hash']) && $old_password != $new_password) {
                //Query to update password of user logged in
                $query = "UPDATE users SET password_hash = '$new_passwordHash' WHERE user_id = $user_id";
                $result = $conn->query($query);

                // Execute the query
                if ($result) {
                    header("Location: success_update.php");  
                    exit();
                } else {
                   echo "Failed to update the password.";
                }
            } else {
                $error = "Invalid password.";
            }
        } else {
            $error = "Error";
        }
    }
?>
<!-- Shows the error -->
<?php if (!empty($error)) { echo "<p style='color:red;'>$error</p>"; } ?>
<br>
<br>
<!-- Links back to home page -->
<a href="index.php">Home</a>
