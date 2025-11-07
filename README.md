```
⏹️AWS WordPress/WooCommerce Infrastructure (Terraform + ECS Fargate + GitHub Actions)
──────────────────────────────────────────────────────────────────────────────
本リポジトリは、AWS上でWordPress/WooCommerceを運用するための
Well-Architected基準に準拠したインフラ構成を示すポートフォリオです。
ECS Fargate・Terraform・GitHub Actions(OIDC) を中心に、
本番運用を想定した設計を一部コード公開しています。
tfvars等アカウント情報が含まれるファイルは、非公開としています。
──────────────────────────────────────────────────────────────────────────────


⏹️概要
──────────────────────────────────────────────────────────────────────────────
・目的 : Terraform と GitHub Actions による自動化構成の学習・検証
・対象 : AWS Fargate で WordPress/WooCommerce を構築するインフラ層
・特徴 : 実環境で稼働確認済み（ECS, ALB, CloudFront, CI/CD）
・公開範囲 : 構成理解に必要な一部コード・設計情報のみ（安全設計）
──────────────────────────────────────────────────────────────────────────────


📂 実際のディレクトリ構成（非公開構成例）
──────────────────────────────────────────────────────────────────────────────
take1-project/
├── app/
│   ├── docker/
│   │   ├── nginx/
│   │   └── php/
│   └── src/
├── docs/
├── infra/
│   ├── envs/
│   │   └── dev/
│   │       ├── app-ecs/           # ECS (nginx+php-fpm, EFS, ALB, AutoScaling)
│   │       ├── app-data/          # RDS, RDS Proxy, Redis, Parameter Store
│   │       ├── app-repository/    # ECR Repositories
│   │       ├── dns/               # Route53 Zones / Records
│   │       ├── edge/              # CloudFront + WAF + ACM
│   │       ├── foundations/       # VPC, Subnets, RouteTables, NAT
│   │       ├── iam/               # IAM Roles / OIDC / Policies
│   │       └── waf/               # WAF Rules (ACL, IPSet)
│   └── modules/
│       ├── app-ecs/
│       │   ├── alb/
│       │   ├── cluster/
│       │   ├── efs/
│       │   ├── log-group/
│       │   ├── service/
│       │   ├── task-definition/
│       │   └── vpc-endpoints/
│       ├── app-data/
│       │   ├── rds/
│       │   ├── rds-proxy/
│       │   ├── redis/
│       │   └── parameter-store/
│       ├── cloudfront/
│       │   ├── acm/
│       │   ├── distribution/
│       │   └── s3/
│       ├── ecr/
│       │   └── repository/
│       ├── iam/
│       │   ├── ecs-execution-role/
│       │   ├── ecs-task-role/
│       │   ├── gha-oidc-role/
│       │   ├── github-oidc-provider/
│       │   └── policies/
│       ├── network/
│       │   ├── eip-egress/
│       │   ├── igw/
│       │   ├── nat-gateway/
│       │   ├── routetable-public/
│       │   ├── routetable-private/
│       │   ├── routetable-rds/
│       │   └── subnets/
│       ├── route53/
│       │   └── route53-records/
│       ├── s3/
│       │   ├── logging/
│       │   └── wp-media/
│       ├── securitygroup/
│       │   └── foundations/
│       │       └── bastion_sg/
│       ├── vpc/
│       └── waf/
└── scripts/
──────────────────────────────────────────────────────────────────────────────


🧩 公開ディレクトリ構成（ポートフォリオ公開範囲）
──────────────────────────────────────────────────────────────────────────────
.
├── README.md
├── docs/
│   ├── arichitecture-ecs-woocommerce.png
│   └── well-architected-summary.pdf
├── infra/
│   ├── modules/
│   │   └── app-ecs/
│   │       ├── cluster/
│   │       ├── service/
│   │       ├── task-definition/
│   │       └── alb/
│   └── example.tf
└── .github/
    └── workflows/
        ├── ecr-push.yml
        └── ecs-deploy.yml
──────────────────────────────────────────────────────────────────────────────


⚙️ 実装済みコンポーネント
──────────────────────────────────────────────────────────────────────────────
| カテゴリ                                | 実装状況        | 説明                                         
|----------------------------------------|------------------|----------------------------------------------
| CloudFront / WAF / Route53             | ✅ 完成         | HTTPSエンドツーエンド構成                    
| ECS / Fargate (nginx+php)              | ✅ 完成         | Unixソケット通信構成（/run/php-fpm/php-fpm.sock） 
| EFS (wp-content)                       | ✅ 完成         | 永続ボリューム構成                          
| ECS AutoScaling                        | ✅ 完成         | Target Tracking (CPU 70%)                   
| GitHub Actions (OIDC)                  | ✅ 完成         | ECR Push → ECS Deploy 自動化                 
| RDS (Aurora MySQL)                     | 🟡 構築経験あり | IaC化設計済み（未公開）                      
| Redis (ElastiCache)                    | 🟡 構築経験あり | WooCommerceキャッシュ層（設計済）             
| RDS Proxy                              | ⚪ 設計中       | IAM認証、コネクションプーリング設計中                 
| API Gateway / Lambda / DynamoDB        | ✅ 実装経験あり | Stripe Webhook連携                          
| AWS WAF                                | ✅ 実装経験あり | Managed Rules + Custom IPSet + Rate-Based 制御 
──────────────────────────────────────────────────────────────────────────────


🚀 ECS (Fargate) アプリケーション層
──────────────────────────────────────────────────────────────────────────────
・構成 : nginx + php-fpm の 2コンテナ構成
・通信方式 : Unixソケット通信（/run/php-fpm/php-fpm.sock）
・EFS : /var/www/html を永続化（wp-content同期）
・ヘルスチェック : ALB → nginx(80) → php-fpm(9000)
・ECS Exec : SSM経由で安全な保守アクセスを許可

🧠 技術的ハイライト
・ソケット通信最適化による低遅延化
・dependsOn + startPeriod による起動順序制御
・ソケット権限 (0660) と UID整合を調整し nginx接続失敗を解消
──────────────────────────────────────────────────────────────────────────────


📈 オートスケーリング
──────────────────────────────────────────────────────────────────────────────
・方式 : Target Tracking Scaling Policy
・メトリクス : ECSServiceAverageCPUUtilization
・ターゲット値 : 70%
・タスク数 : min=1 / max=4
・CloudWatch Alarms : CPU使用率に応じスケール制御
──────────────────────────────────────────────────────────────────────────────


🧠 CI/CD (GitHub Actions + OIDC)
──────────────────────────────────────────────────────────────────────────────
・Docker Build → ECR Push（短SHAタグ）
・Terraform Plan/Apply (Infra)
・ECS Service Update (Rolling Deploy)
・IAMロールは GitHub OIDC 経由でシークレットレスアクセス
──────────────────────────────────────────────────────────────────────────────


💾 Data Layer（設計・構築状況）
──────────────────────────────────────────────────────────────────────────────
| コンポーネント          | ステータス        | 備考                                     
|-------------------------|-------------------|------------------------------------------
| RDS (Aurora MySQL)      | 🟡 構築経験あり  | Terraform IaC化予定                      
| RDS Proxy               | ⚪ 設計中        | ECS再デプロイ時のDB安定化対策            
| Redis (ElastiCache)     | 🟡 構築経験あり  | WooCommerceセッション/キャッシュ層       
──────────────────────────────────────────────────────────────────────────────


🧩 Serverless Integration (Stripe API + Lambda + DynamoDB)
──────────────────────────────────────────────────────────────────────────────
Stripe Webhook → API Gateway → Lambda → DynamoDB の非同期連携を実装。
決済イベントを安全に受信し、トランザクションログをDynamoDBに保存。

🔹 構成概要
API Gateway (REST API)
   ↓
Lambda Function (Node.js)
   ↓
DynamoDB (TransactionLog Table)
   ↓
CloudWatch Logs (監視 / アラート連携)

🔹 技術ポイント
・Webhook Secret検証（Stripe-Signature ヘッダ）
・冪等性制御（event.idによる重複登録防止）
・DynamoDB TTLで古いイベント自動削除
・Lambdaレイヤによる軽量SDK構成
──────────────────────────────────────────────────────────────────────────────


🛡️ AWS WAF Implementation
──────────────────────────────────────────────────────────────────────────────
CloudFront レイヤに WAF を適用し、
AWS Managed Rules + IPSet + Rate-Based Rules による攻撃防御を実装。

🔹 設計ポイント
・SQLi / XSS / CommonRuleSet 有効化
・IPSetによるホワイトリスト制御
・Rate Limit (2000 req/5min) によるBot防御
・WAF Logs → S3 → Athena 解析基盤構築

🔹 運用面
・Terraform による WAF WebACL / RuleGroup 管理
・CloudWatch Alarm + SNS 通知で攻撃検知を自動化
──────────────────────────────────────────────────────────────────────────────


🧠 運用性・セキュリティ設計
──────────────────────────────────────────────────────────────────────────────
・IAMロール最小権限（ECSタスク実行 / OIDC / CloudFront制御）
・Terraformリモートステート：S3（DynamoDB非推奨となった為）
・CloudWatch Logs による統合ログ監視
・ECS Exec による安全な運用保守
──────────────────────────────────────────────────────────────────────────────


🔮 今後の展開
──────────────────────────────────────────────────────────────────────────────
・RDS Proxy の IaC化・負荷検証
・Redis キャッシュ統合・TTLチューニング
・WAFログ → Athena 分析の可視化
・Stripe Webhook の Terraform化
・AutoScaling モジュール共通化
──────────────────────────────────────────────────────────────────────────────


© 2025 Kita  
本リポジトリは技術紹介を目的として一部構成を公開したものであり、  
商用利用・再配布はご遠慮ください。
──────────────────────────────────────────────────────────────────────────────
```