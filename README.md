# LineageOS device tree for the Samsung Galaxy S21 (Exynos)

| Basic         | Spec sheet                                    |
| ------------- | --------------------------------------------- |
| Model         | SM-G991B                                      |
| Codename      | o1s                                           |
| SoC           | Samsung Exynos 2100 (universal2100)           |
| Kernel        | 5.4 (`kernel/samsung/universal2100`)          |
| Partitions    | non-A/B, dynamic partitions (super), vendor_boot |

This tree depends on
[android_device_samsung_universal2100-common](https://github.com/exy2100/android_device_samsung_universal2100-common).

## Building (Miku-Picked UI)

This is the Miku-Picked UI fork of the
[Macktherealonereally](https://github.com/Macktherealonereally/android_device_samsung_o1s)
tree (release `lineage-23.2-20261031`), which is based on the
[exy2100](https://github.com/exy2100/android_device_samsung_o1s) tree.
Miku-Picked UI builds LineageOS 23.2 device trees through its
`vendor/lineage` compatibility layer, so the tree keeps its `lineage_o1s`
product name.

1. Initialize Miku-Picked UI:

   ```sh
   repo init -u https://github.com/Miku-Picked-UI/manifesto -b picked-16 --git-lfs
   ```

2. Add the o1s local manifest. It brings the device, common, kernel and
   vendor trees, `hardware/samsung`, `device/samsung_slsi/sepolicy` and
   `hardware/samsung_slsi-linaro/*`, all from github.com/Miku-Picked-UI:

   ```sh
   mkdir -p .repo/local_manifests
   cp .repo/manifests/local_manifests/o1s.xml .repo/local_manifests/
   ```

3. Sync and build:

   ```sh
   repo sync -c -j$(nproc)
   source build/envsetup.sh
   lunch lineage_o1s-bp4a-userdebug
   m bacon
   ```

   Add `MIKU_GAPPS=true` before `m` for a build with Google apps.

Optional extras from the upstream builds (OpenEUICC for eSIM, the krazey
IMS stack for VoLTE/VoWiFi, Aurora Store) are not part of the Miku-Picked
UI manifests. The tree only uses them when they are synced, see
[galaxy-s21-exynos-lineageos-fixes](https://github.com/Macktherealonereally/galaxy-s21-exynos-lineageos-fixes).

## Installing

Installing LineageOS wipes all data on the device and permanently trips Knox.

Requirements:

* The bootloader must be unlocked (Settings → Developer options → OEM
  unlocking, then long press Volume Up in download mode to unlock).
* Stock firmware **G991BXXSJHZC2** (Android 15) must be installed first.
  Older firmware (e.g. G991BXXSJHZA6) is known to hang at the boot logo.
  Flash all of BL/AP/CP/CSC with Odin (or `odin4` on Linux); the firmware can
  be downloaded with e.g. [samloader](https://github.com/topjohnwu/samloader-rs).

Steps:

1. Pack the recovery image into a tar that Odin accepts:

   ```sh
   tar --format=ustar -cf recovery.tar recovery.img
   ```

2. Boot into download mode (power off, hold Volume Up + Volume Down and plug in
   a USB cable connected to the computer).
3. Flash `recovery.tar` in the AP slot with **Auto Reboot disabled**.
4. Leave download mode by holding Volume Down + Power, and as soon as the
   screen turns off switch to Volume Up + Power (USB cable connected) to boot
   straight into LineageOS recovery. If stock Android boots instead, it
   restores the stock recovery and this step has to be repeated.
5. In recovery, select *Factory reset* → *Format data/factory reset*.
6. Select *Apply update* → *Apply from ADB* and run on the computer:

   ```sh
   adb sideload lineage-23.2-*-o1s.zip
   ```

   The package writes the dynamic partitions as well as `dtbo`, `vbmeta` and
   `vendor_boot`.
7. Select *Reboot system now*. The first boot takes a few minutes.

Later updates (full or incremental OTA packages) can be installed from
recovery with *Apply from ADB* without wiping data.
