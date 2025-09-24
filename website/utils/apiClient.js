import axios from "axios";

const DEFAULT_API_BASE_URL = "/api";

const resolveBaseUrl = () => {
  const envUrl = process.env.NEXT_PUBLIC_API_BASE_URL;
  if (!envUrl) {
    return DEFAULT_API_BASE_URL;
  }
  return envUrl.endsWith("/") ? envUrl.slice(0, -1) : envUrl;
};

const apiClient = axios.create({
  baseURL: resolveBaseUrl(),
});

export default apiClient;

