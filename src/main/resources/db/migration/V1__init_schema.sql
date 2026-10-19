-- =============================================================================
-- Flyway Migration: V1__init_schema.sql
-- Database Schema for PhongTro (35 Tables)
-- Mapped from full ERD & JPA Entities with Soft Delete (is_deleted)
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- 1. users
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(150) UNIQUE NULL,
    `phone` VARCHAR(20) UNIQUE NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `email_verified_at` DATETIME NULL,
    `phone_verified_at` DATETIME NULL,
    `status` VARCHAR(50) NULL,
    `last_login_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 2. roles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(100) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 3. permissions
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(100) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 4. user_roles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_roles` (
    `user_id` BIGINT NOT NULL,
    `role_id` BIGINT NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    PRIMARY KEY (`user_id`, `role_id`),
    CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 5. role_permissions
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `role_permissions` (
    `role_id` BIGINT NOT NULL,
    `permission_id` BIGINT NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`role_id`, `permission_id`),
    CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 6. provinces
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `provinces` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 7. districts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `districts` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `province_id` BIGINT NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT `fk_districts_province` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 8. wards
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `wards` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `district_id` BIGINT NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT `fk_wards_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 9. room_types
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `room_types` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 10. amenities
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `amenities` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `icon` VARCHAR(255) NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 11. service_packages
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `service_packages` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(100) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `max_listings` INT NULL,
    `high_priority_quota` INT NULL,
    `low_priority_quota` INT NULL,
    `has_stats` BOOLEAN NULL,
    `price` DECIMAL(15, 2) NULL,
    `billing_cycle_days` INT NULL,
    `is_active` BOOLEAN NULL,
    `created_by` BIGINT NULL,
    `updated_by` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_service_packages_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_service_packages_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 12. boost_service_packages
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `boost_service_packages` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(100) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `priority_level` INT NULL,
    `duration_days` INT NULL,
    `price` DECIMAL(15, 2) NULL,
    `is_active` BOOLEAN NULL,
    `created_by` BIGINT NULL,
    `updated_by` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_boost_packages_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_boost_packages_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 13. service_package_subscriptions
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `service_package_subscriptions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `landlord_id` BIGINT NOT NULL,
    `package_id` BIGINT NOT NULL,
    `start_at` DATETIME NULL,
    `end_at` DATETIME NULL,
    `status` VARCHAR(50) NULL,
    `active_flag` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_service_pkg_sub_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_service_pkg_sub_package` FOREIGN KEY (`package_id`) REFERENCES `service_packages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 14. tenant_profiles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tenant_profiles` (
    `user_id` BIGINT PRIMARY KEY,
    `desired_province_id` BIGINT NULL,
    `desired_district_id` BIGINT NULL,
    `price_min` DECIMAL(15, 2) NULL,
    `price_max` DECIMAL(15, 2) NULL,
    `area_min` DECIMAL(10, 2) NULL,
    `area_max` DECIMAL(10, 2) NULL,
    `desired_room_type_id` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_tenant_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tenant_profiles_province` FOREIGN KEY (`desired_province_id`) REFERENCES `provinces` (`id`),
    CONSTRAINT `fk_tenant_profiles_district` FOREIGN KEY (`desired_district_id`) REFERENCES `districts` (`id`),
    CONSTRAINT `fk_tenant_profiles_room_type` FOREIGN KEY (`desired_room_type_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 15. rooms
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `rooms` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `landlord_id` BIGINT NOT NULL,
    `room_type_id` BIGINT NULL,
    `price` DECIMAL(15, 2) NULL,
    `area_m2` DECIMAL(10, 2) NULL,
    `province_id` BIGINT NULL,
    `district_id` BIGINT NULL,
    `ward_id` BIGINT NULL,
    `address_line` VARCHAR(500) NULL,
    `latitude` DECIMAL(10, 7) NULL,
    `longitude` DECIMAL(10, 7) NULL,
    `rental_status` VARCHAR(50) NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `deleted_at` DATETIME NULL,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_rooms_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_rooms_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`),
    CONSTRAINT `fk_rooms_province` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`),
    CONSTRAINT `fk_rooms_district` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
    CONSTRAINT `fk_rooms_ward` FOREIGN KEY (`ward_id`) REFERENCES `wards` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 16. room_images
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `room_images` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `room_id` BIGINT NOT NULL,
    `url` VARCHAR(1000) NOT NULL,
    `sort_order` INT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT `fk_room_images_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 17. room_amenities
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `room_amenities` (
    `room_id` BIGINT NOT NULL,
    `amenity_id` BIGINT NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`room_id`, `amenity_id`),
    CONSTRAINT `fk_room_amenities_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_room_amenities_amenity` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 18. listings
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `listings` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `room_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `title` VARCHAR(500) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) NULL,
    `priority_level` INT NULL,
    `view_count` INT NULL,
    `contact_count` INT NULL,
    `expires_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `deleted_at` DATETIME NULL,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_listings_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
    CONSTRAINT `fk_listings_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 19. saved_listings
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `saved_listings` (
    `tenant_id` BIGINT NOT NULL,
    `listing_id` BIGINT NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    PRIMARY KEY (`tenant_id`, `listing_id`),
    CONSTRAINT `fk_saved_listings_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_saved_listings_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 20. listing_view_history
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `listing_view_history` (
    `tenant_id` BIGINT NOT NULL,
    `listing_id` BIGINT NOT NULL,
    `viewed_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`tenant_id`, `listing_id`),
    CONSTRAINT `fk_listing_view_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_listing_view_history_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 21. listing_daily_stats
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `listing_daily_stats` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `listing_id` BIGINT NOT NULL,
    `stat_date` DATE NULL,
    `view_count` INT NULL,
    `contact_count` INT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_listing_daily_stats_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 22. listing_contact_events
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `listing_contact_events` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `listing_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_listing_contact_events_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_listing_contact_events_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 23. boost_service_package_subscriptions
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `boost_service_package_subscriptions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `landlord_id` BIGINT NOT NULL,
    `listing_id` BIGINT NOT NULL,
    `boost_package_id` BIGINT NOT NULL,
    `start_at` DATETIME NULL,
    `end_at` DATETIME NULL,
    `status` VARCHAR(50) NULL,
    `price` DECIMAL(15, 2) NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_boost_pkg_sub_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_boost_pkg_sub_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_boost_pkg_sub_package` FOREIGN KEY (`boost_package_id`) REFERENCES `boost_service_packages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 24. rental_requests
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `rental_requests` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `listing_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `message` VARCHAR(1000) NULL,
    `status` VARCHAR(50) NULL,
    `responded_at` DATETIME NULL,
    `expires_at` DATETIME NULL,
    `pending_key` VARCHAR(255) NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_rental_requests_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`),
    CONSTRAINT `fk_rental_requests_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_rental_requests_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 25. rental_agreements
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `rental_agreements` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `rental_request_id` BIGINT NULL,
    `room_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `price` DECIMAL(15, 2) NULL,
    `deposit` DECIMAL(15, 2) NULL,
    `start_date` DATE NULL,
    `end_date` DATE NULL,
    `terms_text` TEXT NULL,
    `contract_file_url` VARCHAR(500) NULL,
    `status` VARCHAR(50) NULL,
    `created_by_role` VARCHAR(50) NULL,
    `landlord_confirmed_at` DATETIME NULL,
    `tenant_confirmed_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    `updated_at` DATETIME NULL,
    CONSTRAINT `fk_rental_agreements_request` FOREIGN KEY (`rental_request_id`) REFERENCES `rental_requests` (`id`),
    CONSTRAINT `fk_rental_agreements_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
    CONSTRAINT `fk_rental_agreements_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_rental_agreements_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 26. chat_conversations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `chat_conversations` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `listing_id` BIGINT NULL,
    `rental_request_id` BIGINT NULL,
    `tenant_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `last_message_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_chat_conversations_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`),
    CONSTRAINT `fk_chat_conversations_request` FOREIGN KEY (`rental_request_id`) REFERENCES `rental_requests` (`id`),
    CONSTRAINT `fk_chat_conversations_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_chat_conversations_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 27. chat_messages
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `chat_messages` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `conversation_id` BIGINT NOT NULL,
    `sender_id` BIGINT NOT NULL,
    `content` TEXT NULL,
    `message_type` VARCHAR(50) NULL,
    `is_read` BOOLEAN NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_chat_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `chat_conversations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_chat_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 28. reports
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `reports` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `tenant_id` BIGINT NULL,
    `landlord_id` BIGINT NULL,
    `listing_id` BIGINT NULL,
    `reason_code` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `status` VARCHAR(50) NULL,
    `handled_by` BIGINT NULL,
    `resolution_note` TEXT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    `resolved_at` DATETIME NULL,
    CONSTRAINT `fk_reports_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_reports_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_reports_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`),
    CONSTRAINT `fk_reports_handled_by` FOREIGN KEY (`handled_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 29. report_evidences
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `report_evidences` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `report_id` BIGINT NOT NULL,
    `image_url` VARCHAR(1000) NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT `fk_report_evidences_report` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 30. payments
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `payments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `landlord_id` BIGINT NOT NULL,
    `type` VARCHAR(50) NULL,
    `reference_id` BIGINT NULL,
    `amount` DECIMAL(15, 2) NULL,
    `payment_method` VARCHAR(50) NULL,
    `status` VARCHAR(50) NULL,
    `provider_txn_id` VARCHAR(255) NULL,
    `paid_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_payments_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 31. invoices
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `invoices` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `payment_id` BIGINT NOT NULL,
    `type` VARCHAR(50) NULL,
    `service_package_id` BIGINT NULL,
    `invoice_no` VARCHAR(100) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `buyer_name` VARCHAR(255) NULL,
    `buyer_tax_code` VARCHAR(100) NULL,
    `issued_at` DATETIME NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_invoices_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 32. room_reviews
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `room_reviews` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `rental_agreement_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `room_id` BIGINT NOT NULL,
    `rating` INT NULL,
    `comment` TEXT NULL,
    `landlord_reply` TEXT NULL,
    `is_hidden` BOOLEAN NULL,
    `hidden_by` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_room_reviews_agreement` FOREIGN KEY (`rental_agreement_id`) REFERENCES `rental_agreements` (`id`),
    CONSTRAINT `fk_room_reviews_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_room_reviews_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
    CONSTRAINT `fk_room_reviews_hidden_by` FOREIGN KEY (`hidden_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 33. landlord_reviews
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `landlord_reviews` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `rental_agreement_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `rating` INT NULL,
    `comment` TEXT NULL,
    `landlord_reply` TEXT NULL,
    `is_hidden` BOOLEAN NULL,
    `hidden_by` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_landlord_reviews_agreement` FOREIGN KEY (`rental_agreement_id`) REFERENCES `rental_agreements` (`id`),
    CONSTRAINT `fk_landlord_reviews_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_landlord_reviews_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_landlord_reviews_hidden_by` FOREIGN KEY (`hidden_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 34. tenant_reviews
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tenant_reviews` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `rental_agreement_id` BIGINT NOT NULL,
    `landlord_id` BIGINT NOT NULL,
    `tenant_id` BIGINT NOT NULL,
    `rating` INT NULL,
    `comment` TEXT NULL,
    `is_hidden` BOOLEAN NULL,
    `hidden_by` BIGINT NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_tenant_reviews_agreement` FOREIGN KEY (`rental_agreement_id`) REFERENCES `rental_agreements` (`id`),
    CONSTRAINT `fk_tenant_reviews_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_tenant_reviews_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `users` (`id`),
    CONSTRAINT `fk_tenant_reviews_hidden_by` FOREIGN KEY (`hidden_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 35. notifications
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `notifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `type` VARCHAR(50) NULL,
    `title` VARCHAR(255) NULL,
    `body` TEXT NULL,
    `reference_type` VARCHAR(50) NULL,
    `reference_id` BIGINT NULL,
    `is_read` BOOLEAN NULL,
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NULL,
    CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
