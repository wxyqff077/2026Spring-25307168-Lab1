/*
 *  Copyright (c) 2025 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import { AbilityConstant, common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct MailHomePage {
  @StorageLink('recipient') recipient: string = '';
  @StorageLink('sender') sender: string = '';
  @StorageLink('subject') subject: string = '';
  @StorageLink('emailContent') emailContent: string = '';
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  onPageShow(): void {
    this.context.setMissionContinueState(AbilityConstant.ContinueState.ACTIVE, (result) => {
      hilog.info(0x0000, 'MailHomePage', 'setMissionContinueState ACTIVE result: ', JSON.stringify(result));
    });
  }

  onBackPress(): void {
    this.context.setMissionContinueState(AbilityConstant.ContinueState.INACTIVE, (result) => {
      hilog.info(0x0000, 'MailHomePage', 'setMissionContinueState INACTIVE result: ', JSON.stringify(result));
    });
  }

  build() {
    Column() {
      this.NavigationTitle();
      this.EmailContent();
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFF1F3F5')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  /**
   * Top navigation title bar.
   */
  @Builder
  NavigationTitle() {
    Flex({ alignItems: ItemAlign.Center }) {

      Text($r('app.string.new_email_text'))
        .fontSize(20)
        .fontWeight(700)
        .lineHeight(27)
        .fontColor('rgba(0, 0, 0, 0.9)')
        .flexGrow(1)

      Row() {
        SymbolGlyph($r('sys.symbol.paperplane'))
          .fontSize(24)
          .fontWeight(400)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width(40)
      .height(40)
      .backgroundColor('rgba(0, 0, 0, 0.05)')
      .borderRadius(40)
      .margin({ right: 8 })

    }
    .height(56)
  }

  @Builder
  EmailContent() {
    Column() {
      // Recipient
      Row() {
        Text($r('app.string.recipient_text'))
          .fontColor($r('app.color.content_text_color'))
          .fontSize($r('app.float.text_font_size'))
          .focusable(true)
        TextInput({ text: this.recipient })
          .type(InputType.Email)
          .width('100%')
          .backgroundColor($r('app.color.input_textarea_background'))
          .caretColor($r('app.color.text_cursor_color'))
          .onChange((recipientName: string) => {
            this.recipient = recipientName;
            AppStorage.set('recipient', recipientName);
          })
      }
      .width('100%')
      .height(56)
      .border({
        width: { bottom: 1 },
        color: 'rgba(0, 0, 0, 0.2)'
      })

      // Sender
      Row() {
        Text($r('app.string.sender_text'))
          .fontColor($r('app.color.content_text_color'))
          .fontSize($r('app.float.text_font_size'))
        TextInput({ text: this.sender })
          .type(InputType.Email)
          .width('100%')
          .backgroundColor($r('app.color.input_textarea_background'))
          .caretColor($r('app.color.text_cursor_color'))
          .onChange((senderName: string) => {
            this.sender = senderName;
            AppStorage.set('sender', senderName);
          })
      }
      .width('100%')
      .height(56)
      .border({
        width: { bottom: 1 },
        color: 'rgba(0, 0, 0, 0.2)'
      })

      // Subject
      Row() {
        Text($r('app.string.subject_text'))
          .fontColor($r('app.color.content_text_color'))
          .fontSize($r('app.float.text_font_size'))
        TextInput({ text: this.subject })
          .width('100%')
          .backgroundColor($r('app.color.input_textarea_background'))
          .caretColor($r('app.color.text_cursor_color'))
          .onChange((subjectInfo: string) => {
            this.subject = subjectInfo;
            AppStorage.set('subject', subjectInfo);
          })
      }
      .width('100%')
      .height(56)
      .border({
        width: { bottom: 1 },
        color: 'rgba(0, 0, 0, 0.2)'
      })

      // Message content area.
      Row() {
        TextArea({ text: this.emailContent })
          .height('100%')
          .padding(0)
          .backgroundColor($r('app.color.input_textarea_background'))
          .borderRadius(0)
          .caretColor($r('app.color.text_cursor_color'))
          .onChange((emailContent: string) => {
            this.emailContent = emailContent;
            AppStorage.set('emailContent', emailContent);
          })
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .margin({
        top: $r('app.float.text_image_margin'),
        bottom: $r('app.float.navigation_height')
      })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 8, right: 8 })
  }
}