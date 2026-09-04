import React, { useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import type { Variants } from "framer-motion";
import { X, ExternalLink, ShieldCheck, Check } from "lucide-react";

export interface WalletOption {
  id: string;
  name: string;
  description: string;
  iconUrl?: string;
  badge?: string;
  isInstalled?: boolean;
}

export interface ConnectWalletModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSelectWallet: (walletId: string) => void;
  wallets?: WalletOption[];
}

const DEFAULT_WALLETS: WalletOption[] = [
  {
    id: "metamask",
    name: "MetaMask",
    description: "Connect using your browser extension or mobile app",
    iconUrl: "/icons/wallets/metaMask.svg",
    badge: "Popular",
    isInstalled: true,
  },
  {
    id: "walletconnect",
    name: "WalletConnect",
    description: "Scan with Rainbow, Trust Wallet, or 100+ other wallets",
    iconUrl: "/icons/wallets/walletConnect.svg",
    badge: "QR Code",
    isInstalled: true,
  },
  {
    id: "coinbase",
    name: "Coinbase Wallet",
    description: "Connect with Coinbase self-custody wallet",
    iconUrl: "/icons/wallets/coinbase.svg",
    isInstalled: false,
  },
  {
    id: "phantom",
    name: "Phantom",
    description: "Connect to multi-chain wallet (EVM & Solana)",
    iconUrl: "/icons/wallets/phantom.svg",
    isInstalled: false,
  },
];

// Tipagem explicita como Variants para o Framer Motion
const OVERLAY_VARIANTS: Variants = {
  hidden: { opacity: 0 },
  visible: { opacity: 1 },
};

const MODAL_VARIANTS: Variants = {
  hidden: { opacity: 0, scale: 0.95, y: 12 },
  visible: {
    opacity: 1,
    scale: 1,
    y: 0,
    transition: { type: "spring", stiffness: 350, damping: 25 },
  },
  exit: {
    opacity: 0,
    scale: 0.95,
    y: 8,
    transition: { duration: 0.15 },
  },
};

export const ConnectWalletModal: React.FC<ConnectWalletModalProps> = ({
  isOpen,
  onClose,
  onSelectWallet,
  wallets = DEFAULT_WALLETS,
}) => {
  // Fecha com a tecla ESC
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape" && isOpen) {
        onClose();
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  // Trava scroll da página quando modal está aberto
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "unset";
    }
    return () => {
      document.body.style.overflow = "unset";
    };
  }, [isOpen]);

  return (
    <AnimatePresence>
      {isOpen && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6"
          role="dialog"
          aria-modal="true"
          aria-labelledby="connect-wallet-title"
        >
          {/* Fundo Escuro / Overlay */}
          <motion.div
            variants={OVERLAY_VARIANTS}
            initial="hidden"
            animate="visible"
            exit="hidden"
            onClick={onClose}
            className="fixed inset-0 bg-obsidian/80 backdrop-blur-xs"
          />

          {/* Container Principal */}
          <motion.div
            variants={MODAL_VARIANTS}
            initial="hidden"
            animate="visible"
            exit="exit"
            className="relative w-full max-w-md bg-[#ffffffc7] border border-pebble/30 rounded-largecards p-6 sm:p-8 shadow-2xl z-10 overflow-hidden"
          >
            {/* Header */}
            <div className="flex items-center justify-between pb-4 border-b border-pebble/20">
              <div>
                <h2
                  id="connect-wallet-title"
                  className="text-xl sm:text-2xl font-black font-wise-sans text-obsidian tracking-tight"
                >
                  Connect Wallet
                </h2>
                <p className="text-xs sm:text-sm text-slate mt-0.5">
                  Choose your preferred wallet to access Nodus
                </p>
              </div>

              <button
                onClick={onClose}
                className="p-2 text-slate hover:text-obsidian hover:bg-fog rounded-full transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
                aria-label="Close modal"
              >
                <X size={20} />
              </button>
            </div>

            {/* Wallet Options */}
            <div className="mt-5 space-y-3 max-h-[60vh] overflow-y-auto pr-1">
              {wallets.map((wallet) => (
                <button
                  key={wallet.id}
                  onClick={() => {
                    onSelectWallet(wallet.id);
                    onClose();
                  }}
                  className="w-full text-left p-4 rounded-cards bg-paper/30 hover:bg-fog/60 border-[0.1px] border-pebble/30 hover:border-forest-ink/20 transition-all flex items-center justify-between group focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage"
                >
                  <div className="flex items-center gap-3.5">
                    <div className="w-10 h-10 rounded-xl bg-forest-ink/5 border border-forest-ink/10 flex items-center justify-center font-bold text-forest-ink group-hover:scale-105 transition-transform shrink-0">
                      {wallet.iconUrl ? (
                        <img
                          src={wallet.iconUrl}
                          alt={wallet.name}
                          className="w-6 h-6 object-contain"
                        />
                      ) : (
                        wallet.name.charAt(0)
                      )}
                    </div>

                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-obsidian text-base group-hover:text-forest-ink transition-colors">
                          {wallet.name}
                        </span>
                        {wallet.badge && (
                          <span className="text-[10px] font-semibold px-2 py-0.5 rounded-full bg-linen-mist text-spruce">
                            {wallet.badge}
                          </span>
                        )}
                      </div>
                      <p className="text-xs text-slate line-clamp-1 mt-0.5">
                        {wallet.description}
                      </p>
                    </div>
                  </div>

                  {wallet.isInstalled && (
                    <span className="text-spruce opacity-0 group-hover:opacity-100 transition-opacity">
                      <Check size={18} />
                    </span>
                  )}
                </button>
              ))}
            </div>

            {/* Footer */}
            <div className="mt-6 pt-4 border-t border-pebble/20 flex flex-col gap-3">
              <div className="flex items-center gap-2 text-xs text-slate">
                <ShieldCheck size={16} className="text-spruce shrink-0" />
                <span>By connecting, you agree to Nodus Terms & Privacy.</span>
              </div>

              <a
                href="#learn-wallets"
                className="inline-flex items-center gap-1.5 text-xs font-semibold text-signal-blue hover:underline w-fit"
              >
                <span>New to Web3 wallets? Learn more</span>
                <ExternalLink size={12} />
              </a>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
};
