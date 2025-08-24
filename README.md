
# Pet Appication

### Clone Project
```bash
  https://github.com/krmethax/new_project
```
### Project มี 3 โฟลเดอร์ ** เปิดทีละโฟลเดอร์ **
- pet-app - React Native
- api - Express.js
- website(admin) - Next.js

### ติดตั้ง Android Studio
- โหลด https://developer.android.com/studio
- ตั้งค่า path ใน Environment Variables https://drive.google.com/file/d/15kKYwuhaA9Nxlms63La__4SuGrbX7LPh/view?usp=sharing

### ติดตั้ง Node.js ลงเครื่อง หากยังไม่มี
- ติดตั้ง แยกบรรทัด
```bash
curl -o nodejs.msi https://nodejs.org/dist/v18.17.1/node-v18.17.1-x64.msi
msiexec /i nodejs.msi /quiet
```
- เช็คเวอร์ชั่น
```bash
node -v
npm -v
```
### ติดตั้ง npm
```bash
npm install
```
### ติดตั้ง Xampp
- https://www.apachefriends.org/download.html

### โหลด SQL Script
- โหลดตรงนี้ https://github.com/krmethax/pet-project/blob/main/sql.sql 
- นำ sql ไปรันใน xampp https://drive.google.com/uc?export=view&id=1ChTwi1D4OszdCTuRYo27iX0cvNMadI15

### รัน pet-app
- เข้าไปในโฟลเดอร์ `pet-app`
- ติดตั้ง Expo CLI และ dependencies ที่จำเป็น (หากยังไม่ได้ติดตั้ง)
```bash 
npm install expo --legacy-peer-deps
```
- รันแอปด้วย Expo
```bash 
npx expo start
```
- กดปุ่ม a หรือกด Space bar แล้วเลือก Android emulatorเพื่อรันแอปใน Android Emulator (หากเปิดอยู่)หรือสแกน QR code ผ่านแอป Expo Go บนมือถือ

### รัน api
- เข้าไปในโฟลเดอร์ `api`
- ไปที่ไฟล์ `db.js` เปลี่ยน user password และ port ให้ตรงกับอันใหม่
- คำสั่งรัน
```bash 
node server.js
```

### รัน website 
- ติดตั้ง next
```bash 
npm install next react react-dom
```
- คำสั่งรัน
```bash 
npm run dev
```
- เข้าสู่ระบบ `username: admin` `password = 1234`
#
### เปลี่ยน port เพราะ port จะเปลี่ยนเวลาเชื่อมเครือข่ายใหม่
- เข้า cmd พิมพ์ ipconfig
- ตัวอย่าง IPv4 Address. . . . . . . . . . . : 192.168.250.111 ให้นำ 192.168.250.111 ไปเปลี่ยนใน pet-app และ website 
- เช่น http://192.168.1.12:5000/api/auth/member/${memberId}/bookings เก่า
- เปลี่ยน http://192.168.250.111:5000/api/auth/member/${memberId}/bookings ใหม่

*** api ไม่ต้องเปลี่ยนเพราะมันจะรันตาม ip ใหม่เสมอ ***
