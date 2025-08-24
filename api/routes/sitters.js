// routes/admin/sitter.js
const express = require("express");
const router = express.Router();
const db = require("../db"); // PostgreSQL client

// GET /api/admin/sitter/
// ดึงข้อมูลพี่เลี้ยงทั้งหมด
router.get("/", async (req, res) => {
  try {
    const result = await db.query(`
      SELECT sitter_id, first_name, last_name, phone, verification_status,
             face_image AS face_image_url, id_card_image AS id_card_image_url
      FROM Pet_Sitters
      ORDER BY sitter_id ASC
    `);
    res.json({ registrations: result.rows });
  } catch (err) {
    console.error("Error fetching sitters:", err);
    res.status(500).json({ message: "Error fetching sitter registrations" });
  }
});

// POST /api/admin/sitter/update-status
// อัพเดตสถานะพี่เลี้ยง
router.post("/update-status", async (req, res) => {
  const { sitter_id, status } = req.body;
  const validStatuses = ["pending", "approved", "rejected"];

  if (!validStatuses.includes(status)) {
    return res.status(400).json({ message: "Invalid status value" });
  }

  try {
    const result = await db.query(
      `UPDATE Pet_Sitters
       SET verification_status=$1, updated_at=NOW()
       WHERE sitter_id=$2
       RETURNING sitter_id, first_name, last_name, phone, verification_status,
                 face_image AS face_image_url, id_card_image AS id_card_image_url`,
      [status, sitter_id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Sitter not found" });
    }

    res.json({ message: "Sitter status updated successfully", sitter: result.rows[0] });
  } catch (err) {
    console.error("Error updating sitter status:", err);
    res.status(500).json({ message: "Error updating sitter status" });
  }
});

module.exports = router;
