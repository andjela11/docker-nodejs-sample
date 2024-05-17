variable "Owner" {
    type = string
    default = "Andjela Jovanovic"
}

variable "github_profile" {
  description = "Name for GitHub profile"
  type = string
  default = "andjela11"
}

variable "github_repo" {
  description = "Name for GitHub repo"
  type = map(string)
  default = {
    "todo-app-repo" = "docker-nodejs-sample"
  }
}