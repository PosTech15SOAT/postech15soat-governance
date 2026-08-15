locals {
  branch_refs_by_repository = {
    for repository, branches in var.protected_repositories :
    repository => [for branch in branches : "refs/heads/${branch}"]
  }
}

resource "github_repository_ruleset" "baseline" {
  for_each = var.protected_repositories

  name        = "Protected integration branches"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = local.branch_refs_by_repository[each.key]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }
  }
}

resource "github_repository_ruleset" "required_ci" {
  for_each = var.required_status_checks_by_repository

  name        = "Required CI checks"
  repository  = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = local.branch_refs_by_repository[each.key]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = true

      dynamic "required_check" {
        for_each = each.value

        content {
          context = required_check.value
        }
      }
    }
  }
}

resource "github_repository_ruleset" "main_promotion" {
  for_each = var.main_promotion_repositories

  name        = "Require develop promotion"
  repository  = each.value
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      strict_required_status_checks_policy = true

      required_check {
        context = "Validate promotion source"
      }
    }
  }
}
