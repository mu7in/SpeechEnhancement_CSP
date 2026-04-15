# Speech Enhancement System using DSP

This project demonstrates a simple speech enhancement pipeline in MATLAB. A clean speech recording is loaded from a WAV file, artificial noise is added, and then two digital filters are applied to reduce the noise:

- `FIR` low-pass filter
- `IIR` Butterworth low-pass filter

The project is useful for understanding core Digital Signal Processing concepts such as signal loading, noise injection, filter design, FFT-based comparison, and quality evaluation using `SNR` and `MSE`.

## Project Goal

The main idea is:

1. Read a clean speech signal from `audio.wav`
2. Add controlled random noise
3. Process the noisy signal using FIR and IIR filters
4. Compare the original, noisy, and filtered outputs
5. Save plots for reports/presentation material
6. Measure quality using numerical metrics

## What This Project Shows

- How speech gets corrupted by additive noise
- How low-pass filters can suppress high-frequency noise
- The difference between FIR and IIR filtering
- How time-domain and frequency-domain plots help in comparison
- How to evaluate filtering quality using `snr()` and `mean()`

## Repository Structure

```text
SpeechEnhancement_CSP/
|-- speech_CSP.m                Main MATLAB script
|-- speech_CSP.asv              MATLAB autosave/backup file
|-- audio.wav                   Input speech signal
|-- Speech_CSP.prj              MATLAB project file
|-- Documentation/              Report files and supporting writeups
|-- Latex/                      LaTeX source and generated images
|-- resources/                  Images/audio copied for project/report use
|-- README.md                   Project explanation
|-- AGENT.md                    Guide for future contributors/agents
```

## Requirements

- MATLAB
- Signal Processing Toolbox functions used by the script:
  - `audioread`
  - `fir1`
  - `butter`
  - `filter`
  - `freqz`
  - `snr`
  - `sound`

## How To Run

Open MATLAB in this project folder and run:

```matlab
speech_CSP
```

The script will:

- load `audio.wav`
- generate a noisy version of the signal
- apply FIR and IIR filters
- save plots as PNG files
- print SNR and MSE values
- play the original, noisy, FIR, and IIR signals one after another

## Important Assumption in the Script

The script sets:

```matlab
report_dir = 'Project_Final_220932386_Muhsin';
```

and later saves images into that folder using `fullfile(report_dir, ...)`.

That means this folder must already exist before running the script, otherwise the image-saving commands to that path may fail. If needed, create it manually in MATLAB before running:

```matlab
mkdir('Project_Final_220932386_Muhsin');
```

## Full Code Flow

The complete script follows this order:

1. Clear MATLAB state
2. Read the speech audio file
3. Convert stereo to mono if needed
4. Build a time axis
5. Add reproducible random noise
6. Design a low-pass FIR filter
7. Design a low-pass Butterworth IIR filter
8. Filter the noisy signal through both filters
9. Plot time-domain waveforms
10. Plot FFT magnitude spectra
11. Plot filter responses
12. Compute and print SNR
13. Compute and print MSE
14. Play all four signals for listening comparison

## Line-by-Line Explanation of `speech_CSP.m`

This is the most important part for your presentation because almost all of the project logic is inside one script.

### Lines 1-3: Reset MATLAB workspace

```matlab
clc;
clear all;
close all;
```

- `clc;` clears the command window.
- `clear all;` removes variables from memory.
- `close all;` closes all open figure windows.

Purpose: make sure the script starts from a clean state every time.

### Line 5: Section heading

```matlab
%% speech_CSP.m - Complete Script using audio.wav
```

- This is only a section comment for readability in MATLAB.

### Lines 7-11: Load and prepare the audio signal

```matlab
[x, fs] = audioread('audio.wav');
x = x(:,1)';
t = (0:length(x)-1) / fs;
report_dir = 'Project_Final_220932386_Muhsin';
```

