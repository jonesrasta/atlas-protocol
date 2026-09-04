import React, { useState } from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { ArrowDownUp, Settings, Sliders, Search, X, Check } from 'lucide-react';
import type { YieldPool } from './YieldTable';

export interface Token {
  symbol: string;
  name: string;
  iconPath: string;
  rateToUsd: number;
}

export interface SwapWidgetCardProps {
  selectedPool?: YieldPool | null;
  onSwapExecute?: (payToken: Token, receiveToken: Token, payAmount: string) => void;
  onOpenSettings?: () => void;
}

const TOKENS: Record<string, Token> = {
  ETH: { 
    symbol: 'ETH', 
    name: 'Ethereum', 
    iconPath: '/icons/chains/eth.svg', 
    rateToUsd: 3420.5 
  },
  USDC: { 
    symbol: 'USDC', 
    name: 'USD Coin', 
    iconPath: '/icons/chains/usdt.svg', 
    rateToUsd: 1.0 
  },
  USDT: { 
    symbol: 'USDT', 
    name: 'Tether USD', 
    iconPath: '/icons/chains/usdc.svg', 
    rateToUsd: 1.0 
  },
  WBTC: { 
    symbol: 'WBTC', 
    name: 'Wrapped Bitcoin', 
    iconPath: '/icons/chains/btc.svg', 
    rateToUsd: 64200.0 
  },
  DAI: { 
    symbol: 'DAI', 
    name: 'Dai Stablecoin', 
    iconPath: '/icons/chains/dai.svg', 
    rateToUsd: 1.0 
  },
};

const getTokenBySymbol = (symbol?: string): Token => {
  if (!symbol) return TOKENS.ETH;
  const upper = symbol.toUpperCase().trim();
  
  if (TOKENS[upper]) {
    return TOKENS[upper];
  }

  return {
    symbol: upper,
    name: upper,
    iconPath: `/icons/chains/${upper.toLowerCase()}.svg`,
    rateToUsd: 1.0,
  };
};

const TokenIcon: React.FC<{ token: Token }> = ({ token }) => {
  const [hasError, setHasError] = useState(false);

  if (hasError) {
    return (
      <div className="w-5 h-5 rounded-full bg-forest-ink text-paper flex items-center justify-center text-[9px] font-extrabold shrink-0">
        {token.symbol.slice(0, 3)}
      </div>
    );
  }

  return (
    <img 
      src={token.iconPath} 
      alt={`${token.symbol} icon`} 
      className="w-5 h-5 object-contain shrink-0"
      onError={() => setHasError(true)}
    />
  );
};

const SPRING_PHYSICS = { type: 'spring' as const, stiffness: 380, damping: 25 };

