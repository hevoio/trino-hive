## Trino (Presto) with Hive connector
The instructions here relate to run Presto with data present in GCS. This setup has been adapted from this repository: [Hive connector over MinIO file storage](https://github.com/bitsondatadev/trino-getting-started/tree/main/hive/trino-minio).

### Stack
- Trino (Presto)
- Hive GCS connector
- Hive Metastore with MariaDB persistence

### Steps
- Download the [gcs connector](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage) and place the [jar](https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop3-latest.jar) file in lib directory.
- Obtain GCP [service-account credentials json](https://cloud.google.com/iam/docs/creating-managing-service-accounts) with the service-account having admin permissions on GCS. Place this file in `creds` directory, the file name being - **gcp-service-credentials.json**
- Set the GCP project-id against `fs.gs.project.id` in [metastore-site.xml](https://github.com/hevoio/trino-hive/blob/master/conf/metastore-site.xml#L41).
- Run `docker-compose up -d`.
- It should start instances of the database, metastore and Trino 
```
Creating network "trino-hive_trino-network" with driver "bridge"
Creating trino-hive_mariadb_1           ... done
Creating trino-hive_trino-coordinator_1 ... done
Creating trino-hive_hive-metastore_1    ... done
```

### Create Entities
View Catalogs
```
trino> show catalogs;
 Catalog
---------
 hive
 system
 tpcds
 tpch
(4 rows)
```
Create a Schema in the Hive Catalog
```
trino> CREATE SCHEMA hive.hive_gcs WITH (location = 'gs://bucket-test-tj-1/');
CREATE SCHEMA
```
Create some data in GCS. Ensure that partitions like `partion_name=foo` are present in the structure. Example:
![Example](https://cdn.hevodata.com/github/gcs_structure.png)

Create a partitioned Hive Table
```
USE hive.hive_gcs;

CREATE TABLE sample_table1 (
  col_1 varchar, col_2 varchar, col_3 varchar, col_4 varchar, col_5 varchar,
  xing varchar, fing varchar
)
WITH (
  format = 'CSV',
  partitioned_by = ARRAY['xing','fing'],
  external_location = 'gs://bucket-test-tj-1/ping',
  skip_header_line_count = 1
);

```
Update partitions
```
CALL system.sync_partition_metadata(schema_name=>'hive_gcs', table_name=>'sample_table1', mode=>'FULL');
```
Read Data
```

trino:hive_gcs> select * from sample_table1 where xing = 'bar' and fing = 'io';

 col_1 | col_2 | col_3 | col_4 | col_5 | xing | fing
-------+-------+-------+-------+-------+------+------
 91    | 92    | 93    | 94    | 95    | bar  | io
 81    | 82    | 83    | 84    | 85    | bar  | io
```

### Sample code
Maven dependency
```
<dependency>
    <groupId>io.trino</groupId>
    <artifactId>trino-jdbc</artifactId>
    <version>373</version>
</dependency>
```
Java Code
```
public static void main(String[] args) throws Exception {
    // Format: <Trino_Coordinator>/Catalog/Schema
    try (Connection conn = DriverManager.getConnection("jdbc:trino://localhost:9080/hive/hive_gcs?user=anything")) {
        try(Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery("SELECT * FROM sample_table1")) {
                while (rs.next()) {
                    String col1 = rs.getString("col_1");
                    String col2 = rs.getString("col_2");
                    System.out.println(String.format("col_1=%s and col_2=%s", col1, col2));
                }
            }
        }
    }
}
```

### References
- [Hadoop GCS Connector](https://github.com/GoogleCloudDataproc/hadoop-connectors/blob/master/gcs/INSTALL.md)
- [Intro to Hive Connector](https://trino.io/blog/2020/10/20/intro-to-hive-connector.html)
- [Trino GCS Configuration](https://trino.io/docs/current/connector/hive.html#google-cloud-storage-configuration)
- [What is Presto connection?](https://ahana.io/learn/what-is-a-presto-connection-and-how-does-it-work/)

### MinIO
[MinIO](https://min.io/) is a multi-cloud object storage abstraction for any cloud. It has s3 like semantics and is compatible with most clouds. Hence, it can be a good alternate to object storage if rich abstraction is a necessity. A sample [experiment](https://medium.com/google-cloud/build-aws-s3-compatible-cloud-storage-on-gcp-with-minio-and-kubernetes-2adc0a367f98).
