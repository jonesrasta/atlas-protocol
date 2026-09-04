import React from 'react';
import { ArrowRight } from 'lucide-react';

export interface FinalCTASectionProps {
  onStartClick?: () => void;
}

export const FinalCTASection: React.FC<FinalCTASectionProps> = ({ onStartClick }) => {
  return (
    <section className="py-10 px-4 max-w-7xl mx-auto mb-12">
      <div className="relative overflow-hidden bg-forest-ink rounded-3xl p-8 sm:p-14 text-center sm:text-left flex flex-col md:flex-row items-center justify-between gap-8">
        
        {/* Glow Decorativo */}
        <div className="absolute -top-24 -right-24 w-72 h-72 bg-lime-voltage/20 rounded-full blur-3xl pointer-events-none" />

        <div className="max-w-xl z-10">
          <h2 className="text-3xl sm:text-5xl font-black text-paper leading-tight">
            Ready to maximize your <span className="text-lime-voltage">crypto yield?</span>
          </h2>
          <p className="text-paper/70 mt-4 text-sm sm:text-base">
            Connect your wallet now and start swapping or earning yield across multiple chains with zero friction.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-3 z-10 w-full sm:w-auto">
          <button
            onClick={onStartClick}
            className="px-8 py-4 bg-lime-voltage text-forest-ink font-extrabold text-sm rounded-full hover:scale-105 active:scale-95 transition-all flex items-center justify-center gap-2 cursor-pointer shadow-lg"
          >
            <span>Start Earning Now</span>
            <ArrowRight size={16} />
          </button>
        </div>
      </div>
    </section>
  );
};