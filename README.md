# EPF - Parameter Screening

This repository is a companion to our paper `EPF: An Evolutionary, Protocol-Aware, and Coverage-Guided Network Fuzzing Framework`.

It provides a complete execution environment for you to reproduce our parameter screening. The evaluation platform we used has two AMD EPYC 7501 CPUs, 64 GiB of DDR4 RAM, and runs a Ubuntu 20.04.2 LTS server with stock 5.4.0-64-generic kernel provided by the
ubuntu package sources.

In each subfolder, you'll find a README file that aims to explain you what is happening in these folders.

Please check out following execution scripts in the repository root:



| script                                     | description                                                                                                                                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `00_setup.bash`                            | Setup the whole execution environment, including fuzzer compilation, validator setup, and dependency installation                                       |
| `01_run.bash`                              | Run the fuzzers for data aggregation. The raw data will be present in `/datasets`. Synopsis:  `FUZZER=<epf|aflnet> [AFFIRMATIVE=yes] [RUNS=n]`          | 
