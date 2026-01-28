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

call change_task_status(3, 2);


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

call create_task(1, 2, 'Подготовить отчет', '2026-03-01');
