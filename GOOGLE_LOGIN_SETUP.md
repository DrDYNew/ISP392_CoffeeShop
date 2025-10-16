# 📦 HƯỚNG DẪN CÀI ĐẶT GOOGLE LOGIN

## 🔧 Bước 1: Tải thư viện Gson

### Link tải trực tiếp Gson JAR:
**Gson 2.10.1 (Recommended)**
👉 **CLICK ĐỂ TẢI:** https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar

### Cách cài đặt:

#### Phương án 1: Sử dụng NetBeans (Khuyên dùng)
1. **Tải file JAR** từ link trên
2. **Mở NetBeans** → Click phải vào project `ISP392_CoffeeShop`
3. **Properties** → **Libraries** → **Compile** tab
4. **Add JAR/Folder** → Chọn file `gson-2.10.1.jar` vừa tải
5. **OK** → Done! ✓

#### Phương án 2: Copy vào thư mục lib
1. **Tải file JAR** từ link trên
2. **Copy** file `gson-2.10.1.jar` vào thư mục:
   ```
   c:\Code\ISP392_CoffeeShop\lib (1)\
   ```
3. **Refresh** project trong NetBeans
4. **Clean and Build** project

---

## ⚙️ Bước 2: Cấu hình Google OAuth2

### Thông tin đã có:
- **Client ID:** `10418737763-u2v0qn7sd2gbe5dp1n6ef9ldhbahq14f.apps.googleusercontent.com`
- **Client Secret:** `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`
- **Redirect URI:** `http://localhost:8080/ISP392_CoffeeShop/google-callback`

### Kiểm tra Google Console:
1. Truy cập: https://console.cloud.google.com/
2. Chọn project của bạn
3. **APIs & Services** → **Credentials**
4. Click vào OAuth 2.0 Client ID đã tạo
5. Cấu hình 2 phần quan trọng:

#### **Authorized JavaScript origins** (Nguồn gốc JavaScript được phép)
**Mục đích:** Cho phép website của bạn gọi Google API từ browser

**Thêm vào:**
```
http://localhost:8080
```

**Giải thích:**
- Đây là domain/origin nơi ứng dụng của bạn chạy
- Google sẽ kiểm tra request có đến từ domain này không
- **Bảo mật:** Chặn các website khác sử dụng trái phép Client ID của bạn
- **Không cần** path sau domain (không có `/ISP392_CoffeeShop`)

**Ví dụ khi production:**
```
https://yourdomain.com
https://www.yourdomain.com
```

#### **Authorized redirect URIs** (URL chuyển hướng được phép)
**Mục đích:** Nơi Google sẽ redirect user sau khi đăng nhập thành công

**Thêm vào:**
```
http://localhost:8080/ISP392_CoffeeShop/google-callback
```

**Giải thích:**
- Đây là URL endpoint mà Google sẽ gửi authorization code về
- **PHẢI KHỚP CHÍNH XÁC** với `GOOGLE_REDIRECT_URI` trong code
- **Bao gồm:** Protocol (http/https) + Domain + Port + Path đầy đủ
- **Bảo mật:** Google chỉ redirect về URL này, không cho phép URL khác

**Ví dụ khi production:**
```
https://yourdomain.com/ISP392_CoffeeShop/google-callback
```

6. Click **SAVE** để lưu cấu hình

---

## 📁 Files đã tạo:

### 1. ✅ GoogleAuthService.java
**Đường dẫn:** `src/java/services/GoogleAuthService.java`
- Xử lý OAuth2 flow
- Lấy access token từ Google
- Lấy thông tin user từ Google

### 2. ✅ GoogleAuthController.java  
**Đường dẫn:** `src/java/controllers/GoogleAuthController.java`
- URL: `/google-auth`
- Redirect user đến Google login page

### 3. ✅ GoogleCallbackController.java
**Đường dẫn:** `src/java/controllers/GoogleCallbackController.java`
- URL: `/google-callback`
- Nhận callback từ Google
- Xác thực user trong database
- Tạo session và redirect

### 4. ✅ login.jsp (Updated)
**Đường dẫn:** `web/views/common/login.jsp`
- Thêm nút "Đăng nhập với Google"
- CSS cho nút Google
- JavaScript redirect

---

## 🔐 Logic xác thực:

### Flow đăng nhập Google:

