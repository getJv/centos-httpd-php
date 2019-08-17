<?php

# Fonte:  https://www.opentechguides.com/how-to/article/php/143/oracle-php-oci8.html

$user         = env('DB_USERNAME');
$pass         = env('DB_PASSWORD');
$host         = env('DB_HOST');
$service_name = env('DB_SERVICE_NAME');


$conn = @oci_connect($user, $pass, $host . '/' . $service_name );

if (!$conn) {
   die("Database Connection Error");
}

$stid = oci_parse($conn, 'SELECT * from EMPLOYEES');
oci_execute($stid);
echo "<table>";
echo "<tr><th>First Name</th><th>Last Name</th></tr>";
while (($emp = oci_fetch_array($stid, OCI_BOTH)) != false) {
	echo "<tr>";	
	echo "<td>".$emp['FIRST_NAME']."</td>";
	echo "<td>".$emp['LAST_NAME']."</td>";
	echo "</tr>";
	}
echo "</table>";
