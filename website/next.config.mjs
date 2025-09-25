const DEFAULT_BASE_PATH = "/s65114540505";

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

const resolvedBasePath = normalizeBasePath(
  process.env.BASE_PATH || process.env.NEXT_PUBLIC_BASE_PATH || DEFAULT_BASE_PATH
);

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  basePath: resolvedBasePath,
  assetPrefix: resolvedBasePath || undefined,
};

export default nextConfig;
