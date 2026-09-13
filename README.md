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
```

As branches `develop` e `main` são protegidas.

Alterações devem ser promovidas por Pull Request, sem push direto para essas branches.

Para Pull Requests destinados a `main`, o check `Validate promotion source` garante que a origem seja `develop`.

A branch `main` representa a linha utilizada para deploy em produção.

## Rulesets

A governança atualmente é composta pelos seguintes controles.

### Protected integration branches

Aplicado às branches:

- `develop`;
- `main`.

Responsável pela proteção das branches de integração e produção, incluindo a exigência de Pull Request e restrições contra alterações que violem o fluxo definido.

### Required CI checks

Aplicado às branches:

- `develop`;
- `main`.

Exige a execução bem-sucedida do check:

```text
Required validation
```

antes que uma alteração possa ser integrada.

### Require develop promotion

Aplicado à branch:

- `main`.

Exige que a promoção para `main` seja realizada a partir de `develop`, por meio do check:

```text
Validate promotion source
```

Dessa forma, o fluxo esperado é:

```text
feature/* -> develop -> main
```

## Pré-requisitos

- Terraform `>= 1.6` e `< 2.0`;
- acesso administrativo aos repositórios selecionados;
- Fine-grained Personal Access Token limitado à organização e aos repositórios necessários, com permissão `Administration: Read and write`.

O provider lê o token da variável de ambiente `GITHUB_TOKEN`.

Nunca salve o token em arquivos Terraform ou no repositório.

Exemplo no PowerShell:

```powershell
$env:GITHUB_TOKEN = "seu-token"
```

## Validação local

A validação da configuração Terraform pode ser executada localmente:

```powershell
Set-Location terraform

terraform init -backend=false
terraform fmt -check -recursive
terraform validate
terraform plan -out governance.tfplan
terraform show governance.tfplan
```

O `terraform plan` consulta o GitHub e, portanto, precisa do token configurado.

Os comandos de formatação e validação não alteram recursos remotos.

O workflow `Terraform validation` executa as validações de Terraform em pushes e Pull Requests para `main` e `develop`.

O workflow não recebe credenciais administrativas do GitHub e não executa `plan` ou `apply`.

## Aplicação de alterações

Os rulesets de governança já estão provisionados e ativos nos repositórios definidos em `protected_repositories`.

Para alterar a governança:

1. Criar uma branch `feature/*`.
2. Alterar a configuração Terraform.
3. Executar as validações locais.
4. Revisar o resultado de `terraform plan`.
5. Abrir Pull Request para `develop`.
6. Após integração e validação, promover `develop` para `main` por Pull Request.
7. Aplicar a alteração Terraform de forma controlada.
8. Validar os rulesets em **Settings > Rules > Rulesets** no GitHub.

Após qualquer alteração, confirmar:

- rulesets ativos;
- branches corretas associadas;
- checks obrigatórios configurados;
- bloqueio de alterações que violem as regras;
- promoção de `develop` para `main` funcionando corretamente.

Não execute `terraform destroy` como forma de corrigir configurações.

Altere o código Terraform, revise o plano e aplique a mudança incrementalmente.

## Estado da governança

A governança dos repositórios do NumberOne está provisionada e ativa no GitHub.

Atualmente são protegidos:

- `numberone-app-auth`;
- `numberone-app-auto-service-api`;
- `postech15soat-infra-cloud`;
- `postech15soat-infra-database`;
- `postech15soat-governance`.

As branches `develop` e `main` estão cobertas pelos rulesets definidos neste repositório.

O estado efetivamente aplicado pode ser verificado em:

**Settings > Rules > Rulesets**

nos respectivos repositórios.

A configuração versionada neste repositório representa a definição da governança, enquanto o GitHub representa o estado efetivamente aplicado dos rulesets.

## Adicionando um repositório

Para adicionar um novo repositório à governança:

1. Incluir o repositório e suas branches em `protected_repositories`, dentro de:

```text
terraform/variables.tf
```

2. Adicionar checks em `required_status_checks_by_repository` somente depois que eles tiverem executado com sucesso pelo menos uma vez no repositório correspondente.

3. Para exigir o fluxo:

```text
feature/* -> develop -> main
```

incluir também o repositório em `main_promotion_repositories`.

4. Garantir que os workflows responsáveis pelos checks abaixo existam no repositório antes de aplicar o Terraform:

```text
Required validation
Validate promotion source
```

5. Executar `terraform plan` e revisar as alterações.

6. Aplicar a configuração.

7. Confirmar os rulesets em **Settings > Rules > Rulesets**.
