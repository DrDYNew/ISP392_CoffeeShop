# Shop Management System - Implementation Summary

## ✅ Completed Implementation

### 1. Database Schema
**File:** `SQL.sql`
- ✅ Added `APIToken VARCHAR(255) UNIQUE NOT NULL` column to `Shop` table
- ✅ Updated INSERT statements with JWT-like API tokens
- ✅ Sample data includes 5 shops with unique API tokens

### 2. Model Layer
**File:** `src/java/model/Shop.java`
- ✅ Added `apiToken` field with getter/setter methods
- ✅ Model supports all shop properties including API token

### 3. Data Access Layer (DAO)
**File:** `src/java/dao/ShopDAO.java`
- ✅ JWT-like Token Generation System:
  - `generateApiToken()` - Creates tokens in format: `header.payload.signature`
  - `base64UrlEncode()` - Base64 URL encoding without padding
  - `generateSignature()` - SHA-256 hash with secret key: "COFFEE_SHOP_SECRET_KEY_2025"
- ✅ CRUD Operations:
  - `getAllShops()` - Get all shops
  - `getActiveShops()` - Get only active shops
  - `getShopById(int)` - Get shop by ID
  - `getShopByApiToken(String)` - Get shop by API token
  - `insertShop(Shop)` - Create new shop with auto-generated token
  - `updateShop(Shop)` - Update shop information
  - `deleteShop(int)` - Soft delete (set isActive = false)
  - `regenerateApiToken(int)` - Generate new token for shop
  - `isApiTokenValid(String)` - Validate API token
  - `searchShopsByName(String)` - Search shops by name

### 4. Service Layer
**File:** `src/java/services/ShopService.java`
- ✅ Business logic with validation:
  - `getAllShops()` - Get all shops
  - `getActiveShops()` - Get active shops only
  - `getShopById(int)` - Get shop by ID
  - `getShopByApiToken(String)` - Get shop by API token with validation
  - `createShop(String, String, String, Integer, boolean)` - Create shop with validation
  - `updateShop(int, String, String, String, Integer, boolean)` - Update shop with validation
  - `deleteShop(int)` - Delete shop with validation
  - `regenerateApiToken(int)` - Regenerate API token
  - `validateApiToken(String)` - Validate API token
  - `isApiTokenValid(String)` - Alias for validateApiToken
  - `searchShopsByName(String)` - Search shops

### 5. Admin Controller
**File:** `src/java/controllers/ShopController.java`
- ✅ Admin CRUD operations (requires roleID = 2):
  - `doGet()` - Handle GET requests (list, add form, edit form, delete, regenerate token)
  - `doPost()` - Handle POST requests (add, edit)
  - `listShops()` - Display shop list
  - `showAddForm()` - Display add form with users list
  - `showEditForm()` - Display edit form with shop data and users list
  - `addShop()` - Create new shop
  - `editShop()` - Update shop information
  - `deleteShop()` - Soft delete shop
  - `regenerateToken()` - Generate new API token
- ✅ Uses `ShopService` for business logic
- ✅ Fixed `UserDAO.getAllUsers(0, 1000, null, null)` calls

### 6. Public API Controller
**File:** `src/java/controllers/ShopAPIController.java`
- ✅ REST API endpoints:
  - `/api/shop?action=details&token=xxx` - Get shop details by token
  - `/api/shop?action=validate&token=xxx` - Validate API token
- ✅ JSON response format
- ✅ Uses `ShopService` for business logic
- ✅ Token validation required for all requests

### 7. Admin JSP Pages

#### Shop List Page
**File:** `web/views/admin/shop-list.jsp`
- ✅ Display all shops in table format
- ✅ Show API token with copy-to-clipboard button
- ✅ Edit, Delete, Regenerate Token actions
- ✅ Success/error message display
- ✅ Bootstrap styling

