/* task.project_id - часто используеться в join и where, 
 * task_id, is_current - для быстрого доступа к текущему статусу
 * due_date часто используется для сортировки/фильтрации * 
 *   */
-- индекс для поиска задач (по проекту)
create index ind_task_project_id on task(project_id);

--индекс для поиска задач (по исполнителю)
create index ind_task_assigned_user on task(assigned_user_id);

--для анализа статуса задач scd
create index ind_task_status_history_task  on task_status_history(task_id, is_current);

--для фильтрации по статусу 
create index ind_task_current_status on task(current_status_id);

--для анализа задач по строкамм
create index ind_task_due_date  on task(due_date);

--уникальный индекс для текущего статуса задачи
create unique index uq_task_status
on task_status_history(task_id) where is_current = true;

