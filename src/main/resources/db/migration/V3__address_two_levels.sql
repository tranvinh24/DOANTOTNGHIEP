-- =============================================================================
-- Flyway Migration: V3__address_two_levels.sql
-- Chuyển địa chỉ từ 3 cấp (Province → District → Ward) sang 2 cấp (Province → Ward)
-- Idempotent: an toàn với DB đã có district_id, đã có province_id, hoặc cả hai.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. wards: thêm province_id nếu chưa có
-- -----------------------------------------------------------------------------
SET @col_exists := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'wards'
      AND COLUMN_NAME = 'province_id'
);
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE `wards` ADD COLUMN `province_id` BIGINT NULL AFTER `id`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- 2. Backfill province_id từ districts (nếu còn district_id)
-- -----------------------------------------------------------------------------
SET @has_district_id := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'wards'
      AND COLUMN_NAME = 'district_id'
);
SET @sql := IF(@has_district_id > 0,
    'UPDATE `wards` w INNER JOIN `districts` d ON w.district_id = d.id SET w.province_id = d.province_id WHERE w.province_id IS NULL',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- 3. Gỡ FK/cột district_id trên wards
-- -----------------------------------------------------------------------------
SET @fk := (
    SELECT CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'wards'
      AND COLUMN_NAME = 'district_id'
      AND REFERENCED_TABLE_NAME IS NOT NULL
    LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL,
    CONCAT('ALTER TABLE `wards` DROP FOREIGN KEY `', @fk, '`'),
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(@has_district_id > 0,
    'ALTER TABLE `wards` DROP COLUMN `district_id`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- 4. FK wards → provinces + province_id NOT NULL
-- -----------------------------------------------------------------------------
SET @fk_exists := (
    SELECT COUNT(*)
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'wards'
      AND COLUMN_NAME = 'province_id'
      AND REFERENCED_TABLE_NAME = 'provinces'
);
SET @sql := IF(@fk_exists = 0,
    'ALTER TABLE `wards` ADD CONSTRAINT `fk_wards_province` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DELETE FROM `wards` WHERE `province_id` IS NULL;

ALTER TABLE `wards` MODIFY COLUMN `province_id` BIGINT NOT NULL;

-- -----------------------------------------------------------------------------
-- 5. rooms: bỏ district_id
-- -----------------------------------------------------------------------------
SET @fk := (
    SELECT CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'rooms'
      AND COLUMN_NAME = 'district_id'
      AND REFERENCED_TABLE_NAME IS NOT NULL
    LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL,
    CONCAT('ALTER TABLE `rooms` DROP FOREIGN KEY `', @fk, '`'),
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'rooms'
      AND COLUMN_NAME = 'district_id'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `rooms` DROP COLUMN `district_id`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- 6. tenant_profiles: bỏ desired_district_id
-- -----------------------------------------------------------------------------
SET @fk := (
    SELECT CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'tenant_profiles'
      AND COLUMN_NAME = 'desired_district_id'
      AND REFERENCED_TABLE_NAME IS NOT NULL
    LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL,
    CONCAT('ALTER TABLE `tenant_profiles` DROP FOREIGN KEY `', @fk, '`'),
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'tenant_profiles'
      AND COLUMN_NAME = 'desired_district_id'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `tenant_profiles` DROP COLUMN `desired_district_id`',
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------------------------
-- 7. Xóa bảng districts (sau khi không còn FK tham chiếu)
-- -----------------------------------------------------------------------------
SET @fk := (
    SELECT CONSTRAINT_NAME
    FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE()
      AND TABLE_NAME = 'districts'
      AND CONSTRAINT_NAME = 'fk_districts_province'
      AND CONSTRAINT_TYPE = 'FOREIGN KEY'
    LIMIT 1
);
SET @sql := IF(@fk IS NOT NULL,
    CONCAT('ALTER TABLE `districts` DROP FOREIGN KEY `', @fk, '`'),
    'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DROP TABLE IF EXISTS `districts`;
