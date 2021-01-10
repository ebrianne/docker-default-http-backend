# Custom error pages for Kubernetes as default ingress backend

This project is based on work done by [@guillaumebriday](https://github.com/guillaumebriday) for [Traefik](https://doc.traefik.io/traefik/). 

## Dependencies

* [ruby](https://www.ruby-lang.org/en/) < 3.0.0
* [jekyll](https://jekyllrb.com/)

## Local development

First install ruby in your local machine. I would suggested [rbenv](https://github.com/rbenv/rbenv) to use different ruby versions if necessary. 

```bash
rbenv install 2.9.2
```

Go into the jekyll project folder and install dependencies

```bash
gem install bundler jekyll
bundle install
```

If you want to build the project locally

```bash
$ bundle exec jekyll build
```

If you want to preview the pages on your local machine

```bash
$ bundle exec jekyll serve
```

Open http://localhost:4000

## Build the Docker image

This is a [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/), to build the final image

```bash
docker build -t default-http-backend .
```

A user with uid/gid 101 (nginx) is already provided inside the default nginx docker image. It can be used to run the docker container as non-root user for more security.

## Deploy in Kubernetes with nginx-ingress

I use the chart provided by the Kubernetes community to install the nginx-ingress controller. See [here](https://github.com/kubernetes/ingress-nginx). In the `values.yaml` file for the Helm chart, modify the values under `defautBackend`

```yml
defaultBackend:
  ##
  enabled: true

  name: default-backend
  image:
    repository: ebrianne/default-http-backend
    tag: "latest"
    pullPolicy: IfNotPresent
    # nobody user -> uid 65534
    runAsUser: 101
    runAsNonRoot: true
    readOnlyRootFilesystem: false
    allowPrivilegeEscalation: false
```

## How it works?

[Nginx](https://www.nginx.com/) is used as Web server to serve the static files. To generate this pages, I use [Jekyll](https://jekyllrb.com/) in the first step of the build.

## Credits

I used @guillaumebriday project [traefik-custom-error-pages](https://github.com/guillaumebriday/traefik-custom-error-pages). Many thanks!