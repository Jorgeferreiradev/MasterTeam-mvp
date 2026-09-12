<?php

namespace Repositories;

require_once __DIR__ . '/../Config/Database.php';

use Config\Database;
use PDO;

class UserRepository
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    public function countActiveUsers(): int
    {
        $sql = "SELECT COUNT(*) FROM usuarios WHERE activo = 1";
        $stmt = $this->db->query($sql);
        return (int) $stmt->fetchColumn();
    }
}