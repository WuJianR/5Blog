<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>出错了！-easyblog</title>
    <link rel="stylesheet" href="../resource/static/index.css">
</head>
<#import "./common/header.ftl" as t/>
<body>
<@t.top activePath="" />
<div class="body-container">
    ${errorMsg!''}
</div>
</body>
</html>