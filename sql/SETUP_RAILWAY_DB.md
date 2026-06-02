# Setup Database Railway (MySQL)

## 1. Buat Database di Railway

1. Buka [railway.app](https://railway.app) dan login
2. Klik **New Project** → **Provision MySQL**
3. Tunggu sampai database siap

## 2. Dapatkan Credentials

Di dashboard Railway, buka tab **Connect** → salin **MySQL Connection String**:

```
mysql://user:pass@host:port/railway
```

## 3. Konfigurasi di Backend (Spring Boot)

Buka `src/main/resources/application.yml`, sesuaikan:

```yaml
spring:
  datasource:
    url: jdbc:mysql://host:port/railway?useSSL=true&serverTimezone=Asia/Jakarta
    username: your_user
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver

  jpa:
    hibernate:
      ddl-auto: validate
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
```

## 4. Jalankan SQL

```bash
mysql -h host -u your_user -p railway < sql/05_setup_railway.sql
```

## 5. Verifikasi

```sql
SHOW TABLES;
```
