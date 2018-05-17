# My cheap devops stack!

Well, this is a repository to store the contents of [danybmx.github.io/blog/blog/2018/my-cheap-devops-stack](https://danybmx.github.io/blog/blog/2018/my-cheap-devops-stack). Go there and take a look!

## Clone
```
git clone git@github.com:danybmx/docker-sample-use-case.git
```

## Generate certificates
```
sh ./create-registry-certificates.sh
```

## Replace the docker-compose IP with your own

Run the following command replacing `__WRITE_HERE_YOUR_IP__` with your private or public IP (it depends if you want it online).
```
 sed -i -- 's/{{YOUR_IP}}/__WRITE_HERE_YOUR_IP__/g' docker-compose.yml
```

## User
- Default admin user is:
    - User: git@localhost
    - Password: 8eGBCXhN

You can change it on the docker-compose.yml before fist run.

## Run
Just execute and wait until you can access to http://{{YOUR_IP}}:9000/
```
docker-compose up -d
```

## Register your ci-runner

Go to Settings > Runners and copy the token that appears in red text color.

Go to the terminal, and navigate to the path where the docker-compose files are. Once there, run the following command:
```
docker-compose exec ci_runner gitlab-runner register
```

This will execute the `gitlab-runner register` command inside the runner instance and this will prompt you for some data in order to register the runner.

1. Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/)
    - Here you should write the internal http url to reach gitlab, in our case should be `http://gitlab` since `gitlab` is the name of the service.
2. Please enter the gitlab-ci token for this runner:
    - Just paste the token you copied on the website.
3. Please enter the gitlab-ci description for this runner:
    - A description for identify the runner from gitlab, I keep it with the default.
4. Please enter the gitlab-ci tags for this runner (comma separated):
    - I keep this blank too
5. Whether to lock the Runner to current project [true/false]:
    - Here I put false, if it's true, the runner will run only for a specific project.
6. Please enter the executor: docker, shell, ssh, docker-ssh+machine, docker-ssh, parallels, virtualbox, docker+machine, kubernetes:
    - docker
7. Please enter the default Docker image (e.g. ruby:2.1):
    - alpine

## Modify your ci-runner to run on aws spot.

We configured in the docker-compose.yml a volume for the runner instance in which the config.toml file of the runner that we've created in the previous step.

Now, we should modify it to configure it for run on aws spot instances. For that you can edit the config.toml file and add the following values:

```
concurrent = 1
check_interval = 0

[[runners]]
  name = "aws"
  url = "https://git.dpstudios.es/"
  token = "{{RUNNER_TOKEN}}"
  executor = "docker+machine"
  limit = 1
  [runners.docker]
    image = "alpine"
    privileged = true
    disable_cache = true
  [runners.cache]
    Type = "s3"
    ServerAddress = "s3.amazonaws.com"
    AccessKey = "{{YOUR_AWS_IAM_USER_ACCESS_KEY}}"
    SecretKey = "{{YOUR_AWS_IAM_USER_SECRET_KEY}}"
    BucketName = "gitlab-ci-runners-cache"
    BucketLocation = "{{YOUR_AMAZON_REGION}}"
    Shared = true
  [runners.machine]
    IdleCount = 0
    IdleTime = 600
    MachineDriver = "amazonec2"
    MachineName = "gitlab-docker-machine-%s"
    OffPeakTimezone = ""
    OffPeakIdleCount = 0
    OffPeakIdleTime = 0
    MachineOptions = [
      "amazonec2-access-key={{YOUR_AWS_IAM_USER_ACCESS_KEY}}",
      "amazonec2-secret-key={{YOUR_AWS_IAM_USER_SECRET_KEY}}",
      "amazonec2-region={{YOUR_AMAZON_REGION}}",
      "amazonec2-vpc-id={{YOUR_DEFAULT_VPC_ID}}",
      "amazonec2-use-private-address=false",
      "amazonec2-tags=runner-manager-name,aws,gitlab,true,gitlab-runner-autoscale,true",
      "amazonec2-security-group=docker-machine-scaler",
      "amazonec2-instance-type=m3.medium",
      "amazonec2-request-spot-instance=true",
      "amazonec2-spot-price=0.10",
      "amazonec2-block-duration-minutes=60"
    ]
```

That's all, refresh the website and you'll have a new ci-runner waiting!
