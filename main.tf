module "network" {
  source  = "./network"

  tracing_tags_enabled = true
}

module "virtual_machines" {
  source  = "./virtual_machines"
  subnet_id = module.network.web_subnet_id
}

module "load_balancer" {
  source = "./load_balancer"
  backend_pool_ids = module.virtual_machines.vm_ids
}

module "application_gateway" {
  source = "./application_gateway"
  backend_pool_ids = module.virtual_machines.vm_ids
}

module "sql_database" {
  source = "./sql_database"
}