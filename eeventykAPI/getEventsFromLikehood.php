<?php
if(isset($_GET["like"])){
    
    $likehood = $_GET["like"];
    
    $jsonResult = array();
    
    $connection = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb") or 
        die("mysql connection error");
    
    $query = mysqli_query($connection, "SELECT * from Evento "
            . "WHERE Gusto_evento = '".$likehood."'") or die(mysqli_error($connection));
  while($lista = mysqli_fetch_assoc($query)){
      $query2 = mysqli_query($connection, "SELECT * FROM Empresa "
              . "WHERE idEmpresa='".$lista["Empresa_idEmpresa"]."'") or die(mysqli_error($connection));
      while($lista2 = mysqli_fetch_assoc($query2)){
          $lista["NombreEmpresa"] = $lista2["Nombre"];
      }
      array_push($jsonResult, $lista);
  }
    
    echo json_encode($jsonResult);
    
    mysqli_close($connection);
}



