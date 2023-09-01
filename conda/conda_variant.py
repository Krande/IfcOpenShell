import pathlib
import argparse
import yaml


def main(conda_dir, variants):
    """A function that makes a copey of a conda_build_config.yaml and creates a copy with only the desired variant"""

    conda_dir = pathlib.Path(conda_dir)
    with open(conda_dir / "conda_build_config.yaml", "r") as f:
        config = yaml.safe_load(f)

    for variant in variants:
        variant_name, *variant_version = variant.split('=')
        variant_version_str = '='.join(variant_version)
        config[variant_name] = [variant_version_str]

    # write yaml file
    with open(conda_dir / "_conda_build_config.yaml", "w") as f:
        yaml.safe_dump(config, f, indent=2)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("conda_dir", type=str, help="The directory of the conda recipe")
    parser.add_argument("variant", type=str, nargs='+', help="The dependency variant to use, ie. occt=7.5.0=*novtk*")

    args = parser.parse_args()
    main(args.conda_dir, args.variant)
