<?php

$link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
$result = array();
if($_GET["limit"]){
  $query = mysqli_query($link, "SELECT * from Evento ORDER BY Fecha DESC LIMIT ".$_GET["limit"]."");
  while($lista = mysqli_fetch_assoc($query)){
      $query2 = mysqli_query($link, "SELECT * FROM Empresa "
              . "WHERE idEmpresa='".$lista["Empresa_idEmpresa"]."'");
      while($lista2 = mysqli_fetch_assoc($query2)){
          $lista["NombreEmpresa"] = $lista2["Nombre"];
          //$aux = array("NombreEmpresa" => $lista2["Nombre"]);
          //array_push($lista, $aux);
      }
      array_push($result, $lista);
  }
  echo json_encode($result);
//echo json_encode(mysqli_fetch_assoc($query));
}else{
  $query = mysqli_query($link, "SELECT * from Evento ORDER BY Fecha DESC");
  while($lista = mysqli_fetch_assoc($query)){
      $query2 = mysqli_query($link, "SELECT * FROM Empresa "
              . "WHERE idEmpresa='".$lista["Empresa_idEmpresa"]."'");
      while($lista2 = mysqli_fetch_assoc($query2)){
          $lista["NombreEmpresa"] = $lista2["Nombre"];
          //$aux = array("NombreEmpresa" => $lista2["Nombre"]);
          //array_push($lista, $aux);
      }
      array_push($result, $lista);
  }
  echo json_encode($result);
  //echo json_encode(mysqli_fetch_assoc($query)); 
}

mysqli_close($link);



