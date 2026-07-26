provider "github" {
  owner = "taiyo2001"
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.github_app_pem_file
  }
}

data "github_repository" "dotfiles" {
  name = "dotfiles"
}

resource "github_branch_protection" "main" {
  repository_id = data.github_repository.dotfiles.node_id
  pattern       = "main"

  allows_force_pushes = false
  allows_deletions    = false
  lock_branch         = true
  enforce_admins      = false

  required_status_checks {
    strict = true
    contexts = [
      "Shell Script Formatting",
      "ShellCheck",
      "Bats Smoke Tests",
      "Terraform Format",
      "Terraform Validate",
      "Secret Scanning",
    ]
  }
}

resource "github_branch_protection" "gh_pages" {
  repository_id = data.github_repository.dotfiles.node_id
  pattern       = "gh-pages"

  allows_force_pushes = false
  allows_deletions    = false
}
