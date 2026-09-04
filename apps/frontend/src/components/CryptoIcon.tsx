interface CryptoIconProps {
  code: string;
  size?: number;
}

export function CryptoIcon({ code, size = 24 }: CryptoIconProps) {
  // Carrega os ícones genéricos e limpos em SVG direto da biblioteca
  const iconUrl = `https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/svg/color/${code.toLowerCase()}.svg`;

  return (
    <img 
      src={iconUrl} 
      alt={code} 
      width={size} 
      height={size} 
      className="inline-block shrink-0"
      onError={(e) => {
        // Fallback caso a rede não seja encontrada
        (e.target as HTMLImageElement).src = 'https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/svg/color/generic.svg';
      }}
    />
  );
}