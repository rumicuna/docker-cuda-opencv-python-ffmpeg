# docker-cuda-opencv-python-ffmpeg
Repository for clean Dockerfile containing docker, cuda, opencv, python-ffmpeg, based on Ubuntu

# Build
You can build it on your own

``` bash
git clone https://github.com/rumicuna/docker-cuda-opencv-python-ffmpeg.git
cd docker-cuda-opencv-python-ffmpeg
    
# takes lots of time, be prepared
docker build -t rumicuna/docker-cuda-opencv-python-ffmpeg .

# Usage

Image has OpenCV3, python2.7 and ffmpeg ready to use. Example:

``` bash
docker run --rm -it -v $PWD:/workspace rumicuna/docker-cuda-opencv-python-ffmpeg bash
```
