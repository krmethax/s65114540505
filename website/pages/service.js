import { useState, useEffect, useCallback } from "react";
import apiClient from "../utils/apiClient";
import swal from "sweetalert";
import Sidebar from "../components/Sidebar";

export default function ServiceTypes() {
  const [serviceTypes, setServiceTypes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [modalVisible, setModalVisible] = useState(false);
  const [modalMode, setModalMode] = useState("add"); // "add" หรือ "edit"
  const [formData, setFormData] = useState({
    service_type_id: "",
    short_name: "",
    full_description: "",
  });

  // ดึงข้อมูล Service_Types
  const fetchServiceTypes = useCallback(() => {
    setLoading(true);
    apiClient
      .get("/admin/service-types")
      .then((res) => {
        console.log("Fetched rows:", res.data);
        setServiceTypes(res.data.serviceTypes || []);
        setLoading(false);
      })
      .catch((err) => {
        console.error("Error fetching service types:", err);
        swal("Error", "Failed to fetch service types", "error");
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    fetchServiceTypes();
  }, [fetchServiceTypes]);

  const openAddModal = () => {
    setModalMode("add");
    setFormData({ service_type_id: "", short_name: "", full_description: "" });
    setModalVisible(true);
  };

  const openEditModal = (service) => {
    setModalMode("edit");
    setFormData({
      service_type_id: service.service_type_id,
      short_name: service.short_name,
      full_description: service.full_description,
    });
    setModalVisible(true);
  };

  const closeModal = () => {
    setModalVisible(false);
  };

  // เพิ่ม / แก้ไข Service_Types
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (modalMode === "add") {
        const res = await apiClient.post("/admin/service-types", {
          short_name: formData.short_name,
          full_description: formData.full_description,
        });
        swal("Success", res.data.message, "success");
      } else {
        const res = await apiClient.put("/admin/service-types", {
          service_type_id: formData.service_type_id,
          short_name: formData.short_name,
          full_description: formData.full_description,
        });
        swal("Success", res.data.message, "success");
      }
      closeModal();
      fetchServiceTypes();
    } catch (err) {
      console.error("Error saving service type:", err);
      swal("Error", err.response?.data?.message || "Failed to save service type", "error");
    }
  };

  // ลบ Service_Types
  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this service type?")) return;
    try {
      const res = await apiClient.delete(`/admin/service-types/${id}`);
      swal("Success", res.data.message, "success");
      fetchServiceTypes();
    } catch (err) {
      console.error("Error deleting service type:", err);
      swal("Error", err.response?.data?.message || "Failed to delete service type", "error");
    }
  };

  return (
    <div style={styles.pageContainer}>
      <Sidebar />
      <div style={styles.content}>
        <main style={styles.mainContainer}>
          <h1 style={styles.header}>Service Types Dashboard</h1>
          {loading ? (
            <p>Loading...</p>
          ) : (
            <>
              <h2 style={styles.subHeader}>
                Total Service Types: {serviceTypes.length}
              </h2>
              <ul style={styles.list}>
                {serviceTypes.map((service) => (
                  <li key={service.service_type_id} style={styles.listItem}>
                    <strong>{service.short_name}</strong> - <span>{service.full_description}</span>
                    <div style={styles.itemActions}>
                      <button style={styles.editButton} onClick={() => openEditModal(service)}>Edit</button>
                      <button style={styles.deleteButton} onClick={() => handleDelete(service.service_type_id)}>Delete</button>
                    </div>
                  </li>
                ))}
              </ul>
              <button style={styles.addButton} onClick={openAddModal}>Add Service Type</button>
            </>
          )}
        </main>
      </div>

      {modalVisible && (
        <div style={styles.modalOverlay}>
          <div style={styles.modalContent}>
            <h2>{modalMode === "add" ? "Add Service Type" : "Edit Service Type"}</h2>
            <form onSubmit={handleSubmit} style={styles.form}>
              {modalMode === "edit" && (
                <div style={styles.formGroup}>
                  <label>ID:</label>
                  <input type="text" value={formData.service_type_id} readOnly style={styles.input} />
                </div>
              )}
              <div style={styles.formGroup}>
                <label>Short Name:</label>
                <input type="text" value={formData.short_name} onChange={(e) => setFormData({ ...formData, short_name: e.target.value })} style={styles.input} required />
              </div>
              <div style={styles.formGroup}>
                <label>Full Description:</label>
                <textarea value={formData.full_description} onChange={(e) => setFormData({ ...formData, full_description: e.target.value })} style={styles.textarea} required />
              </div>
              <div style={styles.formActions}>
                <button type="submit" style={styles.submitButton}>{modalMode === "add" ? "Add" : "Update"}</button>
                <button type="button" style={styles.cancelButton} onClick={closeModal}>Cancel</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

const styles = {
  pageContainer: { display: "flex", minHeight: "100vh", backgroundColor: "#FFF" },
  content: { marginLeft: "250px", width: "100%", padding: "20px", boxSizing: "border-box", backgroundColor: "#F9F9F9" },
  mainContainer: { flex: 1, padding: "20px" },
  header: { fontSize: "32px", fontWeight: "bold", marginBottom: "20px", color: "#000" },
  subHeader: { fontSize: "24px", marginBottom: "20px", color: "#333" },
  list: { listStyleType: "none", padding: 0 },
  listItem: { marginBottom: "10px", padding: "10px", borderBottom: "1px solid #ccc", display: "flex", justifyContent: "space-between", alignItems: "center" },
  itemActions: { display: "flex", gap: "10px" },
  editButton: { backgroundColor: "#FFC107", border: "none", padding: "5px 10px", borderRadius: "5px", cursor: "pointer", color: "#FFF" },
  deleteButton: { backgroundColor: "#DC3545", border: "none", padding: "5px 10px", borderRadius: "5px", cursor: "pointer", color: "#FFF" },
  addButton: { display: "block", margin: "20px auto", padding: "10px 20px", fontSize: "16px", fontWeight: "bold", backgroundColor: "#1E90FF", color: "#FFF", border: "none", borderRadius: "5px", cursor: "pointer" },
  modalOverlay: { position: "fixed", top: 0, left: 0, right: 0, bottom: 0, backgroundColor: "rgba(0,0,0,0.5)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 1000 },
  modalContent: { backgroundColor: "#FFF", padding: "20px", borderRadius: "10px", width: "400px", boxSizing: "border-box", boxShadow: "0 2px 10px rgba(0,0,0,0.1)" },
  form: { display: "flex", flexDirection: "column" },
  formGroup: { marginBottom: "15px" },
  input: { width: "100%", padding: "8px", fontSize: "16px", borderRadius: "5px", border: "1px solid #ccc", boxSizing: "border-box" },
  textarea: { width: "100%", padding: "8px", fontSize: "16px", borderRadius: "5px", border: "1px solid #ccc", boxSizing: "border-box", resize: "vertical" },
  formActions: { display: "flex", justifyContent: "space-between" },
  submitButton: { backgroundColor: "#28A745", border: "none", padding: "10px 20px", borderRadius: "5px", cursor: "pointer", color: "#FFF", fontWeight: "bold" },
  cancelButton: { backgroundColor: "#6C757D", border: "none", padding: "10px 20px", borderRadius: "5px", cursor: "pointer", color: "#FFF", fontWeight: "bold" },
};

