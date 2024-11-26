<!-- Background Color -->
<style>
    body {
    background-color:#52d1eb ;
    }
</style>

<?php
    //Connects to database
    include 'connection.php';
    session_start(); // Start the session to manage logged-in state

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        // Sanitize inputs
        $usernameOrEmail = htmlspecialchars(trim($_POST['usernameOrEmail']));
        $password = $_POST['password'];

        try {
        // Query to find the user
        $query = "SELECT * FROM users WHERE username = '$usernameOrEmail' OR email = '$usernameOrEmail'";
        $result = $conn->query($query);

        if ($result && $user = $result->fetch_assoc()) {
            // Verify the password
            if (password_verify($password, $user['password_hash'])) {
                // Login successful if user id and user name are correct
                $_SESSION['user_id'] = $user['user_id'];
                $_SESSION['username'] = $user['username'];
                header("Location: index.php"); // Redirect to homepage
                exit();
            } else {
                //Errors if wrong password
                $error = "Invalid username/email or password.";
            }
        } else {
            //Errors if wrong username or email
            $error = "Invalid username/email or password.";
        }
    } catch (Exception $e) {
        //Database error
        $error = "Database Error: " . $e->getMessage();
    }
}
?>

<body>
    <h1>Login</h1>
    <!-- Errors if the variable error is not empty -->
    <?php if (!empty($error)) { echo "<p style='color:red;'>$error</p>"; } ?>
    <!-- Uses POST so it does not show up in searchbar/part of url -->
    <form action="" method="POST">
        <!-- POST form for login using username or Email -->
        <!-- Username or Email is required as well as password -->
        <label for="usernameOrEmail">Username or Email:</label>
        <input type="text" id="usernameOrEmail" name="usernameOrEmail" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <input type="submit" value="Login">
    </form>
    <!-- Redirects to account creation page if the user does not have an account -->
    <p>Don't have an account? <a href="account_creation.php">Sign up here</a>.</p>
</body>
