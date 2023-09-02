import argparse
import pathlib

from ruamel.yaml import YAML


def main(variants):
    yaml = YAML(typ='rt')
    # yaml.explicit_start = True
    yaml.indent(mapping=2, offset=2)
    yaml.preserve_quotes = True  # not necessary for your current input
    yaml.allow_duplicate_keys = True

    """A function that makes a copey of a conda_build_config.yaml and creates a copy with only the desired variant"""

    conda_dir = pathlib.Path(__file__).parent.absolute()
    with open(conda_dir / "conda_build_config.yaml", "r") as f:
        config = yaml.load(f)

    for variant in variants:
        variant_name, *variant_version = variant.split('=')
        variant_version_str = '='.join(variant_version)
        config[variant_name] = [variant_version_str]

    # write yaml file
    with open(conda_dir / "_conda_build_config.yaml", "w") as f:
        yaml.dump(config, f)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("variant", type=str, nargs='+', help="The dependency variant to use, ie. occt=7.5.0=*novtk*")

    args = parser.parse_args()
    main(args.variant)
