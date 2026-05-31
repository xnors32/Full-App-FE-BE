# 🚀 Panduan Setup Lengkap - Sistem Inventaris Laboratorium

Dokumen ini menjelaskan langkah-langkah lengkap untuk setup dan menjalankan sistem inventaris laboratorium (Backend + Frontend).

## 📋 Daftar Isi
1. [Prerequisites](#prerequisites)
2. [Setup Database](#setup-database)
3. [Setup Backend](#setup-backend)
4. [Setup Frontend](#setup-frontend)
5. [Testing & Validation](#testing--validation)
6. [Production Deployment](#production-deployment)
7. [Troubleshooting](#troubleshooting)

---

## 📦 Prerequisites

### System Requirements
- OS: Windows, macOS, or Linux
- Minimal 4GB RAM
- 2GB free disk space

### Required Software

#### 1. Java Development Kit (JDK) 21+
```bash
# Check if installed
java -version

# If not installed, download from:
# https://www.oracle.com/java/technologies/downloads/
```

**Install on macOS:**
```bash
brew install openjdk@21
```

**Install on Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install openjdk-21-jdk
```

#### 2. Maven 3.8+
```bash
# Check if installed
mvn -version

# macOS
brew install maven

# Linux
sudo apt install maven
```

#### 3. Node.js 18+ & npm 10+
```bash
# Check if installed
node --version
npm --version

# Download from: https://nodejs.org/
# Or using package manager:
# macOS: brew install node
# Linux: apt install nodejs npm
```

#### 4. MariaDB Server
```bash
# Check if installed
mysql --version

# macOS
brew install mariadb

# Linux
sudo apt install mariadb-server

# Windows: Download from https://mariadb.org/download/
```

---

## 💾 Setup Database

### 1. Start MariaDB Service

**macOS:**
```bash
brew services start mariadb
```

**Linux:**
```bash
sudo systemctl start mariadb
# or
sudo service mariadb start
```

**Windows:**
```
Services > MariaDB > Start
# or
net start MariaDB
```

### 2. Login ke MariaDB
```bash
mysql -u root -p
# Password: alif (atau sesuai instalasi)
```

### 3. Create Database
```sql
-- Buat database
CREATE DATABASE IF NOT EXISTS inventori_lab 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Use database
USE inventori_lab;

-- Verify
SHOW DATABASES;
SHOW TABLES;
```

**Result:**
- Database `inventori_lab` sudah siap
- Tables akan otomatis dibuat oleh Hibernate saat aplikasi start

### 4. Verify Connection
```bash
# Test koneksi
mysql -u root -p -h localhost -e "SELECT VERSION();"
```

---

## 🔧 Setup Backend

### 1. Navigate ke Backend Directory
```bash
cd /home/youtta/Projects/01/BE-Java-mvn-spring-boot
```

### 2. Verify Configuration
File: `src/main/resources/application.yml`

Pastikan konfigurasi database sesuai:
```yaml
spring:
  datasource:
    url: jdbc:mariadb://localhost:3306/inventori_lab
    username: root
    password: alif  # Sesuaikan dengan password Anda
```

**Jika berbeda, edit konfigurasi:**
```bash
# Edit file
nano src/main/resources/application.yml
# atau gunakan editor favorit Anda
```

### 3. Build Project
```bash
# Clean install
mvn clean install

# Expected output:
# [INFO] BUILD SUCCESS
```

**Troubleshooting jika build gagal:**
```bash
# Clear Maven cache
rm -rf ~/.m2/repository
mvn clean install -U
```

### 4. Run Backend (Development)
```bash
# Terminal 1 (Backend)
mvn spring-boot:run

# Expected output:
# 2024-05-31 14:00:02.456 INFO [...] Tomcat started on port(s): 4000 (http)
# ✅ Backend ready at http://localhost:4000
```

### 5. Test Backend API

Gunakan Postman atau curl:

**Test 1: Health Check**
```bash
curl http://localhost:4000
```

**Test 2: Register User**
```bash
curl -X POST http://localhost:4000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nama": "Test User",
    "email": "test@test.com",
    "password": "password123",
    "role": "MAHASISWA"
  }'
```

**Test 3: Login**
```bash
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@test.com",
    "password": "password123"
  }'
```

---

## 🎨 Setup Frontend

### 1. Navigate ke Frontend Directory
```bash
cd /home/youtta/Projects/01/frontend-baru
```

### 2. Install Dependencies
```bash
npm install

# Expected output:
# added 144 packages, and audited 145 packages
# found 0 vulnerabilities
```

### 3. Create Environment File (Optional)

Buat `.env.local` untuk override default config:
```bash
cat > .env.local << EOF
VITE_API_BASE_URL=http://localhost:4000/api
VITE_APP_NAME=Inventori Lab
EOF
```

### 4. Run Frontend (Development)
```bash
# Terminal 2 (Frontend, jangan close Terminal 1)
npm run dev

# Expected output:
# ➜  Local:   http://localhost:5173/
```

### 5. Buka di Browser
```
Buka: http://localhost:5173
```

**Seharusnya melihat:**
- ✅ Login page
- ✅ Register button
- ✅ Theme toggle (dark/light mode)

---

## ✅ Testing & Validation

### Full End-to-End Test

#### Step 1: Register User
1. Buka `http://localhost:5173`
2. Klik "Register"
3. Isi form:
   - Nama: `Alif Tester`
   - Email: `alif@test.com`
   - Password: `password123`
   - Role: Pilih `MAHASISWA`
4. Klik "Register"

**Expected:** Berhasil register, auto-redirect ke login

#### Step 2: Login
1. Email: `alif@test.com`
2. Password: `password123`
3. Klik "Login"

**Expected:**
- ✅ Login berhasil
- ✅ Redirect ke Dashboard
- ✅ Menampilkan nama user di header

#### Step 3: Test Manajemen Barang
1. Klik "Barang" di sidebar
2. Klik "Tambah Barang"
3. Isi form:
   - Nama: `Mikroskop`
   - Kode: `MKS-001`
   - Kategori: Pilih kategori (jika ada) atau create baru
   - Jumlah: `5`
   - Harga: `5000000`
4. Submit

**Expected:** Barang berhasil ditambahkan dan muncul di tabel

#### Step 4: Test Peminjaman
1. Klik "Peminjaman" di sidebar
2. Klik "Buat Peminjaman"
3. Pilih barang dan jumlah
4. Set tanggal pinjam & kembali
5. Submit

**Expected:** Peminjaman berhasil dibuat dengan status "MENUNGGU"

### Backend Tests
```bash
# Di Terminal 1, buka directory backend
cd /home/youtta/Projects/01/BE-Java-mvn-spring-boot

# Run unit tests
mvn test

# Expected: All tests should pass
# [INFO] Tests run: XX, Failures: 0, Errors: 0
```

---

## 📦 Production Deployment

### Build Production JAR

```bash
# Terminal backend
cd /home/youtta/Projects/01/BE-Java-mvn-spring-boot
mvn clean package

# Output JAR
# target/restfull-api-inventori-laboratorium-0.0.1-SNAPSHOT.jar
```

### Run Backend from JAR
```bash
java -jar target/restfull-api-inventori-laboratorium-0.0.1-SNAPSHOT.jar

# Jika perlu override port/database:
java -jar \
  -Dserver.port=8080 \
  -Dspring.datasource.url=jdbc:mariadb://prod-db:3306/inventori_lab \
  -Dspring.datasource.username=prod_user \
  -Dspring.datasource.password=prod_pass \
  target/restfull-api-inventori-laboratorium-0.0.1-SNAPSHOT.jar
```

### Build Production Frontend

```bash
# Terminal frontend
cd /home/youtta/Projects/01/frontend-baru
npm run build

# Output folder
# dist/

# File size akan optimal untuk production
```

### Deploy Frontend (Nginx Example)

```bash
# Copy dist folder ke server
scp -r dist/* user@server:/var/www/html/inventori-lab/

# Or Docker
cat > Dockerfile.frontend << 'EOF'
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# Build image
docker build -f Dockerfile.frontend -t inventori-lab-frontend:latest .
docker run -p 80:80 inventori-lab-frontend:latest
```

---

## 🔧 Troubleshooting

### ❌ MariaDB Connection Error
```
Error: "java.sql.SQLException: Cannot get a connection, pool error Timeout waiting for idle object"
```

**Solusi:**
```bash
# 1. Check MariaDB status
systemctl status mariadb

# 2. Start MariaDB
systemctl start mariadb

# 3. Verify koneksi
mysql -u root -p -h localhost -e "SELECT 1;"

# 4. Check application.yml credentials
grep -A 5 "datasource:" src/main/resources/application.yml
```

### ❌ Port Already in Use

**Port 4000 (Backend):**
```bash
# macOS/Linux
lsof -i :4000
kill -9 <PID>

# Windows
netstat -ano | findstr :4000
taskkill /PID <PID> /F
```

**Port 5173 (Frontend):**
```bash
lsof -i :5173
kill -9 <PID>

# Atau run di port lain
npm run dev -- --port 5174
```

### ❌ Build Fails: "Cannot find symbol"
```bash
# Clean dan rebuild
mvn clean compile
mvn clean install -U

# Check Java version
java -version  # Should be 21+
```

### ❌ API Request Failed (CORS Error)

**Frontend Console Error:**
```
Access to XMLHttpRequest at 'http://localhost:4000/...' from origin 
'http://localhost:5173' has been blocked by CORS policy
```

**Solusi:**

Backend harus enable CORS. Check `src/main/java/com/inventorilab/security/`:
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:5173")
            .allowedMethods("*")
            .allowedHeaders("*")
            .allowCredentials(true);
    }
}
```

### ❌ Token Expired / Not Authenticated

**Solusi:**
```javascript
// Clear token dan login ulang
localStorage.removeItem('token');
// Refresh halaman
window.location.reload();
```

### ❌ Styling Issues (Tailwind CSS)

```bash
# Rebuild Tailwind
npm run build

# Check tailwind.config.ts
cat tailwind.config.ts

# Restart dev server
npm run dev
```

---

## 📊 Project Structure Summary

```
/home/youtta/Projects/01/
├── BE-Java-mvn-spring-boot/        # Backend (Java/Spring Boot)
│   ├── src/main/
│   │   ├── java/com/inventorilab/  # Source code
│   │   └── resources/              # Config files
│   ├── pom.xml                     # Maven dependencies
│   └── README.md                   # Backend docs
│
├── frontend-baru/                   # Frontend (Vue 3)
│   ├── src/                        # Source code
│   ├── public/                     # Static files
│   ├── package.json                # npm dependencies
│   └── README.md                   # Frontend docs
│
└── SETUP.md                        # This file
```

---

## 📈 Next Steps

### After Successful Setup

1. **Create Sample Data**
   - Register beberapa user dengan role berbeda
   - Create kategori barang
   - Add sample barang

2. **Test All Features**
   - Run through E2E scenarios
   - Test error handling
   - Check permissions per role

3. **Performance Testing**
   - Load test API
   - Frontend performance audit
   - Database query optimization

4. **Security Hardening**
   - Change JWT secret key
   - Update password hashing
   - Enable HTTPS in production
   - Implement rate limiting

---

## 📞 Support & Resources

### Documentation
- Backend: `BE-Java-mvn-spring-boot/README.md`
- Frontend: `frontend-baru/README.md`

### External Resources
- [Spring Boot Docs](https://spring.io/projects/spring-boot)
- [Vue 3 Guide](https://vuejs.org/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Docs](https://tailwindcss.com/)
- [MariaDB Docs](https://mariadb.com/kb/)

### Common Commands Reference

**Backend:**
```bash
# Build
mvn clean install

# Run dev
mvn spring-boot:run

# Run tests
mvn test

# Build JAR
mvn clean package
```

**Frontend:**
```bash
# Install deps
npm install

# Dev server
npm run dev

# Build
npm run build

# Preview
npm run preview
```

---

## ✅ Checklist Sebelum Production

- [ ] Database created & accessible
- [ ] Backend builds successfully
- [ ] Backend unit tests pass
- [ ] Frontend builds successfully
- [ ] E2E testing completed
- [ ] Environment variables set
- [ ] SSL/HTTPS configured
- [ ] JWT secret key changed
- [ ] Database backups configured
- [ ] Logging configured
- [ ] Error monitoring setup
- [ ] Documentation updated

---

**Last Updated:** 31 Mei 2024  
**Version:** 1.0  
**Status:** Production Ready ✅
