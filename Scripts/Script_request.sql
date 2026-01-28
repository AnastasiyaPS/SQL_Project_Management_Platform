insert into status(status_name) values 
('Новая'), ('В работе'),('На проверке'), ('Отложена'),('Отменена'),('Завершена')

Select * from status

insert into tag (tag_name) values
('баг'),
('фича'),
('срочно'),
('документация'),
('дизайн'),
('бекенд'),
('фронтенд'),
('тестирование'),
('важное'),
('оптимизация'),
('рефакторинг'),
('безопасность')

Select * from tag

insert into Project(project_name, project_description, start_date, end_date) values
('CRM система', 'Разработка CRM для отдела продаж', '2025-01-01', '2025-06-30'),
('Мобильное приложение', 'Приложение для клиентов', '2025-02-01', '2025-08-01'),
('Веб-портал', 'Корпоративный портал', '2024-03-01', '2025-09-01'),
('BI аналитика', 'Система аналитики', '2025-01-15', '2026-01-01'),
('DevOps платформа', 'Автоматизация CI/CD', '2025-04-01', '2026-01-07')

Select * from Project

insert into users (full_name, email, role) values
('Иванов Иван', 'ivanov@mail.ru', 'Developer'),
('Петров Петр', 'petrov@mail.ru', 'QA'),
('Сидорова Анна', 'sidorova@mail.ru', 'Manager'),
('Смирнов Олег', 'smirnov@mail.ru', 'DevOps'),
('Кузнецова Мария', 'kuz@mail.ru', 'Analyst')

Select * from users



insert into project_users (project_id, user_id, project_role) values
(1,1,'Developer'),(1,2,'QA'),(1,3,'Manager'),(1,4,'DevOps'),(1,5,'Analyst'),
(2,1,'Developer'),(2,2,'QA'),(2,3,'Manager'),(2,4,'DevOps'),(2,5,'Analyst'),
(3,1,'Developer'),(3,2,'QA'),(3,3,'Manager'),(3,4,'DevOps'),(3,5,'Analyst'),
(4,1,'Developer'),(4,2,'QA'),(4,3,'Manager'),(4,4,'DevOps'),(4,5,'Analyst'),
(5,1,'Developer'),(5,2,'QA'),(5,3,'Manager'),(5,4,'DevOps'),(5,5,'Analyst')

Select * from project_users


insert into  task (project_id, assigned_user_id, current_status_id, title, description, due_date) values
(1, 1, 1, 'Создать структуру БД', 'Проектирование таблиц', '2026-02-01'),
(1, 3, 2, 'Сбор требований', 'Интервью с заказчиком', '2026-02-10'),
(2, 1, 2, 'API авторизации', 'JWT авторизация', '2026-03-01'),
(2, 2, 3, 'Тест логина', 'Проверка сценариев входа', '2026-03-05'),
(3, 5, 1, 'Аналитика данных', 'Сбор метрик', '2026-04-01'),
(1, 2, 1, 'Тестирование БД', 'Проверка корректности схемы', '2026-02-05'),
(1, 4, 2, 'Настройка CI', 'GitLab CI pipeline', '2026-02-15'),
(2, 3, 1, 'UI прототип', 'Макеты экранов', '2026-03-10'),
(2, 5, 2, 'Анализ требований', 'Документация по API', '2026-03-12'),
(3, 1, 3, 'Разработка backend', 'REST сервисы', '2026-04-10'),
(3, 2, 2, 'Тестирование портала', 'UI и API тесты', '2026-04-15'),
(4, 5, 1, 'Сбор данных', 'Источники данных', '2026-05-01'),
(4, 1, 2, 'ETL процесс', 'Загрузка данных', '2026-05-10'),
(5, 4, 1, 'Docker окружение', 'Контейнеризация', '2026-06-01'),
(5, 3, 2, 'Документация CI/CD', 'Описание пайплайнов', '2026-06-10')



select * from task

insert into task_tags (task_id, tag_id) values
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
(15,4),(15,9)

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
(15,1,'2026-06-01',null,true)

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
(12,5,'Источники данных определены')

select * from comments


