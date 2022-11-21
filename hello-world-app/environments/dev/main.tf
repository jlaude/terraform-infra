data "terraform_remote_state" "project" {
  backend = "gcs"


  config ={
    bucket = "0efe1a640c36e423-bucket-tfstate"
    prefix = "terraform/state/project/dev"

  }
}

data "terraform_remote_state" "network" {
  backend = "gcs"


  config ={
    bucket = "0efe1a640c36e423-bucket-tfstate"
    prefix = "terraform/state/network/dev"

  }
}

locals {
  environment = data.terraform_remote_state.project.outputs.environment
  project_id  = data.terraform_remote_state.project.outputs.project_id
  vpc = data.terraform_remote_state.network.outputs.vpc
}


# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                               = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                              = "23.3.0"
  kubernetes_version                   = "1.24.5-gke.600"
  project_id                           = local.project_id
  name                                 = "jlaude-labs-${local.environment}-gke-cluster"
  region                               = "us-central1"
  zones                                = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                              = local.vpc
  subnetwork                           = "dev-subnet-us-central1"
  ip_range_services                    = "dev-subnet-secondary-range-services"
  ip_range_pods                        = "dev-subnet-secondary-range-pods"
  http_load_balancing                  = false
  network_policy                       = false
  horizontal_pod_autoscaling           = true
  filestore_csi_driver                 = false
  enable_private_endpoint              = false
  enable_private_nodes                 = true
  monitoring_enable_managed_prometheus = true
  cluster_autoscaling = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    "gpu_resources" : [],
    "max_cpu_cores" : 0,
    "max_memory_gb" : 0,
    "min_cpu_cores" : 0,
    "min_memory_gb" : 0
  }

  node_pools = [
    {
      name                   = "default-node-pool"
      machine_type           = "e2-medium"
      node_locations         = "us-central1-a,us-central1-b,us-central1-c"
      min_count              = 1
      max_count              = 4
      local_ssd_count        = 0
      spot                   = false
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      enable_gcfs            = false
      enable_secure_boot     = true
      enable_gvnic           = false
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      preemptible            = false
      initial_node_count     = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  /*
  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
*/

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }

}


#GKE Service Account Bindings

data "google_service_account" "gke_sa" {
  account_id = module.gke.service_account
}

resource "google_project_iam_binding" "gke_sa_artifact_registry_reader" {
  project = var.cicd_project
  role    = "roles/artifactregistry.reader"

  members = [
    data.google_service_account.gke_sa.member,
  ]

  depends_on = [module.gke.service_account]
}

#Create cloud deploy SA
resource "google_service_account" "cloud_deploy_sa" {
  account_id   = var.cloud_deploy_cicd_sa_prefix
  display_name = "Cloud Deploy ${local.environment} environment Service Account"
  project      = var.cicd_project
}

# Granting Cloud Build Service Account User permissions on Cloud Deploy SA
module "iam_service_accounts_iam" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "7.4.1"

  service_accounts = [google_service_account.cloud_deploy_sa.email]
  project          = var.cicd_project
  mode             = "additive"
  bindings = {
    "roles/iam.serviceAccountUser" = [
      "serviceAccount:${var.cloud_build_sa}",
    ]
  }

}

#Grant permissions in environment on Cloud Deploy SA
module "project_iam_binding_environment_project" {

  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.4.1"
  projects = [local.project_id]
  mode     = "additive"

  bindings = {
    "roles/container.clusterViewer" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
    "roles/container.developer" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
  }
  depends_on = [google_service_account.cloud_deploy_sa]
}

#Grant permissions in CICD project on Cloud Deploy SA
module "project_iam_binding_cicd_project" {

  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.4.1"
  projects = [var.cicd_project]
  mode     = "additive"

  bindings = {
    "roles/clouddeploy.jobRunner" = [
    "serviceAccount:${var.cloud_deploy_cicd_sa_prefix}@${var.cicd_project}.iam.gserviceaccount.com",
    ]
  }
  depends_on = [google_service_account.cloud_deploy_sa]
}
