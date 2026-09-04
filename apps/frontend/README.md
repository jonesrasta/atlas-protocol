Nodus Protocol UI — Guia do Desenvolvedor e Documentação
Este documento contém a documentação completa do software Nodus Protocol UI, as instruções de instalação e os arquivos no formato Markdown (README.md e DOCUMENTATION.md) prontos para uso no seu projeto.
1. README.md
# ⚡ Nodus Protocol UI

Uma interface moderna e altamente performática para o **Nodus Protocol**, um protocolo de liquidez não custodial focado em swaps, rendimentos (yields) e empréstimos de ativos digitais sem intermediários.

![Version](https://img.shields.io/badge/version-2.0.0-lime)
![React](https://img.shields.io/badge/React-18.x-blue)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v4-38bdf8)

---

## 📸 Demonstração do Layout

![Preview do Layout](./assets/hero-preview.png)

---

## 🚀 Funcionalidades

- **Design Responsivo & Mobile First**: Layout adaptado para desktop e dispositivos móveis, mantendo fidelidade visual nas métricas do protocolo.
- **Micro-interações Suaves**: Animações baseadas em física atreladas ao `framer-motion`.
- **Acessibilidade Nativa (a11y)**: Suporte completo a navegação por teclado, atributos ARIA e detecção de preferências do sistema (`prefers-reduced-motion`).
- **Conectividade Web3**: Modal integrado para seleção de carteiras descentralizadas.

---

## 🛠️ Tecnologias Utilizadas

- **Core**: React, TypeScript
- **Estilização**: Tailwind CSS v4
- **Animações**: Framer Motion
- **Iconografia**: Lucide React

---

## 📦 Instalação e Execução

### Pré-requisitos

Certifique-se de ter o **Node.js** (v18+) e um gerenciador de pacotes (`npm`, `pnpm` ou `yarn`) instalados.

### Passo a Passo

1. **Clone o repositório:**
```bash
git clone https://github.com/seu-usuario/nodus-protocol-ui.git
cd nodus-protocol-ui
```

2. **Instale as dependências:**
```bash
npm install
```

3. **Inicie o servidor de desenvolvimento:**
```bash
npm run dev
```

4. **Acesse no navegador:**
`http://localhost:5173`

---

## 📄 Licença

Este projeto está sob a licença [MIT](./LICENSE).


2. DOCUMENTATION.md
# 📚 Documentação Técnica — Nodus Protocol UI

Este documento detalha a estrutura, propriedades e decisões de design da biblioteca de componentes do Nodus Protocol.

---

## 🧩 Componentes

### ``

O componente `` é a seção principal da landing page. Ele é responsável por apresentar a proposta de valor do protocolo, chamar para ação (CTAs) e exibir dados estatísticos em tempo real através do ticker de métricas.

#### Importação

```tsx
import { HeroSection } from "./components/HeroSection";
```

#### Properties (Props)

| Prop | Tipo | Padrão | Descrição |
| :--- | :--- | :--- | :--- |
| `badgeText` | `string` | `"Nodus Protocol V2 is Live on Mainnet"` | Texto exibido na pílula/badge superior. |
| `headline` | `string` | `"Non-Custodial Liquidity Protocol"` | Título principal da hero section. |
| `description` | `string` | `"Swap, earn yield..."` | Descrição e proposta de valor do protocolo. |
| `metrics` | `ProtocolMetric[]` | `DEFAULT_METRICS` | Lista de estatísticas a serem renderizadas no grid. |
| `onConnectWallet` | `(walletId: string) => void` | `undefined` | Callback acionado ao selecionar uma carteira no modal. |
| `onLaunchApp` | `() => void` | `undefined` | Callback acionado ao clicar no botão "Launch App". |
| `availableWallets`| `WalletOption[]` | `undefined` | Lista de carteiras disponíveis para o modal. |

---

## 📐 Estrutura de Dados

### `ProtocolMetric`

Interface utilizada para renderizar os cards estatísticos.

```typescript
export interface ProtocolMetric {
  id: string;          // Identificador único da métrica (ex: "tvl")
  label: string;       // Rótulo de exibição (ex: "Total Value Locked")
  value: string;       // Valor formatado (ex: "$1.42B")
  isHighlight?: boolean; // Se true, aplica o badge escuro com texto destacado
}
```

---

## 🎨 Layout e Estilização do Ticker de Métricas

O grid de métricas foi otimizado para responder de forma distinta entre telas mobile e desktop:

- **Mobile (< 768px)**:
  - Disposto em um grid de **2 colunas** (`grid-cols-2`).
  - Utiliza uma linha divisória customizada com gradiente entre as linhas superiores e inferiores:
    ```tsx
    

    ```

- **Desktop (≥ 768px)**:
  - Disposto em um grid de **4 colunas** (`md:grid-cols-4`).
  - Utiliza divisórias verticais com gradiente suave entre cada item:
    ```tsx
    

    ```

---

## ♿ Acessibilidade e Movimento

- **`useReducedMotion`**: O componente verifica se o usuário habilitou a opção de redução de movimento nas configurações do sistema. Caso ativado, desabilita automaticamente as animações de pulso da badge e os efeitos de escala ao clicar nos botões.
- **ARIA Attributes**: Elementos interativos utilizam `aria-label` descritivos e papéis semânticos (`role="region"`) para facilitar a navegação por leitores de tela.



3. Guia Rápido: Como Adicionar Imagens e Executar o Projeto

Como Adicionar Imagens:
Para adicionar imagens (prints, diagramas, etc.) ao seu projeto e exibi-las no arquivo README.md:
Crie uma pasta chamada assets na raiz do projeto.
Coloque a imagem desejada na pasta (exemplo: hero-preview.png).
Referencie a imagem no Markdown com a sintaxe: ![Descrição](./assets/hero-preview.png).
Como Executar os Comandos:
No terminal da raiz do projeto, execute:
# Instalar as dependências
npm install

# Rodar a aplicação em modo de desenvolvimento
npm run dev
