FROM lscr.io/linuxserver/webtop:ubuntu-openbox

# Install required dependencies
# Note: libasound2 was renamed to libasound2t64 in Ubuntu Noble (24.04)
RUN apt-get update && apt-get install -y curl gpg sudo libgbm1 libasound2t64

# 1. Add repository and signing key
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
    gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
    tee /etc/apt/sources.list.d/antigravity.list > /dev/null && \
    curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | \
    gpg --dearmor --yes -o /etc/apt/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | \
    tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

# 2. Install initial version (base image)
RUN apt-get update && \
    apt-get install -y antigravity google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 3. Configure automatic update script on container start
RUN mkdir -p /custom-cont-init.d && \
    echo '#!/bin/bash' > /custom-cont-init.d/update-antigravity && \
    echo 'echo "Checking for Antigravity and Chrome updates..."' >> /custom-cont-init.d/update-antigravity && \
    echo 'apt-get update' >> /custom-cont-init.d/update-antigravity && \
    echo 'DEBIAN_FRONTEND=noninteractive apt-get install -y --only-upgrade antigravity google-chrome-stable' >> /custom-cont-init.d/update-antigravity && \
    echo 'echo "Update check complete."' >> /custom-cont-init.d/update-antigravity && \
    chmod +x /custom-cont-init.d/update-antigravity

# 4. Create launcher script that accepts environment arguments
RUN echo '#!/bin/bash' > /usr/local/bin/start-antigravity && \
    echo 'exec antigravity --no-sandbox $ANTIGRAVITY_ARGS' >> /usr/local/bin/start-antigravity && \
    chmod +x /usr/local/bin/start-antigravity

# 5. Copy KasmVNC configuration for optimized rendering
COPY kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml

# 6. Set Antigravity icon as favicon for the web interface
COPY google-antigravity-logo-icon-hd.png /kclient/public/favicon.ico
COPY google-antigravity-logo-icon-hd.png /kclient/public/icon.png

# 7. Configure Openbox autostart
RUN mkdir -p /etc/xdg/openbox && \
    echo "start-antigravity &" >> /etc/xdg/openbox/autostart
