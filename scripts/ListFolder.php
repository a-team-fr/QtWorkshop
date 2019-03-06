import QtQuick 2.12;
ListModel {
<?php
    if ($handle = opendir("./"))
    {
        while (false !== ($entry = readdir($handle))) {
            if ($entry != "." && $entry != ".." && is_dir($entry))
                echo "\tListElement{ uidAlias:'".$entry."'; lastAccess:'".date("Y-m-d H:i",filemtime("./".$entry))."'}\n";
            }
        
        closedir($handle);
    } 

?>
}