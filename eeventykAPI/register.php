<?php

use DateTime;

/*
 *
 * ###################################################
 * ###################################################
 * POST Method
 * login in eventyk app
 * ################################################### 
 * ###################################################
 *  */

function getAge($birth){
    $from = new DateTime($birth);
    $to = new DateTime('today');
    return $from->diff($to)->y;
}

$jsonResult = array();


if($_POST["name"] && $_POST["pass"] && $_POST["birthdate"] && $_POST["email"] 
        && $_POST["city"]){
    $link = mysqli_connect("localhost", "eventykc_ikafeb", "EvEnTyK_OtT_ikafeb","eventykc_eventykdb")
            or die("mysql connection error");
    $flag = mysqli_query($link, "SELECT * FROM Usuario Where email='".$_POST["email"]."'");
    if(mysqli_num_rows($flag) > 0){
        //has that user
    }else{
        $query = mysqli_query($link, "INSERT INTO Usuario (Nombre, Password, "
            . "Fecha_Nacimiento, email, Ciudad) "
            . "VALUES('".$_POST["name"]."', '".$_POST["pass"]."', "
            . "'".$_POST["birthdate"]."', '".$_POST["email"]."', '".$_POST["city"]."')");
    }
    
    $jsonResult = array("success" => 1);
    echo json_encode($jsonResult);
    mysqli_close($link);  
        }else{
            
            //failure
            $jsonResult = array("success" => 0); 
            echo json_encode($jsonResult);
            
        }

        
