# Foodcorner – Food Delivery Website

Foodcorner is a full-stack food delivery web application developed using Java, JSP, Servlets, JDBC, MySQL, HTML, CSS, and JavaScript.

The application allows users to browse restaurants, explore menus, add food items to a cart, place orders, view order history, manage their profile, and track order status. It also includes an admin panel for managing restaurants, menu items, customers, and orders.

## Features

### Customer Module
- User Registration and Login
- Browse Restaurants
- View Restaurant Menus
- Add Items to Cart
- Update Cart Quantity
- Remove Items from Cart
- Checkout and Place Orders
- View Order History
- View Order Details
- Cancel Pending Orders
- Edit User Profile
- Logout

### Admin Module
- Admin Dashboard
- Add Restaurants
- Edit Restaurants
- Enable or Disable Restaurants
- Delete Restaurants
- Manage Menu Items
- Add Menu Items
- Edit Menu Items
- Enable or Disable Menu Availability
- Delete Menu Items
- View Customer Details
- View Orders

## Hero Section

The homepage includes a professional looping food video in the hero section.

The video is:
- Auto-played
- Muted
- Looped continuously
- Responsive
- Displayed with an overlay and call-to-action button

This creates a modern food delivery website experience.

## Technologies Used

### Backend
- Java
- Jakarta Servlets
- JSP
- JDBC
- DAO Design Pattern

### Frontend
- HTML5
- CSS3
- JavaScript
- JSP

### Database
- MySQL 8.0

### Server
- Apache Tomcat 10.1

### Build Tool
- Maven

### IDE
- Eclipse IDE

### Version Control
- Git
- GitHub

## Project Architecture

The application follows a layered architecture:

```text
Frontend
HTML / CSS / JavaScript / JSP
        ↓
Servlet Controllers
        ↓
DAO Layer
        ↓
DAO Implementation
        ↓
JDBC
        ↓
MySQL Database
```

## Project Structure

```text
Foodcorner
│
├── src
│   └── main
│       ├── java
│       │   └── com.tap
│       │       ├── controller
│       │       ├── Dao
│       │       ├── DaoImpl
│       │       ├── model
│       │       └── util
│       │
│       └── webapp
│           ├── images
│           │   ├── menu
│           │   └── restaurants
│           │
│           ├── videos
│           │   └── foodcorner_hero.mp4
│           │
│           ├── index.html
│           ├── restaurant.jsp
│           ├── menu.jsp
│           ├── cart.jsp
│           ├── checkout.jsp
│           ├── orderSuccess.jsp
│           ├── myOrders.jsp
│           ├── orderDetails.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── editProfile.jsp
│           ├── adminDashboard.jsp
│           ├── adminRestaurants.jsp
│           ├── adminMenus.jsp
│           ├── adminOrders.jsp
│           └── adminCustomers.jsp
│
├── pom.xml
├── .gitignore
└── README.md
```

## Database Tables

The project uses the following major tables:

```text
user
restaurant
menu
orders
order_item
```

### User Table
Stores customer and admin account details.

### Restaurant Table
Stores restaurant information including:
- Restaurant name
- Cuisine
- Delivery time
- Address
- Rating
- Status
- Restaurant image

### Menu Table
Stores menu items including:
- Item name
- Description
- Price
- Availability
- Menu image
- Restaurant ID

### Orders Table
Stores customer order information including:
- User ID
- Restaurant ID
- Order date
- Total amount
- Payment mode
- Order status

### Order Item Table
Stores individual food items associated with each order.

## Order Status Flow

Foodcorner automatically manages order status based on order timing.

```text
PENDING
   ↓
CONFIRMED
   ↓
DELIVERED
```

Customers can cancel an order while it is still in the `PENDING` state.

Cancelled orders remain:

```text
CANCELLED
```

## Cart System

The shopping cart is maintained using HTTP Session.

The cart allows users to:
- Add products
- Increase quantity
- Decrease quantity
- Remove products
- View cart total
- Continue to checkout

## Restaurant and Menu Images

Foodcorner uses local images stored inside the project.

Restaurant images:

```text
src/main/webapp/images/restaurants/
```

Menu images:

```text
src/main/webapp/images/menu/
```

Image paths are stored in the MySQL database.

Example:

```text
images/menu/menu_01_masala_dosa.png
```

## Home Page

The homepage includes:

- Transparent navigation bar
- Looping food hero video
- Foodcorner branding
- Explore Restaurants button
- Food delivery introduction
- Feature cards
- Call-to-action section
- Footer

## How to Run the Project

### 1. Clone the Repository

```bash
git clone https://github.com/Priyanka-172000/Foodcorner-Food-Delivery-Website.git
```

### 2. Open the Project

Import the project into Eclipse as a Maven or Dynamic Web Project.

### 3. Configure Apache Tomcat

Use:

```text
Apache Tomcat 10.1
```

Add the Foodcorner project to the Tomcat server.

### 4. Configure MySQL

Create the database:

```sql
CREATE DATABASE foodcorner;
```

Import the required database tables and data.

### 5. Configure JDBC

Update the database connection details in the JDBC utility class.

Example:

```java
String url = "jdbc:mysql://localhost:3306/foodcorner";
String username = "root";
String password = "YOUR_MYSQL_PASSWORD";
```

Do not upload your actual database password publicly.

### 6. Run the Project

Start Apache Tomcat and open:

```text
http://localhost:8080/Foodcorner/
```

## Main Application Flow

```text
Home Page
   ↓
Login / Register
   ↓
Restaurants
   ↓
Restaurant Menu
   ↓
Add to Cart
   ↓
Checkout
   ↓
Place Order
   ↓
Order Success
   ↓
Order History
```

## Admin Flow

```text
Admin Login
   ↓
Admin Dashboard
   ↓
Manage Restaurants
   ↓
Manage Menus
   ↓
View Customers
   ↓
View Orders
```

## Highlights

- Full-stack Java web application
- JSP and Servlet based architecture
- DAO design pattern
- JDBC database integration
- MySQL relational database
- Session-based shopping cart
- Customer and admin modules
- Order management
- Restaurant management
- Menu management
- Local image integration
- Responsive food delivery UI
- Auto-playing looping hero video
- Git and GitHub version control

## Future Enhancements

Possible future improvements include:

- Online payment gateway integration
- Order tracking
- Restaurant search
- Cuisine filters
- Ratings and reviews
- Wishlist functionality
- Email order confirmation
- OTP authentication
- Delivery partner module
- Spring Boot migration
- REST API integration
- React frontend
- Cloud deployment

## Author

**Priyanka Deshnur**

MCA Student  
Full Stack Java Developer

### GitHub
https://github.com/Priyanka-172000

### Portfolio
https://priyanka-portfolio-sigma.vercel.app/

## Repository

Foodcorner – Food Delivery Website

https://github.com/Priyanka-172000/Foodcorner-Food-Delivery-Website

## License

This project is created for educational and portfolio purposes.
