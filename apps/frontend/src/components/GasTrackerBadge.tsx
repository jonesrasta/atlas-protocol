import { useState, useEffect } from "react";
import { motion, AnimatePresence, useReducedMotion } from "framer-motion";
import { Cpu, X, ChevronDown, RefreshCw } from "lucide-react";
import { FaEthereum } from "react-icons/fa6";

export interface GasTrackerBadgeProps {
  /** Intervalo em ms para atualizar o preço do gas (Padrão: 12000ms) */
  refreshInterval?: number;
}

const SPRING_PHYSICS = { type: "spring" as const, stiffness: 400, damping: 28 };

export const GasTrackerBadge: React.FC<GasTrackerBadgeProps> = ({
  refreshInterval = 12000,
}) => {
  const shouldReduceMotion = useReducedMotion();
  const [gasPriceGwei, setGasPriceGwei] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const [isError, setIsError] = useState<boolean>(false);
  const [isGasBadgeDismissed, setIsGasBadgeDismissed] = useState(false);
  const [isGasBadgeMinimized, setIsGasBadgeMinimized] = useState(false);

  useEffect(() => {
    let isMounted = true;

    const formatGwei = (gweiValue: number): string => {
      // Se for menor que 1, exibe até 2 casas decimais (ex: 0.25)
      // Se for maior ou igual a 1, arredonda normalmente (ex: 12)
      if (gweiValue < 1 && gweiValue > 0) {
        return gweiValue.toFixed(2);
      }
      return Math.round(gweiValue).toString();
    };

    const fetchGasPrice = async () => {
      try {
        // Fonte 1: RPC via Ethereum PublicNode
        const response = await fetch("https://ethereum.publicnode.com", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            jsonrpc: "2.0",
            method: "eth_gasPrice",
            params: [],
            id: 1,
          }),
        });

        if (!response.ok) throw new Error("Falha na resposta do servidor");

        const data = await response.json();

        if (data && data.result) {
          const hexString = data.result.replace(/^0x/i, "");
          const gasInWei = parseInt(hexString, 16);

          if (!Number.isNaN(gasInWei)) {
            const rawGwei = gasInWei / 1e9;
            const formattedGwei = formatGwei(rawGwei);

            if (isMounted) {
              setGasPriceGwei(formattedGwei);
              setIsError(false);
              setIsLoading(false);
            }
            return;
          }
        }

        throw new Error("Formato de resposta inválido");
      } catch (err) {
        console.warn("Tentando fallback para busca de gas...", err);

        // Fallback: API pública da Etherscan
        try {
          const fallbackRes = await fetch(
            "https://api.etherscan.io/api?module=gastracker&action=gasoracle",
          );
          const fallbackData = await fallbackRes.json();

          if (fallbackData?.result?.ProProposed) {
            const rawGwei = parseFloat(fallbackData.result.ProProposed);
            const formattedGwei = formatGwei(rawGwei);

            if (isMounted) {
              setGasPriceGwei(formattedGwei);
              setIsError(false);
              setIsLoading(false);
            }
            return;
          }
        } catch (fallbackErr) {
          console.error(
            "Falha também no fallback do Gas Tracker:",
            fallbackErr,
          );
        }

        if (isMounted) {
          setIsError(true);
          setIsLoading(false);
        }
      }
    };

    fetchGasPrice();
    const interval = setInterval(fetchGasPrice, refreshInterval);

    return () => {
      isMounted = false;
      clearInterval(interval);
    };
  }, [refreshInterval]);

  return (
    <AnimatePresence>
      {!isGasBadgeDismissed && (
        <motion.div
          initial={{ opacity: 0, y: 20, scale: 0.95 }}
          animate={{ opacity: 1, y: 0, scale: 1 }}
          exit={{ opacity: 0, y: 20, scale: 0.95 }}
          transition={SPRING_PHYSICS}
          className="fixed bottom-2 right-4 sm:bottom-6 sm:right-6 z-30"
          aria-live="polite"
        >
          {isGasBadgeMinimized ? (
            <motion.button
              whileHover={shouldReduceMotion ? {} : { scale: 1.08 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.92 }}
              onClick={() => setIsGasBadgeMinimized(false)}
              className="p-3 bg-forest-ink/95 text-paper rounded-full shadow-2xl border border-spruce/50 flex items-center justify-center focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage"
              aria-label="Expand Gas Tracker"
            >
              <FaEthereum
                size={18}
                className="text-lime-voltage"
                aria-hidden="true"
              />
            </motion.button>
          ) : (
            <div className="flex items-center gap-3 p-2.5 sm:p-3 bg-forest-ink/95 text-paper rounded-full shadow-2xl border border-spruce/50 backdrop-blur-md">
              <div className="flex items-center justify-center p-2 bg-lime-voltage/20 text-lime-voltage rounded-full shrink-0">
                <Cpu size={18} aria-hidden="true" />
              </div>

              <div className="flex flex-col pr-1">
                <span className="text-[10px] uppercase font-bold tracking-wider text-slate">
                  Gas Tracker
                </span>
                <span className="text-xs font-black text-lime-voltage flex items-center gap-1.5">
                  <span className="relative flex h-2 w-2">
                    <span
                      className={`absolute inline-flex h-full w-full rounded-full ${
                        isError ? "bg-rose-400" : "bg-emerald-400"
                      } opacity-75 ${shouldReduceMotion ? "" : "animate-ping"}`}
                    />
                    <span
                      className={`relative inline-flex rounded-full h-2 w-2 ${
                        isError ? "bg-rose-500" : "bg-emerald-500"
                      }`}
                    />
                  </span>

                  {isLoading ? (
                    <RefreshCw
                      size={12}
                      className="animate-spin text-paper/60"
                    />
                  ) : isError || gasPriceGwei === null ? (
                    <span className="text-rose-400 font-medium">
                      Indisponível
                    </span>
                  ) : (
                    `${gasPriceGwei} Gwei`
                  )}
                </span>
              </div>

              <div className="flex items-center gap-1 pl-1 border-l border-spruce/40">
                <button
                  onClick={() => setIsGasBadgeMinimized(true)}
                  className="p-1 hover:bg-paper/10 rounded-full text-slate hover:text-paper transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-lime-voltage"
                  aria-label="Minimize Gas Tracker"
                >
                  <ChevronDown size={14} />
                </button>
                <button
                  onClick={() => setIsGasBadgeDismissed(true)}
                  className="p-1 hover:bg-paper/10 rounded-full text-slate hover:text-paper transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-lime-voltage"
                  aria-label="Close Gas Tracker"
                >
                  <X size={14} />
                </button>
              </div>
            </div>
          )}
        </motion.div>
      )}
    </AnimatePresence>
  );
};