/* запросы с использованием
WHERE, 
GROUP BY, 
HAVING, 
ORDER BY, 
JOIN (left, right, full, inner)
подзапросы (скалярные и не скалярные,  простые, сложные, с опертором in, any,  all, exists, самосоединением)
оконные функции (ранжирующие, агрегирующие, смещающие, математические)
LIMIT/OFFSET
Рекурсивные запросы
*/

--1
/* все задачи одного проекта с сортировкой по сроку выполнения*/
select task_id, title, description
from task 
where project_id  = 1
order by due_date 

--2
/* список задач с названием проекта и исполнителем 
 * inner потому что у исполнителя может не быть исполнителя*/
select t.task_id, t.title, p.project_name, u.full_name 
from task t 
inner join project p on t.project_id = p.project_id
inner join users u on u.user_id = t.assigned_user_id
order by task_id 

--3
/* все задачи  с исполнителями и без исполнителей */
select t.task_id, t.title, u.full_name 
from task t 
left join users u on u.user_id = t.assigned_user_id
order by task_id 

--4
/* Все пользователи и назначенные им задачи  */
select u.full_name, t.title
from task t 
right join users u on u.user_id = t.assigned_user_id
order by u.user_id 

--5
/* Количество задач в каждом проекте */
select p.project_id, p.project_name , count(*) as count_task
from task t 
inner join project p on t.project_id = p.project_id
group by p.project_id 
order by p.project_id  

--6
/* проекты с больше чем 2 задачами  */
select p.project_id, p.project_name
from task t 
inner join project p on t.project_id = p.project_id
group by p.project_id 
having count(*)>2

--7
/* задачи, у которых срок выполнения позже среднего срока по всем задачам*/ 
select task_id, title, due_date  
from task 
where due_date > (select TO_TIMESTAMP(AVG(extract(EPOCH from due_date)))
from task)

--8 
/* пользователей, которые участвуют в проектах с задачами в статусе "В работе" */ 

select full_name 
from users 
where user_id in 
(select t.assigned_user_id 
from task t
where t.current_status_id in (select status_id from status where status_name ='В работе'))
--9
/* Проекты с хотя бы 1 задачей  */ 

select project_name
from project 
where exists(
select 1 
from task t
join project p on t.project_id=p.project_id)

--10 
/* задачи, срок которых больше любого срока задач проекта 1 */ 

select title 
from task 
where due_date> any (
select due_date 
from task where project_id=1
)

--11
/* задачи одного проекта с одинаковым исполнителем */
select
from task t1
join task t2 on t1.project_id=t2.project_id and t1.assigned_user_id=t2.assigned_user_id and t1.task_id<t2.task_id




--12 
/* ранжирование задач по сроку выполнения внутри каждого проекта */ 
select task_id, project_id, title, due_date, rank() over (partition by project_id order by due_date) as tr 
from task 
order by project_id, tr

--13 
/* количество задач каждлого пользователя и среднее количество задач */
select u.user_id, u.full_name, count(t.task_id) as tasks,
avg(count(t.task_id)) over() as avg_task
from users u 
left join task t on t.assigned_user_id = u.user_id
group by u.user_id, u.full_name

--14
/* задачи, находящиеся в статусе в работе долше среднего  */
select tsh.task_id
from task_status_history tsh 
where tsh.status_id = (select status_id 
from status where status_name ='В работе')
and 
(coalesce(tsh.valid_to, now())-tsh.valid_from)>(
select avg(coalesce(tsh.valid_to, now())-tsh.valid_from)
from task_status_history tsh 
where tsh.status_id = (select status_id 
from status where status_name ='В работе'))

--15
/*последний статус каждой задачи  */
select *
from (
select task_id, status_id, valid_from, 
row_number() over (partition by task_id order by valid_from desc ) as row_numb
from task_status_history 
) t
where row_numb=1

--16
/* пользователи, у которых задач больше, чем у любого QA */ 
select u.user_id, u.full_name 
from users u 
where 
(select count(*)
from task t 
where t.assigned_user_id = u.user_id) > all(
select count(t.task_id)
from users u2
left join task t on t.assigned_user_id = u2.user_id 
where u2.role = 'QA'
group by u2.user_id
)

--
