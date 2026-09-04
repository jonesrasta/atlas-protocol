import { useState, useEffect } from "react";

export interface NavOption {
  id: string;
  label: string;
  href: string;
}

const NAV_OPTIONS: NavOption[] = [
  { id: "features", label: "Features", href: "#features" },
  { id: "how-it-works", label: "How it Works", href: "#how-it-works" },
  { id: "swap", label: "Swap", href: "#swap" },
  { id: "yield", label: "Yield Pools", href: "#yield" },
  { id: "faq", label: "FAQ", href: "#faq" },
];

export const SegmentedControl = () => {
  // Inicia vazio ("") para que nada fique selecionado no Hero
  const [active, setActive] = useState<string>("");

  useEffect(() => {
    // Mapeia todas as seções (incluindo o hero se tiver o id="hero")
    const sectionIds = ["hero", ...NAV_OPTIONS.map((opt) => opt.id)];

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const id = entry.target.id;
            // Se estiver no hero, limpa a seleção; caso contrário, define o ID ativo
            setActive(id === "hero" ? "" : id);
          }
        });
      },
      {
        // Define a linha de detecção no meio da tela
        rootMargin: "-30% 0px -50% 0px",
        threshold: 0,
      },
    );

    sectionIds.forEach((id) => {
      const el = document.getElementById(id);
      if (el) observer.observe(el);
    });

    return () => observer.disconnect();
  }, []);

  const handleNavClick = (option: NavOption) => {
    setActive(option.id);

    const targetId = option.href.replace("#", "");
    const element = document.getElementById(targetId);

    if (element) {
      const navbarOffset = 80;
      const elementPosition = element.getBoundingClientRect().top;
      const offsetPosition =
        elementPosition + window.pageYOffset - navbarOffset;

      window.scrollTo({
        top: offsetPosition,
        behavior: "smooth",
      });
    }
  };

  return (
    <nav className="flex bg-fog p-0.5 rounded-full border border-pebble/20">
      {NAV_OPTIONS.map((option) => (
        <a
          key={option.id}
          href={option.href}
          onClick={(e) => {
            e.preventDefault();
            handleNavClick(option);
          }}
          className={`px-4 py-1.5 text-sm font-medium rounded-full transition-all duration-200 cursor-pointer ${
            active === option.id
              ? "bg-lime-voltage text-forest-ink shadow-xs font-semibold"
              : "text-slate hover:text-obsidian hover:bg-pebble/20"
          }`}
        >
          {option.label}
        </a>
      ))}
    </nav>
  );
};
