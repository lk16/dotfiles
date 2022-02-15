
# List pydantic models and their fields

Click drop-in command:

* Lists all models and their fields alphabetically for specified modules
* Creates mermaid compatible graph as `model_graph.md` with `--graph` flag

```py
@cli.command()
@click.option("--graph", is_flag=True, default=False)
def list_models(graph: bool) -> None:
    modules = [
        "app.models.something",
        ...
    ]

    from pydantic import BaseModel

    import sys
    import inspect
    import importlib

    models = []

    for module in modules:
        importlib.import_module(module)

        for _, obj in inspect.getmembers(sys.modules[module]):
            if inspect.isclass(obj) and issubclass(obj, BaseModel):
                models.append(obj)


    if graph:
        relations = set()

        for model in models:
            for base in model.__bases__:
                relations.add((model.__name__, base.__name__))

        with open("model_graph.md", 'w') as f:

            f.write("```mermaid\n")

            # this string is split to prevent editor parser from breaking down
            f.write("flowchart " + "LR\n")

            for model, base in sorted(relations):
                f.write(f"    {model} --> {base}\n")

            f.write("```\n")

    else:
        for model in sorted(models, key=lambda x: x.__name__):
            print(model.__name__)
            for field in sorted(model.__fields__):
                print(f"- {field}")
            print()
```
