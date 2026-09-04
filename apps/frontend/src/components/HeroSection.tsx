import React, { useState } from "react";
import { motion, useReducedMotion } from "framer-motion";
import type { Variants } from "framer-motion";
import { ArrowUpRight, Wallet, Activity } from "lucide-react";
import { ConnectWalletModal } from "./ConnectWalletModal";
import type { WalletOption } from "./ConnectWalletModal";

// Types & Interfaces
export interface ProtocolMetric {
  id: string;
  label: string;
  value: string;
  isHighlight?: boolean;
}

export interface HeroSectionProps {
  badgeText?: string;
  headline?: string;
  description?: string;
  metrics?: ProtocolMetric[];
  onConnectWallet?: (walletId: string) => void;
  onLaunchApp?: () => void;
  availableWallets?: WalletOption[];
}

// Design Tokens & Variants
const SPRING_PHYSICS = {
  type: "spring" as const,
  stiffness: 380,
  damping: 26,
};

const STAGGER_CONTAINER: Variants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.05,
    },
  },
};

const FADE_UP_ITEM: Variants = {
  hidden: { opacity: 0, y: 16 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.5,
      ease: [0.16, 1, 0.3, 1],
    },
  },
};

const DEFAULT_METRICS: ProtocolMetric[] = [
  { id: "tvl", label: "Total Value Locked", value: "$1.42B" },
  { id: "vol", label: "24h Volume", value: "$284.5M" },
  { id: "apy", label: "Top APY", value: "18.4%", isHighlight: true },
  { id: "users", label: "Total Users", value: "340k+" },
];

