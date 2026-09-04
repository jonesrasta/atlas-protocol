export interface NavSectionOption {
  id: string;
  label: string;
  href: string;
}

export const NAV_SECTIONS: NavSectionOption[] = [
  { id: "features", label: "Features", href: "#features" },
  { id: "how-it-works", label: "How it Works", href: "#how-it-works" },
  { id: "swap", label: "Swap", href: "#swap" },
  { id: "yield", label: "Yield Pools", href: "#yield" },
  { id: "faq", label: "FAQ", href: "#faq" },
];