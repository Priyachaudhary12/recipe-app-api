#Define the name of the image that we're going to use(base image that we pull from docker hub) that we're going to build on top of to add the dependencies that we need for our project
#python is the name of the docker image and alpine3.13 is the name of the tag
FROM python:3.9-alpine3.13   

#Define the maintainer (your name or your website name)
LABEL maintainer="codepandu"

#This is recommended when you are running python in a Docker container. It tells python that you don't want to buffer the output. The output from python will be printed directly to the console,
# which prevents any delays of messages getting from our python running application to the screen so we can see the logs immediately in the screen as they running. 
ENV PYTHONUNBUFFERED 1

#copy our requirements.txt from our local machine to /tmp/requirements.txt and this copies the requirements file that we added earlier into the docker image.
COPY ./requirements.txt /tmp/requirements.txt

# We are going to copy it to the temp directory so that we have it available during the build phase
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# copy the app directory inside the app directory in the container
COPY ./app /app

#It is the default directory that will commands are gonna to be run from when we run commands on our docker image and basically we're setting it to the location where our django
# project is going to be sent so that when we run the commands, we dont need to specify the full path of the django management command
WORKDIR /app

#We want to expose port 8000cfrom our container to our machine when we run the container
EXPOSE 8000


#This defines a build argument called dev and sets the default value to false. We're overriding this, inside our docker compose file by specifying args dev=true. So when we
# use this docker file through this docker compose configuration, it's going to update this dev to true whereas when we use it in any docker compose configuration, it's going
# to leave it as false. 
ARG DEV=false



#This runs the command on the alpine image that we are using when we're building our image. It creates an image for every run command and we want to avoid doing that to keep our images lightweight as possible
# So we do is specify a single run command and we break it down onto multiple lines using this &&\

#This creates a new virtual environment that we're going to use to store our dependencies
RUN python -m venv /py &&\  
# upgrade the pip inside our virtual env
    /py/bin/pip install --upgrade pip &&\
# install the requirements.txt file that we copied in the line13    the if statement is the shell scripting language
    /py/bin/pip install -r /tmp/requirements.txt &&\
    if [$DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ;\
    fi && \    
# remove the tmp directory bcoz we don't want any extra dependencies on our image    
    rm -rf /tmp &&\
# It calls the ADD User Command, which adds a new user inside our image. It is the best practice not to use the root user. If we didn't specify this, then the only user 
# available inside the alpine image that we're using would be the root user. The root user is the user that has full access and permissions to do everything on the server
# so anything that you can do can be done by the root user. It has no restrictions and limitations.     
    adduser \
        --disabled-password \
        --no-create-home \
#user name
        django-user


#We don't need to specify the full path of the environment that is /py/bin. It automatically adds to the system path when we run the docker.
ENV PATH="/py/bin:$PATH"


#So this is the last line of dockerfile and this specifies the user that we're switching to
USER django-user
