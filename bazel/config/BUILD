load(":config.bzl", "flag", "string")

flag(
    name = "relocatable",
    build_setting_default = False,
    doc = "Create relocatable SDL package",
)

flag(
    name = "android_jar",
    build_setting_default = True,
    doc = "Enable creation of SDL3.jar",
)

string(
    name = "assertions",
    build_setting_default = "auto",
    doc = "Enable internal sanity checks (auto/disabled/release/enabled/paranoid)",
    values = [
        "auto",
        "disabled",
        "release",
        "enabled",
        "paranoid",
    ],
)

flag(
    name = "assembly",
    build_setting_default = True,
    doc = "Enable assembly routines",
)

flag(
    name = "avx",
    build_setting_default = True,
    doc = "Use AVX assembly routines",
)
