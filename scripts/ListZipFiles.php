import QtQuick 2.12;
ListModel {
<?php
foreach (glob("*.zip") as $filename)
    echo "\tListElement{ uidAlias:'".pathinfo($filename)['filename']."'; lastAccess:'".date("Y-m-d H:i",filemtime("./".$filename))."'}\n";

?>
}