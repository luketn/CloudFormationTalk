FROM circleci/python:3.6.1
RUN pip install awscli --upgrade --user && \
    echo "export PATH=~/.local/bin:$PATH" > ~/.bash_profile && \
    . ~/.bash_profile
RUN aws --version