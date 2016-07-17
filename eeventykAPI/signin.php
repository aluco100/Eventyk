
<?php
/*
 *####################################################
 *####################################################
 * default user: Admin or Admin@eventyk.com
 * default pass: alt001
 *  
 * ###################################################
 * ###################################################
 *  */

$user = $_GET["user"];
$pass = $_GET["pass"];

$jsonResult = array();
$connection = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb") or 
        die("mysql connection error");
$query = mysqli_query($connection, "SELECT * from Usuario "
        . "where email='".$user."' AND Password='".$pass."'");

if(mysqli_num_rows($query) > 0){
    
    //success
    $jsonResult = array("success" => 1);
    echo json_encode($jsonResult);
    
}  else {
    
    //failure
    $jsonResult = array("success" => 0);
    echo json_encode($jsonResult);
    
}

mysqli_close($connection);

?>