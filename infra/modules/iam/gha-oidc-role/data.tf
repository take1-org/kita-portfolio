# ---------------------------------------------
# data.tf
# ---------------------------------------------

# ---------------------------------------------
# Trust Policy (assume-role condition)
# ---------------------------------------------
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    # GitHub Actions OIDC token の "subject" クレームを検証
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        for ref in var.allowed_refs :
        startswith(ref, "environment:")
        ? "repo:${var.github_owner}/${var.github_repo}:${ref}"
        : "repo:${var.github_owner}/${var.github_repo}:ref:${ref}"
      ]
    }

    # GitHub の OIDC audience (必ず sts.amazonaws.com)
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

