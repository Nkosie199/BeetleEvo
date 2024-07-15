create table catalog (
    id varchar primary key
);

create table schema (
    id varchar primary key,
    uri varchar not null,
    timestamp timestamp not null
);

create table tag (
    id varchar primary key,
    schema_id varchar not null references schema(id)
);

create table record (
    id char(36) primary key,
    schema_id varchar not null references schema(id),
    metadata jsonb not null,
    timestamp timestamp not null
);

create table record_tag (
    id char(36) primary key,
    record_id char(36) not null references record(id),
    tag_id varchar not null references tag(id),
    data jsonb not null,
    timestamp timestamp not null
);

create table catalog_record (
    primary key (catalog_id, record_id),
    catalog_id varchar references catalog(id),
    record_id char(36) references record(id),
    published boolean not null,
    published_record jsonb not null,
    timestamp timestamp not null
);

-- static data
insert into catalog (id) values ('saeon');
insert into schema (id, uri, timestamp) values ('metadata-datacite', 'https://odp.saeon.ac.za/schema/test/metadata/datacite', '2022-04-01');
insert into schema (id, uri, timestamp) values ('tag-qc', 'https://odp.saeon.ac.za/schema/test/tag/qc', '2022-04-28');
insert into schema (id, uri, timestamp) values ('tag-sdg', 'https://odp.saeon.ac.za/schema/test/tag/sdg', '2022-07-16');
insert into tag (id, schema_id) values ('qc', 'tag-qc');
insert into tag (id, schema_id) values ('sdg', 'tag-sdg');

-- metadata
insert into record (id, schema_id, metadata, timestamp) values ('4dcd4807-3965-4595-ba03-e642f04d2299', 'metadata-datacite', '{"doi": "10.55555/TEST01"}', '2022-05-24');
insert into record (id, schema_id, metadata, timestamp) values ('f3e534f8-9fba-4a36-b249-4464a8a05d72', 'metadata-datacite', '{"doi": "10.55555/TEST02"}', '2022-06-13');
insert into record (id, schema_id, metadata, timestamp) values ('ccf38b99-ca09-47cf-b17d-d1bbeb06379a', 'metadata-datacite', '{"doi": "10.55555/TEST03"}', '2022-07-20');
insert into record (id, schema_id, metadata, timestamp) values ('cebcce11-9825-4c6d-80f3-18ca9d903ba8', 'metadata-datacite', '{"doi": "10.55555/TEST04"}', '2022-07-04');
insert into record (id, schema_id, metadata, timestamp) values ('ffeb8b23-0208-4c10-986d-a982a4eb29ce', 'metadata-datacite', '{"doi": "10.55555/TEST05"}', '2022-07-11');
insert into record (id, schema_id, metadata, timestamp) values ('c1885bbf-c56a-4431-a609-c04745f87e06', 'metadata-datacite', '{"doi": "10.55555/TEST06"}', '2022-07-11');

-- curation data
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('729fdebf-60a3-41bc-8bf1-8b1ed508140b', '4dcd4807-3965-4595-ba03-e642f04d2299', 'qc', '{"pass_": true}', '2022-05-25');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('1ee04978-db7f-4447-9b11-25c8298aef92', '4dcd4807-3965-4595-ba03-e642f04d2299', 'sdg', '{"sdg": 3}', '2022-07-19');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('11a45b43-a2d7-4e8c-9a2d-4532a79605e2', 'f3e534f8-9fba-4a36-b249-4464a8a05d72', 'qc', '{"pass_": false}', '2022-06-29');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('2967dacc-c8ca-40ec-921e-0edaf14eedac', 'cebcce11-9825-4c6d-80f3-18ca9d903ba8', 'qc', '{"pass_": true}', '2022-07-09');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('79496a72-f980-423f-92e0-86d017deca00', 'ffeb8b23-0208-4c10-986d-a982a4eb29ce', 'qc', '{"pass_": true}', '2022-07-12');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('32872f72-2223-47c8-940a-8297105a7180', 'ffeb8b23-0208-4c10-986d-a982a4eb29ce', 'sdg', '{"sdg": 7}', '2022-07-12');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('1dc92611-264f-4be6-9b38-17159530d2f1', 'ffeb8b23-0208-4c10-986d-a982a4eb29ce', 'sdg', '{"sdg": 13}', '2022-07-12');
insert into record_tag (id, record_id, tag_id, data, timestamp) values ('bdb4f036-976f-418a-8075-901d04a755e4', 'c1885bbf-c56a-4431-a609-c04745f87e06', 'qc', '{"pass_": false}', '2022-07-22');

-- catalog data
insert into catalog_record (catalog_id, record_id, published, published_record, timestamp) values ('saeon', '4dcd4807-3965-4595-ba03-e642f04d2299', true, '{"doi": "10.55555/TEST01"}', '2022-05-25');
insert into catalog_record (catalog_id, record_id, published, published_record, timestamp) values ('saeon', 'f3e534f8-9fba-4a36-b249-4464a8a05d72', false, 'null', '2022-06-29');
insert into catalog_record (catalog_id, record_id, published, published_record, timestamp) values ('saeon', 'cebcce11-9825-4c6d-80f3-18ca9d903ba8', true, '{"doi": "10.55555/TEST04"}', '2022-07-09');
insert into catalog_record (catalog_id, record_id, published, published_record, timestamp) values ('saeon', 'ffeb8b23-0208-4c10-986d-a982a4eb29ce', true, '{"doi": "10.55555/TEST05"}', '2022-07-12');
insert into catalog_record (catalog_id, record_id, published, published_record, timestamp) values ('saeon', 'c1885bbf-c56a-4431-a609-c04745f87e06', false, 'null', '2022-07-11');
