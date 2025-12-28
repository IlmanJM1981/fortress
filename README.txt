# 👁️ THE APOSTLE'S EYE (v1.1.8 STABLE)
# Built by Jesse Miller / Ilman Yong

## DESCRIPTION
A tactical reconnaissance suite for phone, network, and identity intelligence. 
Designed with self-repairing architecture to maintain stability in Linux environments.

## INSTALLATION
1. Extract the .zip file to your preferred directory.
2. Open a terminal in that directory.
3. Run the installer to set up paths and permissions:
   bash eye_installer.sh

## OPERATION
- Launch via the Desktop Icon or by running: bash ~/Desktop/scripts/eye.sh
- [p] Phone Recon: Carrier extraction & VOIP detection.
- [i] IP/Domain Recon: Whois, Nmap OS discovery, and Streamlined Traceroute.
- [m] MDOC Otis: Michigan Department of Corrections offender search.
- [r] Self-Repair: Reverts script to the stable v1.1.8 backup.

## DEPENDENCIES
The installer handles directory setup, but ensure the following are on your system:
- nmap, whois, traceroute, jq, curl, phoneinfoga
