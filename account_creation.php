<h1>Account Creation</h1>
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
    include 'connection.php';
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        try {
        $username = htmlspecialchars(trim($_POST['username']));
        $email = htmlspecialchars(trim($_POST['email']));
        $password = $_POST['password'];
    
        $passwordHash = password_hash($password, PASSWORD_BCRYPT);
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