import os
import argparse

import ifcopenshell
from ifcopenshell.geom import create_shape

def attach_debugger():
    pid = os.getpid()
    # attach a running visual studio (with the code-aster project loaded) debugger to this process
    os.system(f"vsjitdebugger -p {pid}")
    print(f"Attached debugger to process {pid}")

def load_file(file_path):
    settings = ifcopenshell.geom.settings()

    f = ifcopenshell.open(file_path)

    iterator = ifcopenshell.geom.iterator(settings, f)
    iterator.initialize()

    while True:
        if not iterator.next():
            break

        shape = iterator.next()
        if shape and hasattr(shape, "geometry"):
            print(shape.geometry)

        print(shape)

    print("Done")




if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--file-path', type=str)
    parser.add_argument('--debug', action='store_true')
    args = parser.parse_args()
    print(args.file_path)
    if args.debug:
        attach_debugger()
    load_file(args.file_path)
    print('Done')