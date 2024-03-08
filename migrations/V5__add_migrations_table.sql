create table migrations
(
    name TEXT    not null,
    id   integer not null
        constraint migrations_pk
            primary key
);

