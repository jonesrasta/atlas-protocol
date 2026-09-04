// src/types/wallet.ts
export interface WalletOption {
  id: string;
  name: string;
  description: string;
  iconUrl?: string;
  badge?: string;
  isInstalled?: boolean;
}