// Centralized API base URL helpers so requests can target different backends per environment.
const rawBaseUrl = process.env.EXPO_PUBLIC_API_URL ?? "http://localhost:3001/api";
export const API_BASE_URL = rawBaseUrl.endsWith("/") ? rawBaseUrl.slice(0, -1) : rawBaseUrl;
export const buildApiUrl = (path = "") => {
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;
  return `${API_BASE_URL}${normalizedPath}`;
};
