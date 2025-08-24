const express = require("express");
const router = express.Router();
const db = require("../db");

// GET: ดึงข้อมูลทั้งหมด
router.get("/", async (req, res) => {
  try {
    const result = await db.query(
      "SELECT service_type_id, short_name, full_description FROM Service_Types ORDER BY service_type_id ASC"
    );
    res.json({ serviceTypes: result.rows });
  } catch (err) {
    console.error("Error fetching service types:", err);
    res.status(500).json({ message: "Error fetching service types" });
  }
});

// POST: เพิ่มข้อมูลใหม่
router.post("/", async (req, res) => {
  const { short_name, full_description } = req.body;
  try {
    await db.query(
      "INSERT INTO Service_Types (short_name, full_description) VALUES ($1, $2)",
      [short_name, full_description]
    );
    res.json({ message: "Service type added successfully" });
  } catch (err) {
    console.error("Error adding service type:", err);
    res.status(500).json({ message: "Error adding service type" });
  }
});

// PUT: แก้ไขข้อมูล
router.put("/", async (req, res) => {
  const { service_type_id, short_name, full_description } = req.body;
  try {
    await db.query(
      "UPDATE Service_Types SET short_name = $1, full_description = $2, updated_at = NOW() WHERE service_type_id = $3",
      [short_name, full_description, service_type_id]
    );
    res.json({ message: "Service type updated successfully" });
  } catch (err) {
    console.error("Error updating service type:", err);
    res.status(500).json({ message: "Error updating service type" });
  }
});

// DELETE: ลบข้อมูล
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await db.query("DELETE FROM Service_Types WHERE service_type_id = $1", [id]);
    res.json({ message: "Service type deleted successfully" });
  } catch (err) {
    console.error("Error deleting service type:", err);
    res.status(500).json({ message: "Error deleting service type" });
  }
});

module.exports = router;
