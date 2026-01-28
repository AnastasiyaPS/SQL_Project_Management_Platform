--проверки и ограничения 
alter table task  add constraint chk_task_dse_date
check (due_date>=created_at);

--проверка почты пользователя 
alter table users  add constraint chk_user_email
check (position('@' in email)>1);

--проверка дат 
alter table project  add constraint chk_project_date
check (end_date is null or end_date>=start_date);



