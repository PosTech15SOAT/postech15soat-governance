# Governança de repositórios · Fase 4

Governance versiona as regras do GitHub para promoção e integração. O Terraform modela os rulesets, enquanto cada aplicação publica os checks executados por seus próprios workflows.

| Regra | Papel |
| --- | --- |
| `baseline` | Define as branches de integração protegidas e exige PR de acordo com a configuração do repositório. |
| `required_ci` | Vincula as branches aos nomes de checks publicados no GitHub. |
| `main_promotion` | Exige o check que valida a promoção de `develop` para `main`. |

Em `develop` (`db2d070`), o exemplo versionado abrange monólito, Auth, Cloud, Database e Governance. A ampliação para OS, Billing e Inventory e seu apply precisam de confirmação. Um run verde demonstra a execução do check naquele commit. A auditoria de proteção precisa mostrar o ruleset efetivamente ativo para `main`.

| Repositório a habilitar | Nome do job de validação observado |
| --- | --- |
| OS | `Required validation` |
| Billing | `Validação obrigatória` |
| Inventory | `Validação obrigatória` no PR do Item 2 |

Antes do apply, confirmar o nome que o GitHub registra como contexto obrigatório, a disponibilidade de rulesets no plano da organização e os critérios de promoção. Em particular, a autoria do PR e a origem de `develop` devem ser verificáveis. Para deploy, registrar quem pode disparar o workflow e quais restrições de branch ou environment estão ativas. A revisão de documentação não aplica rulesets.

Na consulta de 14/11, a API retornou lista vazia de rulesets em `main` da OS e do Billing, e a proteção clássica retornou `Branch not protected`. Para o Inventory privado, a API retornou 403 por restrição de plano ou visibilidade. Registrar a evidência de proteção depois de resolver essas configurações.

[Rulesets](../terraform/rulesets.tf) · [Exemplo de configuração](../terraform/terraform.tfvars.example) · [Workflow de validação](../.github/workflows/terraform-validate.yml)
