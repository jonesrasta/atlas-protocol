import React, { useState, useEffect } from "react";
import { motion, AnimatePresence, useReducedMotion } from "framer-motion";
import { ChevronDown, Wallet, Check, Layers, Hexagon, Zap } from "lucide-react";
import { SegmentedControl } from "../components/SegmentedControl";
import { ConnectWalletModal } from "../components/ConnectWalletModal";
import type { WalletOption } from "../components/ConnectWalletModal";
import { NAV_SECTIONS, type NavSectionOption } from "../constants/navigation";

export interface NetworkOption {
  id: string;
  name: string;
  color: string;
  icon: React.ElementType;
}

export interface NavbarProps {
  isConnected?: boolean;
  walletAddress?: string;
  currentNetwork?: string;
  onConnectWallet?: (walletId: string) => void;
  onNetworkChange?: (networkId: string) => void;
  availableWallets?: WalletOption[];
}

const NETWORKS: NetworkOption[] = [
  { id: "eth", name: "Ethereum", color: "bg-emerald-500", icon: Layers },
  { id: "polygon", name: "Polygon", color: "bg-purple-500", icon: Hexagon },
  { id: "arbitrum", name: "Arbitrum", color: "bg-blue-500", icon: Zap },
];

const SPRING_BUTTON = { type: "spring" as const, stiffness: 400, damping: 25 };

