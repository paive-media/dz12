terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone      = "ru-central1-b"
  cloud_id  = "b1goo19u5plmpn9fd1sh"
  folder_id = "b1gnuohjjmafe4gd83hh"
}

resource "yandex_mdb_postgresql_cluster" "pg_cluster_2" {
  name        = "pg_cluster_2"
  environment = "PRODUCTION"
  # network_id = yandex_vpc_network.tfnet-2.id
  network_id = "enp2c9i81b2ba8ebbaq9"
  # security_group_ids  = [yandex_vpc_security_group.pgsql-sg3.id]
  security_group_ids  = ["enp7j4c8n4uurgkmn5h6"]
  deletion_protection = false

  config {
    backup_retain_period_days = 7
    version                   = "15"
    resources {
      resource_preset_id = "s1.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
    pooler_config {
      pool_discard = true
      pooling_mode = "TRANSACTION"
    }
    access {
      data_lens     = true
      data_transfer = true
      serverless    = true
      web_sql       = true
    }
  }

  host {
    assign_public_ip = true
    zone             = "ru-central1-b"
    name             = "pghost-ma"
    subnet_id        = yandex_vpc_subnet.tfsubnet-2.id
    # role      = "MASTER"
  }

  host {
    assign_public_ip = true
    zone             = "ru-central1-b"
    name             = "pghost-rb"
    subnet_id        = yandex_vpc_subnet.tfsubnet-2.id
    # role      = "REPLICA"
  }

  host {
    assign_public_ip = true
    zone             = "ru-central1-b"
    name             = "pghost-rc"
    subnet_id        = yandex_vpc_subnet.tfsubnet-2.id
    # role      = "REPLICA"
  }

  timeouts {
    create = "1h30m" # Полтора часа
    update = "2h"    # 2 часа
    delete = "30m"   # 30 минут
  }
}

resource "yandex_mdb_postgresql_database" "db2" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster_2.id
  name       = "db2"
  owner      = "user2"
}

resource "yandex_mdb_postgresql_user" "user2" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster_2.id
  name       = "user2"
  password   = "Passw2rd!"
}

# resource "yandex_vpc_network" "tfnet-2" {
#   name = "pgnet02"
# }

resource "yandex_vpc_subnet" "tfsubnet-2" {
  name = "pgsubnet02"
  zone = "ru-central1-b"
  # network_id     = yandex_vpc_network.tfnet-2.id
  network_id     = "enp2c9i81b2ba8ebbaq9"
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_vpc_security_group" "pgsql-sg3" {
  # id = enp7j4c8n4uurgkmn5h6
  name = "pgsql-sg3"
  # network_id = yandex_vpc_network.tfnet-2.id
  network_id = "enp2c9i81b2ba8ebbaq9"

  ingress {
    description    = "PostgreSQL"
    port           = 6432
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
