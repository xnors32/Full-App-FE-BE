# 📚 Sistem Inventaris Laboratorium

Aplikasi web lengkap untuk manajemen inventaris barang laboratorium dengan fitur peminjaman, pengembalian, dan laporan.

**Status:** ✅ Production Ready  
**Last Updated:** 31 Mei 2024

---

## 🎯 Quick Start

### Prerequisites
```bash
# Verify installed
java -version       # Java 21+
mvn -version        # Maven 3.8+
node --version      # Node 18+
npm --version       # npm 10+
mysql --version     # MariaDB
```

### 1️⃣ Setup Database
```bash
mysql -u root -p
# Password: alif

CREATE DATABASE inventori_lab CHARACTER SET utf8mb4;
```

### 2️⃣ Run Backend
```bash
cd BE-Java-mvn-spring-boot
mvn spring-boot:run
# Listening on http://localhost:4000
```

### 3️⃣ Run Frontend (in new terminal)
```bash
cd frontend-baru
npm install
npm run dev
# Open http://localhost:5173
```

---

## 📁 Project Structure

```
/Projects/01/
├── BE-Java-mvn-spring-boot/      # Backend API (Java/Spring Boot)
│   ├── README.md                 # Detailed backend docs
│   ├── src/main/
│   │   ├── java/com/inventorilab/
│   │   └── resources/
│   └── pom.xml                   # Maven config
│
├── frontend-baru/                 # Frontend (Vue 3)
│   ├── README.md                 # Detailed frontend docs
│   ├── src/
│   ├── package.json              # npm config
│   └── vite.config.ts
│
├── SETUP.md                      # Complete setup guide
└── README.md                     # This file
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Client Browser                           │
│             (Vue 3 + TypeScript + Tailwind)                │
│                  localhost:5173                             │
└──────────────────────────┬──────────────────────────────────┘
                           │
                    HTTP/REST (Axios)
                           │
┌──────────────────────────▼──────────────────────────────────┐
│              Spring Boot API Server                         │
│                  localhost:4000                             │
│      (Authentication, Business Logic, Validation)           │
└──────────────────────────┬──────────────────────────────────┘
                           │
                       JDBC (JPA)
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                    MariaDB Database                         │
│              (inventori_lab schema)                         │
└─────────────────────────────────────────────────────────────┘
```

---

## ✨ Key Features

### 🔐 Authentication & Authorization
- User registration & login
- JWT token-based auth
- Role-based access (MAHASISWA, PETUGAS, ADMIN)
- Auto logout on token expiry

### 📦 Inventory Management
- Add, edit, delete barang
- Kategori management
- Real-time stock tracking
- Detailed barang information (kode, harga, lokasi)

### 📋 Loan Management
- Create peminjaman request
- Approval workflow (Petugas/Admin)
- Pengembalian dengan kondisi tracking
- Full history & audit trail

### 📊 Reporting
- Stock reports
- Peminjaman analytics
- Pengembalian tracking

### 🎨 User Experience
- Dark/Light theme
- Responsive design
- Intuitive UI
- Real-time updates

---

## 🛠️ Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| **Frontend** | Vue 3 | 3.5.34 |
| **Frontend** | TypeScript | 6.0 |
| **Frontend** | Vite | 8.0 |
| **Frontend** | Tailwind CSS | 4.3 |
| **Backend** | Java | 21 |
| **Backend** | Spring Boot | 3.2.5 |
| **Backend** | Spring Security | 3.2.5 |
| **Backend** | Spring Data JPA | 3.2.5 |
| **Database** | MariaDB | Latest |
| **Security** | JWT (JJWT) | 0.11.5 |
| **Build** | Maven | 3.8+ |
| **Build** | npm | 10+ |

---

## 📚 Documentation

### Full Guides
- **[SETUP.md](./SETUP.md)** - Complete step-by-step setup guide
- **[Backend README](./BE-Java-mvn-spring-boot/README.md)** - API docs, endpoints, configuration
- **[Frontend README](./frontend-baru/README.md)** - Components, state management, styling

### Quick Commands

**Backend:**
```bash
cd BE-Java-mvn-spring-boot

mvn clean install          # Build
mvn spring-boot:run        # Dev server
mvn test                   # Run tests
mvn clean package          # Production build
java -jar target/*.jar     # Run JAR
```

**Frontend:**
```bash
cd frontend-baru

npm install                # Install deps
npm run dev                # Dev server
npm run build              # Production build
npm run preview            # Preview prod build
```

---

## 🚀 Development Workflow

### 1. Backend Development
```bash
# Terminal 1
cd BE-Java-mvn-spring-boot
mvn spring-boot:run

# Runs on http://localhost:4000
# Auto-reload with file changes
```

### 2. Frontend Development
```bash
# Terminal 2
cd frontend-baru
npm run dev

# Runs on http://localhost:5173
# Hot Module Replacement (HMR) enabled
```

### 3. Database
```bash
# Terminal 3 (optional - for monitoring)
mysql -u root -p inventori_lab
mysql> SHOW TABLES;
```

