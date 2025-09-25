// pages/_app.js
import '../styles/globals.css';
import Head from 'next/head';

const DEFAULT_BASE_PATH = '/s65114540505';
const basePath = process.env.NEXT_PUBLIC_BASE_PATH || DEFAULT_BASE_PATH;
const normalizedBasePath = basePath ? (basePath.startsWith('/') ? basePath : `/${basePath}`) : '';
const faviconHref = `${normalizedBasePath || ''}/favicon.ico`;

function MyApp({ Component, pageProps }) {
  return (
    <>
      <Head>
        <link rel="icon" href={faviconHref} />
        <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr"
          crossOrigin="anonymous"
        />
      </Head>
      <Component {...pageProps} />
    </>
  );
}

export default MyApp;
