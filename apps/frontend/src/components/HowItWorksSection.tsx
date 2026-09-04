import React from 'react';
import { motion } from 'framer-motion';
import { Wallet, ArrowLeftRight, TrendingUp } from 'lucide-react';

export interface StepItem {
  number: string;
  title: string;
  description: string;
  icon: React.ElementType;
}

const STEPS: StepItem[] = [
  {
    number: '01',
    title: 'Connect Wallet',
    description: 'Link your Web3 wallet (MetaMask, Coinbase, WalletConnect) in a single click with zero registration.',
    icon: Wallet,
  },
  {
    number: '02',
    title: 'Choose Pool or Swap',
    description: 'Select your preferred pair for instant zero-slippage swap or stake tokens into high-yield liquidity pools.',
    icon: ArrowLeftRight,
  },
  {
    number: '03',
    title: 'Start Earning',
    description: 'Watch your assets grow automatically with real-time yield distribution directly to your non-custodial wallet.',
    icon: TrendingUp,
  },
];

export const HowItWorksSection: React.FC = () => {
  return (
    <section className="py-14 px-4 max-w-7xl mx-auto">
      <div className="text-center max-w-2xl mx-auto mb-16">
        <span className="text-xs font-bold tracking-widest text-lime-voltage uppercase bg-forest-ink px-3 py-1 rounded-full">
          Simple Onboarding
        </span>
        <h2 className="text-3xl sm:text-4xl font-black text-forest-ink mt-4 tracking-tight">
          How Nodus Works
        </h2>
        <p className="text-slate mt-2 text-sm sm:text-base">
          Start swapping and earning yield in three seamless, permissionless steps.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 relative">
        {STEPS.map((step, index) => {
          const Icon = step.icon;
          return (
            <motion.div
              key={step.number}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.4, delay: index * 0.15 }}
              viewport={{ once: true }}
              className="relative bg-paper border border-pebble/40 rounded-3xl p-8 flex flex-col justify-between hover:border-lime-voltage/60 transition-all group"
            >
              <div>
                <div className="flex items-center justify-between mb-6">
                  <div className="w-12 h-12 rounded-2xl bg-fog flex items-center justify-center text-forest-ink group-hover:bg-lime-voltage transition-colors">
                    <Icon size={22} />
                  </div>
                  <span className="text-3xl font-black text-pebble/40 group-hover:text-forest-ink/20 transition-colors">
                    {step.number}
                  </span>
                </div>
                <h3 className="text-xl font-extrabold text-forest-ink mb-3">{step.title}</h3>
                <p className="text-slate text-xs sm:text-sm leading-relaxed">{step.description}</p>
              </div>
            </motion.div>
          );
        })}
      </div>
    </section>
  );
};