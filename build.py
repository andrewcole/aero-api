import pathlib

import click

import orjson

@click.group()
def main():
    pass

@click.argument("index", type=str)
@click.argument("type", type=str)
@click.argument("input", type=click.File(mode='r'))
@main.command()
def targets(
    index,
    type,
    input,
):
    data = orjson.loads(input.read())

    if type not in data:
        raise ValueError(f"{type} not found in data")

    for obj in [obj for obj in data[type] if index in obj]:
        print(obj[index].lower())


@click.argument("value", type=str)
@click.argument("index", type=str)
@click.argument("type", type=str)
@click.argument("input", type=click.File(mode='r'))
@click.option("--output", type=click.Path(dir_okay=True, path_type=pathlib.Path), required=False, default=pathlib.Path("."))
@main.command()
def generate(
    value,
    index,
    type,
    input,
    output
):
    data = orjson.loads(input.read())

    if type not in data:
        raise ValueError(f"{type} not found in data")

    for obj in [obj for obj in data[type] if index in obj and obj[index].lower() in [value.lower()]]:
        (output / type / index / obj[index].lower()).mkdir(parents=True, exist_ok=True)
        with open(output / type / index / obj[index].lower() / "data.json", "wb") as f:
            f.write(orjson.dumps(obj, option=orjson.OPT_INDENT_2))

if __name__ == "__main__":
    main()
