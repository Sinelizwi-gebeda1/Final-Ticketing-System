-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 26, 2025 at 01:27 PM
-- Server version: 11.8.1-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `helpdeskapp1`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add user', 6, 'add_customuser'),
(22, 'Can change user', 6, 'change_customuser'),
(23, 'Can delete user', 6, 'delete_customuser'),
(24, 'Can view user', 6, 'view_customuser'),
(25, 'Can add cab request', 7, 'add_cabrequest'),
(26, 'Can change cab request', 7, 'change_cabrequest'),
(27, 'Can delete cab request', 7, 'delete_cabrequest'),
(28, 'Can view cab request', 7, 'view_cabrequest'),
(29, 'Can add ticket', 8, 'add_ticket'),
(30, 'Can change ticket', 8, 'change_ticket'),
(31, 'Can delete ticket', 8, 'delete_ticket'),
(32, 'Can view ticket', 8, 'view_ticket'),
(33, 'Can view pending tickets', 8, 'view_pending_tickets'),
(34, 'Can view escalated tickets', 8, 'view_escalated_tickets'),
(35, 'Can add ticket assignment', 9, 'add_ticketassignment'),
(36, 'Can change ticket assignment', 9, 'change_ticketassignment'),
(37, 'Can delete ticket assignment', 9, 'delete_ticketassignment'),
(38, 'Can view ticket assignment', 9, 'view_ticketassignment'),
(39, 'Can add escalation note', 10, 'add_escalationnote'),
(40, 'Can change escalation note', 10, 'change_escalationnote'),
(41, 'Can delete escalation note', 10, 'delete_escalationnote'),
(42, 'Can view escalation note', 10, 'view_escalationnote'),
(43, 'Can add notification', 11, 'add_notification'),
(44, 'Can change notification', 11, 'change_notification'),
(45, 'Can delete notification', 11, 'delete_notification'),
(46, 'Can view notification', 11, 'view_notification');

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2025-08-25 11:08:36.239368', '2', 'DBI Sine (End-User)', 1, '[{\"added\": {}}]', 6, 1),
(2, '2025-08-25 11:09:32.106748', '3', 'Technician T1 (L1_Technician)', 1, '[{\"added\": {}}]', 6, 1),
(3, '2025-08-25 11:10:24.358477', '4', 'Technician T2-L1 (L1_Technician)', 1, '[{\"added\": {}}]', 6, 1),
(4, '2025-08-25 11:11:00.175955', '5', 'Technician T1-L2 (L2_Technician)', 1, '[{\"added\": {}}]', 6, 1),
(5, '2025-08-25 11:11:33.547255', '6', 'Technician T2-L2 (L2_Technician)', 1, '[{\"added\": {}}]', 6, 1),
(6, '2025-08-25 11:11:58.530095', '3', 'Technician T1-L1 (L1_Technician)', 2, '[{\"changed\": {\"fields\": [\"Full name\"]}}]', 6, 1),
(7, '2025-08-26 08:08:21.439913', '7', 'Lutho Ngwala (End-User)', 1, '[{\"added\": {}}]', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'contenttypes', 'contenttype'),
(7, 'helpdeskapp', 'cabrequest'),
(6, 'helpdeskapp', 'customuser'),
(10, 'helpdeskapp', 'escalationnote'),
(11, 'helpdeskapp', 'notification'),
(8, 'helpdeskapp', 'ticket'),
(9, 'helpdeskapp', 'ticketassignment'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-08-25 11:03:28.074803'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-08-25 11:03:28.168684'),
(3, 'auth', '0001_initial', '2025-08-25 11:03:28.536258'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-08-25 11:03:28.595324'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-08-25 11:03:28.601613'),
(6, 'auth', '0004_alter_user_username_opts', '2025-08-25 11:03:28.609474'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-08-25 11:03:28.618485'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-08-25 11:03:28.622272'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-08-25 11:03:28.630856'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-08-25 11:03:28.637419'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-08-25 11:03:28.646965'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-08-25 11:03:28.684098'),
(13, 'auth', '0011_update_proxy_permissions', '2025-08-25 11:03:28.698673'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-08-25 11:03:28.706335'),
(15, 'helpdeskapp', '0001_initial', '2025-08-25 11:03:29.668791'),
(16, 'admin', '0001_initial', '2025-08-25 11:03:29.810555'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-08-25 11:03:29.821189'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-08-25 11:03:29.832227'),
(19, 'helpdeskapp', '0002_escalationnote', '2025-08-25 11:03:29.993315'),
(20, 'helpdeskapp', '0003_remove_escalationnote_author_and_more', '2025-08-25 11:03:31.171992'),
(21, 'helpdeskapp', '0004_cabrequest_attachment', '2025-08-25 11:03:31.233513'),
(22, 'helpdeskapp', '0005_ticket_accepted_by_l1_notification', '2025-08-25 11:03:31.450097'),
(23, 'sessions', '0001_initial', '2025-08-25 11:03:31.511540');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('2y32k1yke40jsz1wvpiusfd4fuaipyxs', '.eJxVjMsOwiAURP-FtSElLb3g0r3fQO4DpGogKe2q8d9tky40mdWcM7OpgOuSw9riHCZRV9Wry29HyK9YDiBPLI-quZZlnkgfij5p0_cq8X073b-DjC3va8PGwwCQKDGBR4I9LDQaAx5IhBwN1jqbOmfJMY5onB16SzFG7JL6fAEBiTjQ:1uqoQB:nJ5R_wOwbP9oPm7jKZqzD2qrxlPWViNJvyTr8dcv-cA', '2025-09-09 07:48:47.989310'),
('bz7xstf1ybe55kukg68z5lf1gkt3t30s', '.eJxVjMsOwiAURP-FtSElLb3g0r3fQO4DpGogKe2q8d9tky40mdWcM7OpgOuSw9riHCZRV9Wry29HyK9YDiBPLI-quZZlnkgfij5p0_cq8X073b-DjC3va8PGwwCQKDGBR4I9LDQaAx5IhBwN1jqbOmfJMY5onB16SzFG7JL6fAEBiTjQ:1uqp3I:i5snqqhlkVVSiAaJPQXn3b8_oNMnF0udqq4TYaM0hhM', '2025-09-09 08:29:12.040815'),
('nhngvnu5l6mkxcidmpeyub5e7ta1hoj8', '.eJxVjM0OwiAQhN-FsyFA-NOjd5-B7LKLVA1NSnsyvrsl6UHnMsl8M_MWCba1pq3zkiYSF2HF6TdDyE9uA9AD2n2WeW7rMqEcFXnQLm8z8et6dP8OKvS6r53WCnO0SOgdagMcgy-Fi8NdoMgooBB8tPbsi_bExQwzliJqx-LzBQQROLw:1uqqSQ:nErnq7DbVa0NFQW3zN0rkTol5ksihEpOBEDNjH8RLOM', '2025-09-09 09:59:14.771423'),
('w7ye08e9k42eclv5eueerxj8by6dqrzo', '.eJxVjEEOwiAQRe_C2hAQBqYu3XuGZmBGqRpISrsy3l2bdKHb_977LzXSupRx7TKPE6uTAnX43RLlh9QN8J3qrenc6jJPSW-K3mnXl8byPO_u30GhXr51skBwlSOCQYyBjI-YIFthR2yMEz9Ey4AUSAx6J-CAwafo8xCsj-r9AdKGNxo:1uqox7:9P-eGJVNsvf34OEmZSCIgxU-k47aOyN241PNpzOOuuw', '2025-09-09 08:22:49.697602'),
('wrggkj5oaymlhl0xumqeoob1i97nn9a6', '.eJxVjEsOwjAMBe-SNYrqOG0clux7hsipXVJArdTPCnF3FKkL2L6ZeW-T-NhLOjZd0yTmasBcfrfMw1PnCuTB832xwzLv65RtVexJN9svoq_b6f4dFN5KrZEb8KytdOiBSB3GbgwSWBqNAEiq4KgdKQZgQGzRC4lmJMEcnfl8Ac94N0s:1uqV3H:-uk7U8pnzLKDQRKkqhhEKelorCG7d56aciWb102z3ng', '2025-09-08 11:07:51.441478');

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_cabrequest`
--

CREATE TABLE `helpdeskapp_cabrequest` (
  `id` bigint(20) NOT NULL,
  `change_type` varchar(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `risk_assessment` longtext NOT NULL,
  `implementation_plan` longtext NOT NULL,
  `rollback_plan` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `status` varchar(20) NOT NULL,
  `rejection_reason` varchar(50) DEFAULT NULL,
  `requester_id` bigint(20) NOT NULL,
  `attachment` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_customuser`
--

CREATE TABLE `helpdeskapp_customuser` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `email` varchar(254) NOT NULL,
  `role` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `helpdeskapp_customuser`
--

INSERT INTO `helpdeskapp_customuser` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `is_staff`, `is_active`, `date_joined`, `full_name`, `email`, `role`) VALUES
(1, 'pbkdf2_sha256$870000$mxSdQ8yoTjZ08s9vsidhib$WK9hLoQwV+m46pRwFoIoEuUYHTy9H9m1fN9ltGtxaDk=', '2025-08-26 08:01:22.864867', 1, 'sinelizwigebeda@gmail.com', '', '', 1, 1, '2025-08-25 11:07:24.933939', 'Sinelizwi Gebeda ', 'sinelizwigebeda@gmail.com', 'Administrator'),
(2, 'pbkdf2_sha256$870000$wHInhqnzJl7dM3Jlzz4LjH$EP0OlU7X8FyqjO+CG55es97Y6gx5U8E/8xJTE1676W0=', '2025-08-26 08:32:36.054427', 0, 'Sinelizwi.Gebeda@dbi-itgroup.co.za', '', '', 0, 1, '2025-08-25 11:08:34.627413', 'DBI Sine', 'Sinelizwi.Gebeda@dbi-itgroup.co.za', 'End-User'),
(3, 'pbkdf2_sha256$870000$4BQvTtwfBfenyq4mUmJBRa$A1jCS3IBqLZB92+5Y0miLYU+ipsrNtTe4E/GcrifqR0=', '2025-08-26 08:30:37.373683', 0, 'sinelizwigebeda9@gmail.com', '', '', 0, 1, '2025-08-25 11:09:30.000000', 'Technician T1-L1', 'sinelizwigebeda9@gmail.com', 'L1_Technician'),
(4, 'pbkdf2_sha256$870000$8flUdoohLnX5gkoqPRTPc3$xJ5LG0azmou/uwwvqJjs+/wT05pv8fzjcuFA8sG5MFE=', '2025-08-26 09:59:14.766273', 0, 'hhelpdesk83@gmail.com', '', '', 0, 1, '2025-08-25 11:10:22.750907', 'Technician T2-L1', 'hhelpdesk83@gmail.com', 'L1_Technician'),
(5, 'pbkdf2_sha256$870000$ENU7MmLPxOcBAsd4jzvBtu$vtg/qtVwDtpo/gY5+7GMcMlumAAcqsXGBdCIAlzxQyc=', '2025-08-26 08:22:49.690126', 0, 'Training@dbi-itgroup.co.za', '', '', 0, 1, '2025-08-25 11:10:58.583102', 'Technician T1-L2', 'Training@dbi-itgroup.co.za', 'L2_Technician'),
(6, 'pbkdf2_sha256$870000$WZAYTXHHV7FGZNM9wEt4MU$k8vUh4DN8Mc1bMYzsrEdeNe03heVytHZCcmYKFuHDLI=', '2025-08-26 09:50:53.561342', 0, 'ITSupport@dbi-itgroup.co.za', '', '', 0, 1, '2025-08-25 11:11:32.009071', 'Technician T2-L2', 'ITSupport@dbi-itgroup.co.za', 'L2_Technician'),
(7, 'pbkdf2_sha256$870000$OroOAiktE1i2xRlcKjOuXH$siney6Mr0ERQ/wKTjrSLGuWZjGb/Zm1fxApvl3TwtPs=', NULL, 0, 'luthongwala100@gmail.com', '', '', 0, 1, '2025-08-26 08:08:15.939842', 'Lutho Ngwala', 'luthongwala100@gmail.com', 'End-User');

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_customuser_groups`
--

CREATE TABLE `helpdeskapp_customuser_groups` (
  `id` bigint(20) NOT NULL,
  `customuser_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_customuser_user_permissions`
--

CREATE TABLE `helpdeskapp_customuser_user_permissions` (
  `id` bigint(20) NOT NULL,
  `customuser_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `helpdeskapp_customuser_user_permissions`
--

INSERT INTO `helpdeskapp_customuser_user_permissions` (`id`, `customuser_id`, `permission_id`) VALUES
(1, 1, 33),
(2, 1, 34),
(3, 3, 33),
(4, 4, 33),
(5, 5, 34),
(6, 6, 34);

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_escalationnote`
--

CREATE TABLE `helpdeskapp_escalationnote` (
  `id` bigint(20) NOT NULL,
  `note` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `created_by_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `helpdeskapp_escalationnote`
--

INSERT INTO `helpdeskapp_escalationnote` (`id`, `note`, `created_at`, `ticket_id`, `created_by_id`) VALUES
(1, 'I am testing the escalation', '2025-08-25 11:22:41.773803', 1, 4),
(2, 'Escalation tester', '2025-08-25 12:04:49.639602', 2, 4),
(3, 'Escalate', '2025-08-25 12:21:50.728406', 4, 4),
(4, 'Tester escalation', '2025-08-26 08:21:59.621897', 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_notification`
--

CREATE TABLE `helpdeskapp_notification` (
  `id` bigint(20) NOT NULL,
  `message` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `helpdeskapp_notification`
--

INSERT INTO `helpdeskapp_notification` (`id`, `message`, `created_at`, `is_read`, `user_id`) VALUES
(1, 'Ticket 070FDBAD has not been accepted yet.', '2025-08-25 11:36:49.882814', 0, 4),
(2, 'Ticket 070FDBAD has not been accepted yet.', '2025-08-25 12:05:10.423174', 0, 5),
(3, 'Ticket 5EA0C587 has not been accepted yet.', '2025-08-25 12:17:49.734439', 0, 4),
(4, 'Ticket 875629E7 has not been accepted yet.', '2025-08-25 12:19:56.865783', 0, 3),
(5, 'Ticket 5EA0C587 has not been accepted yet.', '2025-08-25 12:22:30.862104', 0, 6),
(6, 'Ticket 6F1B76F6 has not been accepted yet.', '2025-08-25 13:37:03.766447', 0, 4),
(7, 'Ticket CB5AE01C has not been accepted yet.', '2025-08-26 08:42:49.604578', 0, 4),
(8, 'Ticket CB5AE01C has not been accepted yet.', '2025-08-26 09:50:53.640014', 0, 6);

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_ticket`
--

CREATE TABLE `helpdeskapp_ticket` (
  `id` int(11) NOT NULL,
  `ticket_number` varchar(20) NOT NULL,
  `ticket_title` varchar(255) NOT NULL,
  `department` varchar(100) NOT NULL,
  `contact_info` varchar(255) NOT NULL,
  `problem_description` longtext NOT NULL,
  `priority_level` varchar(50) NOT NULL,
  `preferred_contact_method` varchar(50) NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `date_created_on` datetime(6) NOT NULL,
  `status` varchar(20) NOT NULL,
  `accepted_by_l2` tinyint(1) NOT NULL,
  `assigned_at` datetime(6) DEFAULT NULL,
  `completed_at` datetime(6) DEFAULT NULL,
  `escalated_at` datetime(6) DEFAULT NULL,
  `closed_at` datetime(6) DEFAULT NULL,
  `assigned_technician_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `accepted_by_l1` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Dumping data for table `helpdeskapp_ticket`
--

INSERT INTO `helpdeskapp_ticket` (`id`, `ticket_number`, `ticket_title`, `department`, `contact_info`, `problem_description`, `priority_level`, `preferred_contact_method`, `attachment`, `date_created_on`, `status`, `accepted_by_l2`, `assigned_at`, `completed_at`, `escalated_at`, `closed_at`, `assigned_technician_id`, `user_id`, `accepted_by_l1`) VALUES
(1, 'C7E4AACF', 'Notification tester1', 'IT', '0111111111', 'the issuejkfjk fgkngo;nmk,,,', 'Low', 'Email', 'attachments/glad_tidings_text_logo_ZaHMjuZ.png', '2025-08-25 11:18:43.170546', 'Escalated', 1, '2025-08-25 11:22:22.788902', NULL, '2025-08-25 11:22:41.777824', NULL, 6, 2, 0),
(2, '070FDBAD', 'Notification tester2', 'IT', '0111111111', 'kjcbhn lfiuh lifuh fliuhlsi flsiufdg  ldsfiugh ldisufgh  flduihg sifduh xifcgh lsdfiuhg;sdfihg lifudghlsifdugh lfidugh ;sxoihdf g blfgb', 'Low', 'Email', 'attachments/pexels-pnw-prod-7328133.jpg', '2025-08-25 11:34:45.559735', 'Escalated', 1, '2025-08-25 11:52:27.926990', NULL, '2025-08-25 12:04:49.644027', NULL, 5, 2, 0),
(3, '875629E7', 'Notification tester3', 'HR', '0111111111', 'lmkkkllkn', 'Medium', 'Phone', 'attachments/pexels-pnw-prod-7328133_Qzac0jq.jpg', '2025-08-25 12:14:20.726612', 'Escalated', 1, '2025-08-25 19:18:19.646077', NULL, '2025-08-26 08:21:59.631319', NULL, 5, 2, 0),
(4, '5EA0C587', 'Notification tester4', 'Finance', '0222222222222', 'lkgf  fgkj gf  ;gkj olgfn', 'High', 'Email', 'attachments/1572538039_8836_JoChHGU.jpg', '2025-08-25 12:15:08.804150', 'Escalated', 1, '2025-08-25 12:19:14.139135', NULL, '2025-08-25 12:21:50.729974', NULL, 6, 2, 0),
(5, '6F1B76F6', 'Notification tester5', 'HR', '0222222222222', ', vb nlgng ildhb suhdf kfhxbfg', 'Medium', 'Email', 'attachments/infinite_heart_oT2EZHa.png', '2025-08-25 13:34:04.450435', 'Resolved', 0, '2025-08-25 20:05:26.598004', '2025-08-25 20:05:57.161488', NULL, NULL, 5, 2, 0),
(6, '988C37A4', 'Notification tester7', 'IT', '0222222222222', 'jfdgbifd uufdygvb fkdl kdfuygbv ksufdygb fuygb fsduyb kfsduy uyb fdukyb ksdfuhb dlfulx lsdifugb slfuihb slfuib  lsdufhb lsdfub lsufyg bslfu slifu ls fiugbsldfiub  lsduif sdiluf  guihslduf hsldfuh lsdfuh gsldufb sludfh lsdiuf', 'Low', 'Email', 'attachments/1572538039_8836_JRkzDyG.jpg', '2025-08-26 08:33:48.276583', 'Pending', 0, '2025-08-26 08:33:48.270577', NULL, NULL, NULL, 3, 2, 0),
(7, 'CB5AE01C', 'Notification tester6', 'Finance', '0222222222222', 'ifucvhb fguihb fghblhhfgb  figubhildiufglsduhb lgfbhn', 'High', 'Email', 'attachments/extracted_glad_tidings_logo.png', '2025-08-26 08:34:42.188788', 'Escalated', 0, '2025-08-26 08:44:26.817316', NULL, '2025-08-26 09:50:19.142272', NULL, 6, 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `helpdeskapp_ticketassignment`
--

CREATE TABLE `helpdeskapp_ticketassignment` (
  `id` bigint(20) NOT NULL,
  `assigned_at` datetime(6) NOT NULL,
  `assigned_by_id` bigint(20) DEFAULT NULL,
  `technician_id` bigint(20) NOT NULL,
  `ticket_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_helpdeskapp_customuser_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `helpdeskapp_cabrequest`
--
ALTER TABLE `helpdeskapp_cabrequest`
  ADD PRIMARY KEY (`id`),
  ADD KEY `helpdeskapp_cabreque_requester_id_a16f4e07_fk_helpdeska` (`requester_id`);

--
-- Indexes for table `helpdeskapp_customuser`
--
ALTER TABLE `helpdeskapp_customuser`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `helpdeskapp_customuser_groups`
--
ALTER TABLE `helpdeskapp_customuser_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `helpdeskapp_customuser_g_customuser_id_group_id_a8125761_uniq` (`customuser_id`,`group_id`),
  ADD KEY `helpdeskapp_customuser_groups_group_id_2756f86f_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `helpdeskapp_customuser_user_permissions`
--
ALTER TABLE `helpdeskapp_customuser_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `helpdeskapp_customuser_u_customuser_id_permission_8c04e82e_uniq` (`customuser_id`,`permission_id`),
  ADD KEY `helpdeskapp_customus_permission_id_87bb2b51_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `helpdeskapp_escalationnote`
--
ALTER TABLE `helpdeskapp_escalationnote`
  ADD PRIMARY KEY (`id`),
  ADD KEY `helpdeskapp_escalati_ticket_id_c6c4205d_fk_helpdeska` (`ticket_id`),
  ADD KEY `helpdeskapp_escalati_created_by_id_621fe91b_fk_helpdeska` (`created_by_id`);

--
-- Indexes for table `helpdeskapp_notification`
--
ALTER TABLE `helpdeskapp_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `helpdeskapp_notifica_user_id_697994a1_fk_helpdeska` (`user_id`);

--
-- Indexes for table `helpdeskapp_ticket`
--
ALTER TABLE `helpdeskapp_ticket`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ticket_number` (`ticket_number`),
  ADD KEY `helpdeskapp_ticket_assigned_technician__73f081b1_fk_helpdeska` (`assigned_technician_id`),
  ADD KEY `helpdeskapp_ticket_user_id_3cda6bea_fk_helpdeskapp_customuser_id` (`user_id`);

--
-- Indexes for table `helpdeskapp_ticketassignment`
--
ALTER TABLE `helpdeskapp_ticketassignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `helpdeskapp_ticketassign_ticket_id_technician_id_b614647f_uniq` (`ticket_id`,`technician_id`),
  ADD KEY `helpdeskapp_ticketas_assigned_by_id_34573504_fk_helpdeska` (`assigned_by_id`),
  ADD KEY `helpdeskapp_ticketas_technician_id_17db059b_fk_helpdeska` (`technician_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `helpdeskapp_cabrequest`
--
ALTER TABLE `helpdeskapp_cabrequest`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `helpdeskapp_customuser`
--
ALTER TABLE `helpdeskapp_customuser`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `helpdeskapp_customuser_groups`
--
ALTER TABLE `helpdeskapp_customuser_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `helpdeskapp_customuser_user_permissions`
--
ALTER TABLE `helpdeskapp_customuser_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `helpdeskapp_escalationnote`
--
ALTER TABLE `helpdeskapp_escalationnote`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `helpdeskapp_notification`
--
ALTER TABLE `helpdeskapp_notification`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `helpdeskapp_ticket`
--
ALTER TABLE `helpdeskapp_ticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `helpdeskapp_ticketassignment`
--
ALTER TABLE `helpdeskapp_ticketassignment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_helpdeskapp_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `helpdeskapp_customuser` (`id`);

--
-- Constraints for table `helpdeskapp_cabrequest`
--
ALTER TABLE `helpdeskapp_cabrequest`
  ADD CONSTRAINT `helpdeskapp_cabreque_requester_id_a16f4e07_fk_helpdeska` FOREIGN KEY (`requester_id`) REFERENCES `helpdeskapp_customuser` (`id`);

--
-- Constraints for table `helpdeskapp_customuser_groups`
--
ALTER TABLE `helpdeskapp_customuser_groups`
  ADD CONSTRAINT `helpdeskapp_customus_customuser_id_705e4c89_fk_helpdeska` FOREIGN KEY (`customuser_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_customuser_groups_group_id_2756f86f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `helpdeskapp_customuser_user_permissions`
--
ALTER TABLE `helpdeskapp_customuser_user_permissions`
  ADD CONSTRAINT `helpdeskapp_customus_customuser_id_04171ffd_fk_helpdeska` FOREIGN KEY (`customuser_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_customus_permission_id_87bb2b51_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`);

--
-- Constraints for table `helpdeskapp_escalationnote`
--
ALTER TABLE `helpdeskapp_escalationnote`
  ADD CONSTRAINT `helpdeskapp_escalati_created_by_id_621fe91b_fk_helpdeska` FOREIGN KEY (`created_by_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_escalati_ticket_id_c6c4205d_fk_helpdeska` FOREIGN KEY (`ticket_id`) REFERENCES `helpdeskapp_ticket` (`id`);

--
-- Constraints for table `helpdeskapp_notification`
--
ALTER TABLE `helpdeskapp_notification`
  ADD CONSTRAINT `helpdeskapp_notifica_user_id_697994a1_fk_helpdeska` FOREIGN KEY (`user_id`) REFERENCES `helpdeskapp_customuser` (`id`);

--
-- Constraints for table `helpdeskapp_ticket`
--
ALTER TABLE `helpdeskapp_ticket`
  ADD CONSTRAINT `helpdeskapp_ticket_assigned_technician__73f081b1_fk_helpdeska` FOREIGN KEY (`assigned_technician_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_ticket_user_id_3cda6bea_fk_helpdeskapp_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `helpdeskapp_customuser` (`id`);

--
-- Constraints for table `helpdeskapp_ticketassignment`
--
ALTER TABLE `helpdeskapp_ticketassignment`
  ADD CONSTRAINT `helpdeskapp_ticketas_assigned_by_id_34573504_fk_helpdeska` FOREIGN KEY (`assigned_by_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_ticketas_technician_id_17db059b_fk_helpdeska` FOREIGN KEY (`technician_id`) REFERENCES `helpdeskapp_customuser` (`id`),
  ADD CONSTRAINT `helpdeskapp_ticketas_ticket_id_d3795d50_fk_helpdeska` FOREIGN KEY (`ticket_id`) REFERENCES `helpdeskapp_ticket` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
