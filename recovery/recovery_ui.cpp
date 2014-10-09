/*
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <linux/input.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

#include "common.h"
#include "device.h"
#include "screen_ui.h"

/* See bionic/libc/kernel/common/linux/input.h for KEY_* codes */

const char *HEADERS[] = { "Keyboard/Mouse Scroll up/down to move highlight;",
                          "Keyboard Enter or Mouse left or right button to select;",
                          "Keyboard Esc or Mouse middle button to make menu visible/invisible.",
                          "",                                         /* Blank Line on screen */
                          NULL };

const char *ITEMS[] = { "reboot system now",
                        "apply update from ADB",
                        "apply update from external sdcard",
                        "wipe data/factory reset",
                        "wipe cache partition",
                        NULL };

class MyDeviceUI : public ScreenRecoveryUI {
  public:
    MyDeviceUI() :
        consecutive_power_keys(0) {
    }

    virtual KeyAction CheckKey(int key) {

        printf("%s(key:0x%x)\n", __func__, key);

        /*
         * TOGGLE Selection:
         */
        if (key == KEY_HOME ) {
            consecutive_power_keys = 0;
            return TOGGLE;
        }
        /* MOUSE Middle Button Switched between Visible and Non-Visible */
        if (key == BTN_MIDDLE) {
            consecutive_power_keys = 0;
            printf("%s: MOUSE KEY: return(TOGGLE:%d);\n", __func__, TOGGLE);
            return TOGGLE;
        }
        /* KEYBOARD Escape Switched between Visible and Non-Visible */
        if (key == KEY_ESC) {
            consecutive_power_keys = 0;
            printf("%s: KEYBOARD Enter KEY: return(TOGGLE:%d);\n", __func__, TOGGLE);
            return TOGGLE;
        }

        /*
         * ENQUEUE Selection:
         *
         * MOUSE Left or Right selects.
         */
        if (key == BTN_MOUSE  || key == BTN_RIGHT) {
            consecutive_power_keys = 0;
            printf("%s: MOUSE BUTTON KEY: return(ENQUEUE:%d);\n", __func__, ENQUEUE);
            return ENQUEUE;
        }

        /* KEYBOARD Enter Selects */
        if (key == KEY_ENTER  || key == KEY_KPENTER) {
            consecutive_power_keys = 0;
            printf("%s: KEYBOARD ENTER KEY: return(TOGGLE:%d);\n", __func__, ENQUEUE);
            return ENQUEUE;
        }
        if (key == KEY_END) {
            printf("%s: KEY_END\n", __func__);
            ++consecutive_power_keys;
            if (consecutive_power_keys >= 7) {
                return REBOOT;
            }
        } else {
            consecutive_power_keys = 0;
        }
        printf("%s: KEYBOARD Enter KEY: return(ENQUEUE:%d);\n", __func__, ENQUEUE);
        return ENQUEUE;
    }

  private:
    int consecutive_power_keys;
};

class MyDevice : public Device {
  public:
    MyDevice() :
        ui(new MyDeviceUI) {
    }

    RecoveryUI* GetUI() { return ui; }

    int HandleMenuKey(int key_code, int visible) {
        printf("%s: HandleMenuKey(key_code:0x%x, visible:%d)\n", __func__,
                                  key_code,      visible);
        if (visible) {
            switch (key_code) {
              case KEY_DOWN:                        /* Mouse/Keyboard scroll down */
              case KEY_VOLUMEDOWN:
                return kHighlightDown;

              case KEY_UP:                        /* Mouse/Keyboard Scroll Up */
              case KEY_VOLUMEUP:
                return kHighlightUp;

              case KEY_END:
              case KEY_ENTER:
              case KEY_KPENTER:
              case BTN_MOUSE:
              case BTN_RIGHT:
              //case KEY_POWER:
                return kInvokeItem;
            }
        }

        return kNoAction;
    }

    BuiltinAction InvokeMenuItem(int menu_position) {
        switch (menu_position) {
          case 0: return REBOOT;
          case 1: return APPLY_ADB_SIDELOAD;
          case 2: return APPLY_EXT;                /* SDCARD */
          case 3: return WIPE_DATA;
          case 4: return WIPE_CACHE;
          default: return NO_ACTION;
        }
    }

    const char* const* GetMenuHeaders() { return HEADERS; }
    const char* const* GetMenuItems() { return ITEMS; }

  private:
    RecoveryUI* ui;
};

Device* make_device() {
    return new MyDevice;
}
