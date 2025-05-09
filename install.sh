#!/usr/bin/env bash


script_link=$(readlink -f "${0}")
script_dir=$(dirname "${script_link}")

# Copy the .desktop file to the applications directory
echo "Copying .desktop file to ${HOME}/.local/share/applications/"
mkdir -p ${HOME}/.local/share/applications
cp ${script_dir}/url-yeet.desktop ${HOME}/.local/share/applications/
chmod +x ${HOME}/.local/share/applications/url-yeet.desktop

# Update the .desktop file to point to the correct script location
sed -i "s|Exec=.*|Exec=${script_dir}/url-yeet %U|g" ${HOME}/.local/share/applications/url-yeet.desktop
sed -i "s|Path=.*|Path=${script_dir}|g" ${HOME}/.local/share/applications/url-yeet.desktop

# Update the .desktop file to set the correct icon
sed -i "s|Icon=.*|Icon=${script_dir}/url-yeet.png|g" ${HOME}/.local/share/applications/url-yeet.desktop

# Validate the .desktop file
if command -v desktop-file-validate &> /dev/null
then
    desktop-file-validate ${HOME}/.local/share/applications/url-yeet.desktop
else
    echo "desktop-file-validate not found, skipping validation."
fi

# Copy the script to the bin directory
echo "Copying script to ${HOME}/.local/bin/"
mkdir -p ${HOME}/.local/bin
cp ${script_dir}/url-yeet ${HOME}/.local/bin/url-yeet
chmod +x ${HOME}/.local/bin/url-yeet

# Copy the example rules file to the rules directory if there's not already one there
echo "Copying rules file to ${HOME}/.config/url-yeet/"
mkdir -p ${HOME}/.config/url-yeet
if [ ! -f ${HOME}/.config/url-yeet/rules.txt ]; then
    cp ${script_dir}/rules_example.txt ${HOME}/.config/url-yeet/rules.txt
else
    echo "Rules file already exists at ${HOME}/.config/url-yeet/rules.txt, skipping copy."
fi

cp ${script_dir}/rules.txt ${HOME}/.config/url-yeet/rules.txt

# Copy the default browser file to the config directory
echo "Copying default browser file to ${HOME}/.config/url-yeet/"
mkdir -p ${HOME}/.config/url-yeet
cp ${script_dir}/default_browser_command.txt ${HOME}/.config/url-yeet/default_browser_command.txt

# Copy the icon to the icons directory
echo "Copying icon to ${HOME}/.local/share/icons/hicolor/256x256/apps/"
mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/
cp ${script_dir}/url-yeet.png ${HOME}/.local/share/icons/hicolor/256x256/apps/

# Update the icon cache
if command -v gtk-update-icon-cache &> /dev/null
then
    gtk-update-icon-cache ${HOME}/.local/share/icons/hicolor/
else
    echo "gtk-update-icon-cache not found, skipping icon cache update."
fi

# Update the desktop database
if command -v update-desktop-database &> /dev/null
then
    update-desktop-database ${HOME}/.local/share/applications/
else
    echo "update-desktop-database not found, skipping desktop database update."
fi

# Print success message
echo "url-yeet installed successfully!"
