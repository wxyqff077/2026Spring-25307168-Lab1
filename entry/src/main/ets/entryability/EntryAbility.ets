/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDataObject } from '@kit.ArkData';
import { window } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { MailInfoManager } from '../utils/MailInfoManager';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private distributedObject: distributedDataObject.DataObject | undefined = undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      hilog.info(DOMAIN, 'EntryAbility', '%{public}s', 'Ability onCreate');
      this.restoreDistributedObject(want, launchParam);
    } catch (error) {
      hilog.error(0x0000, 'EntryAbility', `getApplicationContext error. Code:${error.code},message: ${error.message}`);
      return error.code;
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'EntryAbility', `Ability onNewWant`);
    this.restoreDistributedObject(want, launchParam);
  }

  /**
   * The peer device receives data.
   * @param want
   * @param launchParam
   * @returns
   */
  async restoreDistributedObject(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    this.context.setMissionContinueState(AbilityConstant.ContinueState.INACTIVE, (result) => {
      hilog.info(0x0000, 'EntryAbility', `setMissionContinueState: ${JSON.stringify(result)}`);
    });
    if (launchParam.launchReason !== AbilityConstant.LaunchReason.CONTINUATION) {
      return;
    }
    // Obtain the session ID of a distributed data object.
    let mailInfoManager: MailInfoManager = new MailInfoManager(undefined, undefined, undefined, undefined);
    this.distributedObject = distributedDataObject.create(this.context, mailInfoManager);
    // Add a data restored listener.
    try {
      this.distributedObject.on('status',
        (sessionId: string, networkId: string, status: 'online' | 'offline' | 'restored') => {
          hilog.info(0x0000, 'EntryAbility', 'status changed ' + sessionId + ' ' + status + ' ' + networkId);
          if (status === 'restored') {
            if (!this.distributedObject) {
              return;
            }
            AppStorage.setOrCreate('recipient', this.distributedObject['recipient']);
            AppStorage.setOrCreate('sender', this.distributedObject['sender']);
            AppStorage.setOrCreate('subject', this.distributedObject['subject']);
            AppStorage.setOrCreate('emailContent', this.distributedObject['emailContent']);
          }
        });
      let sessionId: string = want.parameters?.distributedSessionId as string;
      hilog.info(0x0000, 'EntryAbility', 'sessionId' + sessionId);
      this.distributedObject.setSessionId(sessionId).catch((err: BusinessError) => {
        hilog.error(0x0000, 'EntryAbility', `setSessionId error .Code:${err.code},message: ${err.message}`);
      });
      this.context.restoreWindowStage(new LocalStorage());
    } catch (error) {
      hilog.error(0x0000, 'EntryAbility', `have error. Code:${error.code}, message: ${error.message}`);
    }
  }

  onWindowStageRestore(windowStage: window.WindowStage): void {
    hilog.info(0x0000, 'EntryAbility', 'Ability onWindowStageRestore');

    windowStage.loadContent('pages/MailHomePage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'EntryAbility', `ailed to load the content, Code:${err.code},message: ${err.message}`);
        return;
      }
      hilog.info(0x0000, 'EntryAbility', 'Succeeded in loading the content, ', `Data: ${data}`);
    });
  }

  async onContinue(wantParam: Record<string, Object | undefined>): Promise<AbilityConstant.OnContinueResult> {
    try {
      // Generate the session ID of the distributed data object.
      let sessionId: string = distributedDataObject.genSessionId();
      wantParam.distributedSessionId = sessionId;

      let mailInfoManager: MailInfoManager = new MailInfoManager(AppStorage.get('recipient'), AppStorage.get('sender'),
        AppStorage.get('subject'), AppStorage.get('emailContent'));
      this.distributedObject = distributedDataObject.create(this.context, mailInfoManager);
      this.distributedObject.setSessionId(sessionId).catch((err: BusinessError) => {
        hilog.error(0x0000, 'EntryAbility', `setSessionId error. Code:${err.code},message: ${err.message}`);
      });
      await this.distributedObject.save(wantParam.targetDevice as string).then(() => {
        hilog.info(0x0000, 'EntryAbility', 'onContinue distributedObject save success');
      }).catch((err: BusinessError) => {
        hilog.error(0x0000, 'EntryAbility', `Failed to save. Code:${err.code}, message:${err.message}`);
      });
    } catch (err) {
      hilog.error(0x0000, 'EntryAbility', `distributedDataObject failed, Code:${err.code}, message:${err.message}`);
    }
    return AbilityConstant.OnContinueResult.AGREE;
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability.
    hilog.info(0x0000, 'EntryAbility', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/MailHomePage', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'EntryAbility', `Failed to load the content, Code: ${err.code}  message:${err.message}`);
        return;
      }
      hilog.info(0x0000, 'EntryAbility', 'Succeeded in loading the content, ', `Data: ${data}`);
    });
  }

  onWindowStageDestroy() {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onForeground');
  }

  onBackground() {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onBackground');
  }

  onDestroy() {
    hilog.info(DOMAIN, 'EntryAbility', 'Ability onDestroy');
  }
}
