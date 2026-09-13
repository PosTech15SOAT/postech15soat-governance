# PosTech15SOAT GitHub Governance

Governança como código para os repositórios da organização `PosTech15SOAT`.

Este repositório administra regras de proteção do GitHub por meio do Terraform. A configuração utiliza rulesets por repositório, compatíveis com organizações no GitHub Free que mantêm repositórios públicos.

## Escopo

O ruleset base exige Pull Request e impede exclusão e force push nas branches selecionadas.

Revisões e resolução de conversas continuam recomendadas, mas não há quantidade mínima de aprovações, aprovação adicional do último push ou obrigação de resolver conversas antes do merge.

Um ruleset adicional exige que Pull Requests para `main` sejam promovidos a partir de `develop`, validado pelo check `Validate promotion source`.

| Repositório | Branches | Check obrigatório |
|---|---|---|
| `numberone-app-auto-service-api` | `main`, `develop` | `Required validation` |
| `numberone-app-auth` | `main`, `develop` | `Required validation` |
| `postech15soat-infra-cloud` | `main`, `develop` | `Required validation` |
| `postech15soat-infra-database` | `main`, `develop` | `Required validation` |
| `postech15soat-governance` | `main`, `develop` | `Required validation` |

Os rulesets também podem apontar para uma branch que ainda não existe. Assim, uma futura branch `develop` já nasce coberta pela política da organização.

## Fluxo de branches

O fluxo de desenvolvimento adotado pelo projeto é:

```text
feature/*
   |
   | Pull Request
   v
develop
   |
   | Pull Request
   v
main
