<?php

  $uploaddir = './FotosDePerfil/';
	$file = basename($_FILES['userfile']['name']);
	$uploadfile = $uploaddir . $file;

	if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
      // echo "myurl/uploads/{$file}";
		echo $uploadfile;
  }
  else{
    echo "erro";
	}

	$error = error_get_last();
	echo $error['message'];

?>