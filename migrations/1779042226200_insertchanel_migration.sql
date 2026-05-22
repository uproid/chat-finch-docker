-- 2026-05-17 18:23:46.205166 
-- MySQL Migration File 
-- Name: insert_channel 
-- ## NEW VERSION:

INSERT INTO `channels` (`slug`) VALUES ('general'),
('random'),
('help'),
('announcements');


-- ## ROLL BACK:

DELETE FROM `channels` WHERE `slug` IN ('general', 'random', 'help', 'announcements');



