// routes/admin/payment.js
const express = require("express");
const router = express.Router();
const db = require("../db"); // PostgreSQL client

// GET /api/admin/booking-slips?status=paid|pending|...
router.get("/booking-slips", async (req, res) => {
  const { status } = req.query;
  try {
    let query = `
      SELECT b.booking_id, b.member_id, b.sitter_id, b.total_price,
             b.payment_status, b.slip_image, b.created_at
      FROM Bookings b
    `;
    const params = [];
    if (status) {
      query += " WHERE b.payment_status = $1";
      params.push(status);
    }
    query += " ORDER BY b.booking_id DESC";

    const result = await db.query(query, params);
    res.json({ bookingSlips: result.rows });
  } catch (err) {
    console.error("Error fetching booking slips:", err);
    res.status(500).json({ message: "Error fetching booking slips" });
  }
});

// PUT /api/admin/booking-slips
// อัพเดต payment_status ของ booking
router.put("/booking-slips", async (req, res) => {
  const { booking_id, payment_status } = req.body;
  const validStatuses = ["pending", "paid", "failed", "unpaid"];
  if (!validStatuses.includes(payment_status)) {
    return res.status(400).json({ message: "Invalid payment status" });
  }

  try {
    const result = await db.query(
      `UPDATE Bookings
       SET payment_status=$1, updated_at=NOW()
       WHERE booking_id=$2
       RETURNING booking_id, member_id, sitter_id, total_price, payment_status, slip_image, created_at`,
      [payment_status, booking_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Booking not found" });
    }
    res.json({ message: "Payment status updated successfully", booking: result.rows[0] });
  } catch (err) {
    console.error("Error updating payment status:", err);
    res.status(500).json({ message: "Error updating payment status" });
  }
});

// DELETE /api/admin/booking-slips/:booking_id
router.delete("/booking-slips/:booking_id", async (req, res) => {
  const { booking_id } = req.params;
  try {
    const result = await db.query(
      `DELETE FROM Bookings WHERE booking_id=$1 RETURNING booking_id`,
      [booking_id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Booking not found" });
    }
    res.json({ message: "Booking deleted successfully" });
  } catch (err) {
    console.error("Error deleting booking:", err);
    res.status(500).json({ message: "Error deleting booking" });
  }
});

module.exports = router;
