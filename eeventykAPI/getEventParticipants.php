<?php
$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
$result = array();
if($_GET["idEvent"]){
    $query = mysqli_query($link, "SELECT idUsuario,Nombre from Lista_Evento "
            . "INNER JOIN Usuario on Usuario_idUsuario = idUsuario "
            . "WHERE Evento_idEvento = '".$_GET["idEvent"]."'");
    while($lista = mysqli_fetch_assoc($query)){
        array_push($result, $lista);
    }
    echo json_encode($result);
}
mysqli_close($link);