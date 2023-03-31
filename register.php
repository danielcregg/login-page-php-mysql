<?php

session_start();

if( isset($_SESSION['user_id']) ){
	header("Location: /");
}

require 'database.php';

$message = '';

if(!empty($_POST['email']) && !empty($_POST['password'])):
	
	// Enter the new user in the database
	$sql = "INSERT INTO users (email, password) VALUES (:email, :password)";
	$stmt = $conn->prepare($sql);

	$stmt->bindParam(':email', $_POST['email']);
	$stmt->bindParam(':password', password_hash($_POST['password'], PASSWORD_BCRYPT));

	if( $stmt->execute() ):
		$message = 'Successfully created new user';
	else:
		$message = 'Sorry there must have been an issue creating your account';
	endif;

endif;

?>

<!DOCTYPE html>
<html>
<head>
	<title>Register Below</title>
</head>
<body>

	<h1>Your App Name OR Logo</h1>
	

	<h1>Register</h1>
	

	<form action="register.php" method="POST">
		
		<input type="text" placeholder="Enter your email" name="email">
		<input type="password" placeholder="and password" name="password">
		<input type="password" placeholder="confirm password" name="confirm_password">
		<input type="submit">
	</form>
	<span>or <a href="login.php">login here</a></span>
	<?php
		if (!empty($message)) {
    			echo "<p>" . $message . "</p>";
		}
		if ($message == "Successfully created new user") {
    			echo "<p>Redirecting to Login Page...</p>";
    			header("Refresh: 3; URL=login.php");
		}	
	?>
</body>
</html>