```
1. User click "Đăng nhập với Google"
   ↓
2. Redirect đến /google-auth
   ↓
3. Redirect đến Google Login Page
   ↓
4. User đăng nhập Google
   ↓
5. Google redirect về /google-callback với code
   ↓
6. Exchange code → Access Token
   ↓
7. Lấy email từ Google
   ↓
8. KIỂM TRA EMAIL TRONG DATABASE
   ↓
   ├─ CÓ → Tạo session → Redirect dashboard ✓
   │
   └─ KHÔNG CÓ → Hiện lỗi "Tài khoản không tồn tại" ✗
```

### Điều kiện đăng nhập:
✅ Email phải tồn tại trong database  
✅ Email phải được verify bởi Google  
✅ Account phải active (isActive = true)  
❌ Nếu không có trong DB → Không cho login

---

## 🧪 Test Google Login:

### Bước 1: Build project
```powershell
# Trong NetBeans: Clean and Build (Shift + F11)
```

### Bước 2: Chạy server
```powershell
# Trong NetBeans: Run (F6)
```

### Bước 3: Test login
1. Mở browser: `http://localhost:8080/ISP392_CoffeeShop/login`
2. Click nút **"Đăng nhập với Google"**
3. Chọn tài khoản Google
4. **Kết quả:**
   - ✅ Nếu email có trong DB → Đăng nhập thành công
   - ❌ Nếu email KHÔNG có trong DB → Hiện lỗi:
     ```
     "Tài khoản không tồn tại trong hệ thống. 
      Vui lòng liên hệ quản trị viên để được cấp tài khoản."
     ```

---

## 📝 Thêm test user vào database:

### SQL để test:
```sql
-- Thêm user test với email Google
INSERT INTO Users (FullName, Email, PasswordHash, RoleID, IsActive, CreatedAt)
VALUES 
('Test User Google', 'your-gmail@gmail.com', 'google_oauth', 2, 1, GETDATE());
```

**Lưu ý:** Thay `your-gmail@gmail.com` bằng email Google thật của bạn!

---

## 🎨 UI Nút Google:

### Giao diện:
```
┌─────────────────────────────────────┐
│  [G] Đăng nhập với Google           │
└─────────────────────────────────────┘
```

- **Icon:** Google logo SVG đầy đủ màu
- **Style:** White background, gray border
- **Hover:** Light gray background + shadow
- **Effect:** Smooth transition

---

## 🔧 Troubleshooting:

### Lỗi 1: "The import com.google cannot be resolved"
**Giải pháp:** Cài đặt Gson JAR (Bước 1 ở trên)

### Lỗi 2: "redirect_uri_mismatch"
**Giải pháp:** 
- Kiểm tra redirect URI trong Google Console
- Đảm bảo là: `http://localhost:8080/ISP392_CoffeeShop/google-callback`
- Context path phải khớp

### Lỗi 3: "Tài khoản không tồn tại"
**Giải pháp:** 
- Thêm email vào database
- Chạy SQL query ở trên
- Đảm bảo IsActive = 1

### Lỗi 4: "Không thể lấy access token"
**Giải pháp:**
- Kiểm tra Client ID và Client Secret
- Kiểm tra internet connection
- Xem server logs để biết chi tiết

---

## 📊 Monitoring:

### Server logs sẽ hiển thị:
```
GoogleAuthController: Redirecting to Google
GoogleCallbackController: Received code from Google
GoogleAuthService: Getting access token...
GoogleAuthService: Getting user info...
GoogleCallbackController: User email = xxx@gmail.com
GoogleCallbackController: User found in database
GoogleCallbackController: Login successful
```

---

## 🚀 Production Deployment:

### Khi deploy lên server thật:
1. **Thay đổi Redirect URI** trong:
   - `GoogleAuthService.java` (line 20)
   - Google Console
   
2. **Ví dụ:**
   ```java
   private static final String GOOGLE_REDIRECT_URI = 
       "https://yourdomain.com/ISP392_CoffeeShop/google-callback";
   ```

3. **Thêm domain vào Google Console:**
   - Authorized JavaScript origins
   - Authorized redirect URIs

---

## 📚 Links hữu ích:

- **Gson Maven:** https://mvnrepository.com/artifact/com.google.code.gson/gson
- **Google OAuth2 Docs:** https://developers.google.com/identity/protocols/oauth2
- **Google Console:** https://console.cloud.google.com/

---

## 🔐 Hiểu rõ về Origins và Redirect URIs:

### ❓ Tại sao cần 2 loại URL này?

