import React from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { chainLogos as defaultChains } from '../constants/chains';

export interface ChainNetwork {
  name: string;
  symbol: string;
  status?: 'Operational' | 'Degraded' | 'Maintenance';
  latency?: string;
}

export interface SupportedNetworksSectionProps {
  chains?: ChainNetwork[];
  onSelectNetwork?: (chain: ChainNetwork) => void;
}

const SPRING_PHYSICS = { type: 'spring' as const, stiffness: 400, damping: 28 };

export const SupportedNetworksSection: React.FC<SupportedNetworksSectionProps> = ({
  chains = defaultChains as ChainNetwork[],
  onSelectNetwork,
}) => {
  const shouldReduceMotion = useReducedMotion();

  return (
    <section className="py-10 px-4 sm:px-6 max-w-7xl mx-auto w-full">
      <div className="flex flex-col gap-2 mb-8">
        <div className="flex items-center gap-2">
          <span className="px-2.5 py-0.5 rounded-full bg-forest-ink/10 text-forest-ink text-xs font-bold uppercase tracking-wider">
            Ecosystem
          </span>
        </div>
        <h3 className="text-2xl sm:text-3xl font-black text-obsidian tracking-tight">
          Supported Networks
        </h3>
        <p className="text-sm text-slate max-w-2xl leading-relaxed">
          Deploy capital seamlessly across top Layer 1s and Layer 2 scaling solutions with automated gas optimization.
        </p>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
        {chains.map((chain) => {
          const iconPath = `/icons/chains/${chain.symbol.toLowerCase().trim()}.svg`;

          return (
            <motion.div
              key={chain.name}
              whileHover={shouldReduceMotion ? {} : { y: -3, scale: 1.02 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
              transition={SPRING_PHYSICS}
              onClick={() => onSelectNetwork?.(chain)}
              role="button"
              tabIndex={0}
              onKeyDown={(e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                  e.preventDefault();
                  onSelectNetwork?.(chain);
                }
              }}
              className="group flex items-center justify-between p-3.5 rounded-2xl border border-pebble/30 shadow-xs bg-paper hover:bg-fog hover:border-forest-ink/20 transition-all cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
            >
              <div className="flex items-center gap-3 min-w-0">
                <div className="w-8 h-8 flex items-center justify-center shrink-0 rounded-full bg-fog border border-pebble/20 p-1 group-hover:border-forest-ink/30 transition-colors">
                  <img
                    src={iconPath}
                    alt={`${chain.name} icon`}
                    className="w-full h-full object-contain"
                  />
                </div>

                <div className="flex flex-col truncate">
                  <span className="text-sm font-bold text-obsidian truncate group-hover:text-forest-ink transition-colors">
                    {chain.name}
                  </span>
                  {chain.latency && (
                    <span className="text-[10px] text-slate font-medium">
                      {chain.latency}
                    </span>
                  )}
                </div>
              </div>

              <span
                className="w-2 h-2 rounded-full bg-emerald-500 shrink-0"
                title={`Status: ${chain.status || 'Operational'}`}
                aria-label={`Network ${chain.name} is ${chain.status || 'Operational'}`}
              />
            </motion.div>
          );
        })}
      </div>
    </section>
  );
};