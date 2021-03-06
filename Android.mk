LOCAL_PATH:= $(call my-dir)

# f2fs-tools depends on Linux kernel headers being in the system include path.
ifneq (,$(filter linux darwin,$(HOST_OS)))

# The versions depend on $(LOCAL_PATH)/VERSION
global_CFLAGS := -DWITH_ANDROID -DWITH_BLKDISCARD -DF2FS_MAJOR_VERSION=1 -DF2FS_MINOR_VERSION=7 -DF2FS_TOOLS_VERSION=\"1.7.0\" -DF2FS_TOOLS_DATE=\"2016-11-05\"

# external/e2fsprogs/lib is needed for uuid/uuid.h
common_C_INCLUDES := $(LOCAL_PATH)/include external/e2fsprogs/lib/

#----------------------------------------------------------
libf2fs_src_files := lib/libf2fs.c lib/libf2fs_io.c lib/libf2fs_zoned.c

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_static
LOCAL_SRC_FILES := $(libf2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
mkfs_f2fs_src_files := \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \
	mkfs/f2fs_format_main.c

include $(CLEAR_VARS)
LOCAL_MODULE := mkfs.f2fs
LOCAL_SRC_FILES := $(mkfs_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_CLANG := false
LOCAL_STATIC_LIBRARIES := libc libf2fs_static libext2_uuid_static
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
fsck_f2fs_src_files := \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/defrag.c \
	fsck/resize.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/dir.c \
	fsck/sload.c \
	fsck/xattr.c

include $(CLEAR_VARS)
LOCAL_MODULE := fsck.f2fs
LOCAL_SRC_FILES := $(fsck_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc libf2fs_static libext2_uuid_static
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := f2fstat
LOCAL_SRC_FILES := tools/f2fstat.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := fibmap.f2fs
LOCAL_SRC_FILES := tools/fibmap.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := parse.f2fs
LOCAL_SRC_FILES := tools/f2fs_io_parse.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host
LOCAL_SRC_FILES := \
    lib/libf2fs.c \
    mkfs/f2fs_format.c \
    mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS)
LOCAL_EXPORT_CFLAGS := $(global_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_HOST_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host_dyn
LOCAL_SRC_FILES := \
    lib/libf2fs.c \
    mkfs/f2fs_format.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(global_CFLAGS) -DANDROID_HOST
LOCAL_EXPORT_CFLAGS := $(global_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
LOCAL_STATIC_LIBRARIES := \
     libf2fs_fmt_host \
     libf2fs_ioutils_host \
     libext2_uuid_host \
     libsparse_host \
     libz
# LOCAL_LDLIBS := -ldl
include $(BUILD_HOST_SHARED_LIBRARY)

endif

