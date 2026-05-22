-- 2026-05-16 23:07:17.282163 
-- MySQL Migration File 
-- Name: insert_admin_user 
-- ## NEW VERSION:

INSERT INTO users (`username`, `email`, `password`)
VALUES
('test', 'test@uproid.com', 'LKIjl9NiYcaTl4XbCn+BgbVpQhWCdRPc71//ldMLim2QksnNYJeYSf5j4Yj6A691');

-- ## ROLL BACK:

DELETE FROM users WHERE username = 'test';



