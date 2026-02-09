create table status (
status_id SERIAL primary key,
status_name VARCHAR(50) not null unique
);

comment on table status is 'Справочник статусов задач';

comment on column status.status_id is 'Уникальный идентификатор статуса';

comment on column status.status_name is 'Название статуса';

create table tag(
tag_id SERIAL primary key,
tag_name VARCHAR(50) NOT NULL UNIQUE
);

create table users(
user_id SERIAL primary key,
full_name VARCHAR (100) not null,
email VARCHAR (100) not null unique,
role VARCHAR (50)
);

comment on table users is 'Пользователи системы';
comment on column users.user_id is 'Уникальный идентификатор пользователя';
comment on column users.full_name is 'ФИО пользователя';
comment on column users.email is 'Электронная почта';
comment on column users.role is 'Роль пользователя в системе';

create table project(
project_id SERIAL primary key,
project_name VARCHAR (100) not null,
project_description TEXT,
start_date DATE not null,
end_date DATE
);

create table task (
task_id SERIAL primary key,
project_id INTEGER not null,
assigned_user_id INTEGER,
current_status_id INTEGER not null,
title VARCHAR(200) not null,
description TEXT,
created_at TIMESTAMP default CURRENT_TIMESTAMP,
due_date DATE,
foreign key (project_id) references project(project_id),
foreign key (assigned_user_id) references users(user_id),
foreign KEY (current_status_id) references status(status_id)
);
--добавления каскадного удаления

select
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name as foreign_table
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
  on tc.constraint_name = kcu.constraint_name
join information_schema.constraint_column_usage ccu
  on ccu.constraint_name = tc.constraint_name
where tc.constraint_type = 'FOREIGN KEY'
order by tc.table_name;


alter table task
drop constraint task_project_id_fkey;

alter table task add constraint task_project_id_fkey
foreign key (project_id)
references project(project_id) on delete cascade;

alter table task
drop constraint task_assigned_user_id_fkey;

alter table task
add constraint task_assigned_user_id_fkey
foreign key (assigned_user_id)
references users(user_id)
on delete set null;


create table comments (
comment_id SERIAL primary key,
task_id  INTEGER not null,
user_id INTEGER not null,
comment_text TEXT not null,
created_at TIMESTAMP default CURRENT_TIMESTAMP,
foreign key (task_id) references task(task_id),
foreign key (user_id) references users(user_id));

--добавление каскадного удаления 
alter table comments
drop constraint comments_task_id_fkey;

alter table comments
drop constraint comments_user_id_fkey;

alter table comments
add constraint comments_task_id_fkey
foreign key (task_id)
references task(task_id)
on delete cascade;

alter table comments
add constraint comments_user_id_fkey
foreign key (user_id)
references users(user_id)
on delete cascade;


create table project_users (
project_id INTEGER not null,
user_id INTEGER not null,
project_role VARCHAR(50) not null,
primary key (project_id, user_id),
foreign key (project_id) references project(project_id),
foreign key (user_id) references users(user_id)
);

alter table project_users 
drop constraint project_users_project_id_fkey;

alter table project_users add constraint project_users_project_id_fkey
foreign key (project_id) references project(project_id) on delete cascade;

alter table project_users 
drop constraint project_users_user_id_fkey;

alter table project_users add constraint project_users_user_id_fkey
foreign key (user_id) references users(user_id) on delete cascade;

create table task_tags (
task_id INTEGER not null,
tag_id INTEGER not null,
primary key (task_id, tag_id),
foreign key (task_id) references task(task_id),
foreign key (tag_id) references tag(tag_id));

alter table task_tags 
drop constraint task_tags_task_id_fkey;

alter table task_tags add constraint task_tags_task_id_fkey
foreign key (task_id) references task(task_id) on delete cascade;

alter table task_tags 
drop constraint task_tags_tag_id_fkey;

alter table task_tags add constraint task_tags_tag_id_fkey
foreign key (tag_id) references tag(tag_id) on delete cascade;

create table task_status_history(
task_status_history_id SERIAL primary key,
task_id INTEGER not null,
status_id INTEGER not null,
valid_from TIMESTAMP not null default CURRENT_TIMESTAMP,
valid_to TIMESTAMP,
is_current BOOLEAN default true,
foreign key (task_id) references task(task_id),
foreign key (status_id) references status(status_id)
);

alter table task_status_history
drop constraint task_status_history_task_id_fkey;

alter table task_status_history
add constraint task_status_history_task_id_fkey
foreign key (task_id)
references task(task_id)
on delete cascade;