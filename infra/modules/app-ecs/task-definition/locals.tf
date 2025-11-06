# ---------------------------------------------
# Locals for ecs task-definition (socket ver.)
# ---------------------------------------------
locals {
  # --- volumes ---
  # エフェメラル共有（ソケット用）
  volumes_ephemeral = [
    { name = "php_runtime" },
    { name = "wp_root" } # ★ 追加：WPコアを置く共有エフェメラル
  ]

  # EFS ボリューム（既存の定義を流用）
  volumes_efs = var.enable_efs ? [
    {
      name = "efs_wpcontent"
      efsVolumeConfiguration = {
        fileSystemId      = var.efs_file_system_id
        transitEncryption = "ENABLED"
        authorizationConfig = {
          accessPointId = var.efs_access_point_id
          iam           = "ENABLED"
        }
      }
    }
  ] : []

  volumes_all = concat(local.volumes_ephemeral, local.volumes_efs)

  # --- mount points ---
  php_mount_points = concat(
    [
      {
        containerPath = "/var/www/html"
        sourceVolume  = "wp_root"
        readOnly      = false
      },
      {
        containerPath = "/run/php-fpm"
        sourceVolume  = "php_runtime"
        readOnly      = false
      }
    ],
    var.enable_efs ? [
      {
        containerPath = "/var/www/html/wp-content"
        sourceVolume  = "efs_wpcontent"
        readOnly      = false
      }
    ] : []
  )

  nginx_mount_points = concat(
    [
      {
        containerPath = "/var/www/html"
        sourceVolume  = "wp_root"
        readOnly      = true
      },
      {
        containerPath = "/run/php-fpm"
        sourceVolume  = "php_runtime"
        readOnly      = true
      }
    ],
    var.enable_efs ? [
      {
        containerPath = "/var/www/html/wp-content"
        sourceVolume  = "efs_wpcontent"
        readOnly      = true
      }
    ] : []
  )

  # --- containers ---
  php_container = merge(
    {
      name      = "php"
      image     = var.php_image
      essential = true

      # ソケット接続のため portMappings は不要
      portMappings = []

      mountPoints = local.php_mount_points
      environment = coalesce(var.php_environment, [])

      command = coalesce(var.php_command, ["php-fpm", "-F"]) # 必要に応じ上書き

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = "${var.family_prefix}/php"
          awslogs-create-group  = "true"
        }
      }
    },
    var.enable_php_healthcheck ? {
      healthCheck = {
        command     = var.php_healthcheck.command
        interval    = var.php_healthcheck.interval
        timeout     = var.php_healthcheck.timeout
        retries     = var.php_healthcheck.retries
        startPeriod = var.php_healthcheck.start_period
      }
    } : {}
  )

  nginx_container_base = {
    name      = "nginx"
    image     = var.nginx_image
    essential = true

    portMappings = [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ]

    mountPoints = local.nginx_mount_points
    environment = coalesce(var.nginx_environment, [])

    # PHP に依存（PHPCHECK有効時はHEALTHY、無効時はSTART）
    dependsOn = [
      {
        containerName = "php"
        condition     = var.enable_php_healthcheck ? "HEALTHY" : "START"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.log_group_name
        awslogs-region        = var.region
        awslogs-stream-prefix = "${var.family_prefix}/nginx"
        awslogs-create-group  = "true"
      }
    }
  }

  nginx_container = merge(
    local.nginx_container_base,
    var.enable_nginx_healthcheck ? {
      healthCheck = {
        command     = var.nginx_healthcheck.command
        interval    = var.nginx_healthcheck.interval
        timeout     = var.nginx_healthcheck.timeout
        retries     = var.nginx_healthcheck.retries
        startPeriod = var.nginx_healthcheck.start_period
      }
    } : {}
  )
}
