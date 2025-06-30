# 📚 Library Management System - JSP/Servlet Project

A web-based **Library Management System** built using **JSP**, **Servlets**, **AJAX**, and **MySQL**. This system allows students to reserve and return books online, while administrators can manage reservations, update book statuses, and monitor activity via a dashboard.

---

## 💻 Tech Stack

- **Frontend:** HTML5, CSS3, Bootstrap, JavaScript
- **Backend:** Java (JSP + Servlets), JDBC
- **Database:** MySQL (PHPMyAdmin)
- **Server:** Apache Tomcat (Jakarta EE)
- **AJAX + JSON**: For live search (admin)

---

## 👤 User Features

- Register and login securely
- Browse and search books (basic search)
- Reserve  books
- View reservation history

---

## 🛠 Admin Features

- Login to a secure admin panel
- View all books and reservations
- Perform **live search** for books using AJAX and JSON
- Update book status (Available / Reserved / Pending)
- Add new users (admin-only)
- View dashboard with real-time stats:
  - 📦 Total Books
  - 👥 Total Users
  - 📖 Total Reservations
  - 📖 Available Books

---

## 🌟 Special Features Implemented

- ✅ **Live Search** for books in the admin panel (AJAX + JSON)
- ✅ **Dashboard Cards** dynamically reflect current database status
- ✅ Clean page navigation added between most major sections
- ✅ Modular DAO and MVC pattern for separation of concerns
- ✅ Distinct role-based views (Admin vs User)
- ✅ User can Reserve books availabale in the library

---

## ⚠️ Known Issues (To Be Fixed)

- ❌ Admin cannot remove users (only add is supported)
- ❌ Some JSP pages have **poor or inconsistent navigation**
- ❌ No client-side validation or alert messages on certain forms
- ❌ Book list lacks pagination and advanced filters
- ❌ UI responsiveness on smaller screens needs improvement
- ❌Only admin can update book status 

- ⚙️These are identified for future enhancement and will be addressed in upcoming updates.

📌 **This is my second project. Some parts are complete, some need polish. I learned a lot building it, and I’ll improve it over time.**

---

## ▶️ How to Run the Project

1. 📥 Clone or download the repository
2. 🧠 Import into **IntelliJ IDEA** or **NetBeans**
3. 🛢 Set up MySQL and import `library_db.sql` from `database/` folder
4. ⚙️ Configure database credentials in DAO files
5. 🚀 Deploy the project on **Apache Tomcat**
6. 🔗 Access it at: `http://localhost:8080/LibraryManagementSystem/`

---

## 🚀 Future Improvements

- Implement **user deletion** (admin side)
- Add **email notifications** for due dates and reminders
- Improve **form validation and error messages**
- Add **pagination** and **filtering options** in book lists
- Enhance **mobile responsiveness** with better layout handling

---

## 📸 Screenshots

_screenshots of the admin dashboard, live search, reservation history, login pages

---

## 👨‍💻 Author

Developed by: Osagani  
GitHub: Osagani31  
Contact: osaganiperera123@gmail.com

---

