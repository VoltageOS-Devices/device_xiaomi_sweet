# Nuke 
rm -rf hardware/qcom-caf/sm8150/display 
rm -rf hardware/qcom-caf/sm8150/audio
rm -rf hardware/qcom-caf/sm8150/media

# Hals
git clone https://github.com/ArrowOS/android_hardware_qcom_audio -b arrow-12.0-caf-sm8150 hardware/qcom-caf/sm8150/audio 
git clone https://github.com/ArrowOS/android_hardware_qcom_media -b arrow-12.0-caf-sm8150 hardware/qcom-caf/sm8150/media 
git clone https://github.com/ArrowOS/android_hardware_qcom_display -b arrow-12.0-caf-sm8150 hardware/qcom-caf/sm8150/display

# Vendor
git clone https://github.com/mrfox2003/vendor_xiaomi_sweet.git -b 12 vendor/xiaomi/sweet

# Kernel & Clang
git clone -b courbet-12.1 --depth=1 https://github.com/mrfox2003/kernel_xiaomi_sm6150.git kernel/xiaomi/sweet
git clone -b master --depth=1 https://github.com/kdrag0n/proton-clang.git prebuilts/clang/host/linux-x86/clang-proton

