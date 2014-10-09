/*
 * Copyright (C) 2013 The Android Open Source Project
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

#define LOG_TAG "healthd-ci20"
#include <errno.h>
#include <healthd.h>
#include <time.h>
#include <unistd.h>
#include <batteryservice/BatteryService.h>
#include <cutils/klog.h>
#include <sys/types.h>

using namespace android;

int healthd_board_battery_update(struct BatteryProperties *props)
{
    // Produce some fake values
    props->chargerAcOnline = true;
    props->batteryStatus = BATTERY_STATUS_FULL;
    props->batteryHealth = BATTERY_HEALTH_GOOD;
    props->batteryCurrentNow = 10000;    // 10mA
    props->batteryChargeCounter = 1;     // 1st charge?
    props->batteryLevel = 100;           // 100%
    props->batteryVoltage = 4900;        // 4.900V
    props->batteryTemperature = 220;     // 22C
    props->batteryTechnology = String8("Li-ion");

    // return 1 to send periodic polled battery status to kernel log
    return 1;
}

void healthd_board_init(struct healthd_config *config)
{
  //  config->periodic_chores_interval_fast = -1;
  //  config->periodic_chores_interval_slow = -1;
}
