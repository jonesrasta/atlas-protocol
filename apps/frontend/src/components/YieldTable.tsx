import React, { useState, useMemo } from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { ArrowUpRight, ArrowUpDown, ArrowUp, ArrowDown, ShieldAlert, ShieldCheck } from 'lucide-react';

export interface YieldPool {
  id: string;
  pair: string;
  protocol: string;
  tvl: string;
  tvlRaw: number;
  apy: string;
  apyRaw: number;
  risk: 'Low' | 'Medium' | 'High';
  isPopular?: boolean;
}

export interface YieldTableProps {
  pools?: YieldPool[];
  onDeposit?: (pool: YieldPool) => void;
  onViewAll?: () => void;
}

const DEFAULT_POOLS: YieldPool[] = [
  { id: '1', pair: 'ETH / USDC', protocol: 'Uniswap V3', tvl: '$240.5M', tvlRaw: 240500000, apy: '14.2%', apyRaw: 14.2, risk: 'Low', isPopular: true },
  { id: '2', pair: 'WBTC / ETH', protocol: 'Curve Finance', tvl: '$180.2M', tvlRaw: 180200000, apy: '8.6%', apyRaw: 8.6, risk: 'Low' },
  { id: '3', pair: 'NODUS / ETH', protocol: 'Nodus Vaults', tvl: '$45.8M', tvlRaw: 45800000, apy: '32.4%', apyRaw: 32.4, risk: 'Medium', isPopular: true },
];

const SPRING_PHYSICS = { type: 'spring' as const, stiffness: 400, damping: 25 };

