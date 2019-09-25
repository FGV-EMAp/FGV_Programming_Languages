from pyd.support import setup, Extension

projName = "Epidemiad"

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, ['source/models.d'],
                  include_dirs=['~/.dub/packages/mir-random-2.2.6/mir-random/source',
                                '~/.dub/packages/mir-core-1.0.2/mir-core/source/',
                                '~/.dub/packages/mir-3.2.0/mir/source/',
                                '~/.dub/packages/mir-linux-kernel-1.0.1/mir-linux-kernel/source/',
                                '~/.dub/packages/mir-algorithm-3.5.5/mir-algorithm/source/'
                                ],
                  # extra_compile_args=['-w'],
                  build_deimos=True,
                  d_lump=True
                  )
    ],
)
