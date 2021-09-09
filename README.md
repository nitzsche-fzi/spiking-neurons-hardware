# spikingneuronshw

You can use the scripts (`build_no_dsp.sh`, `build.sh`, `eval.sh`, `plot.sh`, `rtl.sh`, `sim.sh`) to simulate, build and evaluate the neurons. You can start the Shellscripts on Windows for example with the git bash. The scripts have one mandatory argument which is the directory name of the neuron. Some scripts allow additional optional arguments. Since they are just a small wrapper for convenience, you can alternatively just execute the commands of the scripts individually.

## Simulation & Synthesis
For simulation and sythesis we used Vivado 2020.1 on Windows. You can skip this chapter and use our results, if you don't have Vivado. The results are already contained in this repository in `.output` and `.reports` folders of the individual neurons.

Note, that we used a modified version of `fixed_pkg_2008.vhd`. First, copy `fixed_pkg_2008.vhd` from your Vivado installation path into `utils`. Then apply the patch in `utils`:
```
git apply --whitespace=fix .\implementation\utils\fixed_pkg_2008.vhd.patch
```

Use `sim.sh` to simulate the neuron in VHDL and store its action potential over time in a csv in `.output`. You can use the `--gui` option to run it in the simulator interactively. Otherwise it is run in background mode.
```
./sim.sh lif
```

Use `build.sh` and `build_no_dsp.sh` to generate the utilization, timing and power report for the normal build and the build without DSPs. You have to pass the target part as an argument.
```
./build.sh lif xzcu9eg
./build_no_dsp.sh lif xzcu9eg
```

Additionally, you can view the RTL. Therefor, use `rtl.sh`.
```
./rtl.sh lif
```

## Evaluation
For evaluation we used Python 3. For Linux use the *_linux version of the scripts and use `python3` instead of `python` in the command line. Install all requirements with:
```
python -m pip install -r requirements.txt
```

Before evaluation, we have to parse the build reports and convert them to a simpler format for evaluation. This is step can be skipped as well when using the given results in this repository.
```
./parse_reports lif
```

To evaluate i.e. compute all metrics of a neuron implementation, you can use `eval.sh`. The `--plot` option will generate plots which compare the Python to the VHDL implementation.
```
./eval.sh lif --plot
```

You can also simulate and plot the action potential of a neuron (in Python) for the input currents used in the paper.
```
./plot.sh lif
```
