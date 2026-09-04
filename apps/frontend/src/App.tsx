import { useState } from "react";
import { Navbar } from "./layout/Navbar";
import { HeroSection } from "./components/HeroSection";
import { FeatureCard } from "./components/FeatureCard";
import { CurrencyConverterCard } from "./components/CurrencyConverterCard";
import { HowItWorksSection } from "./components/HowItWorksSection";
import { SwapWidgetCard } from "./components/SwapWidgetCard";
import { YieldTable, type YieldPool } from "./components/YieldTable";
import { SecuritySection } from "./components/SecuritySection";
import { SupportedNetworksSection } from "./components/SupportedNetworksSection";
import { GasTrackerBadge } from "./components/GasTrackerBadge";
import { FAQSection } from "./components/FAQSection";
import { FinalCTASection } from "./components/FinalCTASection";
import { Footer } from "./layout/Footer";

// Mapeamento dos ícones para os FeatureCards
import { Zap, ShieldCheck, Check } from "lucide-react";

export default function App() {
  // Estado para integração entre a Tabela de Yield e o Widget de Swap
  const [selectedPool, setSelectedPool] = useState<YieldPool | null>(null);

  const handleSelectPool = (pool: YieldPool) => {
    setSelectedPool(pool);
    // Rola suavemente até o SwapWidget se o usuário clicar em "Deposit"
    const widgetElement = document.getElementById("swap");
    if (widgetElement) {
      widgetElement.scrollIntoView({ behavior: "smooth" });
    }
  };

  const handleScrollToSwap = () => {
    const widgetElement = document.getElementById("swap");
    if (widgetElement) {
      widgetElement.scrollIntoView({ behavior: "smooth" });
    }
  };

  return (
    <div className="min-h-screen flex flex-col font-sans antialiased text-charcoal bg-paper selection:bg-lime-voltage selection:text-forest-ink">
      {/* Atalho de Acessibilidade (WCAG) */}
      <a
        href="#main-content"
        className="sr-only focus:not-sr-only focus:absolute focus:z-50 focus:p-4 focus:bg-forest-ink focus:text-lime-voltage focus:font-bold focus:rounded-br-2xl focus:outline-none"
      >
        Skip to main content
      </a>

      {/* 1. HEADER & NAVIGATION */}
      <Navbar />

      {/* ÁREA PRINCIPAL DA APLICAÇÃO */}
      <main id="main-content" className="grow">
        {/* 2. HERO SECTION */}
        <section id="hero">
          <HeroSection />
        </section>

        {/* 3. FEATURE ROW */}
        <section
          id="features"
          className="py-4 px-4 sm:px-6 bg-paper scroll-mt-10"
        >
          <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-3 gap-4">
            <FeatureCard
              icon={Zap}
              title="Sub-second Execution"
              description="Smart order routing sends your trades across optimal pools for minimal slippage and instant finality."
            />
            <FeatureCard
              icon={ShieldCheck}
              title="Non-Custodial Yield"
              description="Retain 100% control of your private keys. Smart contracts earn yield directly into your wallet."
            />
            <FeatureCard
              icon={Check}
              title="Cross-Chain Liquidity"
              description="Bridge and swap assets natively across 10+ EVM and non-EVM chains without wrapping tokens."
            />
          </div>
        </section>

        {/* 4. CURRENCY CONVERTER CARD */}
        <CurrencyConverterCard />

        {/* 5. HOW IT WORKS SECTION */}
        <div id="how-it-works" className="scroll-mt-10">
          <HowItWorksSection />
        </div>

        {/* 6. SWAP WIDGET CARD */}
        <section id="swap" className="py-8 scroll-mt-10">
          <SwapWidgetCard selectedPool={selectedPool} />
        </section>

        {/* 7. YIELD TABLE */}
        <div id="yield" className="scroll-mt-10">
          <YieldTable onDeposit={handleSelectPool} />
        </div>

        {/* 8. SECURITY & AUDITS SECTION */}
        <div id="security" className="scroll-mt-10">
          <SecuritySection />
        </div>

        {/* 9. SUPPORTED NETWORKS GRID */}
        <div id="networks" className="scroll-mt-10">
          <SupportedNetworksSection
            onSelectNetwork={(chain) =>
              console.log("Selected chain:", chain.name)
            }
          />
        </div>

        {/* 10. FREQUENTLY ASKED QUESTIONS */}
        <div id="faq" className="scroll-mt-20">
          <FAQSection />
        </div>

        {/* 11. FINAL CALL TO ACTION */}
        <FinalCTASection onStartClick={handleScrollToSwap} />
      </main>

      {/* COMPONENTE FLUTUANTE EM TEMPO REAL */}
      <GasTrackerBadge />

      {/* 12. FOOTER */}
      <Footer />
    </div>
  );
}
