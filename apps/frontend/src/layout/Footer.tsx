import React from 'react';
import { motion, useReducedMotion } from 'framer-motion';
import { Send, ArrowUpRight } from 'lucide-react';
import { FaLinkedin, FaDiscord, FaGithub } from 'react-icons/fa';

export interface FooterProps {
  companyName?: string;
  copyrightYear?: number;
}

const FOOTER_NAV = [
  {
    title: 'Protocol',
    links: [
      { name: 'Swap', href: '#swap' },
      { name: 'Yield Vaults', href: '#earn' },
      { name: 'Borrow', href: '#borrow' },
      { name: 'Analytics', href: '#analytics' },
    ],
  },
  {
    title: 'Ecosystem',
    links: [
      { name: 'Supported Chains', href: '#networks' },
      { name: 'Documentation', href: '#docs' },
      { name: 'Brand Assets', href: '#brand' },
      { name: 'Bug Bounty', href: '#bounty' },
    ],
  },
  {
    title: 'Governance & Security',
    links: [
      { name: 'Audits & Reports', href: '#audits' },
      { name: 'Governance Forum', href: '#forum' },
      { name: 'Privacy Policy', href: '#privacy' },
      { name: 'Terms of Service', href: '#terms' },
    ],
  },
];

const SOCIAL_LINKS = [
  { name: 'LinkedIn', href: 'https://linkedin.com', icon: FaLinkedin },
  { name: 'Discord', href: 'https://discord.com', icon: FaDiscord },
  { name: 'GitHub', href: 'https://github.com', icon: FaGithub },
];

export const Footer: React.FC<FooterProps> = ({
  companyName = 'NODUS',
  copyrightYear = 2026,
}) => {
  const shouldReduceMotion = useReducedMotion();

  const handleSubscribe = (e: React.FormEvent) => {
    e.preventDefault();
    // Lógica para newsletter
  };

  return (
    <footer className="mt-auto bg-forest-ink text-paper relative overflow-hidden border-t border-pebble/10 pt-16 pb-8 px-4 sm:px-6">
      
      {/* Glow Visual Decorativo (Efeito Neon no Fundo) */}
      <div 
        className="absolute -bottom-32 -left-32 w-96 h-96 bg-lime-voltage/15 rounded-full blur-3xl pointer-events-none" 
        aria-hidden="true" 
      />
      <div 
        className="absolute top-0 right-10 w-72 h-72 bg-lime-voltage/10 rounded-full blur-3xl pointer-events-none" 
        aria-hidden="true" 
      />

      <div className="max-w-7xl mx-auto relative z-10">
        
        {/* PARTE SUPERIOR: Frase de Impacto e Newsletter */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 pb-16">
          
          {/* Headline Principal */}
          <div className="lg:col-span-7 flex flex-col justify-between">
            <div>
              <a
                href="/"
                className="text-3xl font-black italic -tracking-widest uppercase text-paper focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage rounded-md"
                aria-label="Nodus Home"
              >
                NODUS<span className="text-lime-voltage">.DeFi</span>
              </a>
              <h3 className="text-2xl sm:text-4xl font-extrabold mt-4 leading-tight tracking-tight text-paper max-w-xl">
                The next evolution of <span className="text-lime-voltage">permissionless</span> liquidity.
              </h3>
            </div>
          </div>

          {/* Form de Newsletter */}
          <div className="lg:col-span-5 bg-paper/5 backdrop-blur-md p-6 sm:p-8 rounded-3xl border border-pebble/20 flex flex-col justify-between">
            <div>
              <h4 className="text-base font-extrabold text-paper">Stay ahead in Web3</h4>
              <p className="text-xs text-paper/70 mt-1">
                Get priority access to high-yield pools, protocol updates, and security reports.
              </p>
            </div>

            <form onSubmit={handleSubscribe} className="mt-5 flex gap-2">
              <input
                type="email"
                placeholder="Enter your email"
                required
                className="grow bg-paper/10 border border-pebble/30 rounded-full px-4 py-2.5 text-xs text-paper placeholder:text-paper/40 focus:outline-none focus:border-lime-voltage transition-colors"
              />
              <button
                type="submit"
                className="bg-lime-voltage text-forest-ink p-2.5 rounded-full font-bold hover:scale-105 active:scale-95 transition-all cursor-pointer flex items-center justify-center shrink-0"
                aria-label="Inscrever-se na Newsletter"
              >
                <Send size={16} />
              </button>
            </form>
          </div>

        </div>

        {/* Divisor Visual com Gradient Em Mapeamento Lime Voltage */}
        <div className="w-full h-px bg-linear-to-r from-transparent via-lime-voltage/60 to-transparent opacity-80" />

        {/* PARTE CENTRAL: Grid de Navegação e Redes */}
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-12 gap-8 py-14">
          
          {/* Mídia Social & Status */}
          <div className="col-span-2 lg:col-span-3 flex flex-col justify-between gap-6">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-lime-voltage">
                Community
              </span>
              <div className="flex items-center gap-2.5 mt-4">
                {SOCIAL_LINKS.map((social) => {
                  const Icon = social.icon;
                  return (
                    <motion.a
                      key={social.name}
                      href={social.href}
                      target="_blank"
                      rel="noopener noreferrer"
                      aria-label={social.name}
                      whileHover={shouldReduceMotion ? {} : { scale: 1.1, y: -2 }}
                      whileTap={shouldReduceMotion ? {} : { scale: 0.95 }}
                      className="p-3 rounded-full bg-paper/10 border border-pebble/20 text-paper hover:text-forest-ink hover:bg-lime-voltage hover:border-lime-voltage transition-all cursor-pointer"
                    >
                      <Icon className="w-4.5 h-4.5" aria-hidden="true" />
                    </motion.a>
                  );
                })}
              </div>
            </div>

            {/* Status da Rede */}
            <div className="inline-flex items-center gap-2.5 bg-paper/5 border border-pebble/20 px-3.5 py-2 rounded-full w-fit">
              <span className="w-2 h-2 rounded-full bg-lime-voltage animate-pulse" aria-hidden="true" />
              <span className="text-xs font-semibold text-paper/90">All Systems Operational</span>
            </div>
          </div>

          {/* Links de Navegação Organizados em Colunas */}
          {FOOTER_NAV.map((col) => (
            <div key={col.title} className="col-span-1 lg:col-span-3">
              <h4 className="text-xs font-bold uppercase tracking-wider text-lime-voltage mb-4">
                {col.title}
              </h4>
              <ul className="flex flex-col gap-2.5 text-xs font-medium text-paper/70">
                {col.links.map((link) => (
                  <li key={link.name}>
                    <a
                      href={link.href}
                      className="hover:text-lime-voltage transition-colors inline-flex items-center gap-1 group"
                    >
                      <span>{link.name}</span>
                      <ArrowUpRight size={12} className="opacity-0 group-hover:opacity-100 transition-opacity text-lime-voltage" />
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          ))}

        </div>

        {/* Divisor Inferior com Gradient */}
        <div className="w-full h-px bg-linear-to-r from-transparent via-lime-voltage/40 to-transparent opacity-60" />

        {/* PARTE INFERIOR: Copyright */}
        <div className="pt-8 flex flex-col sm:flex-row justify-between items-center gap-4 text-xs text-paper/50">
          <p>© {copyrightYear} {companyName}. Non-Custodial Liquidity Protocol.</p>
          <p className="text-center sm:text-right">
            Designed for decentralized finance & non-custodial yield optimization.
          </p>
        </div>

      </div>
    </footer>
  );
};