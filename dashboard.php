<?php
session_start();

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}
?>

<body>
    <p>Welcome, <?php echo htmlspecialchars($_SESSION['username']); ?>!</p>
    <p>You are logged in.</p>
    <a href="logout.php">Logout</a>
    <br>
</body>