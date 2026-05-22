-- 2026-05-20 15:07:05.702204
-- MySQL Migration File
-- Name: chat table
-- ## NEW VERSION:

CREATE TABLE `chats` (
    `id` int NOT NULL AUTO_INCREMENT,
    `user_id` int NOT NULL,
    `message` text NOT NULL,
    `receiver_id` int DEFAULT NULL,
    `channel_id` int DEFAULT NULL,
    `is_read` boolean DEFAULT FALSE,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`),
    FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`),
    -- Add indexes for faster queries
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_receiver_id` (`receiver_id`),
    INDEX `idx_channel_id` (`channel_id`),
    -- Add a full-text index for message search
    FULLTEXT INDEX `idx_message` (`message`)
    
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- ## ROLL BACK:

DROP TABLE IF EXISTS `chats`;