- `audioread('audio.wav')` loads the speech file.
- `x` stores the audio samples.
- `fs` stores the sampling frequency in Hz.
- `x = x(:,1)'` selects the first channel if the audio is stereo and converts it into a row vector.
- `t = (0:length(x)-1) / fs` creates the time axis in seconds for plotting.
- `report_dir = ...` stores the output folder name used for saving report images.

Why this matters:

- DSP operations need the actual samples and the sampling rate.
- Plotting against time is more meaningful than plotting only against sample number.

### Lines 13-16: Add artificial noise

```matlab
rng(0);
noise_power = 0.05;
noisy_signal = x + noise_power * randn(size(x));
```

- `rng(0)` fixes the random seed.
- This makes the random noise reproducible every time the script runs.
- `noise_power = 0.05` controls how strong the added noise is.
- `randn(size(x))` generates Gaussian white noise with the same shape as `x`.
- `noisy_signal = x + ...` adds the noise to the original speech.

Why this matters:

- Reproducibility is important for reports and presentations.
- Without fixed seed, SNR and plots could change slightly every run.

### Lines 18-22: FIR filter design and filtering

```matlab
fir_order = 50;
fir_cutoff = 3400 / (fs/2);
b_fir = fir1(fir_order, fir_cutoff);
fir_output = filter(b_fir, 1, noisy_signal);
```

- `fir_order = 50` sets the filter order.
- `3400 / (fs/2)` normalizes the cutoff frequency with respect to the Nyquist frequency.
- `fir1(...)` designs an FIR low-pass filter.
- `b_fir` contains the numerator coefficients of the FIR filter.
- `filter(b_fir, 1, noisy_signal)` applies the FIR filter to the noisy signal.
- The denominator is `1` because FIR filters are non-recursive in this form.

Why 3400 Hz:

- Speech intelligibility is often concentrated in lower frequency ranges.
- A low-pass filter can help suppress higher-frequency noise.

### Lines 24-28: IIR filter design and filtering

```matlab
iir_order = 4;
iir_cutoff = 3400 / (fs/2);
[b_iir, a_iir] = butter(iir_order, iir_cutoff, 'low');
iir_output = filter(b_iir, a_iir, noisy_signal);
```

- `iir_order = 4` sets the Butterworth filter order.
- The cutoff is again normalized by Nyquist frequency.
- `butter(..., 'low')` designs a low-pass Butterworth IIR filter.
- `b_iir` and `a_iir` are numerator and denominator coefficients.
- `filter(b_iir, a_iir, noisy_signal)` applies the recursive IIR filter.

Why IIR is interesting:

- It usually achieves good filtering with lower order than FIR.
- It is computationally efficient, but phase behavior is generally less linear than FIR.

### Lines 30-66: Plot and save time-domain signals

This block creates separate figures for:

- original signal
- noisy signal
- FIR output
- IIR output

Example pattern:

```matlab
figure;
plot(t, x);
title('Original Speech Signal');
xlabel('Time (s)');
ylabel('Amplitude');
saveas(gcf, '1_original_signal.png');
saveas(gcf, fullfile(report_dir, 'original_signal.png'));
```

What each command does:

- `figure;` opens a new figure window.
- `plot(t, signal);` plots the waveform against time.
- `title(...)`, `xlabel(...)`, `ylabel(...)` label the graph.
- `saveas(gcf, ...)` saves the current figure.
- `gcf` means "get current figure".
- `fullfile(report_dir, ...)` creates a valid path using the chosen output folder.

Why two saves are used:

- One PNG is saved in the current folder with numbered names such as `1_original_signal.png`
- Another PNG is saved to the report directory with cleaner names such as `original_signal.png`

### Lines 68-116: Frequency-domain analysis and filter responses

This section compares the spectral content using FFT:

```matlab
plot(abs(fft(x)));
plot(abs(fft(noisy_signal)));
plot(abs(fft(fir_output)));
plot(abs(fft(iir_output)));
```

