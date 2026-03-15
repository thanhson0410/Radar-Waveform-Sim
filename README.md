# Radar Waveform Simulation

> MATLAB R2024a + Python 3.11 | March 2026

Simulation of radar waveforms: Composite Sine, AWGN noise analysis, and LFM Pulse Compression.

## Structure
```
 Radar-Waveform-Sim/
├── src/
│   ├── sin_wave_sim.m        # Basic sine wave + FFT
│   └── advanced_wave_sim.m   # AWGN + LFM pulse compression
├── runner/
│   └── run_matlab_sim.py     # Python MATLAB Engine runner
├── reports/
│   └── bao_cao_nang_cao.md   # Technical report (Vietnamese)
└── README.md
```

## Key Results
| Module | Result |
|---|---|
| Sin RMS | 0.8515 V (0% error vs theory) |
| AWGN SNR range | -5 dB to +20 dB |
| LFM BT product | 20 |
| Pulse Compression | 25:1 actual |
| PSL | -5.86 dB (target: -13.2 dB) |

## Requirements
- MATLAB R2024a
- Python 3.11 + `matlabengine==24.1.2`
- NumPy, Matplotlib (optional for Python plots)

## TODO / Issues
- [ ] #1 Apply window functions (Taylor/Hamming) to improve PSL
- [ ] #2 Add Doppler effect simulation
- [ ] #3 Implement NLFM waveform
