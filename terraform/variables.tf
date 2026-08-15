variable "github_organization" {
  description = "GitHub organization that owns the managed repositories."
  type        = string
  default     = "PosTech15SOAT"
}

variable "protected_repositories" {
  description = "Repositories and branch names protected by the baseline ruleset."
  type        = map(set(string))

  default = {
    numberone-app-auto-service-api = ["main", "develop"]
    numberone-app-auth             = ["main", "develop"]
    postech15soat-governance       = ["main", "develop"]
    postech15soat-infra-cloud      = ["main", "develop"]
    postech15soat-infra-database   = ["main", "develop"]
  }

  validation {
    condition = alltrue([
      for repository, branches in var.protected_repositories :
      length(trimspace(repository)) > 0 && length(branches) > 0
    ])
    error_message = "Each repository must have a name and at least one protected branch."
  }
}

variable "required_status_checks_by_repository" {
  description = "Required GitHub check contexts for repositories that already publish CI results."
  type        = map(set(string))

  default = {}

  validation {
    condition = alltrue([
      for repository, checks in var.required_status_checks_by_repository :
      contains(keys(var.protected_repositories), repository) && length(checks) > 0
    ])
    error_message = "Checks may only target protected repositories and each entry needs at least one check."
  }
}
