-- 2026-05-17 13:39:03.533292 
-- MySQL Migration File 
-- Name: create_channels 
-- ## NEW VERSION:

CREATE TABLE `channels` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ## ROLL BACK:

DROP TABLE `channels`;



