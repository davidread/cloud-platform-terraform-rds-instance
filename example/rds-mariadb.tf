/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
*/
module "rds_mariadb" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-rds-instance?ref=5.17.1"

  # VPC configuration
  vpc_name = var.vpc_name

  # RDS configuration
  allow_minor_version_upgrade  = true
  allow_major_version_upgrade  = false
  performance_insights_enabled = false
  db_max_allocated_storage     = "500"
  # enable_rds_auto_start_stop   = true # Uncomment to turn off your database overnight between 10PM and 6AM UTC / 11PM and 7AM BST.
  # db_password_rotated_date     = "2023-04-17" # Uncomment to rotate your database password.

  # MariaDB specifics
  db_engine         = "mariadb"
  db_engine_version = "10.6.12"
  rds_family        = "mariadb10.6"
  db_instance_class = "db.t4g.micro"
  db_parameter      = []

  # Tags
  application            = var.application
  business-unit          = var.business_unit
  environment-name       = var.environment
  infrastructure-support = var.infrastructure_support
  is-production          = var.is_production
  namespace              = var.namespace
  team_name              = var.team_name
}

resource "kubernetes_secret" "rds_mariadb" {
  metadata {
    name      = "rds-mariadb-instance-output"
    namespace = var.namespace
  }

  data = {
    rds_instance_endpoint = module.rds_mariadb.rds_instance_endpoint
    database_username     = module.rds_mariadb.database_username
    database_password     = module.rds_mariadb.database_password
    rds_instance_address  = module.rds_mariadb.rds_instance_address
    access_key_id         = module.rds_mariadb.access_key_id
    secret_access_key     = module.rds_mariadb.secret_access_key
  }
}
