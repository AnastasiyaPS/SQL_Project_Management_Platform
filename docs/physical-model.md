# Physical Model (Физическая модель БД)

## СУБД
PostgreSQL 15

Физическая модель базы данных реализована с использованием возможностей PostgreSQL,
включая ограничения целостности, индексы, представления и хранимые процедуры.

## Таблицы и структура


### Project (Проект)
Атрибут	Тип	Описание
project_id (PK)	SERIAL PK	Уникальный идентификатор проекта
project_name	VARCHAR(100) NOT NULL	Название проекта
project_description	TEXT	Описание проекта
start_date	DATE NOT NULL	Дата начала проекта
end_date	DATE	Дата завершения проекта
CHECK: end_date >= start_date или NULL

### Users (Пользователи)
Атрибут	Тип	Описание
user_id (PK)	SERIAL PK	Уникальный идентификатор пользователя
full_name	VARCHAR(100) NOT NULL	ФИО пользователя
email	VARCHAR(100) UNIQUE NOT NULL	Электронная почта
role		VARCHAR(50)	Роль пользователя в системе
CHECK: корректность email

### Task (Задачи)
Атрибут	Тип	Описание
task_id (PK)	SERIAL PK	Уникальный идентификатор задачи
project_id (FK)	INTEGER FK
	Проект, к которому относится задача
assigned_user_id (FK)	INTEGER FK	Назначенный исполнитель
current_status_id (FK)	INTEGER FK	Текущий статус задачи
title	VARCHAR(200) NOT NULL	Название задачи
description	TEXT	Описание задачи
created_at	TIMESTAMP	Дата создания
due_date	DATE	Срок выполнения
Ограничения:
FOREIGN KEY project_id → project
FOREIGN KEY assigned_user_id → users (ON DELETE SET NULL)
FOREIGN KEY current_status_id → status
CHECK: due_date >= created_at 

###Status (Статусы задач)
Атрибут	Тип	Описание
status_id (PK)	SERIAL PK	Уникальный идентификатор статуса
status_name	VARCHAR(50) UNIQUE NOT NULL	Название статуса

### Comments (Комментарии)
Атрибут	Тип	Описание
comment_id (PK)	SERIAL PK	Уникальный идентификатор комментария
task_id (FK)	INTEGER FK	Задача, к которой относится комментарий
user_id (FK)	INTEGER FK	Автор комментария
comment_text	TEXT NOT NULL	Текст комментария
created_at	TIMESTAMP	Дата создания комментария
Удаление задачи или пользователя приводит к каскадному удалению комментариев.
### Tag (Теги)
Атрибут	Тип	Описание
tag_id (PK)	SERIAL PK	Уникальный идентификатор тега
tag_name	VARCHAR(50) UNIQUE NOT NULL	Название тега

Таблицы для связи M:M
### Task_Tags – связь задач и тегов
Атрибут	Тип	Описание
task_id (FK)	INTEGER FK	Идентификатор задачи
tag_id (FK)	INTEGER FK	Идентификатор тега

### Project_Users – участники проектов
Атрибут	Тип	Описание
project_id (FK)	INTEGER FK	Идентификатор проекта
user_id (FK)	INTEGER FK	Идентификатор пользователя
project_role	VARCHAR(50)	Роль пользователя в проекте

Таблица версионных данных (SCD Type 2) – Task_Status_History – история статусов задач
Атрибут	Тип	Описание
task_status_history_id (PK)	SERIAL PK	Уникальный идентификатор записи
task_id (FK)	INTEGER FK	Идентификатор задачи
status_id (FK)	INTEGER FK	Идентификатор статуса
valid_from	TIMESTAMP	Дата начала действия статуса
valid_to	TIMESTAMP	Дата окончания действия статуса
is_current	BOOLEAN	Признак текущего статуса
UNIQUE INDEX: только один текущий статус на задачу

## Индексы
Созданы индексы для:
- поиска задач по проекту
- поиска задач пользователя
- фильтрации по статусу
- анализа сроков выполнения
- ускорения работы с историей статусов

## Процедуры и представления
Физическая модель включает:
- процедуры для создания задач и смены статусов
- представления для текущих, просроченных задач и истории статусов

## Итог
Физическая модель полностью реализует логическую модель системы
и обеспечивает целостность, производительность и расширяемость базы данных.

