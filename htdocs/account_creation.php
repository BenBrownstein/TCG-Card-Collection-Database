<!-- Background Color -->
<style>
    body {
    background-color:#52d1eb ;
    }
</style>
<h1>Account Creation</h1>
<!-- Takes a username, email or password to create an account-->
<form action="" method="POST">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username"required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <input type="submit" value="Confirm">
</form>

<?php
    // Connects to database
    include 'connection.php';
    // Takes the user inputs if they have pressed submit
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        try {
        // sanitizes the code
        $username = htmlspecialchars(trim($_POST['username']));
        $email = htmlspecialchars(trim($_POST['email']));
        $password = $_POST['password'];
        //Hashes the password
        $passwordHash = password_hash($password, PASSWORD_BCRYPT);
        // Creates the account based on the provided information
        $query = "INSERT INTO users (username, email, password_hash) VALUES ('$username', '$email', '$passwordHash')";
        $result = $conn->query($query);

        // Execute the query
        if ($result) {
            header("Location: success.php");  
            exit();
        } else {
            echo "Failed to create user.";
        }
        }
        // Error handling
        catch (PDOException $e) {
            // Handle specific database errors
            if ($e->getCode() == 23000) { // Integrity constraint violation
                echo "Error: Username or email already exists.";
            } else {
                echo "Database Error: " . $e->getMessage();
            }
        }
    }
?>