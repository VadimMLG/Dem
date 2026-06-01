-- ============================================================
-- ГОТОВЫЙ SQL ДЛЯ ВАРИАНТА 5 (01.06.2026)
-- Магазин мебели
-- Импортируй этот файл в phpMyAdmin ВМЕСТО shoe2026_pu.sql
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
/*!40101 SET NAMES utf8mb4 */;

-- Создание таблиц
CREATE TABLE `categories` (`category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `name` varchar(120) NOT NULL, PRIMARY KEY (`category_id`), UNIQUE KEY `name` (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `manufacturers` (`manufacturer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `name` varchar(120) NOT NULL, PRIMARY KEY (`manufacturer_id`), UNIQUE KEY `name` (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `suppliers` (`supplier_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `name` varchar(120) NOT NULL, PRIMARY KEY (`supplier_id`), UNIQUE KEY `name` (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `roles` (`role_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, `role_name` varchar(60) NOT NULL, PRIMARY KEY (`role_id`), UNIQUE KEY `role_name` (`role_name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `users` (`user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `role_id` tinyint(3) UNSIGNED NOT NULL, `full_name` varchar(200) NOT NULL, `login` varchar(120) NOT NULL, `password_plain` varchar(120) NOT NULL, PRIMARY KEY (`user_id`), UNIQUE KEY `login` (`login`), KEY `fk_users_roles` (`role_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `products` (`product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `article` varchar(50) NOT NULL, `name` varchar(200) NOT NULL, `unit_name` varchar(20) NOT NULL, `price` decimal(12,2) DEFAULT NULL, `supplier_id` int(10) UNSIGNED NOT NULL, `manufacturer_id` int(10) UNSIGNED NOT NULL, `category_id` int(10) UNSIGNED NOT NULL, `discount_percent` decimal(5,2) DEFAULT NULL, `stock_quantity` int(11) DEFAULT NULL, `description_text` text DEFAULT NULL, `photo_file` varchar(255) DEFAULT NULL, PRIMARY KEY (`product_id`), UNIQUE KEY `article` (`article`), KEY `fk_products_manufacturers` (`manufacturer_id`), KEY `idx_products_supplier` (`supplier_id`), KEY `idx_products_category` (`category_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `order_statuses` (`status_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, `status_name` varchar(60) DEFAULT NULL, PRIMARY KEY (`status_id`), UNIQUE KEY `status_name` (`status_name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `pickup_points` (`pickup_point_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `address_text` varchar(255) DEFAULT NULL, PRIMARY KEY (`pickup_point_id`), UNIQUE KEY `address_text` (`address_text`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `orders` (`order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `order_number` int(10) UNSIGNED NOT NULL, `article_text` varchar(255) NOT NULL, `order_date` date DEFAULT NULL, `delivery_date` date DEFAULT NULL, `pickup_point_id` int(10) UNSIGNED NOT NULL, `client_user_id` int(10) UNSIGNED DEFAULT NULL, `pickup_code` int(10) UNSIGNED NOT NULL, `status_id` tinyint(3) UNSIGNED NOT NULL, PRIMARY KEY (`order_id`), UNIQUE KEY `order_number` (`order_number`), KEY `fk_orders_pickup_points` (`pickup_point_id`), KEY `fk_orders_users` (`client_user_id`), KEY `idx_orders_status` (`status_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `order_items` (`order_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `order_id` int(10) UNSIGNED NOT NULL, `product_id` int(10) UNSIGNED NOT NULL, `quantity` int(11) DEFAULT NULL, PRIMARY KEY (`order_item_id`), UNIQUE KEY `uk_order_product` (`order_id`,`product_id`), KEY `idx_order_items_product` (`product_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- RAW таблицы для импорта
CREATE TABLE `products_import_raw` (`article_text` varchar(60), `name_text` varchar(200), `unit_text` varchar(20), `price_text` varchar(40), `supplier_text` varchar(120), `manufacturer_text` varchar(120), `category_text` varchar(120), `discount_text` varchar(40), `stock_text` varchar(40), `description_text` text, `photo_text` varchar(120)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `users_import_raw` (`role_name` varchar(100), `full_name` varchar(200), `login_text` varchar(120), `password_text` varchar(120)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `orders_import_raw` (`raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `order_number_text` varchar(40), `articles_text` varchar(255), `order_date_text` varchar(40), `delivery_date_text` varchar(40), `pickup_point_text` varchar(40), `client_fio_text` varchar(200), `pickup_code_text` varchar(40), `status_text` varchar(80), PRIMARY KEY (`raw_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
CREATE TABLE `pickup_points_import_raw` (`raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, `address_text` varchar(255), PRIMARY KEY (`raw_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ============================================================
-- РОЛИ
-- ============================================================
INSERT INTO `roles` (`role_name`) VALUES ('Гость'), ('Авторизированный клиент'), ('Менеджер'), ('Администратор');

-- ============================================================
-- ПОЛЬЗОВАТЕЛИ (из user_import.xlsx)
-- ============================================================
INSERT INTO `users` (`role_id`, `full_name`, `login`, `password_plain`) VALUES
(4, 'Никифорова Анна Семеновна', '94d5ous@gmail.com', 'uzWC67'),
(4, 'Стелина Евгения Петровна', 'uth4iz@mail.com', '2L6KZG'),
(4, 'Никифорова Весения Николаевна', '5d4zbu@tutanota.com', 'rwVDh9'),
(3, 'Сазонов Руслан Германович', 'ptec8ym@yahoo.com', 'LdNyos'),
(3, 'Одинцов Серафим Артёмович', '1qz4kw@mail.com', 'gynQMT'),
(3, 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr'),
(2, 'Степанов Михаил Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
(2, 'Михайлюк Анна Вячеславовна', '1diph5e@tutanota.com', '8ntwUp'),
(2, 'Ситдикова Елена Анатольевна', 'tjde7c@yahoo.com', 'YOyhfR'),
(2, 'Ворсин Петр Евгеньевич', 'wpmrc3do@tutanota.com', 'RSbvHv');

-- ============================================================
-- КАТЕГОРИИ (из Tovar.xlsx)
-- ============================================================
INSERT INTO `categories` (`name`) VALUES ('Прихожая'), ('Диван'), ('Обувница'), ('Пуф'), ('Полка'), ('Стул');

-- ============================================================
-- ПРОИЗВОДИТЕЛИ (из Tovar.xlsx)
-- ============================================================
INSERT INTO `manufacturers` (`name`) VALUES ('SVМЕБЕЛЬ'), ('Мебелони'), ('Инвуд'), ('RIDBERG');

-- ============================================================
-- ПОСТАВЩИКИ (из Tovar.xlsx)
-- ============================================================
INSERT INTO `suppliers` (`name`) VALUES ('Стройландия'), ('Кромма'), ('ЗолотоеРуно'), ('KRYLOVMANUFACTURA');

-- ============================================================
-- ТОВАРЫ (из Tovar.xlsx)
-- ============================================================
INSERT INTO `products` (`article`, `name`, `unit_name`, `price`, `supplier_id`, `manufacturer_id`, `category_id`, `discount_percent`, `stock_quantity`, `description_text`, `photo_file`) VALUES
('А112Т4', 'Прихожая Фаворит 1 1420х2056х352ммм Дуб Делано/Цемент Светлый SV-М 1 шт', 'шт.', 9577.00, 1, 1, 1, 10.00, 0, 'Удивительно функциональная и практичная прихожая Фаворит 1, обладая характерными чертами Скандинавского стиля, выглядит эффектно и способна задать тон интерьеру дома, встречая вас и ваших гостей.', '1.jpg'),
('G843H5', 'Прихожая в коридор Твист с зеркалом мебель со шкафами, 120х37х202 см', 'шт.', 8803.00, 1, 2, 1, 25.00, 9, 'Этот стеллаж со шкафом в прихожую комнату станет отличным элементом для вашего интерьера. Мебель для дома обеспечивает удобное хранение перчаток, шапок, зонтов, сумок и других аксессуаров.', '2.jpg'),
('D325D4', 'Угловой диван Кромма Инвуд Лайт, серый двухместный диван, Velutto 32', 'шт.', 29125.00, 2, 3, 2, 5.00, 12, 'Угловой диван Инвуд Лайт 2 - стильный и комфортный диван подойдет для комнаты любого размера.', '3.jpg'),
('S432T5', 'Обувница RIDBERG, с вешалкой, стальная, 170x60x26 см, 5 полок, вместимость до 15 пар', 'шт.', 885.00, 2, 4, 3, 15.00, 15, 'Обувница Ridberg с 5 полками и вешалкой - идеальное решение для организации хранения обуви в прихожей или гардеробной.', '4.jpg'),
('F325D4', 'Диван, Прямой диван, Диван-кровать Сити темно-коричневый. Квест-33', 'шт.', 14322.00, 3, 3, 2, 18.00, 3, 'Прямой диван-кровать Сити - это современное и функциональное решение для вашего дома.', '5.jpg'),
('G432G6', 'Пуф трансформер кровать раскладушка светло-коричневый велюр', 'шт.', 6149.00, 4, 3, 4, 22.00, 3, 'Пуф трансформер 5в1 представляет собой уникальное сочетание функций, выступая в качестве пуфика, столика, кресла, шезлонга и дополнительного спального места.', '6.jpg'),
('H542F5', 'Диван, Прямой диван, диван кровать, Рио симпл механизм Пантограф. Симпл-16', 'шт.', 20708.00, 3, 3, 2, 4.00, 5, 'Диван Рио симпл от "Золотое Руно" - это сочетание комфорта, функциональности и стильного дизайна.', '7.jpg'),
('C346F5', 'Полка настенная ромб Лофт, черная, 40 см', 'шт.', 2843.00, 4, 4, 5, 5.00, 4, 'Полочки для цветов в стиле лофт. Подойдут как для цветов, так и в качестве декоративного элемента.', '8.jpg'),
('F256G6', 'Стулья для кухни', 'шт.', 4760.00, 4, 4, 6, 6.00, 2, 'Набор из четырех стульев в лофт-дизайне станет любимой мебелью для отдыха и подойдет для взрослых и детей.', '9.jpg'),
('J532V5', 'Магнитная полка, для холодильника, металл, 3шт, универсальная, чёрная', 'шт.', 1387.00, 4, 4, 5, 8.00, 6, 'Магнитная полка для холодильника - это удобный и практичный аксессуар, который поможет организовать пространство в вашем доме.', '10.jpg');

-- ============================================================
-- СТАТУСЫ ЗАКАЗОВ
-- ============================================================
INSERT INTO `order_statuses` (`status_name`) VALUES ('Новый'), ('Завершен');

-- ============================================================
-- ПУНКТЫ ВЫДАЧИ (из Пункты выдачи_import.xlsx)
-- ============================================================
INSERT INTO `pickup_points` (`address_text`) VALUES
('420151, г. Лесной, ул. Вишневая, 32'),
('125061, г. Лесной, ул. Подгорная, 8'),
('630370, г. Лесной, ул. Шоссейная, 24'),
('400562, г. Лесной, ул. Зеленая, 32'),
('614510, г. Лесной, ул. Маяковского, 47'),
('410542, г. Лесной, ул. Светлая, 46'),
('620839, г. Лесной, ул. Цветочная, 8'),
('443890, г. Лесной, ул. Коммунистическая, 1'),
('603379, г. Лесной, ул. Спортивная, 46'),
('603721, г. Лесной, ул. Гоголя, 41'),
('410172, г. Лесной, ул. Северная, 13'),
('614611, г. Лесной, ул. Молодежная, 50'),
('454311, г.Лесной, ул. Новая, 19'),
('660007, г.Лесной, ул. Октябрьская, 19'),
('603036, г. Лесной, ул. Садовая, 4'),
('394060, г.Лесной, ул. Фрунзе, 43'),
('410661, г. Лесной, ул. Школьная, 50'),
('625590, г. Лесной, ул. Коммунистическая, 20'),
('625683, г. Лесной, ул. 8 Марта'),
('450983, г.Лесной, ул. Комсомольская, 26'),
('394782, г. Лесной, ул. Чехова, 3'),
('603002, г. Лесной, ул. Дзержинского, 28'),
('450558, г. Лесной, ул. Набережная, 30'),
('344288, г. Лесной, ул. Чехова, 1'),
('614164, г.Лесной, ул. Степная, 30'),
('394242, г. Лесной, ул. Коммунистическая, 43'),
('660540, г. Лесной, ул. Солнечная, 25'),
('125837, г. Лесной, ул. Шоссейная, 40'),
('125703, г. Лесной, ул. Партизанская, 49'),
('625283, г. Лесной, ул. Победы, 46'),
('614753, г. Лесной, ул. Полевая, 35'),
('426030, г. Лесной, ул. Маяковского, 44'),
('450375, г. Лесной ул. Клубная, 44'),
('625560, г. Лесной, ул. Некрасова, 12'),
('630201, г. Лесной, ул. Комсомольская, 17'),
('190949, г. Лесной, ул. Мичурина, 26');

-- ============================================================
-- ЗАКАЗЫ (из Заказ_import.xlsx)
-- ============================================================
INSERT INTO `orders` (`order_number`, `article_text`, `order_date`, `delivery_date`, `pickup_point_id`, `client_user_id`, `pickup_code`, `status_id`) VALUES
(1, 'А112Т4, 2, G843H5, 2', '2024-02-27', '2024-04-20', 1, 7, 901, 1),
(2, 'G843H5, 1, А112Т4, 1', '2024-09-28', '2024-04-21', 11, 8, 902, 1),
(3, 'D325D4, 10, S432T5, 10', '2024-03-21', '2024-04-22', 2, 9, 903, 1),
(4, 'F325D4, 5, D325D4, 4', '2024-02-20', '2024-04-23', 11, 10, 904, 2),
(5, 'G432G6, 20, H542F5, 20', '2024-03-17', '2024-04-24', 2, 7, 905, 2),
(6, 'А112Т4, 2, G843H5, 2', '2024-03-01', '2024-04-25', 15, 8, 906, 2),
(7, 'G843H5, 1, А112Т4, 1', '2024-03-28', '2024-04-26', 3, 9, 907, 2),
(8, 'D325D4, 10, S432T5, 10', '2024-03-31', '2024-04-27', 19, 10, 908, 1),
(9, 'F325D4, 5, D325D4, 4', '2024-04-02', '2024-04-28', 5, 9, 909, 1),
(10, 'G432G6, 20, H542F5, 20', '2024-04-03', '2024-04-29', 19, 10, 910, 1);

-- ============================================================
-- СОСТАВ ЗАКАЗОВ (order_items, разобраны из article_text)
-- Формат article_text: "Артикул, кол-во, Артикул2, кол-во2"
-- А112Т4=1, G843H5=2, D325D4=3, S432T5=4, F325D4=5, G432G6=6, H542F5=7
-- ============================================================
INSERT INTO `order_items` (`order_id`, `product_id`, `quantity`) VALUES
-- Заказ 1: А112Т4×2, G843H5×2
(1, 1, 2),
(1, 2, 2),
-- Заказ 2: G843H5×1, А112Т4×1
(2, 2, 1),
(2, 1, 1),
-- Заказ 3: D325D4×10, S432T5×10
(3, 3, 10),
(3, 4, 10),
-- Заказ 4: F325D4×5, D325D4×4
(4, 5, 5),
(4, 3, 4),
-- Заказ 5: G432G6×20, H542F5×20
(5, 6, 20),
(5, 7, 20),
-- Заказ 6: А112Т4×2, G843H5×2
(6, 1, 2),
(6, 2, 2),
-- Заказ 7: G843H5×1, А112Т4×1
(7, 2, 1),
(7, 1, 1),
-- Заказ 8: D325D4×10, S432T5×10
(8, 3, 10),
(8, 4, 10),
-- Заказ 9: F325D4×5, D325D4×4
(9, 5, 5),
(9, 3, 4),
-- Заказ 10: G432G6×20, H542F5×20
(10, 6, 20),
(10, 7, 20);

-- ============================================================
-- ВНЕШНИЕ КЛЮЧИ
-- ============================================================
ALTER TABLE `users` ADD CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;
ALTER TABLE `products` ADD CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON UPDATE CASCADE;
ALTER TABLE `products` ADD CONSTRAINT `fk_products_manufacturers` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`manufacturer_id`) ON UPDATE CASCADE;
ALTER TABLE `products` ADD CONSTRAINT `fk_products_suppliers` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON UPDATE CASCADE;
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_pickup_points` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_points` (`pickup_point_id`) ON UPDATE CASCADE;
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_statuses` FOREIGN KEY (`status_id`) REFERENCES `order_statuses` (`status_id`) ON UPDATE CASCADE;
ALTER TABLE `orders` ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE `order_items` ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `order_items` ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE;

COMMIT;

