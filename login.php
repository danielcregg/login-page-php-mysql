<?php

session_start();

if( isset($_SESSION['user_id']) ){
	header('Location: home.php');
}

require 'database.php';

if(!empty($_POST['email']) && !empty($_POST['password'])):
	
	$records = $conn->prepare('SELECT id,email,password FROM users WHERE email = :email');
	$records->bindParam(':email', $_POST['email']);
	$records->execute();
	$results = $records->fetch(PDO::FETCH_ASSOC);

	$message = '';

if ($results === false || count($results) == 0 || !password_verify($_POST['password'], $results['password'])) {
        $message = 'Sorry, those credentials do not match';
    } else {
        $_SESSION['user_id'] = $results['id'];
        header('Location: home.php');
    }

endif;
?>

<!DOCTYPE html>
<html>
<head>
	<title>Login Below</title>
</head>
<body>

	<h1>Your App Name OR Logo</h1>

	

	<h1>Login</h1>

	<form action="login.php" method="POST">
		
		<input type="text" placeholder="Enter your email" name="email">
		<input type="password" placeholder="and password" name="password">

		<input type="submit">

	</form>
	<span>or <a href="register.php">register here</a></span>
<?php if(!empty($message)): ?>
		<p><?= $message ?></p>
	<?php endif; ?>
</body>
</html>
