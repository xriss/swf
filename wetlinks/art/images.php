<html>
<head>
    <title>WetGenes Game icons and images</title>
<link rel="stylesheet" type="text/css" href="/css/base.css"></link>
</head>
<body>
    <?php
    if ($handle = opendir('.'))
	{
        // Loop through the directory and get commonly used image files (.jpeg, .jpg, .gif, .png)
		echo '<center><br /><br />';
        while (false !== ($file = readdir($handle)))
		{
            if (eregi('\.jpg|\.jpeg|\.gif|\.png', $file))
			{
				
                echo '<a href="'.$file.'"><img src="http://swf.wetgenes.com/swf/wetlinks/'.$file.'" /></a><br />http://swf.wetgenes.com/swf/wetlinks/'.$file.'<br /><br /><br />';
            }
        }
        closedir($handle); // Close our file handle.
		echo '<br /></center>';
    }
    ?>
</body>
</html>