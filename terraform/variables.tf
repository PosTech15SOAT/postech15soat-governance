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

  default = {
    numberone-app-auto-service-api = ["Required validation"]
    numberone-app-auth             = ["Required validation"]
    postech15soat-governance       = ["Required validation"]
    postech15soat-infra-cloud      = ["Required validation"]
    postech15soat-infra-database   = ["Required validation"]
  }

  validation {
    condition = alltrue([
      for repository, checks in var.required_status_checks_by_repository :
      contains(keys(var.protected_repositories), repository) && length(checks) > 0
    ])
    error_message = "Checks may only target protected repositories and each entry needs at least one check."
  }
}

variable "main_promotion_repositories" {
  description = "Repositories where Pull Requests to main must originate from develop."
  type        = set(string)

  default = [
    "numberone-app-auto-service-api",
    "numberone-app-auth",
    "postech15soat-governance",
    "postech15soat-infra-cloud",
    "postech15soat-infra-database",
  ]

  validation {
    condition = alltrue([
      for repository in var.main_promotion_repositories :
      contains(keys(var.protected_repositories), repository)
    ])
    error_message = "Main promotion rules may only target protected repositories."
  }
}
