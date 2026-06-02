# Setup Database Neon (PostgreSQL)

## 1. Buat Project di Neon

1. Buka [neon.tech](https://neon.tech) dan login
2. Klik **Create a project**
3. Isi:
   - **Name**: `inventori-lab` (atau sesuai keinginan)
   - **PostgreSQL version**: 16 / 17 (default)
   - **Region**: pilih yang terdekat
4. Klik **Create**

## 2. Dapatkan Connection String

Setelah project jadi, salin **connection string** seperti ini:

```
postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/inventori_lab?sslmode=require
```

> **Catatan**: Ganti `inventori_lab` di URL dengan nama database yang kamu inginkan.  
> Database akan otomatis dibuat saat pertama kali terkoneksi.

## 3. Konfigurasi di Backend (Spring Boot)

Buka `src/main/resources/application.yml`, sesuaikan:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://ep-xxx.us-east-2.aws.neon.tech/inventori_lab?sslmode=require
    username: your_user
    password: your_password
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate   # atau update untuk first run
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
```

## 4. Jalankan SQL

### Via psql

```bash
psql "postgresql://user:pass@ep-xxx.us-east-2.aws.neon.tech/inventori_lab?sslmode=require" -f sql/05_setup_neon.sql
```

### Via Neon SQL Editor

1. Buka project di Neon Dashboard
2. Klik **SQL Editor** di sidebar
3. Copy isi `sql/05_setup_neon.sql`
4. Paste dan jalankan

## 5. Verifikasi

Cek tabel yang terbentuk:

```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```

Cek data seed:

```sql
SELECT nama, email, role FROM users;
SELECT nama_barang, jumlah_tersedia FROM barang;
```