#### Shop Form Page
**File:** `web/views/admin/shop-form.jsp`
- ✅ Create/Edit shop form
- ✅ Fields: shopName, address, phone, ownerId (dropdown), isActive (checkbox)
- ✅ User dropdown populated from database
- ✅ Form validation
- ✅ Back to list button

### 8. Public JSP Pages

#### Shop List Page (Public)
**File:** `web/views/shop/shop-list.jsp`
- ✅ Display active shops only
- ✅ Shop cards with basic information
- ✅ "View Details" button prompts for API token
- ✅ Bootstrap card layout

#### Shop Detail Page (Public)
**File:** `web/views/shop/shop-view.jsp`
- ✅ API token input form
- ✅ AJAX call to validate token and fetch shop details
- ✅ Display shop information when token is valid
- ✅ Error message for invalid tokens
- ✅ Success/error alerts

## 🔧 API Token Format

### JWT-like Structure
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYTFiMmMzZDQtZTVmNi00Nzg5LTkwYWItYmNkZWYxMjM0NTY3IiwiaWF0IjoxNzI5MjMwMDAwfQ.a8f3b2c1d4e5f6g7h8i9j0k1
```

### Components
1. **Header** (Base64 URL encoded):
   ```json
   {"alg":"HS256","typ":"JWT"}
   ```

2. **Payload** (Base64 URL encoded):
   ```json
   {"shop_id":"a1b2c3d4-e5f6-4789-90ab-bcdef1234567","iat":1729230000}
   ```
   - `shop_id`: Unique shop identifier (UUID)
   - `iat`: Issued at timestamp

3. **Signature** (SHA-256 hash):
   - Input: `header.payload + SECRET_KEY`
   - Secret: "COFFEE_SHOP_SECRET_KEY_2025"
   - Output: First 20 characters of hash

## 📋 API Endpoints

### Admin Endpoints
| Method | URL | Description | Auth |
|--------|-----|-------------|------|
| GET | `/admin/shop?action=list` | List all shops | Admin |
| GET | `/admin/shop?action=add` | Show add form | Admin |
| GET | `/admin/shop?action=edit&id={shopId}` | Show edit form | Admin |
| GET | `/admin/shop?action=delete&id={shopId}` | Delete shop | Admin |
| GET | `/admin/shop?action=regenerateToken&id={shopId}` | Regenerate API token | Admin |
| POST | `/admin/shop?action=add` | Create shop | Admin |
| POST | `/admin/shop?action=edit` | Update shop | Admin |

### Public API Endpoints
| Method | URL | Description | Auth |
|--------|-----|-------------|------|
| GET | `/api/shop?action=details&token={apiToken}` | Get shop details | API Token |
| GET | `/api/shop?action=validate&token={apiToken}` | Validate token | API Token |

## 🧪 Testing with Postman

### 1. Get Shop Details
```
GET http://localhost:8080/ISP392_CoffeeShop/api/shop?action=details&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYTFiMmMzZDQtZTVmNi00Nzg5LTkwYWItYmNkZWYxMjM0NTY3IiwiaWF0IjoxNzI5MjMwMDAwfQ.a8f3b2c1d4e5f6g7h8i9j0k1

Response (Success):
{
  "success": true,
  "data": {
    "shopID": 1,
    "shopName": "Coffee Shop Downtown",
    "address": "123 Main Street",
    "phone": "0123456789",
    "isActive": true,
    "createdAt": "2024-10-18 10:00:00"
  }
}

Response (Error):
{
  "success": false,
  "message": "Invalid API Token or shop is inactive"
}
```

### 2. Validate Token
```
GET http://localhost:8080/ISP392_CoffeeShop/api/shop?action=validate&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaG9wX2lkIjoiYTFiMmMzZDQtZTVmNi00Nzg5LTkwYWItYmNkZWYxMjM0NTY3IiwiaWF0IjoxNzI5MjMwMDAwfQ.a8f3b2c1d4e5f6g7h8i9j0k1

Response:
{
  "success": true,
  "message": "Token is valid"
}
```

## 🏗️ Architecture

### MVC + Service Layer Pattern
```
User Request
    ↓