export const SwapWidgetCard: React.FC<SwapWidgetCardProps> = ({
  selectedPool,
  onSwapExecute,
  onOpenSettings,
}) => {
  const shouldReduceMotion = useReducedMotion();

  const [payToken, setPayToken] = useState<Token>(TOKENS.ETH);
  const [receiveToken, setReceiveToken] = useState<Token>(TOKENS.USDC);
  const [payAmount, setPayAmount] = useState<string>('1.0');
  const [rotationAngle, setRotationAngle] = useState<number>(0);

  // Estados do Modal de Seleção de Tokens
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectingSide, setSelectingSide] = useState<'pay' | 'receive'>('pay');
  const [searchQuery, setSearchQuery] = useState('');

  const [prevPool, setPrevPool] = useState<YieldPool | null | undefined>(selectedPool);

  if (selectedPool !== prevPool) {
    setPrevPool(selectedPool);

    if (selectedPool) {
      const parts = selectedPool.pair.split('-');
      const baseSymbol = parts[0];
      const quoteSymbol = parts[1];

      if (baseSymbol) setPayToken(getTokenBySymbol(baseSymbol));
      if (quoteSymbol) setReceiveToken(getTokenBySymbol(quoteSymbol));
    }
  }

  const calculateReceiveAmount = (): string => {
    const numericPay = parseFloat(payAmount);
    if (isNaN(numericPay) || numericPay <= 0) return '0.00';
    const totalInUsd = numericPay * payToken.rateToUsd;
    const estimatedReceive = totalInUsd / receiveToken.rateToUsd;
    return estimatedReceive.toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 4,
    });
  };

  const handlePayAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/,/g, '.');
    if (value === '' || /^\d*\.?\d*$/.test(value)) {
      setPayAmount(value);
    }
  };

  const handleSwitchTokens = () => {
    setPayToken(receiveToken);
    setReceiveToken(payToken);
    setRotationAngle((prev) => prev + 180);
  };

  const openTokenModal = (side: 'pay' | 'receive') => {
    setSelectingSide(side);
    setSearchQuery('');
    setIsModalOpen(true);
  };

  const handleSelectToken = (token: Token) => {
    if (selectingSide === 'pay') {
      if (token.symbol === receiveToken.symbol) {
        setReceiveToken(payToken);
      }
      setPayToken(token);
    } else {
      if (token.symbol === payToken.symbol) {
        setPayToken(receiveToken);
      }
      setReceiveToken(token);
    }
    setIsModalOpen(false);
  };

  const filteredTokens = Object.values(TOKENS).filter(
    (token) =>
      token.symbol.toLowerCase().includes(searchQuery.toLowerCase()) ||
      token.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <section className="py-10 px-4 max-w-7xl w-full mx-auto">
      <div className="bg-forest-ink text-paper rounded-largecards p-4 md:p-12 flex flex-col lg:flex-row gap-8 items-center justify-between shadow-2xl">
        
        <div className="flex flex-col gap-4 max-w-xl">
          <span className="px-3.5 py-1 bg-lime-voltage/20 text-lime-voltage border border-lime-voltage/30 text-xs font-semibold rounded-full w-fit">
            INSTANT LIQUIDITY
          </span>
          <h2 className="text-3xl md:text-5xl font-bold text-lime-voltage tracking-tight leading-tight">
            Swap tokens with zero slippage.
          </h2>
          <p className="text-paper/80 text-base md:text-lg leading-relaxed">
            Aggregated routes across 15+ DEXs ensure you get the absolute best price with minimal gas consumption.
          </p>
        </div>

        <div className="bg-paper text-charcoal rounded-3xl p-5 sm:p-6 w-full max-w-md flex flex-col gap-3 shadow-2xl border border-pebble/30">
          
          <div className="flex justify-between items-center px-1 mb-1">
            <span className="text-sm font-extrabold text-obsidian tracking-wide uppercase">
              Swap
            </span>
            <button
              onClick={onOpenSettings}
              aria-label="Abrir Configurações de Slippage e Gas"
              className="p-2 hover:bg-fog rounded-full text-slate transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
            >
              <Settings size={18} aria-hidden="true" />
            </button>
          </div>

          {/* Pay Input */}
          <div className="p-4 bg-fog rounded-2xl flex justify-between items-center border border-pebble/20 focus-within:border-forest-ink/40 transition-colors">
            <div className="flex flex-col gap-1 w-full mr-2">
              <label htmlFor="swap-pay-input" className="text-xs font-semibold text-slate">
                You Pay
              </label>
              <input
                id="swap-pay-input"
                type="text"
                inputMode="decimal"
                value={payAmount}
                onChange={handlePayAmountChange}
                placeholder="0.0"
                aria-label={`Valor a pagar em ${payToken.symbol}`}
                className="bg-transparent text-2xl font-bold text-obsidian outline-none w-full"
              />
            </div>
            <button
              type="button"
              onClick={() => openTokenModal('pay')}
              className="flex items-center gap-2 bg-paper px-3.5 py-2 rounded-full border border-pebble/40 text-xs font-bold text-obsidian hover:bg-pebble/20 transition-colors shadow-xs shrink-0 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
              aria-label={`Selecionar Token de Pagamento (Atual: ${payToken.symbol})`}
            >
              <TokenIcon key={payToken.iconPath} token={payToken} />
              <span>{payToken.symbol}</span>
              <Sliders size={12} className="text-slate" aria-hidden="true" />
            </button>
          </div>

          {/* Switch Button */}
          <div className="flex justify-center -my-3 z-10">
            <motion.button
              type="button"
              onClick={handleSwitchTokens}
              whileHover={shouldReduceMotion ? {} : { scale: 1.1 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.9 }}
              animate={{ rotate: shouldReduceMotion ? 0 : rotationAngle }}
              transition={SPRING_PHYSICS}
              aria-label="Inverter ordem dos tokens de swap"
              className="p-2.5 bg-paper border border-pebble/30 text-forest-ink rounded-full shadow-md hover:shadow-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
            >
              <ArrowDownUp size={16} aria-hidden="true" />
            </motion.button>
          </div>

          {/* Receive Input */}
          <div className="p-4 bg-fog rounded-2xl flex justify-between items-center border border-pebble/20">
            <div className="flex flex-col gap-1 w-full mr-2">
              <label htmlFor="swap-receive-input" className="text-xs font-semibold text-slate">
                You Receive (Est.)
              </label>
              <input
                id="swap-receive-input"
                type="text"
                readOnly
                value={calculateReceiveAmount()}
                aria-label={`Valor estimado a receber em ${receiveToken.symbol}`}
                className="bg-transparent text-2xl font-bold text-obsidian outline-none w-full cursor-not-allowed opacity-90"
              />
            </div>
            <button
              type="button"
              onClick={() => openTokenModal('receive')}
              className="flex items-center gap-2 bg-paper px-3.5 py-2 rounded-full border border-pebble/40 text-xs font-bold text-obsidian hover:bg-pebble/20 transition-colors shadow-xs shrink-0 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
              aria-label={`Selecionar Token de Recebimento (Atual: ${receiveToken.symbol})`}
            >
              <TokenIcon key={receiveToken.iconPath} token={receiveToken} />
              <span>{receiveToken.symbol}</span>
              <Sliders size={12} className="text-slate" aria-hidden="true" />
            </button>
          </div>

          <motion.button
            whileHover={shouldReduceMotion ? {} : { scale: 1.01 }}
            whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
            transition={SPRING_PHYSICS}
            onClick={() => onSwapExecute?.(payToken, receiveToken, payAmount)}
            className="w-full py-4 mt-2 bg-lime-voltage text-forest-ink font-bold rounded-full hover:brightness-105 transition-all text-sm sm:text-base shadow-lg shadow-lime-voltage/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink focus-visible:ring-offset-2"
          >
            Connect Wallet to Swap
          </motion.button>

        </div>
      </div>

      {/* Modal de Seleção de Tokens */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 bg-obsidian/60 backdrop-blur-sm flex items-center justify-center p-4">
          <motion.div 
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
            className="bg-paper text-obsidian w-full max-w-md rounded-3xl p-6 shadow-2xl border border-pebble/30 flex flex-col gap-4"
          >
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-bold">Select a Token</h3>
              <button 
                onClick={() => setIsModalOpen(false)}
                className="p-1 hover:bg-fog rounded-full text-slate transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate" size={18} />
              <input 
                type="text"
                placeholder="Search name or symbol"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-3 bg-fog rounded-2xl text-sm outline-none border border-pebble/20 focus:border-forest-ink/40 transition-colors"
              />
            </div>

            <div className="max-h-64 overflow-y-auto flex flex-col gap-1 pr-1 custom-scrollbar">
              {filteredTokens.length > 0 ? (
                filteredTokens.map((token) => {
                  const isSelected = selectingSide === 'pay' 
                    ? token.symbol === payToken.symbol 
                    : token.symbol === receiveToken.symbol;

                  return (
                    <button
                      key={token.symbol}
                      onClick={() => handleSelectToken(token)}
                      className={`flex items-center justify-between p-3 rounded-2xl hover:bg-fog transition-colors ${
                        isSelected ? 'bg-fog/80' : ''
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <TokenIcon token={token} />
                        <div className="flex flex-col items-start">
                          <span className="font-bold text-sm leading-none">{token.symbol}</span>
                          <span className="text-xs text-slate">{token.name}</span>
                        </div>
                      </div>
                      {isSelected && <Check size={18} className="text-forest-ink" />}
                    </button>
                  );
                })
              ) : (
                <div className="text-center py-6 text-slate text-sm">
                  No tokens found.
                </div>
              )}
            </div>
          </motion.div>
        </div>
      )}
    </section>
  );
};