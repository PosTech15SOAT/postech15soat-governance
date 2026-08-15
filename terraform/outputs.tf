output "baseline_ruleset_repositories" {
  description = "Repositories managed by the baseline protection ruleset."
  value       = sort(keys(github_repository_ruleset.baseline))
}

output "required_ci_ruleset_repositories" {
  description = "Repositories with required CI checks managed by Terraform."
  value       = sort(keys(github_repository_ruleset.required_ci))
}

output "main_promotion_ruleset_repositories" {
  description = "Repositories where main only accepts promotions from develop."
  value       = sort(keys(github_repository_ruleset.main_promotion))
}
