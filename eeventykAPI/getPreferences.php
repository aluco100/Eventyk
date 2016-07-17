<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
$result = array();
$query = mysqli_query($link, "SELECT * from Gustos");
while($lista = mysqli_fetch_assoc($query)){
    array_push($result, $lista);
}
echo json_encode($result);
mysqli_close($link);