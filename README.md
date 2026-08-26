# PosTech15SOAT GitHub Governance

Governanca como codigo para os repositorios da organizacao
[`PosTech15SOAT`](https://github.com/PosTech15SOAT).

Este repositorio administra regras de protecao do GitHub por meio do Terraform.
A configuracao inicial usa rulesets por repositorio, compativel com organizacoes
no GitHub Free que mantem repositorios publicos.

## Escopo inicial

O ruleset base exige Pull Request e impede exclusao e force push nas branches
selecionadas. Revisoes e resolucao de conversas continuam recomendadas, mas nao
ha quantidade minima de aprovacoes, aprovacao adicional do ultimo push ou
obrigacao de resolver conversas antes do merge.
Um ruleset adicional exige que Pull Requests para `main` sejam promovidos a
partir de `develop`, validado pelo check `Validate promotion source`.

| Repositorio | Branches | Check obrigatorio |
|---|---|---|
| `numberone-app-auto-service-api` | `main`, `develop` | `Required validation` |
| `numberone-app-auth` | `main`, `develop` | `Required validation` |
| `postech15soat-infra-cloud` | `main`, `develop` | `Required validation` |
| `postech15soat-infra-database` | `main`, `develop` | `Required validation` |
| `postech15soat-governance` | `main`, `develop` | `Required validation` |

Os rulesets tambem podem apontar para uma branch que ainda nao existe. Assim,
uma futura branch `develop` ja nasce coberta pela politica da organizacao.

As protecoes classicas de `main` e `develop` em
`postech15soat-infra-database` devem permanecer ativas durante a migracao. Elas
so podem ser removidas depois da aplicacao e verificacao dos novos rulesets.

## Pre-requisitos

- Terraform `>= 1.6` e `< 2.0`.
- Acesso administrativo aos repositorios selecionados.
- Fine-grained Personal Access Token limitado a organizacao e aos repositorios
  necessarios, com permissao `Administration: Read and write`.

O provider le o token da variavel de ambiente `GITHUB_TOKEN`. Nunca salve o
token em arquivos Terraform ou no repositorio.

```powershell
$env:GITHUB_TOKEN = "seu-token"
```

## Validacao local

```powershell
Set-Location terraform
terraform init -backend=false
terraform fmt -check -recursive
terraform validate
terraform plan -out governance.tfplan
terraform show governance.tfplan
```

O `terraform plan` consulta o GitHub, portanto precisa do token. Os comandos de
formatacao e validacao nao alteram nenhum recurso remoto.

O workflow `Terraform validation` repete `fmt`, `init` e `validate` em pushes e
Pull Requests para `main` e `develop`. Ele nao recebe credenciais e nao executa
`plan` ou `apply`.

## Primeira aplicacao

1. Revisar o codigo e o resultado de `terraform plan`.
2. Confirmar que todos os integrantes possuem acesso aos repositorios.
3. Executar `terraform apply governance.tfplan`.
4. Abrir um Pull Request de teste para `develop` na API.
5. Confirmar bloqueio de push direto, force push e exclusao das branches.
6. Remover protecoes classicas somente depois de validar o ruleset substituto.

Nao execute `terraform destroy` como forma de corrigir configuracao. Altere o
codigo, revise o plano e aplique a mudanca incrementalmente.

## Estado Terraform

O backend ainda nao foi definido. Enquanto a configuracao estiver apenas em
revisao local, o state sera local e ignorado pelo Git. Antes do primeiro apply em
equipe, configure um backend remoto com criptografia, versionamento e controle de
acesso, como S3 ou Terraform Cloud.

## Adicionando um repositorio

Inclua o repositorio e suas branches em `protected_repositories`, dentro de
`terraform/variables.tf`. Somente adicione checks em
`required_status_checks_by_repository` depois que eles tiverem executado com
sucesso pelo menos uma vez no repositorio correspondente. Para exigir o fluxo
`feature/* -> develop -> main`, inclua tambem o repositorio em
`main_promotion_repositories` e adicione os workflows `Required validation` e
`Validate promotion source` antes de aplicar o Terraform.
