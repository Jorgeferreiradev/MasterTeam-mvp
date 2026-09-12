<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

spl_autoload_register(function ($class) {
    $file = __DIR__ . '/../src/' . str_replace('\\', DIRECTORY_SEPARATOR, $class) . '.php';
    if (file_exists($file)) {
        require_once $file;
    }
});

// Importar rutas (ajustado a donde tienes tu api.php)
require_once __DIR__ . '/../src/Routes/api.php';