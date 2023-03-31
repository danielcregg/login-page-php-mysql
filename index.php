<?php

session_start();

require 'database.php';

if( isset($_SESSION['user_id']) ){

	$records = $conn->prepare('SELECT id,email,password FROM users WHERE id = :id');
	$records->bindParam(':id', $_SESSION['user_id']);
	$records->execute();
	$results = $records->fetch(PDO::FETCH_ASSOC);

	$user = NULL;

	if( count($results) > 0){
		$user = $results;
	}

}

?>

<!DOCTYPE html>
<html>
<head>
	<title>Login Page</title>
</head>
<body>
	<h1>Your App Name OR Logo</h1>

	<?php 
		if (!empty($user)) {
    			header('Location: home.php');
		} else {
    			echo '<h1>Please <a href="login.php">Login</a> or <a href="register.php">Register</a></h1>';
		}
	?>
</body>
</html>
