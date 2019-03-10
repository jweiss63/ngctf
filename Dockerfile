#
# This example Dockerfile illustrates a method to install
# additional packages on top of NVIDIA's TensorFlow container image.
#
# To use this Dockerfile, use the `docker build` command.
# See https://docs.docker.com/engine/reference/builder/
# for more information.
#
FROM nvcr.io/nvidia/tensorflow:19.01

# Install my-extra-package-1 and my-extra-package-2
RUN apt-get update && apt-get install -y --no-install-recommends \
        my-extra-package-1 \
        my-extra-package-2 \
      && \
    rm -rf /var/lib/apt/lists/

#
# This example Dockerfile illustrates a method to apply
# patches to the source code in NVIDIA's TensorFlow
# container image and to rebuild TensorFlow.  The RUN command
# included below will rebuild TensorFlow in the same way as
# it was built in the original image.
#
# By applying customizations through a Dockerfile and
# `docker build` in this manner rather than modifying the
# container interactively, it will be straightforward to
# apply the same changes to later versions of the TensorFlow
# container image.
#
# https://docs.docker.com/engine/reference/builder/
#
FROM nvcr.io/nvidia/tensorflow:19.01

# Bring in changes from outside container to /tmp
# (assumes my-tensorflow-modifications.patch is in same directory as Dockerfile)
COPY my-tensorflow-modifications.patch /tmp

# Change working directory to TensorFlow source path
WORKDIR /opt/tensorflow

# Apply modifications
RUN patch -p1 < /tmp/my-tensorflow-modifications.patch

# Rebuild TensorFlow for python 2 and 3
RUN ./nvbuild.sh --python2
RUN ./nvbuild.sh --python3

# Reset default working directory
WORKDIR /workspace
