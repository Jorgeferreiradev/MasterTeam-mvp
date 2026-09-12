<?php

$request_uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);

// Si entra a la raíz o a /api/health
if ($request_uri === '/api/health' || $request_uri === '/health') {
    $controller = new \Controllers\HealthController();
    $controller->status();
    exit();
}

// Si la URL no coincide, imprimimos la que llegó para ver el desajuste
http_response_code(404);
echo json_encode([
    "error" => "Ruta no encontrada",
    "uri_recibida" => $request_uri
]);