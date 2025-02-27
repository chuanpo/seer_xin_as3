# unzip_script.py
import zipfile
import os
import shutil

def unzip_and_rename_swc(swc_path, extract_to):
    with zipfile.ZipFile(swc_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
    
    # 重命名 library.swf 为 core.swf
    library_swf_path = os.path.join(extract_to, 'library.swf')
    core_swf_path = os.path.join(extract_to, 'core.swf')
    
    if os.path.exists(library_swf_path):
        if os.path.exists(core_swf_path):
            os.remove(core_swf_path)  # 强制覆盖，删除已存在的 core.swf
        os.rename(library_swf_path, core_swf_path)
        print(f"Unzip SWC and Renamed {library_swf_path} to {core_swf_path}")
    else:
        print(f"library.swf not found in {extract_to}")

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))+'/../bin/'
    swc_files = [f for f in os.listdir(script_dir) if f.endswith('.swc')]
    
    if swc_files:
        swc_path = os.path.join(script_dir, swc_files[0])
        extract_to = script_dir  # 解压到脚本所在目录
        unzip_and_rename_swc(swc_path, extract_to)
    else:
        print("No SWC file found in the script directory")