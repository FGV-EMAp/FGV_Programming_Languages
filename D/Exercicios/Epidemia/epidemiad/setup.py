from pyd.support import setup, Extension
import os, json

f = os.popen('dub describe')
build_pars = json.loads(f.read())['targets'][0]['buildSettings']

projName = "epidemiad"

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, ['source/models.d', 'source/multinomial'],
                  include_dirs=build_pars['importPaths'],
                  extra_link_args=build_pars['linkerFiles'],
                  # extra_compile_args=['-w'],
                  build_deimos=True,
                  d_lump=True
                  )
    ],
)
