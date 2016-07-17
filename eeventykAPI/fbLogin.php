<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");

if($_POST["user"] && $_POST["name"]){
    $query = mysqli_query($link, "SELECT * from Usuario "
            . "where email = '".$_POST["user"]."'");
    if(mysqli_num_rows($query) <= 0){
        //insert
        mysqli_query($link, "INSERT INTO Usuario (Nombre, email) "
                . "VALUES('".$_POST["name"]."','".$_POST["user"]."')");
    }
}

mysqli_close($link);
