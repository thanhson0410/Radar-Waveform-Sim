# -*- coding: utf-8 -*-
"""
run_matlab_sim.py - Python MATLAB Engine runner
Requires: Python 3.11 + MATLAB R2024a + matlabengine==24.1.2
"""
import sys, io, matlab.engine, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

SCRIPT_DIR  = r'd:\Python\Antigravity\Radar_equation'
SCRIPT_NAME = 'sin_wave_sim'  # Change to 'advanced_wave_sim' for AWGN+LFM

print('Starting MATLAB Engine...')
eng = matlab.engine.start_matlab()
eng.cd(SCRIPT_DIR, nargout=0)
print(f'Running {SCRIPT_NAME}.m...')
eng.run(SCRIPT_NAME, nargout=0)
eng.quit()
print('DONE')
