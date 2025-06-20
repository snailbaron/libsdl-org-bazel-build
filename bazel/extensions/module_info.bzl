def _module_info_repository_impl(rctx):
    rctx.file("BUILD", content = """\
exports_files(["module_info.bzl"])
""")

    module_info_bzl_content = """\
module_info = struct(
    is_root = {is_root},
    version = "{version}",
}}
""".format(
        is_root = rctx.attr.is_root,
        version = rctx.attr.version,
    )

    rctx.file(
        "module_info.bzl",
        executable = False,
        content = module_info_bzl_content,
    )

module_info_repository = repository_rule(
    implementation = _module_info_repository_impl,
    attrs = {
        "is_root": attr.bool(mandatory = True),
        "version": attr.string(mandatory = True),
    },
)

def _module_info_impl(mctx):
    this_module = mctx.modules[0]
    module_info_repository(
        name = "module_info",
        is_root = this_module.is_root,
        version = this_module.version,
    )

module_info = module_extension(
    implementation = _module_info_impl,
)
