# BAO CAO NANG CAO: Mo Phong Tin Hieu, Nhieu AWGN va LFM

**Date:** 16/03/2026 | **Software:** MATLAB R2024a + Python 3.11

## Results Summary

### Sin Wave
- RMS = 0.8515 V (matches theory, error = 0%)
- Peak = 1.6090 V, Phase Fill Factor = 84.7%
- Energy = 0.7250 J/Ohm (Parseval verified)

### AWGN Analysis
| SNR (dB) | sigma_n (V) | SNR Actual | Detectability |
|---|---|---|---|
| 20 | 0.0851 | 20.01 dB | Excellent |
| 10 | 0.2693 | 10.01 dB | Good |
| 0 | 0.8515 | -0.05 dB | Hard |
| -5 | 1.5142 | -4.96 dB | Impossible |

### LFM Pulse Compression (BT=20)
| Parameter | Theory | Simulated |
|---|---|---|
| Compression Ratio | 20:1 | 25:1 |
| Compressed Pulse Width | 5.0 ms | 4.0 ms |
| PSL | -13.2 dB | -5.86 dB |
| SNR Improvement | +13 dB | +11.6 dB |

## TODO
- [ ] Apply Taylor/Hamming window → PSL target: -35 dB
- [ ] Doppler shift simulation
- [ ] NLFM waveform comparison
