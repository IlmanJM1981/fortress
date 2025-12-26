--- FORTRESS OF ILMAN YONG v1.0: INSTALLATION GUIDE ---

[ SYSTEM REQUIREMENTS ]
- Operating System: Ubuntu (Noble/24.04 recommended)
- Permissions: Sudo/Root access required for firewall and SSH changes.

[ INSTALLATION OPTIONS ]

OPTION A: The One-Liner (Best for Coworkers)
Run this command exactly. The '-k' flag tells curl to trust our 
self-signed certificate.

  curl -kO https://24.180.174.83/downloads/fortress-install.sh && bash fortress-install.sh

OPTION B: Manual Zip Install (USB/Direct Download)
1. Unzip the package to your Desktop scripts folder:
   unzip fortress_v1.0.zip -d ~/Desktop/scripts/
2. Move into the directory:
   cd ~/Desktop/scripts/
3. Run the local setup script:
   ./setup-local.sh

[ POST-INSTALLATION ]
- Refresh your terminal: source ~/.bashrc
- Launch the Fortress: type 'fortress'

[ TROUBLESHOOTING ]
- "SSL Certificate Problem": Use the '-k' flag with curl.
- "Permission Denied": Ensure you have used 'chmod +x' on the scripts.
- "Command not found": Ensure the alias was added to your .bashrc.

--- PROTECT THE GATE. LOG THE FLIES. ---
