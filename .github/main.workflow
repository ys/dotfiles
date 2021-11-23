workflow "Docker build workstation" {
  on = "push"
  resolves = ["Push latest"]
}

action "Pull latest" {
  uses = "actions/docker/cli@master"
  args = "pull yannicks/dev:latest"
  needs = ["Docker Registry"]
}

action "Build Docker image" {
  uses = "actions/docker/cli@master"
  args = ["build", "-t", "yannicks/dev:$GITHUB_SHA", "-t", "yannicks/dev:latest", "./workstation"]
  needs = [
    "Pull latest",
  ]
}

action "Push sha" {
  uses = "actions/docker/cli@master"
  args = "push yannicks/dev:$GITHUB_SHA"
  needs = [
    "Push latest",
  ]
}

action "Push latest" {
  uses = "actions/docker/cli@master"
  needs = [
    "Build Docker image",
  ]
  args = "push yannicks/dev:latest"
}

action "Docker Registry" {
  uses = "actions/docker/login@master"
  secrets = [
    "DOCKER_PASSWORD",
    "DOCKER_USERNAME",
  ]
}
