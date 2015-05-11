/*
 * Copyright (C) 2015 The Android Open Source Project
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

#include <hardware_legacy/AudioPolicyManagerBase.h>

namespace android_audio_legacy {

class AudioPolicyManager: public AudioPolicyManagerBase
{

public:
    AudioPolicyManager(AudioPolicyClientInterface *clientInterface)
            : AudioPolicyManagerBase(clientInterface) {}
    virtual ~AudioPolicyManager() {}

    virtual void defaultAudioPolicyConfig(void);
    virtual audio_devices_t getDeviceForVolume(audio_devices_t device);
    virtual audio_devices_t getDeviceForStrategy(routing_strategy strategy, bool fromCache);
    virtual audio_devices_t getDeviceForInputSource(int inputSource);

};
};

