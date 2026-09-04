import React from 'react';
import { motion, useReducedMotion, type Variants } from 'framer-motion';
import type { LucideIcon } from 'lucide-react';

export interface FeatureCardProps {
  /** Ícone da biblioteca Lucide a ser exibido */
  icon: LucideIcon;
  /** Título principal do recurso */
  title: string;
  /** Descrição detalhada do recurso */
  description: string;
  /** Badge opcional para destacar status (ex: "NOVO", "V2", "AUDITED") */
  badgeText?: string;
  /** Link opcional; se fornecido, o card se comporta semanticamente como uma tag <a> */
  href?: string;
  /** Callback opcional de clique */
  onClick?: () => void;
  /** Classe CSS customizada para sobreposição */
  className?: string;
}

// Configuração de Física de Mola (Spring)
const SPRING_TRANSITION = {
  type: 'spring' as const,
  stiffness: 380,
  damping: 26,
};

// Variantes do Ícone (Sincronizado com o pai via Framer Motion)
const ICON_CONTAINER_VARIANTS: Variants = {
  rest: {
    scale: 1,
    backgroundColor: 'var(--color-fog, rgba(0,0,0,0.03))',
  },
  hover: {
    scale: 1.05,
    backgroundColor: 'var(--color-lime-voltage-20, rgba(163, 230, 53, 0.2))',
  },
};

export const FeatureCard: React.FC<FeatureCardProps> = ({
  icon: Icon,
  title,
  description,
  badgeText,
  href,
  onClick,
  className = '',
}) => {
  const shouldReduceMotion = useReducedMotion();
  const isInteractive = Boolean(href || onClick);

  const Component = href ? motion.a : isInteractive ? motion.button : motion.div;

  return (
    <Component
      href={href}
      onClick={onClick}
      initial="rest"
      whileHover={shouldReduceMotion || !isInteractive ? 'rest' : 'hover'}
      whileTap={shouldReduceMotion || !isInteractive ? 'rest' : 'tap'}
      variants={{
        rest: { y: 0, scale: 1 },
        hover: { y: -4, scale: 1.01 },
        tap: { y: -1, scale: 0.99 },
      }}
      transition={SPRING_TRANSITION}
      className={`
        relative flex flex-col items-start gap-5 p-6 rounded-3xl
        bg-paper border border-pebble/20 shadow-xs
        ${isInteractive ? 'cursor-pointer hover:border-lime-voltage/40 hover:shadow-md' : 'cursor-default'}
        focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-lime-voltage focus-visible:ring-offset-2
        transition-shadow duration-200 text-left w-full
        ${className}
      `.trim()}
    >
      {/* Container Superior: Ícone e Badge Opcional */}
      <div className="w-full flex items-center justify-between gap-4">
        <motion.div
          variants={ICON_CONTAINER_VARIANTS}
          transition={SPRING_TRANSITION}
          className="p-3.5 rounded-2xl text-forest-ink border border-pebble/20 flex items-center justify-center"
        >
          <Icon size={24} strokeWidth={2} aria-hidden="true" />
        </motion.div>

        {badgeText && (
          <span className="px-2.5 py-1 text-[10px] font-bold tracking-wider uppercase bg-lime-voltage/15 text-forest-ink rounded-full border border-lime-voltage/30">
            {badgeText}
          </span>
        )}
      </div>

      {/* Conteúdo Textual */}
      <div className="flex flex-col gap-2">
        <h3 className="text-xl font-bold text-obsidian tracking-tight leading-snug">
          {title}
        </h3>
        <p className="text-sm md:text-base text-slate leading-relaxed">
          {description}
        </p>
      </div>
    </Component>
  );
};