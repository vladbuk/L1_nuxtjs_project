# Final project 

This project is a simple nuxt.js web application. For deploy to testing or production environment, it used Jenkins pipelines. There are two key branches in a repository - **main** and **test**. Pushing or merge code to one or that branches has started pipeline which has built docker image in Jenkins agent. The built image is pushed to docker hub. On a corresponding environment is run docker container which use pulled image. 

For creating and provisioning infrastructure is used corresponding Terraform and Ansible jobs in Jenkins. 


## Project links

Main repository: https://github.com/vladbuk/L1_nuxtjs_project.git

Jenkins file for testing environment: https://github.com/vladbuk/L1_nuxtjs_project/blob/test/Jenkinsfile

Jenkins file for production environment: https://github.com/vladbuk/L1_nuxtjs_project/blob/main/Jenkinsfile_production

Terraform and ansible repository: https://github.com/vladbuk/L1_IaC.git

## Additional links

This project on Azure static web app: https://orange-dune-0bbed7d03.2.azurestaticapps.net/

Hometasks: https://github.com/vladbuk/L1_hometasks.git

S3 backet static website: https://s3web.vladbuk.site/

S3 backet static website original link: http://s3.vladbuk.site.s3.eu-central-1.amazonaws.com/index.html


## Build Setup

The application requires node js v16.

```bash
# install dependencies
npm install

# serve with hot reload at localhost:3000
npm run dev

# build for production and launch server
npm run build
npm run start

# generate static project
npm run generate

# run testing app in docker container
docker run -d -t --name nuxt-docker --restart always -p 80:8080 vladbuk/nuxt-docker

# run production app in docker container
docker run -d -t --name nuxt-docker --restart always -p 80:8080 vladbuk/nuxt-docker-production:latest
```

For a detailed explanation on how to work the with app, check out [Nuxt.js docs](https://nuxtjs.org).
