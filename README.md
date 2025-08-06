# Distro Debian Installer

This project is licensed under the GNU General Public License v3 (GPLv3). It is offered without any warranty, and the author is not responsible for any damage or problems that may arise from its use.

⚠️ **Warning! Risk of Data Loss** ⚠️

- This installer will modify the contents of your partitions. It is highly recommended that you perform a complete backup of your important data before using it.

- Use this installer on an empty disk or partition and make sure you are absolutely certain of the configuration settings before starting the process.

- This installer is designed for users with intermediate or advanced knowledge of Linux. It is not recommended for novice users.

## Key Advantages and Features 🌟

Unlike traditional installers, this project offers you complete control and a unique educational experience.

- Totally Flexible and Customizable: Adapt your Debian distribution to your exact needs. You can easily modify the distro.yaml configuration file or directly edit the installer's scripts for granular control over every step of the process.

- Always Up-to-Date System: The installer downloads packages directly from the official repositories, ensuring your system is 100% updated with the latest software versions at the time of installation.

- "From Scratch" Educational Experience: This project is inspired by the "Linux From Scratch" philosophy. By using it, you will see how a Debian system is built from an empty partition, allowing you to deeply understand the architecture of your operating system.

- Greater Knowledge, Better Problem Solving: By understanding how your system is assembled, you will be better prepared to diagnose and solve any problems that may arise in the future. It empowers you as a user.

## System Requirements and Work Environment 🛠️

To use this installer, you need a live Linux environment (Live USB or Live DVD) that meets the following requirements.

Note: This installer has been successfully tested on virtual machines using QEMU-KVM/Libvirt. It is an ideal environment if you want to test the process without risk.

1. Live Operating System

You must boot from a live Linux operating system. A distribution based on Debian or Ubuntu in its most recent versions is highly recommended, as these often have the necessary software or allow for easy installation.

2. Required Software

Make sure your live system has the following software installed:

- debootstrap: To build the base Debian system.

- yq: To process the distro.yaml configuration file.

- arch-install-scripts: To prepare the chroot environment and perform the installation.

- bash: The command interpreter.

- git: To clone the project repository.

- A text editor: To modify the configuration file. Examples: nano, vim, emacs or, if you are in a graphical environment, kwrite or mousepad.

- Partitioning and formatting tools: To prepare the hard disk. Examples: fdisk, cfdisk, parted, gparted (if you are using a graphical environment), and tools for filesystems such as mkfs.ext4, mkfs.xfs, mkfs.btrfs, among others.

**Quick Installation on a Debian/Ubuntu-based distro**:

If you are missing any of these programs, you can install them all at once with the following command in the terminal:

```bash
sudo apt update
sudo apt install -y debootstrap yq arch-install-scripts git fdisk gparted nano
```
You can add other packages to the command if you need different tools.

## Cloning the Repository 📥

To get started, you need to clone this repository. Open a terminal on your Live system and run the following command:

```bash
git clone https://github.com/jmpevzla/distro-debian-installer.git
```

This will download the entire installer and the necessary configuration files to your current system. Once it's finished, you can enter the project folder to continue:

```bash
cd distro-debian-installer
```

## Project Structure and Configuration ⚙️

The project is designed to be simple and modular, allowing you to easily customize the installation. Once you have cloned the repository, you will find the following structure:

- **distro.yaml**: This is the main configuration file. Here you can define your system's settings, including the language, localization, the scripts to be executed, and other customization options for your Debian system. It is the ideal starting point to adapt the installation to your needs.

