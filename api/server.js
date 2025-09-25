const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors({ origin: "*", credentials: true }));

app.use(express.json());

const normalizeBasePath = (value) => {
  if (!value || value === "/") {
    return "";
  }
  const trimmed = value.trim();
  const startsWithSlash = trimmed.startsWith("/") ? trimmed : `/${trimmed}`;
  return startsWithSlash.endsWith("/")
    ? startsWithSlash.slice(0, -1)
    : startsWithSlash;
};

const basePath = normalizeBasePath(process.env.BASE_PATH);
const withBasePath = (path = "/") => `${basePath}${path}`;

const serviceTypesRoute = require("./routes/serviceTypes");
const petTypesRoute = require("./routes/petTypes");
const sitterRoute = require("./routes/sitters");
const paymentRoute = require("./routes/payment");

app.use(withBasePath("/api/admin/service-types"), serviceTypesRoute);
app.use(withBasePath("/api/admin/pet-types"), petTypesRoute);
app.use(withBasePath("/api/admin/sitter"), sitterRoute);
app.use(withBasePath("/api/admin/payment"), paymentRoute);

app.get(withBasePath("/"), (req, res) => {
  res.send("API running");
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`API server running on port ${PORT}`));