- `fft(...)` computes the Fast Fourier Transform.
- `abs(...)` takes magnitude only.
- This helps visualize how the spectral content changes before and after filtering.

Then the script plots filter responses:

```matlab
freqz(b_fir,1);
freqz(b_iir,a_iir);
```

- `freqz` shows the frequency response of a digital filter.
- For FIR: only numerator coefficients are needed with denominator `1`.
- For IIR: both numerator and denominator are needed.

Why this section is important in a viva/presentation:

- Time plots show waveform behavior.
- FFT plots show which frequency components are present.
- `freqz` shows how the filters behave mathematically.

### Line 118: Completion message

```matlab
disp('Done! All figures saved.');
```

- Prints a simple status message after all plots are saved.

### Lines 120-127: SNR calculation

```matlab
snr_noisy = snr(x, noisy_signal - x);
snr_fir = snr(x, fir_output - x);
snr_iir = snr(x, iir_output - x);

fprintf('SNR Noisy: %.2f dB\n', snr_noisy);
fprintf('SNR FIR: %.2f dB\n', snr_fir);
fprintf('SNR IIR: %.2f dB\n', snr_iir);
```

- `snr(signal, noise)` calculates signal-to-noise ratio in dB.
- For noisy input, the noise term is `noisy_signal - x`.
- For FIR output, the residual error term is `fir_output - x`.
- For IIR output, the residual error term is `iir_output - x`.
- `fprintf` prints the results in formatted form.

How to explain it:

- Higher SNR usually means better signal quality.
- A better filter should ideally improve SNR compared to the noisy signal.

Important observation:

- In your report table, FIR gives worse SNR than the noisy signal.
- That means this specific FIR design is smoothing the signal but also distorting useful speech components enough to reduce the metric.
- This is a strong discussion point in your presentation because it shows that filtering must be tuned, not just applied blindly.

### Lines 129-136: MSE calculation

```matlab
mse_noisy = mean((x - noisy_signal).^2);
mse_fir = mean((x - fir_output).^2);
mse_iir = mean((x - iir_output).^2);

fprintf('MSE Noisy: %.6f\n', mse_noisy);
fprintf('MSE FIR: %.6f\n', mse_fir);
fprintf('MSE IIR: %.6f\n', mse_iir);
```

- `x - processed_signal` gives the sample-by-sample error.
- `.^2` squares each error value.
- `mean(...)` computes average squared error.
- Lower MSE generally means the processed output is closer to the original clean signal.

How to explain it:

- SNR tells us relative noise strength.
- MSE tells us numerical closeness to the original signal.
- Together they give a stronger evaluation than visual inspection alone.

### Lines 138-155: Audio playback

```matlab
sound(x, fs);
pause(length(x)/fs + 1);
...
sound(noisy_signal, fs);
...
sound(fir_output, fs);
...
sound(iir_output, fs);
```

- `sound(signal, fs)` plays the signal at the correct sampling rate.
- `pause(length(signal)/fs + 1)` waits until playback finishes before starting the next signal.
- This allows listening comparison between:
  - original
  - noisy
  - FIR output
  - IIR output

Why this is useful:

- Hearing the result is very important in speech enhancement.
- A signal that looks smoother in a plot may not always sound better.

## MATLAB Concepts Used in This Project

### `audioread`

Reads a WAV file into MATLAB.

### `randn`

Creates Gaussian random noise.

### `fir1`

Designs an FIR filter using the window method.

### `butter`

Designs a Butterworth IIR filter.

### `filter`

Applies a digital filter to a signal.

### `fft`

Transforms a time-domain signal into the frequency domain.

### `freqz`

Shows the frequency response of a filter.

### `snr`

Measures signal-to-noise ratio.

### `mean`

Used here to compute MSE from squared error values.

## FIR vs IIR in This Project

### FIR

- Uses only present and past input values
- Usually stable
- Often preserves phase better
- Here it uses order `50`

### IIR

