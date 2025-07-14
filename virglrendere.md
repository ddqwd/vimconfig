# 构建

```bash
git clone https://gitlab.freedesktop.org/virgl/virglrenderer.git
cd virglrenderer
rm -rf build
meson setup build \
    -Dbuildtype=debug \
    -Dprefix=`pwd`/install
    
cd build
ninja -j32 -t compdb 
ninja install
cp compile_commands.json ..
cd ..

```


# 源码分析

运行策略分为**子进程模式**和**&线程模式**
根据main注释，现在只支持**一个连接**

定义一个服务器结构 **render_server**

初始化流程如下:
1. 解析参数
2. 创建render_worker_jail, 该结构是一个链表
3. 创建一个render_client

之后开始运行render_server
监听模式使用的是一个poll模式
如果有事件, 获取该request 通过 全局dispatch table 获取对应的请求处理接口处理

render_client_dispatch_nop
render_client_op_init
render_client_op_create_context_request


## init 


## create_context
在这个函数中, 会创建一个新的context, 并且将这个context绑定到一个新的worker上
这个worker会被添加到worker_jail中
在该函数内部实现了main函数注释所说的**子进程模式**和**&线程模式**
如果是一个线程, 则运行 render_context_main
在render_context_main内部:
1. render_state_init
初始化状态,debug的环境变量,主要环境变量是VKR_DEBUG, 主要选项有 validate, udmabuf 
初始化日志

2. render_context_init
加载一个参数传入的driver,可以通过MESA_DRICONF_EXECUTABLE_OVERRIDE指定

3. render_context_run
接收客户端的请求,并且处理
主要业务如下 
```c++
/* context ops, which are handled by workers (subprocesses or threads) created
 * by the server process
 */
enum render_context_op {
   RENDER_CONTEXT_OP_NOP = 0,
   RENDER_CONTEXT_OP_INIT,
   RENDER_CONTEXT_OP_CREATE_RESOURCE, // render_context_dispatch_create_resource
   RENDER_CONTEXT_OP_IMPORT_RESOURCE,
   RENDER_CONTEXT_OP_DESTROY_RESOURCE,
   RENDER_CONTEXT_OP_SUBMIT_CMD,
   RENDER_CONTEXT_OP_SUBMIT_FENCE,

   RENDER_CONTEXT_OP_COUNT,
};
```
## render_context_dispatch_create_resource
资源的类型由一个virgl_resource_fd_type枚举定义
```c
enum virgl_resource_fd_type {
   VIRGL_RESOURCE_FD_DMABUF,
   VIRGL_RESOURCE_FD_OPAQUE,
   /* mmap()-able, usually memfd or shm */
   VIRGL_RESOURCE_FD_SHM,

   /**
    * An opaque handle can be something like a GEM handle, from which a
    * fd can be created upon demand.
    *
    * Renderers which use this type must implement virgl_context::export_fd
    *
    * Do not use this type for resources that are _BLOB_FLAG_USE_SHAREABLE,
    * as the opaque handle can become invalid/stale any time outside of the
    * original context.
    */
   VIRGL_RESOURCE_OPAQUE_HANDLE,

   VIRGL_RESOURCE_FD_INVALID = -1,
};
```

在该函数内部:
1. 查找ctx_id对应 的vkr_context
根据是否引用 一个存在的vkDeviceMemory 来创建对应的资源
* 如果不存在, 则会根据当前平台的不同, 创建对应的资源,在linux下
会创建一个临时文件,这个临时文件目录可以通过 XDG_RUNTIME_DIR 环境变量指定
具体的name是%s/mesa-shared-%s-xxxxx, %s是XDG_RUNTIME_DIR,, xxxx是debug_name, debug_name会根据不同的平台生成, 
默认是linux平台 , 所以是vkr-shmem, 如果在android是 mesa-shared
NOTE:这块有点混乱, 可能需要调试才能理解.l...
* 如果存在, 则首先会通过通过查找一个hash_table_entry获取一个vkr_device_memory指针,至于这个指针什么时候初始化的,还需要查看 
```c
struct vkr_device_memory {
vkr_device* device;
struct gbm_bo* gbm_bo;
int udmabuf_fd;
}

```

通过这个结构体可以看出应该是drm中的bo概念

2. 根据不同的内存类型, 获取不同的内存
主要有:
* dma_buf_fd
对于这种类型, 直接 调用 这个os中的fcntl拷贝一个新的fd, 这个原始的fd是udmabuf_fd

* gbm_bo 
这块还没有实现这个
* vulkan memory实现的bo
调用PFN_vkGetMemoryFdKHR

获取完一个fd之后会填充一个vigl_context_blob对象 这个对象是一个结构, 包含了这个fd和这个fd的类型, 以及相关的vulkan_info

3. 开始导入一个资源内部
=在这个创建的是一个vkr_resource对象, 这个对象会用到上面构造的这个blob对象 
之后将这个resource对象添加这个contxt的资源列表,也就是vkr_context的resource_table list中



##  render_context_dispatch_import_resource

如果这个资源是一个FD_SHM
那么会直接调用这个mmap函数,将这个资源映射到内存中
然后将这个指针填充vk_resource中的这个u.data中的

如果不是一个fd_shm, 那么填充这个fd字段

最后构造的这个vk_resource都会添加到这个context的resource_table中

## render_context_dispatch_destroy_resource



## render_context_dispatch_submit_cmd

下发的buffer主要填充到这个context中的这个vkr_cs_decoder中的这个cur指针中,并且增加end指针
之后循环这个decoder中的cur, 和end指针, 
分别调用不同的接口 对这个buffer进行解析
主要解析的类型有:
cmd_type
cmd_flags

根据类型和flags, 调用全局表vn_dispatch_table中的对应的函数进行处理

```c
static void (*const vn_dispatch_table[331])(struct vn_dispatch_context *ctx, VkCommandFlagsEXT flags) = {
    [VK_COMMAND_TYPE_vkCreateInstance_EXT] = vn_dispatch_vkCreateInstance,
    [VK_COMMAND_TYPE_vkDestroyInstance_EXT] = vn_dispatch_vkDestroyInstance,
    [

```
这些函数最终会调用这个vn_dispatch_context中的函数， 这些都是vulkan的函数


## render_context_dispatch_submit_fence


























