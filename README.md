# 🔥 HYPE Admin — TKT Protocol


Aplicativo de demonstração do Pitich: https://hype-experience-vault.lovable.app/#solution

Notebook: com IA conectada no supaabse: https://colab.research.google.com/drive/1lIsKBlxPYXkMYnWrFbkN76NUQWI7WHE9

Painel administrativo do ecossistema **HYPE (TKT Protocol)**, um sistema de ticketing baseado em blockchain que transforma eventos em ativos digitais e cria uma economia baseada em experiências.

---

## 🚀 Sobre o Projeto

O **HYPE Admin** é um dashboard desenvolvido em **Streamlit + Supabase**, utilizado para gerenciar:

- 👤 Usuários
- 🎟️ Eventos
- 🏆 Gamificação (badges e recompensas)
- 💰 Transações e marketplace

Este projeto faz parte do ecossistema **HYPE - TKT Protocol**, que introduz o conceito de:

### 🧠 Proof of Experience (PoE)

Um modelo onde experiências reais se tornam ativos digitais verificáveis, criando identidade, reputação e valor para os usuários.

---

## 🧱 Stack Utilizada

- Python
- Streamlit (Frontend + Dashboard)
- Supabase (Banco de dados e backend)
- Solidity (Smart Contracts)
- Blockchain (compatível com EVM)

---

## 🧩 Arquitetura do Ecossistema

O projeto faz parte de uma arquitetura maior:

- 🎫 **Ticket Token (NFT)** → Representa o ingresso
- 📍 **Attendance Token (Soulbound)** → Prova de participação
- 💰 **TKT Token (ERC-20)** → Economia interna
- 🏆 **HYPE Score** → Sistema de reputação

---

## ⚙️ Funcionalidades

### ✅ Admin Dashboard

- Visualização de dados (READ)
- Criação de registros (CREATE)
- Interface modular por domínio:
  - Usuários
  - Eventos
  - Gamificação
  - Financeiro

### 🔄 Futuras melhorias

- Update e Delete (CRUD completo)
- Autenticação de admin
- Upload de imagens
- Relacionamentos inteligentes (dropdowns)
- Analytics e métricas

---

## 📦 Estrutura do Projeto



Deployed Contracts
Contract	Address

HypeToken	0xdBA88BabefdfFE8eD3fb3BBbe3Ffd8C7459c1a06

HypePass	0x62D32fB746A305252c1c8838F09c8dcbeb8d1212

HypeCore	0x366EE0f4303fb276fCEca38dE022430fb94b22c6

HypeSale	0x53A89c90ADd3d10e3263860b702F83806192D3b7

All permissions were configured:

    HypeCore and HypeSale were added as minters on HypeToken
    HypeCore was added as a controller on HypePass

Total gas used: ~9.26M gas (~0.94 MON at 102 gwei). The deployer address is 0x811E405d0b65Fe91e592400B87Dc488daDd873f3.
