<?php

if(isset($_POST["idUser"])&&isset($_POST["idLikehood"])&&isset($_POST["flagToInsert"])){
    $idUser = $_POST["idUser"];
    $idLikehood = $_POST["idLikehood"];
    $flag = $_POST["flagToInsert"];
    
    $link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
    
    if($flag){
      $query = "INSERT INTO Usuario_has_Gustos(Usuario_idUsuario,Gustos_idGustos) "
            . "VALUES(".$idUser.",".$idLikehood.")";  
    }else{
       $query = "DELETE FROM Usuario_has_Gustos "
               . "WHERE Usuario_idUsuario=".$idUser." AND Gustos_idGustos=".$idLikehood; 
    }
    
    mysqli_query($link, $query) or die(mysqli_error($link));
    
    $jsonResult = array("result"=>"ok");
    
    echo json_encode($jsonResult);
    
    mysqli_close($link);
    
}