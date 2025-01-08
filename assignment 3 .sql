


  ASSIGNMENT 3 - Advanced Features of PostgreSQL 

postgres=# CREATE EXTENSION hstore;
CREATE EXTENSION
postgres=# CREATE TABLE gadgets (    id SERIAL PRIMARY KEY,    model_name TEXT NOT NULL,    specifications hstore);
CREATE TABLE
postgres=# INSERT INTO gadgets (model_name, specifications) VALUES('Lenovo', 'cpu => "Octa-core", ram => "8GB", storage => "128GB"'),('HP', 'cpu => "Quad-core", ram => "2GB", storage => "32GB"'),('Dell', 'cpu => "Dual-core", ram => "4GB", storage => "64GB"');
INSERT 0 3
postgres=# SELECT * FROM gadgets;
 id | model_name |                    specifications                    
----+------------+------------------------------------------------------
  1 | HP         | "cpu"=>"Quad-core", "ram"=>"4GB", "storage"=>"64GB"
  2 | Lenovo     | "cpu"=>"Octa-core", "ram"=>"8GB", "storage"=>"128GB"
  3 | Dell       | "cpu"=>"Dual-core", "ram"=>"2GB", "storage"=>"32GB"
(3 rows)

-----------------------------------------------


postgres=# CREATE TABLE developers (id SERIAL PRIMARY KEY,developer_name TEXT NOT NULL,tech_stack TEXT[]);
CREATE TABLE
postgres=# INSERT INTO developers (developer_name, tech_stack) VALUES ('Thiru', ARRAY['Python', 'JavaScript', 'HTML']), ('Velu', ARRAY['Java', 'C++', 'SQL']);
INSERT 0 2                                   ^
postgres=# SELECT * FROM developers WHERE 'Python' = ANY(tech_stack);
 id | developer_name |        tech_stack        
----+----------------+--------------------------
  1 | Arun           | {Python,JavaScript,HTML}
(1 row)

-----------------------

postgres=# UPDATE developers SET tech_stack = array_append(array_remove(tech_stack, 'CSS'), 'React') WHERE developer_name = 'Velu';
UPDATE 1
postgres=# SELECT * FROM developers;
 id | developer_name |           tech_stack           
----+----------------+--------------------------------
  2 | Krishnan       | {Java,C++,SQL}
  1 | Arun           | {Python,JavaScript,HTML,React}
(2 rows)

postgres=# UPDATE developers SET tech_stack = array_append(array_remove(tech_stack, 'CSS'), 'React') WHERE developer_name = 'Thiru';
UPDATE 1
postgres=# SELECT * FROM developers;
 id | developer_name |           tech_stack           
----+----------------+--------------------------------
  1 | Arun           | {Python,JavaScript,HTML,React}
  2 | Krishnan       | {Java,C++,SQL,React}
(2 rows)

--------------------------------------

postgres=# CREATE TABLE metadata (id SERIAL PRIMARY KEY,details JSONB);
CREATE TABLE
postgres=# INSERT INTO metadata (details) VALUES('{"file_type": "pdf", "size": "6MB", "owner": "Dinesh"}'),('{"file_type": "jpg", "size": "8MB", "owner": "Vijay"}'),('{"file_type": "docx", "size": "10MB", "owner": "Ajith"}');
INSERT 0 3
postgres=# select * from metadata;
 id |                        details                         
----+--------------------------------------------------------
  1 | {"size": "2MB", "owner": "Rajesh", "file_type": "pdf"}
  2 | {"size": "5MB", "owner": "Ajay", "file_type": "jpg"}
  3 | {"size": "1MB", "owner": "Anil", "file_type": "docx"}
(3 rows)

postgres=# CREATE INDEX idx_metadata_details ON metadata USING GIN (details);
CREATE INDEX

postgres=# \d metadata;
                             Table "public.metadata"
 Column  |  Type   | Collation | Nullable |               Default                
---------+---------+-----------+----------+--------------------------------------
 id      | integer |           | not null | nextval('metadata_id_seq'::regclass)
 details | jsonb   |           |          | 
Indexes:
    "metadata_pkey" PRIMARY KEY, btree (id)
    "idx_metadata_details" gin (details)
