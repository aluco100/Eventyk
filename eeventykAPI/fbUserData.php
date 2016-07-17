<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
$result = array();

if($_GET["user"]){
    $query = mysqli_query($link, "SELECT * from Usuario "
            . "WHERE email = '".$_GET["user"]."'");
    if(mysqli_num_rows($query) > 0){
        array_push($result, mysqli_fetch_assoc($query));
    }
    echo json_encode($result);
}

mysqli_close($link);