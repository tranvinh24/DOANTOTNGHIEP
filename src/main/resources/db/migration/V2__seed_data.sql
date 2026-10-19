-- =============================================================================
-- Flyway Migration: V2__seed_data.sql
-- Seed Initial Data: 4 Roles, 10 Permissions, Default Admin, Role-Permissions
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Insert 4 Roles
-- -----------------------------------------------------------------------------
INSERT INTO `roles` (`id`, `code`, `name`, `is_deleted`, `created_at`) VALUES
(1, 'ROLE_ADMIN', 'Quản trị viên hệ thống', FALSE, NOW()),
(2, 'ROLE_LANDLORD', 'Chủ nhà trọ', FALSE, NOW()),
(3, 'ROLE_TENANT', 'Khách thuê trọ', FALSE, NOW()),
(4, 'ROLE_USER', 'Người dùng thông thường', FALSE, NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- -----------------------------------------------------------------------------
-- 2. Insert 10 Permissions (chia theo entity: READ, WRITE, DELETE + SYSTEM_ADMIN)
-- -----------------------------------------------------------------------------
INSERT INTO `permissions` (`id`, `code`, `name`, `is_deleted`) VALUES
-- Entity User (3 permissions)
(1, 'USER_READ', 'Xem thông tin người dùng', FALSE),
(2, 'USER_WRITE', 'Thêm và sửa thông tin người dùng', FALSE),
(3, 'USER_DELETE', 'Xóa người dùng', FALSE),

-- Entity Room (3 permissions)
(4, 'ROOM_READ', 'Xem thông tin phòng trọ', FALSE),
(5, 'ROOM_WRITE', 'Thêm và cập nhật phòng trọ', FALSE),
(6, 'ROOM_DELETE', 'Xóa phòng trọ', FALSE),

-- Entity Listing (3 permissions)
(7, 'LISTING_READ', 'Xem tin đăng phòng trọ', FALSE),
(8, 'LISTING_WRITE', 'Đăng và cập nhật tin đăng', FALSE),
(9, 'LISTING_DELETE', 'Xóa tin đăng', FALSE),

-- System Administration (1 permission)
(10, 'SYSTEM_ADMIN', 'Toàn quyền quản trị hệ thống', FALSE)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- -----------------------------------------------------------------------------
-- 3. Map Role - Permissions (role_permissions)
-- -----------------------------------------------------------------------------
-- ROLE_ADMIN (id=1): Nhận đủ tất cả 10 quyền
INSERT INTO `role_permissions` (`role_id`, `permission_id`, `is_deleted`) VALUES
(1, 1, FALSE), (1, 2, FALSE), (1, 3, FALSE),
(1, 4, FALSE), (1, 5, FALSE), (1, 6, FALSE),
(1, 7, FALSE), (1, 8, FALSE), (1, 9, FALSE),
(1, 10, FALSE)
ON DUPLICATE KEY UPDATE `is_deleted` = VALUES(`is_deleted`);

-- ROLE_LANDLORD (id=2): Quản lý phòng trọ và tin đăng của mình
INSERT INTO `role_permissions` (`role_id`, `permission_id`, `is_deleted`) VALUES
(2, 1, FALSE), -- USER_READ
(2, 4, FALSE), (2, 5, FALSE), (2, 6, FALSE), -- ROOM_READ, ROOM_WRITE, ROOM_DELETE
(2, 7, FALSE), (2, 8, FALSE), (2, 9, FALSE)  -- LISTING_READ, LISTING_WRITE, LISTING_DELETE
ON DUPLICATE KEY UPDATE `is_deleted` = VALUES(`is_deleted`);

-- ROLE_TENANT (id=3): Xem phòng trọ, xem tin đăng, xem thông tin người dùng
INSERT INTO `role_permissions` (`role_id`, `permission_id`, `is_deleted`) VALUES
(3, 1, FALSE), -- USER_READ
(3, 4, FALSE), -- ROOM_READ
(3, 7, FALSE)  -- LISTING_READ
ON DUPLICATE KEY UPDATE `is_deleted` = VALUES(`is_deleted`);

-- ROLE_USER (id=4): Người dùng cơ bản
INSERT INTO `role_permissions` (`role_id`, `permission_id`, `is_deleted`) VALUES
(4, 1, FALSE), -- USER_READ
(4, 4, FALSE), -- ROOM_READ
(4, 7, FALSE)  -- LISTING_READ
ON DUPLICATE KEY UPDATE `is_deleted` = VALUES(`is_deleted`);

-- -----------------------------------------------------------------------------
-- 4. Insert Default Admin User
-- Email: admin@phongtro.com | Password: admin123 (BCrypt hash)
-- -----------------------------------------------------------------------------
INSERT INTO `users` (
    `id`,
    `email`,
    `phone`,
    `password_hash`,
    `email_verified_at`,
    `phone_verified_at`,
    `status`,
    `last_login_at`,
    `is_deleted`,
    `created_at`,
    `updated_at`
) VALUES (
    1,
    'admin@phongtro.com',
    '0900000000',
    '$2a$10$mgKTYSVzeK4uR5xpkW9i1OUhMag635c0Si720xV8d71QRh2q1rZ26',
    NOW(),
    NOW(),
    'ACTIVE',
    NULL,
    FALSE,
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE `email` = VALUES(`email`);

-- -----------------------------------------------------------------------------
-- 5. Assign ROLE_ADMIN to Default Admin (user_roles)
-- -----------------------------------------------------------------------------
INSERT INTO `user_roles` (`user_id`, `role_id`, `is_deleted`, `created_at`) VALUES
(1, 1, FALSE, NOW())
ON DUPLICATE KEY UPDATE `is_deleted` = VALUES(`is_deleted`);