---

## 🧪 Testing

### Backend Tests
```bash
cd BE-Java-mvn-spring-boot
mvn test                    # Run all tests
mvn test -Dtest=ClassName  # Run specific test
```

### Frontend E2E
```bash
cd frontend-baru
# Manually test in browser:
# 1. Register user
# 2. Login
# 3. Create barang
# 4. Create peminjaman
# 5. Approve/return
```

---

## 🌐 API Endpoints

### Auth
```
POST   /api/auth/register    - Register user
POST   /api/auth/login       - Login & get token
```

### Barang
```
GET    /api/barang           - List barang (paginated)
GET    /api/barang/{id}      - Get detail
POST   /api/barang           - Create barang
PUT    /api/barang/{id}      - Update barang
DELETE /api/barang/{id}      - Delete barang
```

### Peminjaman
```
GET    /api/peminjaman                 - List peminjaman
GET    /api/peminjaman/{id}            - Get detail
POST   /api/peminjaman                 - Create peminjaman
PUT    /api/peminjaman/{id}/approve    - Approve
PUT    /api/peminjaman/{id}/reject     - Reject
PUT    /api/peminjaman/{id}/return     - Return items
```

### Complete list in [Backend README](./BE-Java-mvn-spring-boot/README.md#-api-endpoints)

---

## 🔒 Security

- JWT token authentication (24h expiry)
- Spring Security integration
- CORS configured for localhost:5173
- Password hashing
- Role-based access control

**For production:**
- Update JWT secret key
- Enable HTTPS/SSL
- Implement rate limiting
- Set secure cookie flags
- Add monitoring & logging

---

## 🐛 Troubleshooting

### Common Issues

**Backend won't start:**
```bash
# Check Java version
java -version  # Should be 21+

# Check database connection
mysql -u root -p -e "SELECT 1;"

# Clean rebuild
mvn clean compile
```

**Frontend won't load:**
```bash
# Check Node version
node --version  # Should be 18+

# Reinstall deps
rm -rf node_modules package-lock.json
npm install

# Check port
lsof -i :5173
```

**CORS error:**
- Backend must be running
- Check both ports (4000 & 5173)
- Clear browser cache

**Token errors:**
- Token valid for 24h
- Login again for new token
- Clear localStorage if needed

See **[SETUP.md](./SETUP.md#-troubleshooting)** for more solutions

---

## 📦 Production Deployment

### Backend JAR
```bash
cd BE-Java-mvn-spring-boot
mvn clean package
java -jar target/*.jar
```

### Frontend Static Files
```bash
cd frontend-baru
npm run build
# Deploy dist/ folder to web server
```

### Docker (Optional)
- Backend: Dockerfile provided in backend dir
- Frontend: See SETUP.md for Docker example

---

## 📊 Database Schema

### Main Tables
- **users** - User accounts & roles
- **kategori** - Item categories
- **barang** - Inventory items
- **peminjaman** - Loan requests
- **detail_peminjaman** - Loan item details

### Relationships
```
Users ──┐
        ├─→ Peminjaman ──→ DetailPeminjaman ──→ Barang
        │
        └─→ Kategori ──────────┘
```

---

## 🎓 Learning Resources

### Recommended Reading Order
1. This README (overview)
2. [SETUP.md](./SETUP.md) (detailed setup)
3. [Backend README](./BE-Java-mvn-spring-boot/README.md) (API)
4. [Frontend README](./frontend-baru/README.md) (UI)
5. Source code in `src/` directories

### External Docs
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Vue 3](https://vuejs.org/)
- [TypeScript](https://www.typescriptlang.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [MariaDB](https://mariadb.com/kb/)

---

## 📝 Project Info

- **Type:** Full-stack web application
- **Purpose:** Laboratory inventory management system
- **Academic:** Software Engineering Course Assignment
- **Team:** Development Team
- **Status:** ✅ Production Ready
- **Version:** 1.0
- **License:** Proprietary

---

## ✅ Checklist

- [x] Backend API complete
- [x] Frontend UI complete
- [x] Database schema ready
- [x] Authentication working
- [x] All features tested
- [x] Documentation complete
- [x] Build process verified
- [ ] Production deployment (manual step)
- [ ] Setup HTTPS/SSL
- [ ] Configure monitoring

---

## 📞 Getting Help

1. **Check documentation:**
   - [SETUP.md](./SETUP.md) - Setup issues
   - [Backend README](./BE-Java-mvn-spring-boot/README.md) - API issues
   - [Frontend README](./frontend-baru/README.md) - UI issues

2. **Check logs:**
   - Backend: Terminal output from `mvn spring-boot:run`
   - Frontend: Browser DevTools Console
   - Database: `mysql -u root -p`

3. **Contact support:** Reach out to development team

---

**Created:** 31 Mei 2024  
**Last Modified:** 31 Mei 2024  
**Ready for Production:** ✅ Yes

Start with [SETUP.md](./SETUP.md) to get up and running!
