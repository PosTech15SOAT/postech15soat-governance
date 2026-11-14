# Rulesets habilitados no GitHub após validar os PRs de promoção da Fase 4.
# O primeiro apply os associa ao estado Terraform usado pela equipe.
import {
  to = github_repository_ruleset.baseline["numberone-service-order"]
  id = "numberone-service-order:27280197"
}

import {
  to = github_repository_ruleset.required_ci["numberone-service-order"]
  id = "numberone-service-order:27280199"
}

import {
  to = github_repository_ruleset.baseline["numberone-billing-service"]
  id = "numberone-billing-service:27280211"
}

import {
  to = github_repository_ruleset.required_ci["numberone-billing-service"]
  id = "numberone-billing-service:27280213"
}
