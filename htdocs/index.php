<?php
echo '<h1>List all schemas of database</h1>';
// Connecting, selecting database
$dbconn = pg_connect("host=localhost port=5433 dbname=db_test user=user_db password=abc123")
    or die('Could not connect: ' . pg_last_error());

// Performing SQL query
$query = 'SELECT schema_name FROM information_schema.schemata';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

// Printing results in HTML
echo "<table>\n";
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Free resultset
pg_free_result($result);

// Closing connection
pg_close($dbconn);

// read and write file test
$fh = fopen('test.html', 'a');
fwrite($fh, '<h1>Hello world!</h1>');
fclose($fh);
// delete
unlink('test.html');

echo '<h1>Show phpinfo</h1>';

phpinfo();