- **scripts/**: This folder contains the bash scripts that orchestrate the installation process. You are free to review them, understand their logic, and modify them directly if you need more in-depth control. They are designed to be short and easy to understand, without convoluted code.

- Other files: The remaining files, such as the license (LICENSE) and this README.md, provide information and documentation about the project.

To customize your installation, simply open and edit the distro.yaml file with your preferred text editor. If you want total control, you can explore and adjust the scripts inside the scripts/ folder.

## Exploring distro.yaml 📄

The **distro.yaml** file is the control center of your installation. Here is where you define every detail of your future Debian distribution, from the basic system configuration to the packages and desktop environments you want to install.

Below, we explain the main sections you will find and what you can configure in each one:

- distro:
    - name: The name of the distribution (by default, Debian).
    
    - number: The numeric version of Debian (e.g., 13).

    - version: The codename of the Debian version (e.g., trixie).

    - mode: Defines the system boot mode: efi for modern systems with UEFI or mbr for older systems with BIOS.

    - partitions:
        - Here you specify the paths to your partitions. Important! You must have created and formatted these partitions beforehand in your Live USB/DVD.

        - root: The main partition where the system will be installed (/).

        - efi: The EFI partition (only if mode is efi). If the mode is mbr, it must be null.

        - boot, home, var, tmp, opt, usrlocal: Optional partitions for mounting specific directories. If you don't use them, leave them as null.

    - mount:

        - Defines the mount points for your partitions within the installation environment.

        - root: Always /mnt.

        - efi: Always /mnt/efi (only if mode is efi). If the mode is mbr, it must be null.

    - swap:

        - Configures how swap memory will be managed. You can choose between different modes:

        - mode: null (no swap), partition (use a dedicated partition), file (use a swap file), or zram (compressed swap in RAM).

        - partition: If mode is partition, specify the path to the swap partition.

        - file: If mode is file, define the name of the swap file and its size in MB.

        - zram: If mode is zram, you can configure the compression algorithm (algo: lz4, zstd), the percentage of RAM to use (perc) or a fixed size (size in MiB).

    - log:

        - Controls the logging of the installation process.

        - file: The name of the log file.

        - clear_at_init: Yes or No to clear the log at the beginning of each installation.

    - config:

        - This section covers general system configurations.

        - arch: System architecture. Currently amd64 is supported, but it might work on other architectures.

        - efi_target: Target for GRUB on EFI systems (e.g., x86_64-efi).

        - grub_mbr: The disk where GRUB will be installed. This option is only valid for systems with MBR mode (BIOS Legacy).

        - repo: The main Debian repository.

        - rtc: Real-time clock configuration (UTC or LOCAL).

        - tz: Your time zone (area and zone). Example: America/Caracas or Europe/Madrid.

        - hostname: The name of your computer.

        - locale: The regional settings of the system.

            - gen: List of locales to generate (e.g., es_ES.UTF-8 UTF-8).

            - default: The default locale (e.g., es_VE.UTF-8).

            - Note: Language and country codes are specific. If you are unsure of the codes for your region, it is recommended to search on Google or check the configuration files of your current distribution.

        - keyboard: Detailed keyboard configuration (layout, variant, model).

            - Note: As with locales, keyboard codes can vary. For example, for English you can use English/en, while for Spanish you can use Spanish-es or latam (for Latin America). Consult the localization documentation to find the exact code for your region.

        - user: The name of the main user that will be created.

        - desktop: Here you can choose the desktop environment: none (CLI only), kde, xfce, lxde. You can also define the installation type (minimal, standard, full) and whether to install extras (extras).

    - stages:

        - This is an ordered list of the scripts that the installer will execute. Each entry has:

            - script: The name of the script to be executed (located in the scripts/ folder).

            - desc: A brief description of what the script does.

        - Important! The order of these scripts is crucial for the installation process. You can comment out (#) or uncomment lines to include or exclude steps or optional packages (such as Bluetooth, SSH, CUPS, or specific text editors).

## Password Configuration 🔒

To set the passwords for the root user and the user you configured in distro.yaml, you must create two files in the project's main folder.

- .root.env: Contains the password for the root user.

- .user.env: Contains the password for the main user.

Each file must have two lines with the same password. This serves to confirm that there are no typos.

Example:

If you want the password to be supersecure, the content of both files (.root.env and .user.env) should be:

```
supersecure
supersecure
```

**Note**: For your peace of mind, the installation script is designed to automatically empty the contents of these files upon completion of this stage of the process, ensuring that no plain-text passwords are left behind.

## Starting the Installation Process 🚀

Once you have prepared the disk, configured distro.yaml, and created the password files, you can start the installation process.

First, get a complete superuser (root) session in the terminal:

```bash
sudo su
```

Then, make sure you are in the project's main directory and run the install.bash script:

```bash
bash install.bash
```

The installer will take care of following the instructions you defined in the distro.yaml file and will continue to execute the scripts until your new Debian system is ready.

## Process Log 📝

During the installation, all steps and script results are recorded in a file named distro.log.

This file is crucial for monitoring the progress of the installation and, in case an error occurs, it will allow you to identify exactly which stage the process failed in.

## Re-running a Specific Script 🔄

If the installation fails at a certain stage or if you want to modify and re-run a particular script (for example, to change a configuration), you can do so manually.

Navigate to the scripts folder:

```bash
cd scripts
```

Run the script you want to re-execute. For example, if you want to reconfigure the time zone, run:

```bash
bash ss3-tzdata.sh
```

This flexibility allows you to debug problems or make adjustments without having to restart the entire installation process from scratch.

## Handling Interruptions and Re-execution 🛑

If the installation process stops unexpectedly (due to a power outage, a network disconnection, or an error you need to correct), you can restart the process safely.

- Stop the script: If the installer is running, press Ctrl+C repeatedly in the terminal until the script stops completely.

- Delete the lock file: The installer creates a lock file called installer.lock to prevent multiple executions. Since the process stopped abruptly, you must delete this file manually before starting over:
    
```bash
rm installer.lock
```

**Prepare for a clean installation**: To avoid conflicts, it is recommended to unmount and reformat the partitions before re-running the installer.

Unmount the root partition:

```bash    
umount -R /mnt
```

Format the partitions: Use the formatting tools (mkfs.ext4, mkfs.xfs, etc.) to clean the partitions you are going to use.

Once you have completed these steps, you can re-run **bash install.bash** with the peace of mind that the process will start again in a clean environment.

## Desktop Options 🖥️

This installer focuses on the desktop environments I use most, but it is designed to be easily extensible. In the desktop section of the distro.yaml file, you can configure the following:

- **Desktop Types (type)**: For now, three main environments are offered: kde, xfce, and lxde. If you want a different desktop environment, you can create your own installation script (scripts/soX-your_desktop.sh) and add it to the stages section of distro.yaml following the same pattern.

- For a basic installation **without a graphical environment**, just set type to null. It is not necessary to comment out the desktop scripts in the stages section.

- **Installation Levels (install)**: For each desktop, you can choose the installation level you prefer:

    - **minimal**: Includes only the most essential packages for the desktop to function.

    - **standard**: Offers a standard user experience with recommended applications.

    - **full**: Installs all available packages for the desktop, providing a complete and fully functional experience.

    - **Extras (extras)**: With the extras option, you can install a web browser and a multimedia player at any installation level, regardless of whether you chose minimal, standard, or full.

This structure gives you the power to have granular control over your installation, choosing between a lightweight or a complete experience.

## Questions, Suggestions, and Collaboration 🤝

This project is a work in constant evolution. If you have questions, find any errors, or simply want to suggest improvements, do not hesitate to contact me. Your support is essential to continue improving this tool.

You can contact me through:

GitHub: Open an **Issue** in this repository or write me an email

