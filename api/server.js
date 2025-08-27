const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors({ origin: "*", credentials: true }));

app.use(express.json());

const serviceTypesRoute = require("./routes/serviceTypes");
const petTypesRoute = require("./routes/petTypes");
const sitterRoute = require("./routes/sitters");
const paymentRoute = require("./routes/payment");

app.use("/api/admin/service-types", serviceTypesRoute);
app.use("/api/admin/pet-types", petTypesRoute);
app.use("/api/admin/sitter", sitterRoute);
app.use("/api/admin/payment", paymentRoute);

app.get("/", (req, res) => {
  res.send("API running");
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`API server running on port ${PORT}`));