export const Navbar: React.FC<NavbarProps> = ({
  isConnected = false,
  walletAddress = "0x71C...39A1",
  currentNetwork = "eth",
  onConnectWallet,
  onNetworkChange,
  availableWallets,
}) => {
  const [isNetworkMenuOpen, setIsNetworkMenuOpen] = useState(false);
  const [isWalletModalOpen, setIsWalletModalOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  
  // Controle de rede selecionada localmente (ou via prop)
  const [localNetworkId, setLocalNetworkId] = useState<string | null>(null);
  const [activeSection, setActiveSection] = useState<string>("");

  const shouldReduceMotion = useReducedMotion();

  // Deriva a rede atual combinando a prop externa e a seleção local (sem triggering de renderização extra)
  const activeNetworkId = localNetworkId ?? currentNetwork;
  const activeNetwork =
    NETWORKS.find(
      (n) => n.id === activeNetworkId || n.name.toLowerCase() === activeNetworkId.toLowerCase()
    ) || NETWORKS[0];

  // Observador de Rolagem para atualizar a seção ativa
  useEffect(() => {
    const sectionIds = ["hero", ...NAV_SECTIONS.map((sec) => sec.id)];

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const id = entry.target.id;
            setActiveSection(id === "hero" ? "" : id);
          }
        });
      },
      {
        rootMargin: "-30% 0px -50% 0px",
        threshold: 0,
      }
    );

    sectionIds.forEach((id) => {
      const el = document.getElementById(id);
      if (el) observer.observe(el);
    });

    return () => observer.disconnect();
  }, []);

  const handleSelectNetwork = (networkId: string) => {
    setLocalNetworkId(networkId);
    onNetworkChange?.(networkId);
    setIsNetworkMenuOpen(false);
  };

  const handleWalletClick = () => {
    if (!isConnected) {
      setIsWalletModalOpen(true);
      setIsMobileMenuOpen(false);
    }
  };

  const handleSelectWallet = (walletId: string) => {
    onConnectWallet?.(walletId);
    setIsWalletModalOpen(false);
  };

  const handleSectionClick = (section: NavSectionOption) => {
    setActiveSection(section.id);
    setIsMobileMenuOpen(false);

    setTimeout(() => {
      const targetId = section.href.replace(/^#/, "");
      const element = document.getElementById(targetId);

      if (element) {
        const navbarOffset = 70;
        const elementPosition = element.getBoundingClientRect().top;
        const offsetPosition =
          elementPosition + window.pageYOffset - navbarOffset;

        window.scrollTo({
          top: offsetPosition,
          behavior: "smooth",
        });
      }
    }, 100);
  };

  const handleLogoClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    e.preventDefault();
    setIsMobileMenuOpen(false);
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  };

  const ActiveIcon = activeNetwork.icon;

  return (
    <>
      <header className="fixed top-0 z-50 w-full h-17 bg-paper/95 backdrop-blur-md border-b border-fog shadow-xs">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 h-full flex items-center justify-between gap-4">
          
          {/* LOGO DE MARCA */}
          <div className="flex items-center h-full">
            <a
              href="#hero"
              onClick={handleLogoClick}
              className="text-2xl font-black italic tracking-tighter text-forest-ink uppercase focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage rounded-lg py-1 cursor-pointer transition-opacity hover:opacity-90"
              aria-label="Nodus DeFi Home"
            >
              NODUS<span className="text-lime-voltage">.DeFi</span>
            </a>
          </div>

          {/* NAVEGAÇÃO DESKTOP (CENTRO) */}
          <div className="hidden md:flex justify-center items-center h-full">
            <SegmentedControl />
          </div>

          {/* AÇÕES DIREITA */}
          <div className="flex items-center justify-end gap-2.5 sm:gap-3 h-full">
            
            {/* SELETOR DE REDE DESKTOP */}
            <div className="relative hidden sm:flex items-center h-full">
              <motion.button
                whileHover={shouldReduceMotion ? {} : { scale: 1.02 }}
                whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
                transition={SPRING_BUTTON}
                onClick={() => setIsNetworkMenuOpen((prev) => !prev)}
                aria-expanded={isNetworkMenuOpen}
                aria-haspopup="listbox"
                aria-label="Selecionar Rede Blockchain"
                className="flex items-center gap-2 text-xs font-bold bg-fog px-3.5 py-2 rounded-full border border-pebble/30 text-forest-ink hover:bg-pebble/20 hover:border-pebble/60 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink transition-all cursor-pointer"
              >
                <ActiveIcon className="w-3.5 h-3.5 text-forest-ink" aria-hidden="true" />
                <span
                  className={`w-2 h-2 rounded-full ${activeNetwork.color} ring-2 ring-paper`}
                  aria-hidden="true"
                />
                <span>{activeNetwork.name}</span>
                <ChevronDown
                  size={14}
                  className={`transition-transform duration-200 text-slate ${
                    isNetworkMenuOpen ? "rotate-180" : ""
                  }`}
                  aria-hidden="true"
                />
              </motion.button>

              {/* DROPDOWN DESKTOP */}
              <AnimatePresence>
                {isNetworkMenuOpen && (
                  <motion.ul
                    initial={{ opacity: 0, y: 8, scale: 0.96 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 8, scale: 0.96 }}
                    transition={{ duration: 0.15, ease: "easeOut" }}
                    role="listbox"
                    className="absolute right-0 top-full mt-2 w-48 p-1.5 bg-paper rounded-2xl border border-pebble/30 shadow-xl z-50 flex flex-col gap-1"
                  >
                    <div className="px-3 py-1.5 text-[10px] font-bold uppercase tracking-wider text-slate">
                      Select Network
                    </div>
                    {NETWORKS.map((net) => {
                      const isSelected = net.id === activeNetwork.id;
                      const Icon = net.icon;
                      return (
                        <li key={net.id} role="option" aria-selected={isSelected}>
                          <button
                            onClick={() => handleSelectNetwork(net.id)}
                            className={`w-full flex items-center justify-between px-3 py-2 text-xs font-semibold rounded-xl transition-colors cursor-pointer ${
                              isSelected
                                ? "bg-fog text-forest-ink font-bold"
                                : "text-slate hover:text-forest-ink hover:bg-fog/60"
                            }`}
                          >
                            <span className="flex items-center gap-2.5">
                              <Icon size={14} className="text-forest-ink" />
                              <span
                                className={`w-2 h-2 rounded-full ${net.color}`}
                              />
                              {net.name}
                            </span>
                            {isSelected && (
                              <Check size={14} className="text-forest-ink" />
                            )}
                          </button>
                        </li>
                      );
                    })}
                  </motion.ul>
                )}
              </AnimatePresence>
            </div>

            {/* BOTÃO CONECTAR CARTEIRA */}
            <motion.button
              whileHover={shouldReduceMotion ? {} : { scale: 1.02 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
              transition={SPRING_BUTTON}
              onClick={handleWalletClick}
              className="flex items-center gap-2 text-xs font-semibold bg-forest-ink text-lime-voltage px-4 py-2.5 rounded-full shadow-sm hover:shadow-md hover:bg-forest-ink/95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage focus-visible:ring-offset-2 cursor-pointer transition-all"
              aria-label={
                isConnected
                  ? `Carteira conectada: ${walletAddress}`
                  : "Conectar Carteira Web3"
              }
            >
              <Wallet size={16} aria-hidden="true" />
              <span>{isConnected ? walletAddress : "Connect Wallet"}</span>
            </motion.button>

            {/* Hamburger Customizado */}
            <button
              type="button"
              onClick={() => setIsMobileMenuOpen((prev) => !prev)}
              className="md:hidden flex flex-col justify-center items-center w-9 h-9 gap-1.25 cursor-pointer rounded-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
              aria-label="Alternar Menu"
              aria-expanded={isMobileMenuOpen}
            >
              <motion.div
                animate={
                  isMobileMenuOpen
                    ? { rotate: 45, y: 6.5 }
                    : { rotate: 0, y: 0 }
                }
                transition={{ duration: 0.2, ease: "easeInOut" }}
                className="w-7 h-0.5 bg-forest-ink"
              />
              <motion.div
                animate={
                  isMobileMenuOpen
                    ? { opacity: 0, scaleX: 0 }
                    : { opacity: 1, scaleX: 1 }
                }
                transition={{ duration: 0.15 }}
                className="w-7 h-0.5 bg-forest-ink"
              />
              <motion.div
                animate={
                  isMobileMenuOpen
                    ? { rotate: -45, y: -6.5 }
                    : { rotate: 0, y: 0 }
                }
                transition={{ duration: 0.2, ease: "easeInOut" }}
                className="w-7 h-0.5 bg-forest-ink"
              />
            </button>
          </div>
        </div>

        {/* MENU MOBILE SLIDE-DOWN */}
        <AnimatePresence>
          {isMobileMenuOpen && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              transition={{ duration: 0.25, ease: "easeInOut" }}
              className="md:hidden overflow-hidden bg-paper/95 backdrop-blur-xl border-b border-fog shadow-2xl relative z-50 max-h-[calc(100vh-4rem)] overflow-y-auto"
            >
              <div className="p-5 flex flex-col gap-5 max-w-md mx-auto">
                
                {/* NAVEGAÇÃO DE SEÇÕES MOBILE */}
                <nav className="bg-fog/60 border border-pebble/20 rounded-2xl p-1.5 flex flex-col gap-1">
                  {NAV_SECTIONS.map((sec) => {
                    const isActive = activeSection === sec.id;
                    return (
                      <button
                        key={sec.id}
                        onClick={() => handleSectionClick(sec)}
                        className={`w-full py-4 px-4 rounded-xl font-medium text-lg transition-all cursor-pointer text-center ${
                          isActive
                            ? "bg-lime-voltage text-forest-ink shadow-xs font-semibold"
                            : "text-forest-ink/70 hover:text-forest-ink hover:bg-paper/50"
                        }`}
                      >
                        {sec.label}
                      </button>
                    );
                  })}
                </nav>

                {/* SELETOR DE REDES MOBILE COM ÍCONES */}
                <div className="flex flex-col gap-2.5 px-1">
                  <span className="text-sm font-bold uppercase tracking-wider text-slate">
                    Select Chain
                  </span>
                  <div className="grid grid-cols-3 gap-2">
                    {NETWORKS.map((net) => {
                      const isSelected = net.id === activeNetwork.id;
                      const Icon = net.icon;
                      return (
                        <button
                          key={net.id}
                          onClick={() => {
                            handleSelectNetwork(net.id);
                            setIsMobileMenuOpen(false);
                          }}
                          className={`py-2.5 px-3 rounded-xl text-xs font-bold flex items-center justify-center gap-1.5 border transition-all cursor-pointer ${
                            isSelected
                              ? "bg-forest-ink text-lime-voltage border-forest-ink shadow-xs"
                              : "bg-fog border-pebble/20 text-slate hover:bg-pebble/20"
                          }`}
                        >
                          <Icon size={14} />
                          <span
                            className={`w-1.5 h-1.5 rounded-full ${net.color}`}
                          />
                          <span>{net.name}</span>
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* AÇÃO PRINCIPAL MOBILE */}
                <button
                  onClick={handleWalletClick}
                  className="w-full py-4 bg-forest-ink text-lime-voltage font-black text-base rounded-2xl flex items-center justify-center gap-2.5 shadow-lg active:scale-[0.98] transition-all cursor-pointer mt-1"
                >
                  <Wallet size={18} />
                  <span>{isConnected ? walletAddress : "Connect Wallet"}</span>
                </button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </header>

      {/* BACKDROP OVERLAY */}
      <AnimatePresence>
        {isMobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2 }}
            onClick={() => setIsMobileMenuOpen(false)}
            className="fixed inset-0 top-16 z-40 bg-obsidian/80 backdrop-blur-[2px] md:hidden"
          />
        )}
      </AnimatePresence>

      {/* MODAL DE CARTEIRA */}
      <ConnectWalletModal
        isOpen={isWalletModalOpen}
        onClose={() => setIsWalletModalOpen(false)}
        onSelectWallet={handleSelectWallet}
        wallets={availableWallets}
      />
    </>
  );
};