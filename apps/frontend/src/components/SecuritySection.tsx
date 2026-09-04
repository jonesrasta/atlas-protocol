import React, { useState } from 'react';
import { motion, AnimatePresence, useReducedMotion } from 'framer-motion';
import { ShieldCheck, FileCode, ExternalLink, ChevronDown, CheckCircle2, ArrowUpRight } from 'lucide-react';

export interface AuditReport {
  id: string;
  auditor: string;
  date: string;
  score: string;
  reportUrl: string;
}

export interface SecuritySectionProps {
  score?: string;
  lastAuditDate?: string;
  reports?: AuditReport[];
  onViewAllReports?: () => void;
}

const DEFAULT_REPORTS: AuditReport[] = [
  { id: 'certik', auditor: 'CertiK', date: 'August 2026', score: '98/100', reportUrl: '#certik' },
  { id: 'openzeppelin', auditor: 'OpenZeppelin', date: 'July 2026', score: 'Passed', reportUrl: '#openzeppelin' },
];

const SPRING_PHYSICS = { type: 'spring' as const, stiffness: 380, damping: 26 };

export const SecuritySection: React.FC<SecuritySectionProps> = ({
  score = '98.5',
  lastAuditDate = 'Aug 2026',
  reports = DEFAULT_REPORTS,
  onViewAllReports,
}) => {
  const [isExpanded, setIsExpanded] = useState(false);
  const shouldReduceMotion = useReducedMotion();

  return (
    <section className="py-10 px-4 sm:px-6 max-w-7xl mx-auto w-full">
      <motion.div
        initial="rest"
        whileHover={shouldReduceMotion ? 'rest' : 'hover'}
        variants={{
          rest: { y: 0 },
          hover: { y: -2 },
        }}
        transition={SPRING_PHYSICS}
        className="p-6 sm:p-8 bg-paper rounded-largecards border border-pebble/30 shadow-xs hover:shadow-md transition-shadow duration-200"
      >
        <div className="flex flex-col lg:flex-row gap-6 justify-between items-start lg:items-center">
          
          {/* Lado Esquerdo: Ícone + Título + Status */}
          <div className="flex items-start sm:items-center gap-4">
            <div className="p-3.5 sm:p-4 bg-lime-voltage/20 text-forest-ink rounded-2xl border border-lime-voltage/30 shrink-0">
              <ShieldCheck size={32} aria-hidden="true" />
            </div>

            <div className="flex flex-col gap-1">
              <div className="flex items-center gap-2 flex-wrap">
                <h3 className="text-xl sm:text-2xl font-black text-obsidian tracking-tight">
                  Audited & Non-Custodial
                </h3>
                <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-700 text-xs font-semibold">
                  <span className={`w-1.5 h-1.5 rounded-full bg-emerald-500 ${shouldReduceMotion ? '' : 'animate-pulse'}`} aria-hidden="true" />
                  Score: {score}
                </span>
              </div>
              <p className="text-sm text-slate leading-relaxed">
                Smart contracts fully audited by CertiK and OpenZeppelin. Zero critical vulnerabilities found.
              </p>
            </div>
          </div>

          {/* Lado Direito: Ações */}
          <div className="flex items-center gap-3 w-full lg:w-auto justify-end pt-2 lg:pt-0 border-t lg:border-t-0 border-pebble/20">
            <motion.button
              whileHover={shouldReduceMotion ? {} : { scale: 1.02 }}
              whileTap={shouldReduceMotion ? {} : { scale: 0.98 }}
              transition={SPRING_PHYSICS}
              onClick={() => setIsExpanded((prev) => !prev)}
              aria-expanded={isExpanded}
              aria-controls="security-details-panel"
              className="flex items-center justify-center gap-2 min-h-11 px-4 py-2.5 bg-fog text-xs font-bold rounded-full border border-pebble/30 text-forest-ink hover:bg-pebble/20 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink transition-colors w-full sm:w-auto"
            >
              <FileCode size={16} aria-hidden="true" />
              <span>{isExpanded ? 'Hide Reports' : 'View Audit Reports'}</span>
              <ChevronDown
                size={14}
                className={`transition-transform duration-200 ${isExpanded ? 'rotate-180' : ''}`}
                aria-hidden="true"
              />
            </motion.button>
          </div>
        </div>

        {/* Painel Expansível de Detalhes das Auditorias */}
        <AnimatePresence>
          {isExpanded && (
            <motion.div
              id="security-details-panel"
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="overflow-hidden"
            >
              <div className="mt-6 pt-6 border-t border-pebble/20">
                {/* Exibição do 'lastAuditDate' */}
                <div className="flex justify-between items-center mb-4">
                  <span className="text-xs font-semibold text-slate">
                    Last Verified: <span className="text-obsidian font-bold">{lastAuditDate}</span>
                  </span>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  {reports.map((report) => (
                    <div
                      key={report.id}
                      className="p-4 bg-fog/60 rounded-2xl border border-pebble/20 flex items-center justify-between"
                    >
                      <div className="flex items-center gap-3">
                        <CheckCircle2 size={18} className="text-emerald-600 shrink-0" aria-hidden="true" />
                        <div>
                          <span className="text-sm font-bold text-obsidian block">{report.auditor}</span>
                          <span className="text-xs text-slate">Verified {report.date}</span>
                        </div>
                      </div>

                      <a
                        href={report.reportUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-bold text-forest-ink bg-paper rounded-full border border-pebble/30 hover:bg-pebble/10 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink"
                        aria-label={`Open external ${report.auditor} audit report`}
                      >
                        <span>{report.score}</span>
                        <ExternalLink size={12} aria-hidden="true" />
                      </a>
                    </div>
                  ))}
                </div>

                {/* Uso do 'onViewAllReports' */}
                {onViewAllReports && (
                  <div className="mt-4 text-center">
                    <button
                      onClick={onViewAllReports}
                      className="inline-flex items-center gap-1 text-xs font-bold text-forest-ink hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-forest-ink rounded-md px-2 py-1"
                    >
                      Explore All Certificates <ArrowUpRight size={14} />
                    </button>
                  </div>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
    </section>
  );
};