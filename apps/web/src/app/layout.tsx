import type { Metadata, Viewport } from 'next';
import type { ReactElement, ReactNode } from 'react';

import './globals.css';

export const metadata: Metadata = {
  title: 'Talanta',
  description: "Africa's home for talent, culture and community.",
};

export const viewport: Viewport = {
  themeColor: '#0E0B14',
  colorScheme: 'dark',
};

export default function RootLayout({ children }: { children: ReactNode }): ReactElement {
  return (
    <html lang="en">
      <body className="weave">{children}</body>
    </html>
  );
}