Google OAuth2 có 2 bước bảo mật:

**Bước 1: Kiểm tra Origin (Nguồn gốc)**
```
Browser của user → Gửi request đến Google
Google check: "Request này đến từ domain nào?"
→ Nếu domain trong "Authorized JavaScript origins" → OK ✓
→ Nếu không → Chặn ✗
```

**Bước 2: Kiểm tra Redirect URI**
```
User đăng nhập Google thành công
Google chuẩn bị redirect về app với code
Google check: "Redirect URI có trong danh sách không?"
→ Nếu có → Redirect + gửi code ✓
→ Nếu không → Báo lỗi "redirect_uri_mismatch" ✗
```

---

### 🎯 So sánh chi tiết:

| Tiêu chí | Authorized JavaScript origins | Authorized redirect URIs |
|----------|------------------------------|--------------------------|
| **Mục đích** | Xác định domain được phép gọi API | Xác định URL nhận callback |
| **Format** | Chỉ protocol + domain + port | Đầy đủ protocol + domain + port + path |
| **Ví dụ** | `http://localhost:8080` | `http://localhost:8080/ISP392_CoffeeShop/google-callback` |
| **Khi nào dùng** | Request ban đầu từ browser | Khi Google redirect về sau login |
| **Phải khớp** | Với domain của app | Với GOOGLE_REDIRECT_URI trong code |
| **Có path không?** | ❌ KHÔNG | ✅ CÓ (bắt buộc) |

---

### 💡 Ví dụ thực tế:

#### Development (Local):
```javascript
// Authorized JavaScript origins:
http://localhost:8080

// Authorized redirect URIs:
http://localhost:8080/ISP392_CoffeeShop/google-callback
```

#### Production (Server thật):
```javascript
// Authorized JavaScript origins:
https://coffeeshop.com
https://www.coffeeshop.com

// Authorized redirect URIs:
https://coffeeshop.com/ISP392_CoffeeShop/google-callback
https://www.coffeeshop.com/ISP392_CoffeeShop/google-callback
```

---

### ⚠️ Lỗi thường gặp:

#### Lỗi 1: "redirect_uri_mismatch"
```
Nguyên nhân: Redirect URI không khớp

Sai:
- Code: http://localhost:8080/ISP392_CoffeeShop/google-callback
- Console: http://localhost:8080/google-callback
         (thiếu /ISP392_CoffeeShop)

Đúng:
- Code: http://localhost:8080/ISP392_CoffeeShop/google-callback
- Console: http://localhost:8080/ISP392_CoffeeShop/google-callback
          (khớp 100%)
```

#### Lỗi 2: "Origin not allowed"
```
Nguyên nhân: JavaScript origin không được phép

Sai:
- Console: (để trống hoặc không có)

Đúng:
- Console: http://localhost:8080
```

#### Lỗi 3: Thêm path vào JavaScript origins
```
Sai:
- http://localhost:8080/ISP392_CoffeeShop ❌
  (JavaScript origins KHÔNG CẦN path)

Đúng:
- http://localhost:8080 ✓
  (chỉ protocol + domain + port)
```

---

### 🔒 Bảo mật:

**Tại sao phải cấu hình?**

1. **Chống CSRF (Cross-Site Request Forgery)**
   - Chặn website khác sử dụng Client ID của bạn
   - Chỉ domain được phép mới gọi được API

2. **Chống Redirect Attack**
   - Hacker không thể redirect code về domain của họ
   - Code chỉ gửi về URL đã đăng ký

3. **Kiểm soát truy cập**
   - Bạn kiểm soát được ứng dụng nào dùng OAuth
   - Dễ dàng thu hồi quyền truy cập

**Ví dụ tấn công nếu không có bảo mật:**
```
Hacker tạo website: evil.com
Dùng Client ID của bạn
User đăng nhập → Code gửi về evil.com
Hacker lấy được code → Đăng nhập vào hệ thống của bạn!

→ Nhưng với cấu hình đúng, Google sẽ chặn ngay! ✓
```

---

## ✅ Checklist hoàn thành:

- [ ] Tải và cài đặt Gson JAR
- [ ] Clean and Build project
- [ ] Kiểm tra Google Console redirect URI
- [ ] Thêm test user vào database
- [ ] Test login với Google
- [ ] Test với email không có trong DB
- [ ] Test với email đã có trong DB

---

**DONE! Giờ bạn có thể đăng nhập bằng Google! 🎉**
