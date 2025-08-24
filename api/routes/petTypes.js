const express = require("express");
const router = express.Router();
const db = require("../db");

// POST: เพิ่มประเภทสัตว์
router.post("/", async (req, res) => {
  const { type_name, description } = req.body;
  console.log("POST /pet-types body:", req.body);
  try {
    const result = await db.query(
      "INSERT INTO Pet_Types (type_name, description) VALUES ($1, $2) RETURNING *",
      [type_name, description]
    );
    console.log("Inserted:", result.rows[0]);
    res.json({ message: "Pet type added successfully", data: result.rows[0] });
  } catch (err) {
    console.error("Error adding pet type:", err);
    res.status(500).json({ message: "Error adding pet type", error: err });
  }
});

// GET: ดึงประเภทสัตว์ทั้งหมด
router.get("/", async (req, res) => {
  console.log("GET /pet-types called");
  try {
    const result = await db.query("SELECT * FROM Pet_Types ORDER BY pet_type_id ASC");
    console.log("Fetched rows:", result.rows);
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching pet types:", err);
    res.status(500).json({ error: "Internal server error", details: err });
  }
});

// PUT: อัพเดตประเภทสัตว์
router.put("/", async (req, res) => {
  const { pet_type_id, type_name, description } = req.body;
  console.log("PUT /pet-types body:", req.body);
  try {
    const result = await db.query(
      "UPDATE Pet_Types SET type_name=$1, description=$2, updated_at=NOW() WHERE pet_type_id=$3 RETURNING *",
      [type_name, description, pet_type_id]
    );
    console.log("Updated:", result.rows[0]);
    res.json({ message: "Pet type updated successfully", data: result.rows[0] });
  } catch (err) {
    console.error("Error updating pet type:", err);
    res.status(500).json({ message: "Error updating pet type", error: err });
  }
});

// DELETE: ลบประเภทสัตว์
router.delete("/:id", async (req, res) => {
  const { id } = req.params;
  console.log("DELETE /pet-types id:", id);
  try {
    const result = await db.query("DELETE FROM Pet_Types WHERE pet_type_id=$1 RETURNING *", [id]);
    console.log("Deleted:", result.rows[0]);
    res.json({ message: "Pet type deleted successfully", data: result.rows[0] });
  } catch (err) {
    console.error("Error deleting pet type:", err);
    res.status(500).json({ message: "Error deleting pet type", error: err });
  }
});

module.exports = router;
