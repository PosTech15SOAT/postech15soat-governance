## Aplicacao e validacao

Os rulesets de governanca ja foram provisionados via Terraform e estao ativos nos repositorios definidos em `protected_repositories`.

Apos qualquer alteracao nas regras de governanca:

1. Revisar o codigo e o resultado de `terraform plan`.
2. Aplicar a alteracao de forma incremental com `terraform apply`.
3. Validar os rulesets em **Settings > Rules > Rulesets** no GitHub.
4. Confirmar que os checks obrigatorios continuam associados as branches protegidas.
5. Validar o fluxo de promocao por Pull Request:
   `feature/* -> develop -> main`.

Atualmente a governanca utiliza, entre outros, os seguintes controles:

- **Protected integration branches**: protege `develop` e `main`;
- **Required CI checks**: exige os checks definidos para `develop` e `main`;
- **Require develop promotion**: exige que Pull Requests destinados a `main` sejam promovidos a partir de `develop`.

Os rulesets impedem alteracoes que violem o fluxo de governanca configurado, incluindo pushes diretos nas branches protegidas conforme as regras aplicadas.

Nao execute `terraform destroy` como forma de corrigir configuracoes.
Altere o codigo Terraform, revise o plano e aplique a mudanca incrementalmente.

## Estado da governanca

A governanca dos repositorios do NumberOne esta provisionada e ativa no GitHub.

Os repositorios protegidos sao:

- `numberone-app-auth`;
- `numberone-app-auto-service-api`;
- `postech15soat-infra-cloud`;
- `postech15soat-infra-database`;
- `postech15soat-governance`.

As branches `develop` e `main` sao protegidas pelos rulesets definidos neste repositorio.

O fluxo adotado pelo projeto e:

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
