load("@rules_cc//cc:action_names.bzl", "C_COMPILE_ACTION_NAME")
load("@rules_cc//cc:find_cc_toolchain.bzl", "find_cc_toolchain", "use_cc_toolchain")
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")

CheckCSourceCompilesInfo = provider(fields = ["check_file"])

def _check_c_source_compiles_impl(ctx):
    cc_toolchain = find_cc_toolchain(ctx, mandatory = True)

    source_file = ctx.actions.declare_file("check_c_source_compiles.c")
    ctx.actions.write(source_file, ctx.attr.source)

    object_file = ctx.actions.declare_file(ctx.label.name + ".o")
    check_file = ctx.actions.declare_file(ctx.label.name + ".check")

    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )
    c_compiler_path = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
    )
    c_compile_variables = cc_common.create_compile_variables(
        feature_configuration = feature_configuration,
        cc_toolchain = cc_toolchain,
        user_compile_flags = ctx.fragments.cpp.copts + ctx.fragments.cpp.conlyopts,
        source_file = source_file.path,
        output_file = object_file.path,
    )
    command_line = cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
        variables = c_compile_variables,
    )
    env = cc_common.get_environment_variables(
        feature_configuration = feature_configuration,
        action_name = C_COMPILE_ACTION_NAME,
        variables = c_compile_variables,
    )

    wrapper = ctx.attr._check_c_source_compiles[DefaultInfo].files_to_run.executable

    ctx.actions.run(
        executable = wrapper,
        arguments = [check_file.path, c_compiler_path] + command_line,
        env = env,
        inputs = depset(
            [source_file],
            transitive = [cc_toolchain.all_files],
        ),
        outputs = [object_file, check_file],
    )

    return [
        DefaultInfo(files = depset([object_file, check_file])),
        CheckCSourceCompilesInfo(check_file = check_file),
    ]

check_c_source_compiles = rule(
    implementation = _check_c_source_compiles_impl,
    attrs = {
        "source": attr.string(mandatory = True),
        "_check_c_source_compiles": attr.label(
            default = ":check_source_compiles",
            executable = True,
            cfg = "exec",
        ),
    },
    toolchains = use_cc_toolchain(),
    fragments = ["cpp"],

    # TODO: add variables from here as parameters:
    # https://cmake.org/cmake/help/latest/module/CheckCSourceCompiles.html
)
