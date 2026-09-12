<?php

namespace Controllers;

use Repositories\UserRepository;

class HealthController
{
    public function status(): void
    {
        try {
            $userRepo = new UserRepository();
            $totalUsers = $userRepo->countActiveUsers();

            http_response_code(200);
            echo json_encode([
                "status" => "success",
                "message" => "Conexión a MariaDB exitosa y operativa",
                "active_users" => $totalUsers
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Fallo de conexión a la base de datos: " . $e->getMessage()
            ]);
        }
    }
}