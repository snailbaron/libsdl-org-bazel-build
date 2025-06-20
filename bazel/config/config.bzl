FlagProvider = provider(fields = ["value"])

def _flag_impl(ctx):
    return FlagProvider(value = ctx.build_setting_value)

flag = rule(
    implementation = _flag_impl,
    build_setting = config.bool(flag = True),
    attrs = {
        "doc": attr.string(default = ""),
    },
)

StringProvider = provider(fields = ["value"])

def _string_impl(ctx):
    if ctx.attr.values and ctx.build_setting_value not in ctx.attr.values:
        fail("{} value must be one of {}".format(ctx.label, ctx.attr.values))

    return StringProvider(value = ctx.build_setting_value)

string = rule(
    implementation = _string_impl,
    build_setting = config.string(flag = True),
    attrs = {
        "doc": attr.string(default = ""),
        "values": attr.string_list(),
    },
)
