# omfilespy

[![ci](../../actions/workflows/ci.yml/badge.svg)](../../actions/workflows/ci.yml)

Use a static swift artifact via python!

Some useful links: 
- https://github.com/gmcheese/wrap-swift-python/tree/main
- https://pybind11.readthedocs.io/en/stable/
- https://theswiftdev.com/building-static-and-dynamic-swift-libraries-using-the-swift-compiler/


## How to develop on this?

```bash
make install
.venv/bin/pytest .
```

This will install the required dependencies as defined in the pyproject.toml file. Further, the pyproject.toml file also defines the build system, which is used by the `make install` command to build the swift artifact. The swift artifact is built using the swift compiler and the pybind11 library. The swift artifact is then copied to the `omfilespy` directory, which is then used by the python code to interact with the swift code.
