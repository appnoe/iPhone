<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<title>Dateiupload</title>
	</head>
	<body>
		<form enctype="multipart/form-data" method="POST">
			Code: <input type="text" name="code" value="<?php echo $_POST['code'] ?>"/></br />
			Message: <input type="text" name="message" value="<?php echo $_POST['message'] ?>" /></br />
			Choose a photo to upload: <input name="photo" type="file" /><br />
			<input type="submit" value="Upload File" />
		</form>
		<?php
			if(isset($_FILES['photo']) && move_uploaded_file($_FILES['photo']['tmp_name'], "uploads/".$_FILES['photo']['name'])) {
				echo "<p class='result'>Received ".$_FILES['photo']['name'].".</p>";
			}
		?>
	</body>
</html>
