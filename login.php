<?php
include 'connection.php'; // Include the database connection file
session_start(); // Start the session to manage logged-in state

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Sanitize inputs
    $usernameOrEmail = htmlspecialchars(trim($_POST['usernameOrEmail']));
    $password = $_POST['password'];

    try {
        // Query to find the user
        $query = "SELECT * FROM users WHERE username = '$usernameOrEmail' OR email = '$usernameOrEmail'";
        $result = $conn->query($query);

        if ($result && $user = $result->fetch_assoc()) { // Use fetch_assoc() for MySQLi
            // Verify the password
            if (password_verify($password, $user['password_hash'])) {
                // Login successful
                $_SESSION['user_id'] = $user['user_id'];
                $_SESSION['username'] = $user['username'];
                header("Location: index.php"); // Redirect to dashboard
                exit();
            } else {
                $error = "Invalid username/email or password.";
            }
        } else {
            $error = "Invalid username/email or password.";
        }
    } catch (Exception $e) {
        $error = "Database Error: " . $e->getMessage();
    }
}
?>

<body>
    <h1>Login</h1>
    <?php if (!empty($error)) { echo "<p style='color:red;'>$error</p>"; } ?>
    <form action="" method="POST">
        <label for="usernameOrEmail">Username or Email:</label>
        <input type="text" id="usernameOrEmail" name="usernameOrEmail" required>
        <br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br>
        <input type="submit" value="Login">
    </form>
    <p>Don't have an account? <a href="account_creation.php">Sign up here</a>.</p>
</body>