export const HeroSection: React.FC<HeroSectionProps> = ({
  badgeText = "Nodus Protocol V2 is Live on Mainnet",
  headline = "Non-Custodial Liquidity Protocol",
  description = "Swap, earn yield, and borrow digital assets with zero intermediaries. Full self-custody and audited smart contracts.",
  metrics = DEFAULT_METRICS,
  onConnectWallet,
  onLaunchApp,
  availableWallets,
}) => {
  const shouldReduceMotion = useReducedMotion();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleOpenModal = () => {
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  const handleSelectWallet = (walletId: string) => {
    if (onConnectWallet) {
      onConnectWallet(walletId);
    }
  };

  return (
    <>
      <section
        id="hero"
        className="relative pt-36 md:pt-44 pb-16 px-6 max-w-6xl mx-auto flex flex-col items-center text-center selection:bg-lime-voltage/30 overflow-hidden"
        aria-labelledby="hero-title"
      >
        {/* Luzes / Gradiente de Fundo Decorativo */}
        <div className="aria-hidden:true pointer-events-none absolute inset-0 -z-10 flex items-center justify-center">
          <div className="absolute top-12 w-150 h-87.5 sm:w-200 sm:h-112.5 bg-linear-to-b from-linen-mist/80 via-fog/40 to-transparent blur-3xl rounded-full opacity-70" />
          <div className="absolute top-0 w-75 h-50 bg-lime-voltage/15 blur-2xl rounded-full" />
        </div>

        <motion.div
          variants={STAGGER_CONTAINER}
          initial="hidden"
          animate="visible"
          className="flex flex-col items-center w-full"
        >
          {/* Badge do Protocolo */}
          <motion.div variants={FADE_UP_ITEM}>
            <a
              href="#changelog"
              className="relative group inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-lime-voltage text-xs font-semibold overflow-hidden transition-all duration-300 shadow-md hover:shadow-lime-voltage/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage focus-visible:ring-offset-2 focus-visible:ring-offset-obsidian border border-lime-voltage/30 bg-linear-to-r from-forest-ink via-forest-ink/90 to-obsidian"
              aria-label={`Update status: ${badgeText}`}
            >
              <span
                className="absolute inset-0 bg-linear-to-b from-white/15 via-white/5 to-transparent pointer-events-none rounded-full"
                aria-hidden="true"
              />
              <span
                className="absolute -inset-full top-0 block w-1/2 h-full z-10 bg-linear-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 -translate-x-full group-hover:translate-x-[400%] transition-transform duration-1000 ease-in-out pointer-events-none"
                aria-hidden="true"
              />
              <span
                className={`relative z-10 w-2 h-2 rounded-full bg-lime-voltage shadow-[0_0_8px_rgba(204,255,0,0.8)] ${
                  shouldReduceMotion ? "" : "animate-pulse"
                }`}
                aria-hidden="true"
              />
              <span className="relative z-10 drop-shadow-xs">{badgeText}</span>
            </a>
          </motion.div>

          {/* Headline Principal */}
          <motion.h1
            id="hero-title"
            variants={FADE_UP_ITEM}
            className="mt-6 text-4xl sm:text-6xl md:text-7xl lg:text-8xl font-black font-wise-sans text-obsidian tracking-tight leading-[0.95] max-w-4xl"
          >
            {headline}
          </motion.h1>

          {/* Subtítulo / Descrição */}
          <motion.p
            variants={FADE_UP_ITEM}
            className="mt-6 text-lg sm:text-xl text-slate max-w-2xl leading-relaxed"
          >
            {description}
          </motion.p>

          {/* Ações / CTAs */}
          <motion.div
            variants={FADE_UP_ITEM}
            className="mt-8 flex flex-col sm:flex-row items-center gap-4 w-full sm:w-auto"
          >
            <motion.button
              whileHover={shouldReduceMotion ? {} : { scale: 1.02 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
              transition={SPRING_PHYSICS}
              onClick={handleOpenModal}
              className="w-full sm:w-auto min-h-13 px-8 py-4 md:3.5 bg-lime-voltage text-forest-ink font-bold rounded-full text-base flex items-center justify-center gap-2 shadow-lg shadow-lime-voltage/20 hover:shadow-lime-voltage/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage focus-visible:ring-offset-2 cursor-pointer"
              aria-label="Connect your Web3 Wallet"
            >
              <Wallet size={20} aria-hidden="true" />
              <span>Connect Wallet</span>
            </motion.button>

            <motion.button
              whileHover={shouldReduceMotion ? {} : { scale: 1.02 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
              transition={SPRING_PHYSICS}
              onClick={onLaunchApp}
              className="w-full sm:w-auto min-h-13 px-8 py-4 md:3.5 border-[0.1px] border-forest-ink/20 text-forest-ink font-semibold rounded-full hover:border-forest-ink hover:bg-fog/50 backdrop-blur-sm transition-colors text-base flex items-center justify-center gap-2 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink focus-visible:ring-offset-2 cursor-pointer"
              aria-label="Launch the Nodus Protocol application"
            >
              <span>Launch App</span>
              <ArrowUpRight size={18} aria-hidden="true" />
            </motion.button>
          </motion.div>

          {/* Ticker de Métricas */}
          <motion.div
            variants={FADE_UP_ITEM}
            className="relative mt-14 w-full p-6 sm:p-8 bg-paper/90 backdrop-blur-md rounded-3xl border border-pebble/20 shadow-xl shadow-forest-ink/5 flex flex-col gap-6 mb-4"
            role="region"
            aria-label="Protocol metrics"
          >
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 relative z-10">
              {metrics.map((metric, index) => (
                <div
                  key={metric.id}
                  className="relative flex flex-col items-center md:items-start"
                >
                  {/* Divisória Vertical (Apenas Desktop - md:) */}
                  {index !== 0 && (
                    <div className="hidden md:block absolute left-0 top-0 bottom-0 w-px bg-linear-to-b from-transparent via-forest-ink/20 to-transparent opacity-60" />
                  )}

                  <div
                    className={`flex flex-col items-center md:items-start w-full ${index !== 0 ? "md:pl-6" : ""}`}
                  >
                    <span className="text-xs font-medium text-slate uppercase tracking-wider flex items-center gap-1.5">
                      {metric.isHighlight && (
                        <Activity
                          size={12}
                          className="text-lime-voltage"
                          aria-hidden="true"
                        />
                      )}
                      {metric.label}
                    </span>

                    <span
                      className={`text-2xl sm:text-3xl font-extrabold mt-1 tracking-tight ${
                        metric.isHighlight
                          ? "text-lime-voltage bg-forest-ink px-2.5 py-1 rounded-xl inline-block"
                          : "text-obsidian"
                      }`}
                    >
                      {metric.value}
                    </span>
                  </div>

                  {/* Divisória Horizontal da sua classe (Apenas Mobile nas duas primeiras métricas) */}
                  {index < 2 && (
                    <div className="md:hidden w-full h-px mt-6 bg-linear-to-r from-transparent via-forest-ink/20 to-transparent opacity-60" />
                  )}
                </div>
              ))}
            </div>
          </motion.div>

          {/* Linha Divisória de Fundo (Horizontal) */}
          <div className="w-full h-px mt-16 bg-linear-to-r from-transparent via-forest-ink/20 to-transparent opacity-60" />
        </motion.div>
      </section>

      {/* Modal Conectado */}
      <ConnectWalletModal
        isOpen={isModalOpen}
        onClose={handleCloseModal}
        onSelectWallet={handleSelectWallet}
        wallets={availableWallets}
      />
    </>
  );
};