- Uses present/past inputs and past outputs
- More computationally efficient
- Can achieve stronger filtering with lower order
- Here it uses Butterworth order `4`

### Practical comparison in this project

- FIR output may look smoother
- IIR output performs better numerically in the report
- This gives a nice comparison between visual smoothness and quantitative quality

## Key Results You Can Say in the Presentation

Based on the report included in this repository:

- Noisy signal SNR: `4.77 dB`
- FIR output SNR: `-3.68 dB`
- IIR output SNR: `5.64 dB`
- Noisy signal MSE: `0.002494`
- FIR output MSE: `0.017465`
- IIR output MSE: `0.002041`

Interpretation:

- The IIR filter performs best among the tested outputs.
- The FIR filter reduces some visible noise but introduces more error relative to the original signal.
- So the lesson is not just "filtering helps", but "filter design choices strongly affect output quality".

## Good Viva / Professor Questions and How To Answer Them

### Why did you add noise artificially?

To simulate a noisy recording condition in a controlled way so that the clean signal is known and metrics like SNR and MSE can be measured.

### Why convert stereo to mono?

The project processes one speech waveform only. Using a single channel simplifies DSP operations and comparison.

### Why use 3400 Hz cutoff?

Because the main intelligible speech content is usually concentrated in lower frequencies, and a low-pass filter can help reduce higher-frequency noise.

### Why use both FIR and IIR?

To compare two classic DSP filtering approaches:

- FIR for simplicity, stability, and linear-phase advantages
- IIR for efficiency and lower-order implementation

### Why use both SNR and MSE?

Because visual inspection alone is not enough. SNR measures relative noise level, while MSE measures error relative to the original clean signal.

### Why is FIR worse than expected here?

Because the chosen filter parameters may remove not only noise but also useful speech components, causing distortion and poorer numerical performance.

## Suggested Improvements

If you want to improve the project later, you could add:

- automatic creation of the report output folder
- spectrogram comparison using `spectrogram()`
- zero-phase filtering using `filtfilt()` for fairer comparison
- parameter sweep for FIR order and cutoff frequency
- listening test notes
- side-by-side subplot figures instead of separate windows

## How To Push This Project To GitHub

This folder is currently not a Git repository, so you will first initialize Git and then connect it to GitHub.

### Step 1: Open terminal in this folder

Make sure you are inside:

```powershell
C:\Users\Muhsin\Desktop\INTERNSHIP\PROJECTS\SpeechEnhancement_CSP
```

### Step 2: Initialize Git

```powershell
git init
```

### Step 3: Add files

```powershell
git add .
```

### Step 4: Create first commit

```powershell
git commit -m "Initial commit - speech enhancement project"
```

If Git asks for identity, run:

```powershell
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

Then commit again.

### Step 5: Create an empty GitHub repository

On GitHub:

1. Log in
2. Click `New repository`
3. Choose a repository name such as `SpeechEnhancement_CSP`
4. Keep it empty
5. Do not add README or `.gitignore` there if you already have local files

### Step 6: Connect local repo to GitHub

Replace `YOUR_USERNAME` and the repository name if needed:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/SpeechEnhancement_CSP.git
```

### Step 7: Push the code

```powershell
git branch -M main
git push -u origin main
```

After that, your project will be available on GitHub.

## Recommended Files To Include On GitHub

You should definitely keep:

- `speech_CSP.m`
- `audio.wav`
- `Speech_CSP.prj`
- `Documentation/`
- `Latex/`
- `resources/`
- `README.md`
- `AGENT.md`

You may choose not to upload:

- `.session/`
- `speech_CSP.asv`

These are local/session-style files and are usually not important for collaborators.

## Final Summary

This project is a compact MATLAB speech enhancement demo that compares FIR and IIR low-pass filtering on a noisy speech recording. The code is easy to present because the entire workflow lives in one main file, and the most important discussion point is that filter design quality matters more than simply applying a filter. In your current implementation, the IIR filter is the better-performing approach according to both SNR and MSE.
