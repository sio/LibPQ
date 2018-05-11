#!/usr/bin/env python3
'''
Build script for packaging multiple Power Query functions into a Power Query
extension file (*.mez or *.pqx)
'''


import os
import zipfile
from textwrap import indent


SOURCE_EXT = ('.pq',)
DESTINATION_EXT = ('.pq', '.m')


def module(filename, module_name=None):
    '''Format a single module's source code for inclusion in *.mez package'''
    header = '\n\n\n/** {filename} **/\nshared {name} ='
    footer = ';'

    name, extension = os.path.splitext(os.path.basename(filename))
    if module_name is not None:
        name = module_name

    with open(filename) as f:
        code = f.read()

    return '\n'.join((
        header.format(**locals()),
        indent(code, ' ' * 4),
        footer.format(**locals()),
    ))


def section(name, filenames):
    '''Generate section document for Power Query'''
    header = 'section {name};'
    return header.format(**locals()) + '\n'.join(module(f) for f in filenames)


def list_modules(directory):
    '''Yield paths to Power Query code modules in the directory'''
    for extension in SOURCE_EXT:
        for name in os.listdir(directory):
            path = os.path.join(directory, name)
            if os.path.isfile(path) \
            and name.endswith(extension):
                yield path


def package(filename, sections):
    '''
    Create *.mez package

    filename:
        Destination name (full path) for the archive to be created
    sections:
        Dictionary containing section names with corresponding file lists, like
        {
            "Section1": [
                "/path/to/section1/module1.pq",
                "/path/to/section1/module1.pq"
            ],
            "Section2": ["/path/to/the/only/moduleinsection.pq"]
        }
    '''
    package = zipfile.ZipFile(filename, mode='w')
    for name, files in sections.items():
        code = section(name, files)
        if code:
            for extension in DESTINATION_EXT:
                package.writestr(name + extension, code)
    package.close()



def main():
    '''Demo function that assumes current working directory is Modules/'''
    package(
        'NewPackage.mez',
        {
            "LibPQ": ("../LibPQ.pq",),
            "LibPQ.Modules": list_modules('.')
        }
    )


if __name__ == '__main__':
    main()
