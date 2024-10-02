local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

local FORMATTING = methods.internal.FORMATTING
local RANGE_FORMATTING = methods.internal.RANGE_FORMATTING

return helpers.make_builtin({
    name = "palantir-java-format",
    meta = {
        url = "",
        description = "",
    },
    method = {
        FORMATTING,
        RANGE_FORMATTING,
    },
    filetypes = {
        "java",
    },
    generator_opts = {
        command = "palantir-java-format",
        args = function(params)
            if params.method == RANGE_FORMATTING and params.range then
                return {
                    "--palantir",
                    "--lines",
                    params.range.row .. ":" .. params.range.end_row,
                    "--skip-sorting-import",
                    "--skip-removing-unused-imports",
                    "--skip-javadoc-formatting",
                    "--skip-reflowing-long-string",
                    "-",
                }
            end
            return {
                "--palantir",
                "-",
            }
        end,
        to_stdin = true,
    },
    factory = helpers.formatter_factory,
})
