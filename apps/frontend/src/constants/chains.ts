export interface ChainNetwork {
  name: string;
  symbol: string;
  status?: 'Operational' | 'Degraded' | 'Maintenance';
  latency?: string;
}

export const chainLogos: ChainNetwork[] = [
  {
    name: 'Ethereum',
    symbol: 'eth',
    status: 'Operational',
    latency: '12ms',
  },
  {
    name: 'Arbitrum',
    symbol: 'arb',
    status: 'Operational',
    latency: '15ms',
  },
  {
    name: 'Bitcoin',
    symbol: 'btc',
    status: 'Operational',
    latency: '18ms',
  },
  {
    name: 'Tether',
    symbol: 'usdt',
    status: 'Operational',
    latency: '14ms',
  },
  {
    name: 'Sui',
    symbol: 'sui',
    status: 'Operational',
    latency: '10ms',
  },
  {
    name: 'Solana',
    symbol: 'sol',
    status: 'Operational',
    latency: '8ms',
  },
  {
    name: 'Avalanche',
    symbol: 'avax',
    status: 'Operational',
    latency: '25ms',
  },
  {
    name: 'BNB Chain',
    symbol: 'bnb',
    status: 'Operational',
    latency: '30ms',
  },
];