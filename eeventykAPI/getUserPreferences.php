<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
$result = array();
if($_GET["idUser"]){
    $query = mysqli_query($link, "SELECT * FROM Usuario_has_Gustos "
            . "INNER JOIN Gustos ON Gustos_idGustos = idGustos "
            . "WHERE Usuario_idUsuario='".$_GET["idUser"]."'");
    while($lista = mysqli_fetch_assoc($query)){
        array_push($result, $lista);
    }
    echo json_encode($result);
}
mysqli_close($link);