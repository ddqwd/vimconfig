# 构建

git clone https://gitlab.freedesktop.org/virgl/virglrenderer.git
cd virglrenderer
meson build
ninja -C build -t compdb
