# AGENT.md

## Purpose

This repository contains a MATLAB-based speech enhancement mini-project centered around one main script: `speech_CSP.m`.

Anyone helping with this project should treat it as:

- a student DSP project
- a presentation/report-oriented codebase
- a MATLAB script project rather than a large software system

The top priority is preserving clarity and correctness for academic explanation.

## Main Entry Point

- `speech_CSP.m` is the main executable script

Most of the project logic is concentrated there:

1. load audio
2. add synthetic noise
3. design FIR filter
4. design IIR filter
5. generate plots
6. compute SNR and MSE
7. play audio signals

## Important Project Context

- Input speech file: `audio.wav`
- MATLAB project file: `Speech_CSP.prj`
- Report and writeup material exists in `Documentation/` and `Latex/`
- `resources/` contains report assets and MATLAB project metadata

This project appears to support both:

- code execution in MATLAB
- academic documentation and final report generation

## How To Read The Project Quickly

If you are new to the repo, read in this order:

1. `README.md`
2. `speech_CSP.m`
3. `Latex/Speech_CSP_Muhsin.tex`
4. `Documentation/` files if you need final report wording

That sequence gives the fastest understanding of both implementation and presentation intent.

## Behavior of `speech_CSP.m`

The script does the following:

- clears MATLAB state
- reads `audio.wav`
- converts stereo to mono by selecting the first channel
- creates a time vector
- adds Gaussian noise using a fixed random seed
- applies:
  - FIR low-pass filter of order 50
  - IIR Butterworth low-pass filter of order 4
- saves time-domain and frequency-domain plots
- saves filter response plots
- computes SNR and MSE
- plays original, noisy, FIR, and IIR signals sequentially

## Important Assumptions and Risks

### Output folder assumption

The script uses:

```matlab
report_dir = 'Project_Final_220932386_Muhsin';
```

It then tries to save images into that folder. If the folder does not exist, `saveas(..., fullfile(report_dir, ...))` can fail.

Preferred fix if editing later:

```matlab
if ~exist(report_dir, 'dir')
    mkdir(report_dir);
end
```

### Metrics interpretation

The current report values indicate:

- IIR performs better than the noisy baseline
- FIR may visually smooth the signal but performs worse numerically

Do not assume FIR is automatically superior just because the waveform looks smoother.

### Audio playback side effects

The script uses `sound()` and `pause()`, so execution is interactive and time-consuming. This matters when running repeated tests or demos.

## Editing Guidelines

- Keep the project beginner-friendly
- Prefer simple MATLAB code over advanced abstractions
- Preserve the academic/presentation focus
- Avoid changing output filenames unless the report is updated too
- If modifying filter parameters, also update README/report explanations
- Be careful not to break paths used by LaTeX or documentation assets

## Good Contributions

Helpful future improvements include:

- create `report_dir` automatically
- add comments directly in `speech_CSP.m`
- convert repeated plotting code into helper functions if the owner wants cleaner structure
- add spectrogram analysis
- compare `filter()` vs `filtfilt()`
- document expected MATLAB toolbox requirements more explicitly
- add a `.gitignore` before publishing to GitHub

## Files That Matter Most

- `speech_CSP.m`: core implementation
- `audio.wav`: source speech sample
- `Latex/Speech_CSP_Muhsin.tex`: report narrative and figures
- `README.md`: explanation for presentation prep

## Files That Are Lower Priority

- `speech_CSP.asv`: autosave backup
- `.session/`: local MATLAB session data

These should usually not drive code understanding or version-control decisions.

## If You Need To Explain The Project To Someone Quickly

Use this short explanation:

"This project loads a clean speech recording, adds synthetic noise, and then compares FIR and IIR low-pass filtering in MATLAB using plots, FFT analysis, and quality metrics like SNR and MSE."

## If You Need To Demo The Project

Recommended demo order:

1. show `audio.wav` as the input
2. explain the noisy signal generation
3. explain FIR and IIR filter design
4. show waveform plots
5. show FFT plots
6. discuss SNR and MSE results
7. play audio outputs if time allows

## Version Control Advice

If this repo is pushed to GitHub, prefer excluding:

- `.session/`
- `*.asv`

Everything else can be included unless file size becomes an issue.
