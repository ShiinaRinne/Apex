import os
import subprocess
import tkinter as tk
from tkinter import filedialog, messagebox
from loguru import logger
from functools import partial

logger.add("apex.log", level="INFO")

def create_junction(source, target):
    logger.info(f"创建 Junction: {source} -> {target}")
    try:
        os.makedirs(os.path.dirname(target), exist_ok=True)
        cmd = f'mklink /J "{target}" "{source}"'
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as e:
        logger.error(f"无法创建 Junction: {e.stderr}")
        messagebox.showerror("Error", f"无法创建 Junction:\n{e.stderr}")
        return False
    return True

def convert_version(source_type, target_type):
    logger.info(f"-> {source_type} 版本转 {target_type} 版本")
    
    source_path = filedialog.askdirectory(title=f"选择 {source_type} 版 Apex 的安装路径")
    if not source_path:
        return
    
    target_parent = filedialog.askdirectory(title=f"选择 {target_type} 安装路径")
    if not target_parent:
        return
    
    target_path = os.path.join(target_parent, "Apex" if target_type == "EA App" else "Apex Legends")
    os.makedirs(target_path, exist_ok=True)
    
    folders = ["paks", "audio", "media", "cfg", "bin", "Crashpad", "LiveAPI", "materials", "r2"]
    for folder in folders:
        source = os.path.join(source_path, folder)
        target = os.path.join(target_path, folder)
        create_junction(source, target)
    
    messagebox.showinfo("操作完成", f"操作完成。打开 {target_type}，下载或修复游戏文件即可。")

def create_button(root, text, command):
    return tk.Button(root, text=text, font=("Arial", 12), command=command, width=25)

def main():
    root = tk.Tk()
    root.title("Apex EA Steam 双端共存工具")
    root.geometry("400x250")
    
    tk.Label(root, text="请选择操作:", font=("Arial", 14)).pack(pady=20)
    
    create_button(root, "1. Steam 版本转 EA 版本", partial(convert_version, "Steam", "EA App")).pack(pady=5)
    create_button(root, "2. EA 版本转 Steam 版本", partial(convert_version, "EA App", "Steam")).pack(pady=5)
    create_button(root, "3. 退出", root.quit).pack(pady=5)
    
    root.mainloop()

if __name__ == "__main__":
    main()