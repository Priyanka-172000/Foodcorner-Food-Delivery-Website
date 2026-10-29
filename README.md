# Foodcorner – Food Delivery Website

Foodcorner is a full-stack food delivery web application built using Java, JSP, Jakarta Servlets, JDBC, MySQL, HTML, CSS, and JavaScript.

The application allows customers to browse restaurants, explore menus, manage their shopping cart, place orders, make test payments through PayU Hosted Checkout, view order history, check order status, and manage their profiles. It also includes an admin panel for managing restaurants, menu items, customers, and orders.

## Features

### Customer Module
- User registration and login
- Browse restaurants and explore menus
- Add food items to the cart
- Increase or decrease item quantities
- Remove items from the cart
- Checkout and place orders
- Choose an available payment method
- PayU Hosted Checkout integration in test mode
- View payment status and order results
- View order history and order details
- Cancel pending orders
- Edit customer profile
- Logout

### Admin Module
- Admin dashboard
- Add, edit, enable, disable, and delete restaurants
- Manage restaurant menu items
- Add, edit, enable, disable, and delete menu items
- View customer details
- View customer orders
- Manage restaurant and menu information

## Homepage and Hero Section

The homepage features a looping food video designed to create a modern food delivery experience.

The hero video supports:
- Automatic playback
- Muted audio
- Continuous looping
- Responsive display
- A visual overlay
- A call-to-action button

The homepage also includes Foodcorner branding, navigation, restaurant exploration, feature sections, promotional content, and a footer.

## Technologies Used

| Category | Technologies |
|---|---|
| Backend | Java, Jakarta Servlets, JSP |
| Frontend | HTML5, CSS3, JavaScript |
| Database | MySQL 8.0 |
| Database connectivity | JDBC |
| Architecture | DAO Design Pattern |
| Payment gateway | PayU Hosted Checkout (test mode) |
| Web server | Apache Tomcat 10.1 |
| Build tool | Apache Maven |
| IDE | Eclipse IDE |
| Version control | Git and GitHub |

## Project Architecture

Foodcorner follows a layered architecture that separates the presentation, request-handling, database-access, and persistence responsibilities.

```text
Frontend
HTML / CSS / JavaScript / JSP
             ↓
Servlet Controllers
             ↓
DAO Interfaces
             ↓
DAO Implementations
             ↓
JDBC
             ↓
MySQL Database
```

PayU payment processing is integrated into the checkout flow to handle the hosted payment request and the payment response.

## Project Structure

```text
Foodcorner/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/tap/
│       │       ├── controller/
│       │       ├── Dao/
│       │       ├── DaoImpl/
│       │       ├── model/
│       │       └── util/
│       └── webapp/
│           ├── images/
│           │   ├── menu/
│           │   └── restaurants/
│           ├── videos/
│           │   └── foodcorner_hero.mp4
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
├── pom.xml
├── .gitignore
└── README.md
```

## Database Design

The application uses MySQL to store customer accounts, restaurant details, menu items, orders, and order items.

### Main Tables

- **user** – Stores customer and admin account information.
- **restaurant** – Stores restaurant names, cuisine, delivery time, address, rating, status, and image paths.
- **menu** – Stores food item names, descriptions, prices, availability, image paths, and restaurant IDs.
- **orders** – Stores customer order details, order date, total amount, order status, payment mode, delivery address, and payment information.
- **order_item** – Stores individual food items associated with each order, including quantities and amounts.

The `orders` table also supports payment-related information such as payment status and the PayU transaction ID.

## Cart System

The shopping cart is maintained using the HTTP session.

Customers can:
- Add food items to the cart
- Increase or decrease quantities
- Remove items
- View item prices and the cart total
- Continue to checkout

## Order Management

The application supports order placement, order history, order details, and cancellation of pending orders.

The order status flow is:

```text
PENDING
   ↓
CONFIRMED
   ↓
DELIVERED
```

Customers can cancel an order while it is in the `PENDING` state. Cancelled orders retain the `CANCELLED` status.

## PayU Payment Integration

