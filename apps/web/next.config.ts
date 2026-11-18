import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,
  poweredByHeader: false,
  transpilePackages: ['@talanta/api-contract', '@talanta/design-tokens'],
};

export default nextConfig;
