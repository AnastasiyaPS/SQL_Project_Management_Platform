
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
order by due_date;

--2
/* список задач с названием проекта и исполнителем 
 * inner потому что у исполнителя может не быть исполнителя*/
select t.task_id, t.title, p.project_name, u.full_name 
from task t 
inner join project p on t.project_id = p.project_id
inner join users u on u.user_id = t.assigned_user_id
order by task_id;

--3
/* все задачи  с исполнителями и без исполнителей */
select t.task_id, t.title, u.full_name 
from task t 
left join users u on u.user_id = t.assigned_user_id
order by task_id;

--4
/* Все пользователи и назначенные им задачи  */
select u.full_name, t.title
from task t 
right join users u on u.user_id = t.assigned_user_id
order by u.user_id; 

--5
/* Количество задач в каждом проекте */
select p.project_id, p.project_name , count(*) as count_task
from task t 
inner join project p on t.project_id = p.project_id
group by p.project_id,p.project_name 
order by p.project_id;  



--6
/* проекты с больше чем 2 задачами  */
select p.project_id, p.project_name
from task t 
inner join project p on t.project_id = p.project_id
group by p.project_id , p.project_name
having count(*)>2;

--7
/* задачи, у которых срок выполнения позже среднего срока по всем задачам*/ 
select task_id, title, due_date  
from task 
where due_date > (select TO_TIMESTAMP(AVG(extract(EPOCH from due_date)))
from task);

--8 
/* пользователей, которые участвуют в проектах с задачами в статусе "В работе" */ 

select full_name 
from users 
where user_id in 
(select t.assigned_user_id 
from task t
where t.current_status_id in (select status_id from status where status_name ='В работе'));
--9
/* Проекты с хотя бы 1 задачей  */ 

select project_name
from project 
where exists(
select 1 
from task t
where t.project_id=project.project_id);

--10 
/* задачи, срок которых больше любого срока задач проекта 1 */ 

select title 
from task 
where due_date> all (
select due_date 
from task where project_id=1
);

--11
/* задачи одного проекта с одинаковым исполнителем */
select t1.project_id, t1.assigned_user_id, t1.task_id, t1.title, t2.task_id, t2.title, u.full_name
from task t1
join task t2 on t1.project_id=t2.project_id and t1.assigned_user_id=t2.assigned_user_id and t1.task_id<t2.task_id
join users u on u.user_id = t1.assigned_user_id
where t1.assigned_user_id is not null
order by t1.project_id, t1.assigned_user_id, t1.task_id;



--12 
/* ранжирование задач по сроку выполнения внутри каждого проекта */ 
select task_id, project_id, title, due_date, rank() over (partition by project_id order by due_date) as tr 
from task 
order by project_id, tr;

--13 
/* количество задач каждлого пользователя и среднее количество задач */
select u.user_id, u.full_name, count(t.task_id) as tasks,
avg(count(t.task_id)) over() as avg_task
from users u 
left join task t on t.assigned_user_id = u.user_id
group by u.user_id, u.full_name;

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
from status where status_name ='В работе'));

--15
/*последний статус каждой задачи  */
select *
from (
select task_id, status_id, valid_from, 
row_number() over (partition by task_id order by valid_from desc ) as row_numb
from task_status_history 
) t
where row_numb=1;

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
);

--17
/* вывести  проекты, задачи и исполнители
 * даже если им не назначены исполнители или исполнителям задачи */
select p.project_name, t.title, u.full_name, s.status_name 
from project p 
full join task t using(project_id)
full join users u on u.user_id = t.assigned_user_id 
left join status s on s.status_id = t.current_status_id
order by p.project_name, t.title, u.full_name, s.status_name ;

--18
--первые 3 задачи по времени окончания (самые последние)
select *
from task t 
order by due_date desc, task_id
limit 3;

--19
/* рекурсивный запрос история изменения статусов задач*/

/* Рекурсивный запрос:
история изменения статусов задач */

with recursive status_flow (task_id, status_id, valid_from, valid_to) as (
    select tsh.task_id, tsh.status_id, tsh.valid_from, tsh.valid_to
    from task_status_history tsh
    where tsh.valid_from = (
        select min(t2.valid_from)
        from task_status_history t2
        where t2.task_id = tsh.task_id
    )
    union all
    
    select tt.task_id, tt.status_id, tt.valid_from, tt.valid_to
    from task_status_history tt
    join status_flow sf
      on sf.task_id = tt.task_id
    where tt.valid_from = (
         select min(t3.valid_from)
         from task_status_history t3
         where t3.task_id = sf.task_id
           and t3.valid_from > sf.valid_from
     )) 
select *
from status_flow
order by task_id, valid_from;