Foodcorner integrates **PayU Hosted Checkout in test mode** for online payment processing.

The integration includes:
- Preparing the payment request
- Generating the required PayU hash
- Redirecting customers to the PayU hosted payment page
- Handling the payment response
- Recording payment-related information against the order

### Payment Configuration

The PayU integration uses environment variables configured in the Tomcat run configuration:

```text
PAYU_KEY=your_test_merchant_key
PAYU_SALT=your_test_merchant_salt
PAYU_ENV=test
```

Use your own PayU test credentials. Never commit merchant salts, API secrets, database passwords, or other sensitive credentials to a public repository.

**Important:** The current integration is for testing. Live payments require the appropriate production credentials, configuration, and end-to-end verification before deployment.

## Restaurant and Menu Images

Foodcorner uses local image files stored in the project.

Restaurant images:

```text
src/main/webapp/images/restaurants/
```

Menu images:

```text
src/main/webapp/images/menu/
```

The database stores the image paths used by the application.

Example:

```text
images/menu/menu_01_masala_dosa.png
```

## How to Run the Project

### 1. Clone the Repository

```bash
git clone https://github.com/Priyanka-172000/Foodcorner-Food-Delivery-Website.git
```

### 2. Import into Eclipse

Import the project into Eclipse as a Maven project. Ensure the required Maven dependencies are downloaded and the project builds successfully.

### 3. Configure Apache Tomcat

Configure Apache Tomcat 10.1 in Eclipse and add the Foodcorner project to the server.

### 4. Configure MySQL

Create the database:

```sql
CREATE DATABASE foodcorner;
```

Import or create the required database tables and data before running the application.

### 5. Configure the JDBC Connection

Update the database connection settings in the JDBC utility class to match your local MySQL installation.

Example:

```java
String url = "jdbc:mysql://localhost:3306/foodcorner";
String username = "root";
String password = "YOUR_MYSQL_PASSWORD";
```

Keep actual database credentials private. Do not commit passwords to GitHub.

### 6. Configure PayU (Optional)

To test online payments, configure the PayU test credentials in the Tomcat environment variables as described in the PayU Payment Integration section.

Do not use real banking credentials on the test payment page.

### 7. Run the Application

Start the Tomcat server and open:

```text
http://localhost:8080/Foodcorner/
```

The context path may differ depending on the project configuration in Eclipse.

## Main Application Flow

```text
Home Page
    ↓
Login / Registration
    ↓
Browse Restaurants
    ↓
View Restaurant Menu
    ↓
Add Items to Cart
    ↓
Checkout
    ↓
Select Payment Method
    ↓
Place Order / PayU Test Checkout
    ↓
Payment Result / Order Success
    ↓
Order History and Order Details
```

## Admin Workflow

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
View and Manage Orders
```

## Project Highlights

- Full-stack Java web application
- JSP and Jakarta Servlet architecture
- DAO design pattern
- JDBC and MySQL integration
- Session-based shopping cart
- Customer and admin modules
- Restaurant and menu management
- Order placement and order history
- PayU Hosted Checkout integration in test mode
- Local restaurant and menu images
- Responsive food delivery interface
- Looping homepage hero video
- Git and GitHub version control

## Future Enhancements

- Production payment gateway activation and deployment
- Restaurant search and cuisine filters
- Customer ratings and reviews
- Wishlist functionality
- Email order confirmations
- OTP-based authentication
- Delivery partner module
- Live delivery tracking
- Spring Boot migration
- REST API integration
- React frontend
- Cloud deployment

## Author

**Priyanka Deshnur**

MCA Student | Aspiring Full Stack Java Developer

- **GitHub:** https://github.com/Priyanka-172000
- **Portfolio:** https://priyanka-portfolio-sigma.vercel.app/

## Repository

[Foodcorner – Food Delivery Website](https://github.com/Priyanka-172000/Foodcorner-Food-Delivery-Website)

## Project Usage

This project was developed for educational, learning, and portfolio purposes.

If you are interested in the project, would like to discuss its implementation, or want to collaborate, feel free to connect through GitHub or LinkedIn.
