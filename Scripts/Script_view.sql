--представление

create view v_current_task as
select
    t.task_id,
    t.title,
    p.project_name,
    u.full_name,
    s.status_name,
    t.due_date
from task t
join project p on p.project_id = t.project_id
left join users u on u.user_id = t.assigned_user_id
join status s on s.status_id = t.current_status_id

SELECT * FROM v_current_task


--просроченные задачи 
create view v_overdue_tasks as
select * 
from task 
where due_date < current_date and current_status_id <> (
select status_id from status  
where status_name='Завершена')

--история статусов задач
create view v_task_full_history as select
t.task_id,
t.title,
s.status_name, 
tsh.valid_from,
tsh.valid_to
from task_status_history tsh
join task t on t.task_id=tsh.task_id
join status s on s.status_id=tsh.status_id
