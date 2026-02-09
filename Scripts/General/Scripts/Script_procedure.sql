--Процедуры

--смена статуса 
create or replace procedure change_task_status(
p_task_id int,
p_status_id int
) 
language plpgsql
as $$
begin
	--закрытие старого статуса
	update task_status_history
	set valid_to = now(), is_current=false
	where task_id=p_task_id and is_current=true;
	--сщздаем новый статус
	insert into task_status_history(task_id, status_id, valid_from, is_current)
	values(p_task_id, p_status_id, now(), true);
	--обновляем текущий статус задачи
	update task
	set current_status_id=p_status_id 
	where task_id=p_task_id;

end;
$$;



--создание задачи 
create or replace procedure create_task(
p_project_id int,
p_user_id int,
p_title text,
p_due_date date
)
language plpgsql
as $$
declare new_task_id int;
begin
	insert into task(project_id, assigned_user_id,current_status_id, title, due_date)
	values (p_project_id, p_user_id,1, p_title, p_due_date)
	returning task_id into new_task_id;

insert into task_status_history(task_id, status_id, valid_from, is_current) values (new_task_id, 1, now(),true);

end; $$;

create or replace procedure seed_demo_data (p_rest boolean default true)
language plpgsql
as $$
begin
	
	if p_rest then truncate table
	comments,
      task_status_history,
      task_tags,
      project_users,
      task,
      project,
      users,
      tag,
      status
    restart identity cascade;
  end if;

  -- справочники
  insert into status(status_name) values
    ('Новая'), ('В работе'), ('На проверке'), ('Отложена'), ('Отменена'), ('Завершена');

  insert into tag(tag_name) values
    ('баг'), ('фича'), ('срочно'), ('документация'), ('дизайн'),
    ('бекенд'), ('фронтенд'), ('тестирование'), ('важное'),
    ('оптимизация'), ('рефакторинг'), ('безопасность');

  -- проекты
  insert into project(project_name, project_description, start_date, end_date) values
    ('CRM система', 'Разработка CRM для отдела продаж', '2025-01-01', '2025-06-30'),
    ('Мобильное приложение', 'Приложение для клиентов', '2025-02-01', '2025-08-01'),
    ('Веб-портал', 'Корпоративный портал', '2024-03-01', '2025-09-01'),
    ('BI аналитика', 'Система аналитики', '2025-01-15', '2026-01-01'),
    ('DevOps платформа', 'Автоматизация CI/CD', '2025-04-01', '2026-01-07');

  -- пользователи
  insert into users(full_name, email, role) values
    ('Иванов Иван', 'ivanov@mail.ru', 'Developer'),
    ('Петров Петр', 'petrov@mail.ru', 'QA'),
    ('Сидорова Анна', 'sidorova@mail.ru', 'Manager'),
    ('Смирнов Олег', 'smirnov@mail.ru', 'DevOps'),
    ('Кузнецова Мария', 'kuz@mail.ru', 'Analyst');

  -- участники проектов
  insert into project_users(project_id, user_id, project_role) values
    (1,1,'Developer'),(1,2,'QA'),(1,3,'Manager'),(1,4,'DevOps'),(1,5,'Analyst'),
    (2,1,'Developer'),(2,2,'QA'),(2,3,'Manager'),(2,4,'DevOps'),(2,5,'Analyst'),
    (3,1,'Developer'),(3,2,'QA'),(3,3,'Manager'),(3,4,'DevOps'),(3,5,'Analyst'),
    (4,1,'Developer'),(4,2,'QA'),(4,3,'Manager'),(4,4,'DevOps'),(4,5,'Analyst'),
    (5,1,'Developer'),(5,2,'QA'),(5,3,'Manager'),(5,4,'DevOps'),(5,5,'Analyst');

  -- задачи
  insert into task(project_id, assigned_user_id, current_status_id, title, description, created_at, due_date) values
  (1, 1, 1, 'Создать структуру БД', 'Проектирование таблиц', '2026-01-01', '2026-02-01'),
  (1, 3, 2, 'Сбор требований', 'Интервью с заказчиком', '2026-01-02', '2026-02-10'),
  (2, 1, 2, 'API авторизации', 'JWT авторизация', '2026-02-01', '2026-03-01'),
  (2, 2, 3, 'Тест логина', 'Проверка сценариев входа', '2026-02-03', '2026-03-05'),
  (3, 5, 1, 'Аналитика данных', 'Сбор метрик', '2026-03-01', '2026-04-01'),
  (1, 2, 1, 'Тестирование БД', 'Проверка корректности схемы', '2026-01-15', '2026-02-05'),
  (1, 4, 2, 'Настройка CI', 'GitLab CI pipeline', '2026-01-20', '2026-02-15'),
  (2, 3, 1, 'UI прототип', 'Макеты экранов', '2026-02-10', '2026-03-10'),
  (2, 5, 2, 'Анализ требований', 'Документация по API', '2026-02-11', '2026-03-12'),
  (3, 1, 3, 'Разработка backend', 'REST сервисы', '2026-03-10', '2026-04-10'),
  (3, 2, 2, 'Тестирование портала', 'UI и API тесты', '2026-03-12', '2026-04-15'),
  (4, 5, 1, 'Сбор данных', 'Источники данных', '2026-04-01', '2026-05-01'),
  (4, 1, 2, 'ETL процесс', 'Загрузка данных', '2026-04-02', '2026-05-10'),
  (5, 4, 1, 'Docker окружение', 'Контейнеризация', '2026-05-01', '2026-06-01'),
  (5, 3, 2, 'Документация CI/CD', 'Описание пайплайнов', '2026-05-02', '2026-06-10');


  -- теги задач
  insert into task_tags(task_id, tag_id) values
    (1,6),(1,10),(1,9),
    (2,4),(2,9),
    (3,6),(3,11),
    (4,8),(4,3),
    (5,5),(5,9),
    (6,8),(6,9),
    (7,11),(7,6),
    (8,5),(8,4),
    (9,4),(9,9),
    (10,6),(10,1),
    (11,8),(11,9),
    (12,6),(12,10),
    (13,9),(13,3),
    (14,6),(14,10),
    (15,4),(15,9);

  -- история статусов (как у тебя было)
  insert into task_status_history (task_id, status_id, valid_from, valid_to, is_current) values
    (1,1,'2026-01-01','2026-01-05',false),
    (1,2,'2026-01-05',null,true),
    (2,1,'2026-01-02','2026-01-10',false),
    (2,2,'2026-01-10',null,true),
    (3,1,'2026-02-01','2026-02-15',false),
    (3,2,'2026-02-15',null,true),
    (4,1,'2026-02-03','2026-02-20',false),
    (4,3,'2026-02-20',null,true),
    (5,1,'2026-03-01',null,true),
    (6,1,'2026-03-05','2026-03-15',false),
    (6,2,'2026-03-15',null,true),
    (7,1,'2026-03-10',null,true),
    (8,1,'2026-03-12','2026-03-25',false),
    (8,2,'2026-03-25',null,true),
    (9,1,'2026-04-01',null,true),
    (10,1,'2026-04-05','2026-04-20',false),
    (10,3,'2026-04-20',null,true),
    (11,1,'2026-04-10',null,true),
    (12,1,'2026-04-15','2026-04-30',false),
    (12,2,'2026-04-30',null,true),
    (13,1,'2026-05-01',null,true),
    (14,1,'2026-05-05','2026-05-20',false),
    (14,2,'2026-05-20',null,true),
    (15,1,'2026-06-01',null,true);

  -- синхронизация current_status_id по истории
  update task t
  set current_status_id = tsh.status_id
  from task_status_history tsh
  where tsh.task_id = t.task_id and tsh.is_current = true;

  -- комментарии
  insert into comments (task_id, user_id, comment_text) values
    (1,3,'Необходимо уточнить требования'),
    (1,1,'Начал проектирование схемы'),
    (2,3,'Проведена встреча с заказчиком'),
    (2,1,'Ожидаю финальные требования'),
    (3,1,'Реализован базовый функционал'),
    (3,2,'Требуется дополнительное тестирование'),
    (4,2,'Найдены баги в форме логина'),
    (5,5,'Собраны ключевые метрики'),
    (6,2,'Проверка ограничений'),
    (7,4,'CI настроен'),
    (8,3,'Макеты согласованы'),
    (9,5,'Документация обновлена'),
    (10,1,'API готово'),
    (11,2,'Тесты пройдены'),
    (12,5,'Источники данных определены');

end;
$$;
