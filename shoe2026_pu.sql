-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Май 31 2026 г., 21:42
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `shoe2026_pu`
--

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Женская обувь'),
(2, 'Мужская обувь');

-- --------------------------------------------------------

--
-- Структура таблицы `manufacturers`
--

CREATE TABLE `manufacturers` (
  `manufacturer_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `manufacturers`
--

INSERT INTO `manufacturers` (`manufacturer_id`, `name`) VALUES
(5, 'Alessio Nesca'),
(6, 'CROSBY'),
(1, 'Kari'),
(2, 'Marco Tozzi'),
(4, 'Rieker'),
(3, 'Рос');

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_number` int(10) UNSIGNED NOT NULL,
  `article_text` varchar(255) NOT NULL,
  `order_date` date DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `pickup_point_id` int(10) UNSIGNED NOT NULL,
  `client_user_id` int(10) UNSIGNED DEFAULT NULL,
  `pickup_code` int(10) UNSIGNED NOT NULL,
  `status_id` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`order_id`, `order_number`, `article_text`, `order_date`, `delivery_date`, `pickup_point_id`, `client_user_id`, `pickup_code`, `status_id`) VALUES
(1, 0, 'Товар 1', '2026-05-31', '2026-06-02', 1, 5, 0, 1),
(2, 1, 'братуха42, 1', '2026-05-31', '2026-06-01', 1, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `orders_import_raw`
--

CREATE TABLE `orders_import_raw` (
  `raw_id` int(10) UNSIGNED NOT NULL,
  `order_number_text` varchar(40) DEFAULT NULL,
  `articles_text` varchar(255) DEFAULT NULL,
  `order_date_text` varchar(40) DEFAULT NULL,
  `delivery_date_text` varchar(40) DEFAULT NULL,
  `pickup_point_text` varchar(40) DEFAULT NULL,
  `client_fio_text` varchar(200) DEFAULT NULL,
  `pickup_code_text` varchar(40) DEFAULT NULL,
  `status_text` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `orders_import_raw`
--

INSERT INTO `orders_import_raw` (`raw_id`, `order_number_text`, `articles_text`, `order_date_text`, `delivery_date_text`, `pickup_point_text`, `client_fio_text`, `pickup_code_text`, `status_text`) VALUES
(1, 'А112Т4, 2, F635R4, 2', NULL, '27.02.2025', '20.04.2025', '1', 'Степанов Михаил Артёмович', '901', 'Завершен'),
(2, 'H782T5, 1, G783F5, 1', NULL, '28.09.2022', '21.04.2025', '11', 'Никифорова Весения Николаевна', '902', 'Завершен'),
(3, 'J384T6, 10, D572U8, 10', NULL, '21.03.2025', '22.04.2025', '2', 'Сазонов Руслан Германович', '903', 'Завершен'),
(4, 'F572H7, 5, D329H3, 4', NULL, '20.02.2025', '23.04.2025', '11', 'Одинцов Серафим Артёмович', '904', 'Завершен'),
(5, 'А112Т4, 2, F635R4, 2', NULL, '17.03.2025', '24.04.2025', '2', 'Степанов Михаил Артёмович', '905', 'Завершен'),
(6, 'H782T5, 1, G783F5, 1', NULL, '01.03.2025', '25.04.2025', '15', 'Никифорова Весения Николаевна', '906', 'Завершен'),
(7, 'J384T6, 10, D572U8, 10', NULL, '30.02.2025', '26.04.2025', '3', 'Сазонов Руслан Германович', '907', 'Завершен'),
(8, 'F572H7, 5, D329H3, 4', NULL, '31.03.2025', '27.04.2025', '19', 'Одинцов Серафим Артёмович', '908', 'Новый '),
(9, 'B320R5, 5, G432E4, 1', NULL, '02.04.2025', '28.04.2025', '5', 'Степанов Михаил Артёмович', '909', 'Новый '),
(10, 'S213E3, 5, E482R4, 5', NULL, '03.04.2025', '29.04.2025', '19', 'Степанов Михаил Артёмович', '910', 'Новый ');

-- --------------------------------------------------------

--
-- Структура таблицы `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `quantity` int(11) DEFAULT NULL CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `quantity`) VALUES
(1, 2, 2, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `order_statuses`
--

CREATE TABLE `order_statuses` (
  `status_id` tinyint(3) UNSIGNED NOT NULL,
  `status_name` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `order_statuses`
--

INSERT INTO `order_statuses` (`status_id`, `status_name`) VALUES
(1, 'Завершен'),
(2, 'Новый');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points`
--

CREATE TABLE `pickup_points` (
  `pickup_point_id` int(10) UNSIGNED NOT NULL,
  `address_text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points`
--

INSERT INTO `pickup_points` (`pickup_point_id`, `address_text`) VALUES
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(36, '190949, г. Лесной, ул. Мичурина, 26'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(27, '660540, г. Лесной, ул. Солнечная, 25');

-- --------------------------------------------------------

--
-- Структура таблицы `pickup_points_import_raw`
--

CREATE TABLE `pickup_points_import_raw` (
  `raw_id` int(10) UNSIGNED NOT NULL,
  `address_text` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `pickup_points_import_raw`
--

INSERT INTO `pickup_points_import_raw` (`raw_id`, `address_text`) VALUES
(1, '420151, г. Лесной, ул. Вишневая, 32'),
(2, '125061, г. Лесной, ул. Подгорная, 8'),
(3, '630370, г. Лесной, ул. Шоссейная, 24'),
(4, '400562, г. Лесной, ул. Зеленая, 32'),
(5, '614510, г. Лесной, ул. Маяковского, 47'),
(6, '410542, г. Лесной, ул. Светлая, 46'),
(7, '620839, г. Лесной, ул. Цветочная, 8'),
(8, '443890, г. Лесной, ул. Коммунистическая, 1'),
(9, '603379, г. Лесной, ул. Спортивная, 46'),
(10, '603721, г. Лесной, ул. Гоголя, 41'),
(11, '410172, г. Лесной, ул. Северная, 13'),
(12, '614611, г. Лесной, ул. Молодежная, 50'),
(13, '454311, г.Лесной, ул. Новая, 19'),
(14, '660007, г.Лесной, ул. Октябрьская, 19'),
(15, '603036, г. Лесной, ул. Садовая, 4'),
(16, '394060, г.Лесной, ул. Фрунзе, 43'),
(17, '410661, г. Лесной, ул. Школьная, 50'),
(18, '625590, г. Лесной, ул. Коммунистическая, 20'),
(19, '625683, г. Лесной, ул. 8 Марта'),
(20, '450983, г.Лесной, ул. Комсомольская, 26'),
(21, '394782, г. Лесной, ул. Чехова, 3'),
(22, '603002, г. Лесной, ул. Дзержинского, 28'),
(23, '450558, г. Лесной, ул. Набережная, 30'),
(24, '344288, г. Лесной, ул. Чехова, 1'),
(25, '614164, г.Лесной,  ул. Степная, 30'),
(26, '394242, г. Лесной, ул. Коммунистическая, 43'),
(27, '660540, г. Лесной, ул. Солнечная, 25'),
(28, '125837, г. Лесной, ул. Шоссейная, 40'),
(29, '125703, г. Лесной, ул. Партизанская, 49'),
(30, '625283, г. Лесной, ул. Победы, 46'),
(31, '614753, г. Лесной, ул. Полевая, 35'),
(32, '426030, г. Лесной, ул. Маяковского, 44'),
(33, '450375, г. Лесной ул. Клубная, 44'),
(34, '625560, г. Лесной, ул. Некрасова, 12'),
(35, '630201, г. Лесной, ул. Комсомольская, 17'),
(36, '190949, г. Лесной, ул. Мичурина, 26');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `article` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `unit_name` varchar(20) NOT NULL,
  `price` decimal(12,2) DEFAULT NULL CHECK (`price` >= 0),
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `manufacturer_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `discount_percent` decimal(5,2) DEFAULT NULL CHECK (`discount_percent` >= 0),
  `stock_quantity` int(11) DEFAULT NULL CHECK (`stock_quantity` >= 0),
  `description_text` text DEFAULT NULL,
  `photo_file` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products`
--

INSERT INTO `products` (`product_id`, `article`, `name`, `unit_name`, `price`, `supplier_id`, `manufacturer_id`, `category_id`, `discount_percent`, `stock_quantity`, `description_text`, `photo_file`) VALUES
(1, 'A001', 'ватафак мазафака', 'шт', 100.00, 1, 1, 1, 0.00, 10, 'Описание', 'photo.jpg'),
(2, 'братуха42', 'Братулец', 'шт', 190000.00, 4, 5, 2, 7.00, 1, 'мужская обувь братулец вайбово смотрться на стрит вир комплексе', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `products_import_raw`
--

CREATE TABLE `products_import_raw` (
  `article_text` varchar(60) DEFAULT NULL,
  `name_text` varchar(200) DEFAULT NULL,
  `unit_text` varchar(20) DEFAULT NULL,
  `price_text` varchar(40) DEFAULT NULL,
  `supplier_text` varchar(120) DEFAULT NULL,
  `manufacturer_text` varchar(120) DEFAULT NULL,
  `category_text` varchar(120) DEFAULT NULL,
  `discount_text` varchar(40) DEFAULT NULL,
  `stock_text` varchar(40) DEFAULT NULL,
  `description_text` text DEFAULT NULL,
  `photo_text` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `products_import_raw`
--

INSERT INTO `products_import_raw` (`article_text`, `name_text`, `unit_text`, `price_text`, `supplier_text`, `manufacturer_text`, `category_text`, `discount_text`, `stock_text`, `description_text`, `photo_text`) VALUES
('А112Т4', 'Ботинки', 'шт.', '4990', 'Kari', 'Kari', 'Женская обувь', '3', '6', 'Женские Ботинки демисезонные kari', '1.jpg'),
('F635R4', 'Ботинки', 'шт.', '3244', 'Обувь для вас', 'Marco Tozzi', 'Женская обувь', '2', '13', 'Ботинки Marco Tozzi женские демисезонные, размер 39, цвет бежевый', '2.jpg'),
('H782T5', 'Туфли', 'шт.', '4499', 'Kari', 'Kari', 'Мужская обувь', '4', '5', 'Туфли kari мужские классика MYZ21AW-450A, размер 43, цвет: черный', '3.jpg'),
('G783F5', 'Ботинки', 'шт.', '5900', 'Kari', 'Рос', 'Мужская обувь', '2', '8', 'Мужские ботинки Рос-Обувь кожаные с натуральным мехом', '4.jpg'),
('J384T6', 'Ботинки', 'шт.', '3800', 'Обувь для вас', 'Rieker', 'Мужская обувь', '2', '16', 'B3430/14 Полуботинки мужские Rieker', '5.jpg'),
('D572U8', 'Кроссовки', 'шт.', '4100', 'Обувь для вас', 'Рос', 'Мужская обувь', '3', '6', '129615-4 Кроссовки мужские', '6.jpg'),
('F572H7', 'Туфли', 'шт.', '2700', 'Kari', 'Marco Tozzi', 'Женская обувь', '2', '14', 'Туфли Marco Tozzi женские летние, размер 39, цвет черный', '7.jpg'),
('D329H3', 'Полуботинки', 'шт.', '1890', 'Обувь для вас', 'Alessio Nesca', 'Женская обувь', '4', '4', 'Полуботинки Alessio Nesca женские 3-30797-47, размер 37, цвет: бордовый', '8.jpg'),
('B320R5', 'Туфли', 'шт.', '4300', 'Kari', 'Rieker', 'Женская обувь', '2', '6', 'Туфли Rieker женские демисезонные, размер 41, цвет коричневый', '9.jpg'),
('G432E4', 'Туфли', 'шт.', '2800', 'Kari', 'Kari', 'Женская обувь', '3', '15', 'Туфли kari женские TR-YR-413017, размер 37, цвет: черный', '10.jpg'),
('S213E3', 'Полуботинки', 'шт.', '2156', 'Обувь для вас', 'CROSBY', 'Мужская обувь', '3', '6', '407700/01-01 Полуботинки мужские CROSBY', ''),
('E482R4', 'Полуботинки', 'шт.', '1800', 'Kari', 'Kari', 'Женская обувь', '2', '14', 'Полуботинки kari женские MYZ20S-149, размер 41, цвет: черный', ''),
('S634B5', 'Кеды', 'шт.', '5500', 'Обувь для вас', 'CROSBY', 'Мужская обувь', '3', '0', 'Кеды Caprice мужские демисезонные, размер 42, цвет черный', ''),
('K345R4', 'Полуботинки', 'шт.', '2100', 'Обувь для вас', 'CROSBY', 'Мужская обувь', '2', '3', '407700/01-02 Полуботинки мужские CROSBY', ''),
('O754F4', 'Туфли', 'шт.', '5400', 'Обувь для вас', 'Rieker', 'Женская обувь', '4', '18', 'Туфли женские демисезонные Rieker артикул 55073-68/37', ''),
('G531F4', 'Ботинки', 'шт.', '6600', 'Kari', 'Kari', 'Женская обувь', '12', '9', 'Ботинки женские зимние ROMER арт. 893167-01 Черный', ''),
('J542F5', 'Тапочки', 'шт.', '500', 'Kari', 'Kari', 'Мужская обувь', '13', '0', 'Тапочки мужские Арт.70701-55-67син р.41', ''),
('B431R5', 'Ботинки', 'шт.', '2700', 'Обувь для вас', 'Rieker', 'Мужская обувь', '2', '5', 'Мужские кожаные ботинки/мужские ботинки', ''),
('P764G4', 'Туфли', 'шт.', '6800', 'Kari', 'CROSBY', 'Женская обувь', '15', '15', 'Туфли женские, ARGO, размер 38', ''),
('C436G5', 'Ботинки', 'шт.', '10200', 'Kari', 'Alessio Nesca', 'Женская обувь', '15', '9', 'Ботинки женские, ARGO, размер 40', ''),
('F427R5', 'Ботинки', 'шт.', '11800', 'Обувь для вас', 'Rieker', 'Женская обувь', '15', '11', 'Ботинки на молнии с декоративной пряжкой FRAU', ''),
('N457T5', 'Полуботинки', 'шт.', '4600', 'Kari', 'CROSBY', 'Женская обувь', '3', '13', 'Полуботинки Ботинки черные зимние, мех', ''),
('D364R4', 'Туфли', 'шт.', '12400', 'Kari', 'Kari', 'Женская обувь', '16', '5', 'Туфли Luiza Belly женские Kate-lazo черные из натуральной замши', ''),
('S326R5', 'Тапочки', 'шт.', '9900', 'Обувь для вас', 'CROSBY', 'Мужская обувь', '17', '15', 'Мужские кожаные тапочки \"Профиль С.Дали\" ', ''),
('L754R4', 'Полуботинки', 'шт.', '1700', 'Kari', 'Kari', 'Женская обувь', '2', '7', 'Полуботинки kari женские WB2020SS-26, размер 38, цвет: черный', ''),
('M542T5', 'Кроссовки', 'шт.', '2800', 'Обувь для вас', 'Rieker', 'Мужская обувь', '18', '3', 'Кроссовки мужские TOFA', ''),
('D268G5', 'Туфли', 'шт.', '4399', 'Обувь для вас', 'Rieker', 'Женская обувь', '3', '12', 'Туфли Rieker женские демисезонные, размер 36, цвет коричневый', ''),
('T324F5', 'Сапоги', 'шт.', '4699', 'Kari', 'CROSBY', 'Женская обувь', '2', '5', 'Сапоги замша Цвет: синий', ''),
('K358H6', 'Тапочки', 'шт.', '599', 'Kari', 'Rieker', 'Мужская обувь', '20', '2', 'Тапочки мужские син р.41', ''),
('H535R5', 'Ботинки', 'шт.', '2300', 'Обувь для вас', 'Rieker', 'Женская обувь', '2', '7', 'Женские Ботинки демисезонные', '');

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `role_id` tinyint(3) UNSIGNED NOT NULL,
  `role_name` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(2, 'Авторизированный клиент'),
(4, 'Администратор'),
(1, 'Гость'),
(3, 'Менеджер');

-- --------------------------------------------------------

--
-- Структура таблицы `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`) VALUES
(1, 'Kari'),
(4, 'Зоренко константин'),
(2, 'Обувь для вас'),
(5, 'ываываыаыва');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` tinyint(3) UNSIGNED NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `login` varchar(120) NOT NULL,
  `password_plain` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `full_name`, `login`, `password_plain`) VALUES
(1, 4, 'Никифорова Весения Николаевна', '94d5ous@gmail.com', 'uzWC67'),
(2, 4, 'Сазонов Руслан Германович', 'uth4iz@mail.com', '2L6KZG'),
(3, 4, 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
(4, 3, 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp'),
(5, 3, 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR'),
(6, 3, 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv'),
(7, 2, 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9'),
(8, 2, 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos'),
(9, 2, 'Ворсин Петр Евгеньевич', '1qz4kw@mail.com', 'gynQMT'),
(10, 2, 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr');

-- --------------------------------------------------------

--
-- Структура таблицы `users_import_raw`
--

CREATE TABLE `users_import_raw` (
  `role_name` varchar(100) DEFAULT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  `login_text` varchar(120) DEFAULT NULL,
  `password_text` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `users_import_raw`
--

INSERT INTO `users_import_raw` (`role_name`, `full_name`, `login_text`, `password_text`) VALUES
('Администратор', 'Никифорова Весения Николаевна', '94d5ous@gmail.com', 'uzWC67'),
('Администратор', 'Сазонов Руслан Германович', 'uth4iz@mail.com', '2L6KZG'),
('Администратор', 'Одинцов Серафим Артёмович', 'yzls62@outlook.com', 'JlFRCZ'),
('Менеджер', 'Степанов Михаил Артёмович', '1diph5e@tutanota.com', '8ntwUp'),
('Менеджер', 'Ворсин Петр Евгеньевич', 'tjde7c@yahoo.com', 'YOyhfR'),
('Менеджер', 'Старикова Елена Павловна', 'wpmrc3do@tutanota.com', 'RSbvHv'),
('Авторизированный клиент', 'Михайлюк Анна Вячеславовна', '5d4zbu@tutanota.com', 'rwVDh9'),
('Авторизированный клиент', 'Ситдикова Елена Анатольевна', 'ptec8ym@yahoo.com', 'LdNyos'),
('Авторизированный клиент', 'Ворсин Петр Евгеньевич', '1qz4kw@mail.com', 'gynQMT'),
('Авторизированный клиент', 'Старикова Елена Павловна', '4np6se@mail.com', 'AtnDjr');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  ADD PRIMARY KEY (`manufacturer_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `fk_orders_pickup_points` (`pickup_point_id`),
  ADD KEY `fk_orders_users` (`client_user_id`),
  ADD KEY `idx_orders_status` (`status_id`);

--
-- Индексы таблицы `orders_import_raw`
--
ALTER TABLE `orders_import_raw`
  ADD PRIMARY KEY (`raw_id`);

--
-- Индексы таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD UNIQUE KEY `uk_order_product` (`order_id`,`product_id`),
  ADD KEY `idx_order_items_product` (`product_id`);

--
-- Индексы таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  ADD PRIMARY KEY (`status_id`),
  ADD UNIQUE KEY `status_name` (`status_name`);

--
-- Индексы таблицы `pickup_points`
--
ALTER TABLE `pickup_points`
  ADD PRIMARY KEY (`pickup_point_id`),
  ADD UNIQUE KEY `address_text` (`address_text`);

--
-- Индексы таблицы `pickup_points_import_raw`
--
ALTER TABLE `pickup_points_import_raw`
  ADD PRIMARY KEY (`raw_id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `article` (`article`),
  ADD KEY `fk_products_manufacturers` (`manufacturer_id`),
  ADD KEY `idx_products_supplier` (`supplier_id`),
  ADD KEY `idx_products_category` (`category_id`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Индексы таблицы `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD KEY `fk_users_roles` (`role_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `manufacturers`
--
ALTER TABLE `manufacturers`
  MODIFY `manufacturer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `orders_import_raw`
--
ALTER TABLE `orders_import_raw`
  MODIFY `raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `order_statuses`
--
ALTER TABLE `order_statuses`
  MODIFY `status_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `pickup_points_import_raw`
--
ALTER TABLE `pickup_points_import_raw`
  MODIFY `raw_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_pickup_points` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_points` (`pickup_point_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_statuses` FOREIGN KEY (`status_id`) REFERENCES `order_statuses` (`status_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_products_manufacturers` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers` (`manufacturer_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_products_suppliers` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
