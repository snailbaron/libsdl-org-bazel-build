load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    "ACTION_NAMES",
)
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")

action_name_groups = struct(
    all_cc_compile_actions = [
        ACTION_NAMES.c_compile,
        ACTION_NAMES.preprocess_assemble,
        ACTION_NAMES.assemble,
        ACTION_NAMES.objc_compile,
    ],
)

features = struct(
    compile_with_utf8 = feature(
        name = "compile_with_utf8",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = action_name_groups.all_cc_compile_actions,
                flag_groups = ([
                    flag_group(flags = ["/utf-8"]),
                ]),
            ),
        ],
    ),
    w3 = feature(
        name = "w3",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = action_name_groups.all_cc_compile_actions,
                flag_groups = ([
                    flag_group(flags = ["/W3"]),
                ]),
            ),
        ],
    ),
)

def _msvc_toolchain_config(ctx):
    tool_paths = [
        tool_path(name = "gcc", path = "cl"),
        tool_path(name = "ld", path = "cl"),
        tool_path(name = "ar", path = "/bin/false"),
        tool_path(name = "cpp", path = "/bin/false"),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
        tool_path(name = "strip", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = [
            features.compile_with_utf8,
        ],
        cxx_builtin_include_directories = [
            "/usr/include",
        ],
        toolchain_identifier = "k8-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "k8",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

def _msvc_clang_toolchain_config(ctx):
    tool_paths = [
        tool_path(name = "gcc", path = "cl"),
        tool_path(name = "ld", path = "cl"),
        tool_path(name = "ar", path = "/bin/false"),
        tool_path(name = "cpp", path = "/bin/false"),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
        tool_path(name = "strip", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = [
            features.compile_with_utf8,
            features.w3,
        ],
        cxx_builtin_include_directories = [
            "/usr/include",
        ],
        toolchain_identifier = "k8-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "k8",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

def _clang_toolchain_config(ctx):
    tool_paths = [
        tool_path(name = "gcc", path = "/usr/bin/clang"),
        tool_path(name = "ld", path = "/usr/bin/ld"),
        tool_path(name = "ar", path = "/usr/bin/ar"),
        tool_path(name = "cpp", path = "/bin/false"),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
        tool_path(name = "strip", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = [],
        cxx_builtin_include_directories = [
            "/usr/include",
            "/usr/lib/clang/19/include",
        ],
        toolchain_identifier = "k8-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "k8",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

clang_toolchain_config = rule(
    implementation = _clang_toolchain_config,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)

msvc_toolchain_config = rule(
    implementation = _msvc_toolchain_config,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
