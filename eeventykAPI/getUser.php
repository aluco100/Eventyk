<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
if($_GET["user"] && $_GET["pass"]){
    $query = mysqli_query($link, "SELECT * from Usuario WHERE email='".$_GET["user"]."' "
            . "AND Password='".$_GET["pass"]."'");
    if(mysqli_num_rows($query) > 0){
        echo json_encode(mysqli_fetch_assoc($query));
    }
}
mysqli_close($link);