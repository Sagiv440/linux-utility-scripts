# Auto Refresh refesh the currently open webpage per given amount of time by pressing F5 
# Usage:
#   python ./auto-refresh.py <time per refresh in minutes>
# 
# libraries Require: 
#   pip install pyautogui

import pyautogui
import msvcrt
import time
import sys

def refresh_chrome(tm):
    print("Starting refrashing chrome page every: "+ str(tm) +" minutes")
    pyautogui.FAILSAFE = False
    startTime = time.time()
    cycales = 0;
    while True:
        # Press F5 to refresh the page (works on most browsers)
        pyautogui.hotkey('f5')
        print("Page refreshed ! ( Press 'ESC' to exit)")

        timeout = tm*60
        start = time.time()
        cycales += 1;
        while time.time() - start < timeout:
            if msvcrt.kbhit():
                key = msvcrt.getch()
                if key == b'\x1b':  # ESC
                    pyautogui.FAILSAFE = True
                    print("Stoped Auto Refrach")
                    sys.exit(0)
                    
                if key == b' ':  # ESC
                    print("\n\nStatus:\n")    
                    print("- Refrash Time Every: ",print_time(timeout))
                    print("- Refrach Count: ",cycales)                    
                    print("- Time To Next Refrach: ",print_time(timeout -(time.time()-start)))
                    print("- Total Run Time: ",print_time(time.time()-startTime))
                    
            time.sleep(0.05)
            

def print_time(t):
    if t >= 86400:  # days
        return f"{int(t // 86400)}d {int(t % 86400 // 3600)}h {int(t % 3600 // 60)}m {t % 60:.2f}s"
    elif t >= 3600:  # hours
        return f"{int(t // 3600)}h {int(t % 3600 // 60)}m {t % 60:.2f}s"
    elif t >= 60:  # minutes
        return f"{int(t // 60)}m {t % 60:.2f}s"
    else:  # seconds
        return f"{t:.2f}s"

        
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Error: No Time was given  - sigmiture: auto-refrashing.py <number-of-minit>")
        sys.exit(0)
    arg = sys.argv [1]
    try:
        minutes = float(arg)
    except ValueError:
        print("Error: Invalid value - sigmiture: auto-refrashing.py <number-of-minutes>")
        sys.exit(0)    
        
    if minutes < 0.2:
        print("Error: minimum time can't be less then 0.2")
        sys.exit(0)
    refresh_chrome(minutes)


