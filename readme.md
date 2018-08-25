this is a bunch of matlab-functions and data files which I wrote in the context of my Master's Thesis "A Basic Architecture for Automatic Transcription of Electronic Drumset Performances", written in collaboration with Josefin Nohrdahl . 
In the thesis,  I designed and automatic transcription algorithm for edrum files. The algorithm  consists of three steps: 
1) Beat tracking (uses Dixon's BeatRoot, but modified to the drumming situation and enhanced by suggestions made by Gouyon et al.)
2) Rhythm Quantization (uses a Bayesian approach as suggested byCemgil et al )
3) Time Signature Extraction (a self developed, rather straight-forward method)

As  expressively performed realworld drum data with  annotated true beat positions is hard to get, we used synthetic drum tracks to test and evaluate performance.
To this end, we downloaded drumtracks from midi arrangements and manipulated tempo and microtiming, and then tested Dixons original beat tracker vs ours. 
  