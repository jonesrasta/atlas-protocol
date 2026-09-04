import React, { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { ChevronDown } from "lucide-react";

export interface FAQItem {
  q: string;
  a: string;
}

const FAQS: FAQItem[] = [
  {
    q: "How does Nodus eliminate Impermanent Loss?",
    a: "Nodus uses dynamic algorithmic balancing and single-sided liquidity vaults to mitigate impermanent loss risk significantly compared to traditional AMMs.",
  },
  {
    q: "Are my funds held by Nodus?",
    a: "No. Nodus is 100% non-custodial. You maintain total ownership of your private keys and assets at all times through smart contract execution.",
  },
  {
    q: "What are the gas fees on Nodus?",
    a: "By leveraging Layer 2 networks like Arbitrum, Polygon, and optimized EVM routes, transaction fees on NODUS are typically under $0.05 per trade.",
  },
  {
    q: "How are yield APYs calculated and distributed?",
    a: "Yields are generated real-time from swap fees and automated yield strategy compounding, distributed directly into your connected wallet.",
  },
  {
    q: "Is there a minimum lock-up period or minimum deposit?",
    a: "No. Nodus features zero minimum deposits and zero lock-up periods for standard liquidity pools. You can deposit and withdraw your assets anytime with instant liquidity.",
  },
  {
    q: "Which Web3 wallets are currently supported?",
    a: "NODUS natively supports all major EVM-compatible wallets including MetaMask, Coinbase Wallet, Rainbow, Rabby, and any wallet compatible with WalletConnect.",
  },
];

export const FAQSection: React.FC = () => {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section className="py-10 px-4 max-w-4xl mx-auto">
      <div className="text-center mb-14">
        <h2 className="text-3xl font-black text-forest-ink">
          Frequently Asked Questions
        </h2>
        <p className="text-slate text-sm mt-2">
          Everything you need to know about the protocol.
        </p>
      </div>

      <div className="flex flex-col gap-3">
        {FAQS.map((faq, idx) => {
          const isOpen = openIndex === idx;
          return (
            <div
              key={idx}
              className="border-[0.1px] border-pebble/30 rounded-2xl overflow-hidden bg-paper"
            >
              <button
                onClick={() => setOpenIndex(isOpen ? null : idx)}
                className="w-full p-5 text-left flex items-center justify-between font-bold text-forest-ink text-sm sm:text-base cursor-pointer"
                aria-expanded={isOpen}
              >
                <span>{faq.q}</span>
                <ChevronDown
                  size={18}
                  className={`transition-transform duration-200 text-slate shrink-0 ml-4 ${isOpen ? "rotate-180" : ""}`}
                />
              </button>
              <AnimatePresence>
                {isOpen && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    transition={{ duration: 0.2, ease: "easeInOut" }}
                    className="overflow-hidden"
                  >
                    {/* Divisor Visual com Gradient Personalizado */}
                    <div className="mx-5 h-px bg-linear-to-r from-transparent via-pebble/80 to-transparent opacity-40" />

                    {/* Conteúdo da Resposta */}
                    <p className="p-5 text-slate text-xs sm:text-sm leading-relaxed">
                      {faq.a}
                    </p>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          );
        })}
      </div>
    </section>
  );
};
