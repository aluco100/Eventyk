<?php
if(isset($_GET["username"])&&isset($_GET["mail"])&&isset($_GET["birthdate"])
        &&isset($_GET["id"])){
    $user = $_GET["username"];
    $mail = $_GET["mail"];
    $birthdate = $_GET["birthdate"];
    $id = $_GET["id"];
    
    $link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
    mysqli_query($link, "UPDATE Usuario "
            . "SET Nombre='".$user."',email='".$mail."',Fecha_Nacimiento='".$birthdate."' "
            . "WHERE idUsuario=".$id);
    
    $jsonValue = array("result" => "Ok");
    
    echo json_encode($jsonValue);
    
    mysqli_close($link);
}