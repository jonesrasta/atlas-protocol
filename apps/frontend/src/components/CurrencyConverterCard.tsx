import React, { useState, useEffect } from 'react';
import { ArrowUpDown, RefreshCw } from 'lucide-react';

interface CurrencyOption {
  code: string;
  flag: string;
  name: string;
}

const SUPPORTED_CURRENCIES: CurrencyOption[] = [
  { code: 'USD', flag: '🇺🇸', name: 'US Dollar' },
  { code: 'EUR', flag: '🇪🇺', name: 'Euro' },
  { code: 'BRL', flag: '🇧🇷', name: 'Brazilian Real' },
  { code: 'GBP', flag: '🇬🇧', name: 'British Pound' },
  { code: 'JPY', flag: '🇯🇵', name: 'Japanese Yen' },
];

export const CurrencyConverterCard: React.FC = () => {
  const [amount, setAmount] = useState<number>(1000);
  const [fromCurrency, setFromCurrency] = useState<string>('USD');
  const [toCurrency, setToCurrency] = useState<string>('EUR');
  const [exchangeRate, setExchangeRate] = useState<number | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [isError, setIsError] = useState<boolean>(false);

  useEffect(() => {
    let isMounted = true;

    const fetchExchangeRate = async () => {
      if (fromCurrency === toCurrency) {
        setExchangeRate(1);
        setIsLoading(false);
        return;
      }

      setIsLoading(true);
      setIsError(false);

      // Fonte 1: Endpoint oficial atualizado do Frankfurter API (.dev)
      try {
        const response = await fetch(
          `https://api.frankfurter.dev/v1/latest?base=${fromCurrency}&symbols=${toCurrency}`
        );

        if (!response.ok) throw new Error('Falha no Frankfurter');

        const data = await response.json();
        const rate = data.rates?.[toCurrency];

        if (isMounted && rate) {
          setExchangeRate(rate);
          setIsLoading(false);
          return;
        }
      } catch (err) {
        console.warn('Tentando fallback para API secundária de câmbio...', err);
      }

      // Fonte 2 (Fallback): ExchangeRate-API pública
      try {
        const fallbackRes = await fetch(
          `https://open.er-api.com/v6/latest/${fromCurrency}`
        );

        if (!fallbackRes.ok) throw new Error('Falha no Fallback');

        const fallbackData = await fallbackRes.json();
        const fallbackRate = fallbackData.rates?.[toCurrency];

        if (isMounted && fallbackRate) {
          setExchangeRate(fallbackRate);
          setIsError(false);
        } else if (isMounted) {
          setIsError(true);
        }
      } catch (fallbackErr) {
        console.error('Erro total ao buscar câmbio:', fallbackErr);
        if (isMounted) setIsError(true);
      } finally {
        if (isMounted) setIsLoading(false);
      }
    };

    fetchExchangeRate();

    return () => {
      isMounted = false;
    };
  }, [fromCurrency, toCurrency]);

  const handleSwapCurrencies = () => {
    setFromCurrency(toCurrency);
    setToCurrency(fromCurrency);
  };

  const convertedAmount = exchangeRate
    ? (amount * exchangeRate).toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
    : '---';

  const fromCurrencyObj = SUPPORTED_CURRENCIES.find((c) => c.code === fromCurrency);
  const toCurrencyObj = SUPPORTED_CURRENCIES.find((c) => c.code === toCurrency);

  return (
    <section className="py-16 px-4 md:px-0 max-w-5xl w-full mx-auto">
      <div className="bg-forest-ink text-paper rounded-3xl p-8 md:p-12 flex flex-col lg:flex-row gap-8 items-center justify-between shadow-xl">
        <div className="flex flex-col gap-4 max-w-xl">
          <span className="px-3 py-1 bg-linen-mist text-forest-ink text-xs font-semibold rounded-full w-fit">
            CURRENCY EXCHANGE
          </span>
          <h2 className="text-3xl md:text-5xl font-bold text-lime-voltage tracking-tight">
            Send money anywhere, fast.
          </h2>
          <p className="text-paper/80 text-base leading-relaxed">
            Check live exchange rates and calculate fees upfront before transferring money abroad.
          </p>
        </div>

        <div className="bg-paper text-charcoal rounded-3xl p-5 w-full max-w-sm flex flex-col gap-3 shadow-md relative">
          {/* You Send */}
          <div className="flex items-center justify-between p-3 bg-fog rounded-2xl border border-transparent focus-within:border-forest-ink/30 transition-all">
            <div className="flex items-center gap-3 w-full">
              <span className="text-2xl">{fromCurrencyObj?.flag}</span>
              <div className="flex flex-col grow">
                <label htmlFor="send-amount" className="text-[10px] uppercase font-bold text-slate">
                  You send
                </label>
                <input
                  id="send-amount"
                  type="number"
                  min="0"
                  value={amount || ''}
                  onChange={(e) => setAmount(Math.max(0, parseFloat(e.target.value) || 0))}
                  className="text-lg font-bold text-obsidian bg-transparent outline-none w-full"
                  placeholder="0.00"
                />
              </div>
            </div>

            <select
              value={fromCurrency}
              onChange={(e) => setFromCurrency(e.target.value)}
              className="bg-paper text-xs font-semibold border border-forest-ink/20 text-forest-ink rounded-full px-2 py-1 outline-none cursor-pointer hover:bg-fog"
            >
              {SUPPORTED_CURRENCIES.map((c) => (
                <option key={c.code} value={c.code}>
                  {c.code}
                </option>
              ))}
            </select>
          </div>

          {/* Swap Button */}
          <div className="flex justify-center -my-2 z-10">
            <button
              onClick={handleSwapCurrencies}
              className="p-2 bg-forest-ink text-lime-voltage rounded-full shadow-md hover:scale-110 active:scale-95 transition-all"
              title="Swap Currencies"
              aria-label="Swap Currencies"
            >
              <ArrowUpDown size={14} />
            </button>
          </div>

          {/* Recipient Gets */}
          <div className="flex items-center justify-between p-3 bg-fog rounded-2xl border border-transparent">
            <div className="flex items-center gap-3 w-full">
              <span className="text-2xl">{toCurrencyObj?.flag}</span>
              <div className="flex flex-col grow">
                <span className="text-[10px] uppercase font-bold text-slate">
                  Recipient gets
                </span>
                <div className="text-lg font-bold text-obsidian flex items-center gap-2">
                  {isLoading ? (
                    <RefreshCw size={16} className="animate-spin text-slate" />
                  ) : isError ? (
                    <span className="text-xs text-rose-500 font-normal">Erro na cotação</span>
                  ) : (
                    `${convertedAmount} ${toCurrency}`
                  )}
                </div>
              </div>
            </div>

            <select
              value={toCurrency}
              onChange={(e) => setToCurrency(e.target.value)}
              className="bg-paper text-xs font-semibold border border-forest-ink/20 text-forest-ink rounded-full px-2 py-1 outline-none cursor-pointer hover:bg-fog"
            >
              {SUPPORTED_CURRENCIES.map((c) => (
                <option key={c.code} value={c.code}>
                  {c.code}
                </option>
              ))}
            </select>
          </div>

          {/* Rate Subtitle */}
          {exchangeRate && !isLoading && !isError && (
            <div className="text-[11px] text-center text-slate font-medium">
              1 {fromCurrency} = {exchangeRate.toFixed(4)} {toCurrency}
            </div>
          )}

          <button className="w-full py-3 bg-lime-voltage text-forest-ink font-semibold rounded-full hover:brightness-105 transition-all text-sm shadow-sm active:scale-[0.98]">
            Get Started
          </button>
        </div>
      </div>
    </section>
  );
};