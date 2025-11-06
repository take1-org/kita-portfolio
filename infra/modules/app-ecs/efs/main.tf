# ---------------------------------------------
# efs
# ---------------------------------------------

resource "aws_efs_file_system" "this" {
  count            = var.enable_efs ? 1 : 0
  creation_token   = "${var.name_prefix}-efs"
  encrypted        = true
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"
  tags = merge(
    var.common_tags,
    { Name = "${var.name_prefix}-efs" },
    var.tags
  )
}
# ★ 1AZぶんだけ Mount Target を作成（単数）
resource "aws_efs_mount_target" "this" {
  count           = var.enable_efs ? 1 : 0
  file_system_id  = aws_efs_file_system.this[0].id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.this[0].id]
}

# Access Point（POSIX権限固定）
resource "aws_efs_access_point" "this" {
  count          = var.enable_efs ? 1 : 0
  file_system_id = aws_efs_file_system.this[0].id

  posix_user {
    uid = var.posix_uid
    gid = var.posix_gid
  }

  root_directory {
    path = var.ap_root_dir
    creation_info {
      owner_uid   = var.posix_uid
      owner_gid   = var.posix_gid
      permissions = "0755"
    }
  }

  tags = merge(
    var.common_tags,
    { Name = "${var.name_prefix}-efs-ap" },
    var.tags
  )
}
