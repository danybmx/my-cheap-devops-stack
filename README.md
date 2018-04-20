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

## Register your ci_runner

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

That's all, refresh the website and you'll have a new ci-runner waiting!