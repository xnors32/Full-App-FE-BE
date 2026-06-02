# Setup Database Railway (PostgreSQL)

## 1. Buat Database di Railway

1. Buka [railway.app](https://railway.app) dan login
2. Klik **New Project** → **Provision PostgreSQL**
3. Tunggu sampai database siap

## 2. Dapatkan Connection String

Di dashboard Railway, buka tab **Connect** → salin **Postgres Connection String**:

```
postgresql://user:pass@host:port/railway
```

## 3. Konfigurasi di Backend (Spring Boot)

Buka `src/main/resources/application.yml`, sesuaikan:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://host:port/railway?sslmode=require
    username: your_user
    password: your_password
    driver-class-name: org.postgresql.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
```

## 4. Jalankan SQL

```bash
psql "postgresql://user:pass@host:port/railway" -f sql/05_setup_railway.sql
```

## 5. Verifikasi

```sql
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
```
