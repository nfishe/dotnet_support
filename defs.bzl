def _typeof(value, typeof):
    return type(value) == type(typeof)

def _kwargs(additional_env = None, **kw):
    processed_args = dict(kw)
    env = []

    if additional_env:
        env.append(additional_env)

    execution_env = {}
    for e in env:
        execution_env.update(e)

    processed_args["env"] = execution_env

    return processed_args

def _run(ctx, multilevel_lookup = 1, **kw):
    processed_args = _kwargs(
        additional_env = {
            # _dontet_config[dotnet_common.<>] is the configuration environemnt
            "DOTNET_MULITLEVEL_LOOKUP": "1",
            # Run remote
            "DOTNET_CLI_HOME": None
        },
        **kw
    )

    execuable_args = ctx.actions.args()
    executable = processed_args.pop("executable")
    
    execuable_args.add(execuable)
    execuable_args.add_all(
        processed_args.pop("arguments", default = [])
    )

    tools = processed_args.pop("tools", None)

    if _typeof(tools, []):
        tools.append(execuable)


    ctx.actions.run(
        arguments = execuable_args,
        tools = tools,
        executable = ctx.execuable._core_host,
        **processed_args
    )

dotnet_support = struct(
    run = _run
)