
# ========== dockerfile by kiran  ================

FROM  ubuntu:latest   # we use custom images in real envirionments
LABEL  name="dev_environment"  # tag is comes under  LABEL

RUN makedir /app1
RUN groupadd appuser && useradd -r -g  appuser appuser
WORKDIR /app 
USER /appuser  # generally in orgnaization we do not use USER  , bcz if we give it,user gets root dir permissions 

ENV AWS_ACCESS_KEY_ID= XLLLL\
    AWS_SECRETES_KEY_ID=AQ\
    AWS_DEFAULT_REGION=ap-south-1a


COPY  file  /var/www/html   # default location for nginx 
COPY  file2 /var/www/html
ADD  file3 /var/www/html   # 
ADD  <URL>  /var/www/html/  # it download and copy it to /var/www/html location



ARG T_VERSION='1.6.6'\
    P_VERSION='1.8.0'

RUN  apt update && apt install -y  jq net-tools  curl wget unzip\
     && apt install -y nginx iputils-ping
    
RUN wget <terraform_url ${T_VERSION}>\
    && wget <packer url ${P_VERSION}\
    && unzip <terraorm packer> && unzip <packer> \
    && chmod 777 terraform  && chmod 777 packer\
    && ./terraform version && ./packer version

CMD ["nginx","-g ","daemon off " ]  # this keeeps nginx is running and run contaienr in background 



# docker build -t  dockerfile.dev .  // dockerfile.dev is  dcodker file name
# docker build -t gashok120707/custom:v1 -f dockerfile.dev .   // to tag along with build
# docker build -t gashok120707/custom:v1 -f dockerfile.dev .   --no-cache   // to build image from starting  with out using storing cache
# docker run --rm -d --name  app1 -p 8000:80 gashok120707/custom:v1

# #  how to  pass build arguments?
by using ARG, WE  can pass build arguments during build time 
# # how you can over ride argumetns?
docker build -t gashok120707/custom:v1  --build-arg  T_VERSION='1.6.7' --build-arg P_VERSION='1.9.9.' -f dockerfile.dev . 

# to see in detial veiw of each stage while building image
docker build -t gashok120707/custom:v1  --build-arg  T_VERSION='1.6.7' --build-arg P_VERSION='1.9.9.' -f dockerfile.dev . 

# to view history of docker images 
docker history <image name>


# #  how to  pass environments variables?
by using ENV  we can pass environment variables during container run time
# - 
# -

# to see environment variables in container 
docker exec -it contaienr_name  env    // we can see envirionments variables

# how you pass env varialbes while running contienrs 
docker run --rm  -d --name app2 -p 8010:80 -e AWS_ACCESS_KEY_ID=xyz -e AWS_SECRETES_KEY_ID=abc <image_name>

# docker system prune
it deletes all old build  images data and  dangling images(), so that it cleans unnessecary  images and freee space

# docker life cycle
crate docker file- build it-  create image- run continaer


# diff b/n cmd and entry point
CMD ["/usr/bin/ping", "-c 4 ", "www.ggole.com"]
    # if we mention this in docker file and run container and then i want to test it from command line and  want to ping youtube
CMD ["/usr/bin/ping", "-c 4 ", "www.youtube.com"]  
  # evnethough docker file has google.com , we can change it over command line

ENTRYPOINT  ["/usr/bin/ping", "-c 4 ", "www.ggole.com"]  # here in docker file we have google.com and want to try to ping over command line to youtube, it does not support 

EXPOSE #  it is a documentation b/n developer and who build the image

COPY   # copy file from loacel dir to dir 
ADD   get files from s3 / any other over the internet



# ========================================================================






















# ==================== docker file by abhi ======================================== 

# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with a base image
FROM golang:1.21 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application
RUN go build -o main .

#######################################################
# Reduce the image size using multi-stage builds
# We will use a distroless image to run the application
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]