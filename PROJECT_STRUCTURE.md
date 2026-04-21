# DistributedMail 项目文件说明

## 项目概述

这是一个基于 HarmonyOS 的分布式邮件应用，使用应用接续和分布式数据对象实现跨设备的数据传输和功能迁移。

## 根目录文件

| 文件/文件夹 | 作用说明 |
|------------|---------|
| `README.md` | 项目主文档，包含项目简介、功能说明、使用说明、实现步骤等 |
| `README.en.md` | 英文版本的项目说明文档 |
| `LICENSE` | 项目许可证文件 |
| `build-profile.json5` | 应用构建配置文件，定义SDK版本、构建模式等 |
| `code-linter.json5` | 代码规范配置文件，用于代码风格检查 |
| `oh-package.json5` | 项目依赖管理配置文件 |
| `hvigorfile.ts` | Hvigor 构建脚本配置，导出应用构建任务 |
| `AppScope/` | 应用全局配置目录 |
| `entry/` | 应用主模块目录 |
| `hvigor/` | Hvigor 构建工具相关文件目录 |
| `screenshots/` | 项目截图目录 |
| `.hvigor/` | Hvigor 构建缓存目录（不建议上传） |
| `.idea/` | IDE 配置目录（不建议上传） |

## AppScope/ 目录

| 文件/文件夹 | 作用说明 |
|------------|---------|
| `app.json5` | 应用全局配置文件 |
| `resources/` | 应用全局资源文件目录 |

## entry/ 目录（主模块）

| 文件/文件夹 | 作用说明 |
|------------|---------|
| `build-profile.json5` | 模块构建配置文件 |
| `hvigorfile.ts` | 模块构建脚本 |
| `oh-package.json5` | 模级依赖管理配置 |
| `src/` | 源代码目录 |

## entry/src/main/ 目录

| 文件/文件夹 | 作用说明 |
|------------|---------|
| `module.json5` | 模块配置文件，定义应用能力、权限等 |
| `resources/` | 模块资源文件目录 |
| `ets/` | ArkTS 源代码目录 |

## entry/src/main/ets/ 目录（源代码）

| 文件/文件夹 | 作用说明 |
|------------|---------|
| `entryability/EntryAbility.ets` | 应用入口文件，管理应用生命周期和接续逻辑 |
| `pages/MailHomePage.ets` | 邮件首页UI界面 |
| `utils/MailInfoManager.ets` | 邮件信息管理类，处理分布式数据对象 |

## 核心功能实现

1. **分布式数据传输**：通过 `distributedDataObject` API 实现跨设备数据传输
2. **应用接续**：通过系统 Dock 栏实现应用在不同设备间的接续
3. **数据同步**：使用分布式数据对象实现邮件数据的实时同步

## 技术要求

- HarmonyOS 系统：5.0.5 Release 及以上
- DevEco Studio：6.0.2 Release 及以上
- HarmonyOS SDK：6.0.2 Release SDK 及以上
- 支持设备：华为手机

## 必要权限

- `ohos.permission.DISTRIBUTED_DATASYNC`：分布式数据同步权限
