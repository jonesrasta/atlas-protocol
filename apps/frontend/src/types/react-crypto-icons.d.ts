declare module 'react-crypto-icons' {
  import React from 'react';

  interface CryptoIconProps {
    name: string;
    size?: number;
    color?: string;
    className?: string;
  }

  const CryptoIcon: React.FC<CryptoIconProps>;
  export default CryptoIcon;
}