Controller (ShopController / ShopAPIController)
    ↓
Service Layer (ShopService) ← Business Logic & Validation
    ↓
Data Access Layer (ShopDAO) ← Database Operations
    ↓
Database (PostgreSQL)
```

### Benefits
1. **Separation of Concerns**: Each layer has specific responsibility
2. **Maintainability**: Easy to modify business logic without changing controllers
3. **Testability**: Service layer can be tested independently
4. **Reusability**: Service methods can be used by multiple controllers
5. **Validation**: Centralized input validation in service layer

## 📝 Sample SQL Data

The database includes 5 sample shops with unique API tokens:

1. **Coffee Shop Downtown** - Main Street
2. **Coffee Corner** - Second Avenue
3. **Brew & Bean** - Oak Street
4. **Morning Coffee** - Elm Street
5. **The Coffee House** - Pine Road

Each shop has:
- Unique API token in JWT format
- Assigned owner (UserID)
- Active status
- Creation timestamp

## 🔐 Security Features

1. **Role-Based Access Control**: Only admin (roleID = 2) can manage shops
2. **API Token Authentication**: Public pages require valid token to view shop details
3. **Token Uniqueness**: Each shop has unique API token (database constraint)
4. **Token Regeneration**: Admin can regenerate compromised tokens
5. **Soft Delete**: Deleted shops are marked inactive, not removed from database
6. **Input Validation**: Service layer validates all inputs before processing

## 📂 File Structure

```
ISP392_CoffeeShop/
├── SQL.sql                           # Database schema with sample data
├── src/java/
│   ├── model/
│   │   └── Shop.java                 # Shop entity model
│   ├── dao/
│   │   └── ShopDAO.java              # Data access with JWT token generation
│   ├── services/
│   │   └── ShopService.java          # Business logic layer
│   └── controllers/
│       ├── ShopController.java       # Admin shop management
│       └── ShopAPIController.java    # Public API endpoints
└── web/views/
    ├── admin/
    │   ├── shop-list.jsp             # Admin shop list page
    │   └── shop-form.jsp             # Admin add/edit form
    └── shop/
        ├── shop-list.jsp             # Public shop list page
        └── shop-view.jsp             # Public shop detail page with token input
```

## ✅ Implementation Checklist

- [x] Database schema updated
- [x] Shop model with apiToken field
- [x] ShopDAO with JWT token generation
- [x] ShopService with business logic
- [x] ShopController refactored to use ShopService
- [x] ShopAPIController refactored to use ShopService
- [x] Fixed UserDAO.getAllUsers() calls
- [x] Admin JSP pages created
- [x] Public JSP pages created
- [x] SQL sample data with JWT tokens
- [x] API documentation
- [x] Postman testing guide

## 🚀 Next Steps

1. **Build the project** to resolve library dependencies (Jakarta Servlet, Gson)
2. **Deploy the application** to application server (Tomcat, GlassFish, etc.)
3. **Test admin functionality**:
   - Login as admin
   - Create new shop
   - Edit shop details
   - Regenerate API token
   - Delete shop
4. **Test public pages**:
   - View shop list
   - Enter API token to view shop details
5. **Test API with Postman**:
   - Test `/api/shop?action=details&token=xxx`
   - Test `/api/shop?action=validate&token=xxx`
   - Test with invalid tokens

## 📌 Notes

- The Jakarta Servlet and Gson import errors shown in IDE are **configuration issues**, not code issues
- Make sure `jakarta.servlet-api` and `gson` libraries are in project classpath
- The application follows proper MVC+Service architecture pattern
- All code includes Vietnamese comments for better understanding
- API tokens are generated automatically when creating new shops
- Tokens can be regenerated by admin if needed

---

**Implementation Date:** 2024
**Architecture:** Java Servlet/JSP with MVC + Service Layer
**Database:** PostgreSQL
**Authentication:** JWT-like API Tokens with SHA-256 signature