export const YieldTable: React.FC<YieldTableProps> = ({
  pools = DEFAULT_POOLS,
  onDeposit,
  onViewAll,
}) => {
  const shouldReduceMotion = useReducedMotion();

  // Mantém apenas o estado das preferências de ordenação
  const [sortField, setSortField] = useState<'tvlRaw' | 'apyRaw'>('apyRaw');
  const [sortAsc, setSortAsc] = useState<boolean>(false);

  // Derivação direta: calcula a lista ordenada dinamicamente sem acionar re-renderizações em cascata
  const sortedData = useMemo(() => {
    return [...pools].sort((a, b) => {
      return sortAsc ? a[sortField] - b[sortField] : b[sortField] - a[sortField];
    });
  }, [pools, sortField, sortAsc]);

  const handleSort = (field: 'tvlRaw' | 'apyRaw') => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(false);
    }
  };

  const renderSortIcon = (field: 'tvlRaw' | 'apyRaw') => {
    if (sortField !== field) {
      return <ArrowUpDown size={12} className="text-slate/60" />;
    }
    return sortAsc ? (
      <ArrowUp size={12} className="text-forest-ink" />
    ) : (
      <ArrowDown size={12} className="text-forest-ink" />
    );
  };

  const getRiskBadge = (risk: YieldPool['risk']) => {
    switch (risk) {
      case 'Low':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-600 border border-emerald-500/20">
            <ShieldCheck size={12} /> Low Risk
          </span>
        );
      case 'Medium':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold px-2 py-0.5 rounded-full bg-amber-500/10 text-amber-600 border border-amber-500/20">
            <ShieldAlert size={12} /> Medium Risk
          </span>
        );
      case 'High':
        return (
          <span className="inline-flex items-center gap-1 text-[11px] font-semibold px-2 py-0.5 rounded-full bg-rose-500/10 text-rose-600 border border-rose-500/20">
            <ShieldAlert size={12} /> High Risk
          </span>
        );
    }
  };

  return (
    <section className="py-10 px-4 sm:px-6 max-w-7xl mx-auto w-full">
      <div className="flex justify-between items-end mb-6">
        <div>
          <h2 className="text-2xl sm:text-3xl font-bold text-obsidian tracking-tight">
            Top Yield Pools
          </h2>
          <p className="text-sm text-slate mt-1">
            Deposit assets to earn automated yield with optimized gas routes.
          </p>
        </div>
        <motion.button
          whileHover={shouldReduceMotion ? {} : { x: 2 }}
          onClick={onViewAll}
          className="text-sm font-semibold text-forest-ink flex items-center gap-1 hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink rounded-md px-1"
        >
          View All Pools <ArrowUpRight size={16} aria-hidden="true" />
        </motion.button>
      </div>

      {/* VIEW DESKTOP */}
      <div className="hidden md:block overflow-hidden bg-fog rounded-3xl border border-pebble/30 shadow-xs">
        <table className="w-full text-left border-collapse" aria-label="Tabela de Liquidez e Yield">
          <thead>
            <tr className="text-xs font-semibold text-slate border-b border-pebble/20">
              <th scope="col" className="p-6">Pool Pair</th>
              <th scope="col" className="p-6">Strategy</th>
              <th scope="col" className="p-6">Risk Level</th>
              <th 
                scope="col" 
                className="p-6 cursor-pointer hover:text-obsidian select-none transition-colors" 
                onClick={() => handleSort('tvlRaw')}
              >
                <div className="flex items-center gap-1.5">
                  <span className={sortField === 'tvlRaw' ? 'font-bold text-obsidian' : ''}>TVL</span>
                  {renderSortIcon('tvlRaw')}
                </div>
              </th>
              <th 
                scope="col" 
                className="p-6 cursor-pointer hover:text-obsidian select-none transition-colors" 
                onClick={() => handleSort('apyRaw')}
              >
                <div className="flex items-center gap-1.5">
                  <span className={sortField === 'apyRaw' ? 'font-bold text-obsidian' : ''}>APY</span>
                  {renderSortIcon('apyRaw')}
                </div>
              </th>
              <th scope="col" className="p-6 text-right">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-pebble/20">
            {sortedData.length > 0 ? (
              sortedData.map((pool) => (
                <motion.tr
                  key={pool.id}
                  whileHover={shouldReduceMotion ? {} : { backgroundColor: 'var(--color-paper, rgba(255, 255, 255, 0.8))' }}
                  transition={{ duration: 0.15 }}
                  className="transition-colors group"
                >
                  <td className="p-6 font-extrabold text-obsidian flex items-center gap-2">
                    <span>{pool.pair}</span>
                    {pool.isPopular && (
                      <span className="text-[10px] bg-forest-ink text-lime-voltage font-bold px-2 py-0.5 rounded-full">
                        HOT
                      </span>
                    )}
                  </td>
                  <td className="p-6 text-sm text-slate font-medium">{pool.protocol}</td>
                  <td className="p-6">{getRiskBadge(pool.risk)}</td>
                  <td className="p-6 text-sm font-bold text-obsidian">{pool.tvl}</td>
                  <td className="p-6">
                    <span className="bg-lime-voltage/20 text-forest-ink text-xs font-black px-3 py-1 rounded-lg border border-lime-voltage/30">
                      {pool.apy}
                    </span>
                  </td>
                  <td className="p-6 text-right">
                    <motion.button
                      whileHover={shouldReduceMotion ? {} : { scale: 1.05 }}
                      whileTap={shouldReduceMotion ? {} : { scale: 0.95 }}
                      transition={SPRING_PHYSICS}
                      onClick={() => onDeposit?.(pool)}
                      className="px-5 py-2 text-xs font-bold bg-forest-ink text-paper rounded-full hover:bg-forest-ink/90 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage"
                    >
                      Deposit
                    </motion.button>
                  </td>
                </motion.tr>
              ))
            ) : (
              <tr>
                <td colSpan={6} className="p-8 text-center text-slate text-sm font-medium">
                  No pools available at the moment.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* VIEW MOBILE */}
      <div className="flex flex-col gap-3 md:hidden">
        <div className="flex items-center justify-between px-1 mb-1">
          <span className="text-xs font-bold text-slate uppercase">Sort by</span>
          <div className="flex gap-2">
            <button
              onClick={() => handleSort('apyRaw')}
              className={`px-3 py-1 text-xs rounded-full border font-bold transition-colors ${
                sortField === 'apyRaw'
                  ? 'bg-forest-ink text-paper border-forest-ink'
                  : 'bg-fog text-slate border-pebble/30'
              }`}
            >
              APY {sortField === 'apyRaw' && (sortAsc ? '↑' : '↓')}
            </button>
            <button
              onClick={() => handleSort('tvlRaw')}
              className={`px-3 py-1 text-xs rounded-full border font-bold transition-colors ${
                sortField === 'tvlRaw'
                  ? 'bg-forest-ink text-paper border-forest-ink'
                  : 'bg-fog text-slate border-pebble/30'
              }`}
            >
              TVL {sortField === 'tvlRaw' && (sortAsc ? '↑' : '↓')}
            </button>
          </div>
        </div>

        {sortedData.length > 0 ? (
          sortedData.map((pool) => (
            <div
              key={pool.id}
              className="p-5 bg-fog rounded-2xl border border-pebble/30 flex flex-col gap-4 shadow-xs"
            >
              <div className="flex justify-between items-start">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-lg font-black text-obsidian">{pool.pair}</span>
                    {pool.isPopular && (
                      <span className="text-[9px] bg-forest-ink text-lime-voltage font-bold px-1.5 py-0.5 rounded-full">
                        HOT
                      </span>
                    )}
                  </div>
                  <p className="text-xs text-slate font-medium mt-0.5">{pool.protocol}</p>
                </div>
                <span className="bg-lime-voltage/20 text-forest-ink text-xs font-black px-3 py-1 rounded-lg border border-lime-voltage/30">
                  {pool.apy}
                </span>
              </div>

              <div className="flex justify-between items-center pt-2 border-t border-pebble/20">
                <div className="flex flex-col">
                  <span className="text-[10px] text-slate uppercase font-semibold">TVL</span>
                  <span className="text-sm font-bold text-obsidian">{pool.tvl}</span>
                </div>
                {getRiskBadge(pool.risk)}
              </div>

              <motion.button
                whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
                transition={SPRING_PHYSICS}
                onClick={() => onDeposit?.(pool)}
                className="w-full py-3 text-xs font-bold bg-forest-ink text-paper rounded-full flex items-center justify-center gap-1 shadow-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage"
              >
                Deposit Assets
              </motion.button>
            </div>
          ))
        ) : (
          <div className="p-8 text-center text-slate text-sm font-medium bg-fog rounded-2xl border border-pebble/30">
            No pools available at the moment.
          </div>
        )}
      </div>
    </section>
  );
};