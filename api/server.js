const express = require("express");
const cors = require("cors");

const app = express();

// ✅ เปิด CORS ให้ frontend (localhost:10505) เข้าถึงได้
app.use(cors({ origin: "http://localhost:10505", credentials: true }));

app.use(express.json());

// import routes
const serviceTypesRoute = require("./routes/serviceTypes");
const petTypesRoute = require("./routes/petTypes");
const sitterRoute = require("./routes/sitters");
const paymentRoute = require("./routes/payment");

app.use("/api/admin/service-types", serviceTypesRoute);
app.use("/api/admin/pet-types", petTypesRoute);
app.use("/api/admin/sitter", sitterRoute);
app.use("/api/admin/payment", paymentRoute);

app.get("/", (req, res) => {
  res.send("API running with Express + PostgreSQL + CORS enabled");
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`API server running on port ${PORT}`));
