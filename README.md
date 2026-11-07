# 东方妖妖梦 · AI 联机包

> 基于 [`sbrik1111/th07_multi_player`](https://github.com/sbrik1111/th07_multi_player)（CC0）的 **P2 自动驾驶改版**：
> 2～3 人合作闯关，P2 可以交给 AI 自己躲弹幕、输出、捡道具；也支持本地双人（P1 你 + P2 bot）。

## 这个包包含什么

| 目录 | 内容 |
|---|---|
| `src/` | 完整源码（含 bot 的决策逻辑 `src/th07/multi/Bot.cpp`） |
| `build/` | 编译好的 `th07_multi.exe`、启动器配置、`play-*.cmd` 脚本 |
| `scripts/` | 构建脚本（`build.py`、`download_deps.py`） |
| `docs/game-changes.md` | 相对上游的全部改动说明 |
| `game-patch/` | 上述改动的补丁文件（可直接 `git apply`） |

## 这个包**不包含**什么

- ❌ **游戏本体数据**：`th07.dat`、`thbgm.dat`、`th07.exe`
  —— 请自备正版《东方妖妖梦 ver 1.00b》，把这三个文件放进 `build/`
- ❌ MSVC / Windows SDK / DirectX 8 SDK 工具链（只在你自己编译时需要）
- ❌ 打包好的完整游戏（本仓库只有 mod，不含原作内容）

## 快速开始

1. 准备好正版游戏，把 `th07.dat`、`thbgm.dat`、`th07.exe` 复制到 `build/`
2. 双击 **`build/play-coop.cmd`**
3. 启动器窗口里点 **`Start Game (local)`**，然后自己选难度和机体
4. 进关卡后：**P1 是你，P2 是 bot**

想全自动（两个座位都交给 bot，测试用）：双击 `build/play-auto.cmd`。

### 键位

- **P1（你）**：方向键移动，`Z` 射击，`X` Bomb，`Shift` 低速
- **P2（bot）**：自动
- 让 P1 也交给 bot：启动前 `set TH07_MP_BOT_P1=1`

## bot 能做到什么

- 读游戏内存判断弹幕、激光、敌机、道具（不是截图，零延迟）
- 34 帧前瞻、9 个采样点、17 个动作，每 8 帧重规划
- 会主动 Bomb、捡 P、捡残机、在 Boss 战往前压
- 实测：**N/H 稳，L 六面可以过**；Phantasm 能磨过去但很慢

参数都在 `src/th07/multi/Bot.cpp` 顶部的常量里，改完重新编译即可。

## 自己编译

需要：Visual Studio 2022 + **MSVC v141（14.16.27023）** + Windows 10 SDK 19041 + DirectX 8 SDK。

```bash
python scripts/download_deps.py   # 拉 DirectX 8 SDK 到 thirdparty/dx8
python scripts/build.py           # 产物在 build/th07_multi.exe
```

## 已知限制

- **DirectInput 不可用**：日志里会打印 `DirectInput が使用できません`，手柄用不了；键鼠走 `GetKeyboardState`，不影响正常玩
- 独占全屏会盖住任何置顶窗口（配合桌宠时请保持窗口化）
- L 难度只测过第六面；更高难度需要自己调参
- 这是**反编译产物**：CC0 只代表作者对自身贡献的主张，不改变 ZUN / 上海爱丽丝幻乐团的权利；本项目与官方无关，请勿用于商业用途

## 相关

- 配套桌宠（读日志说话的那个）：[`MSaknussemm/mesugaki-lite-pet`](https://github.com/MSaknussemm/mesugaki-lite-pet)
- 上游：[`sbrik1111/th07_multi_player`](https://github.com/sbrik1111/th07_multi_player)、反编译基础 [`some100/th07`](https://github.com/some100/th07)

## 许可

源码跟随上游 **CC0 1.0**，见 [LICENSE](LICENSE)。游戏本体数据的版权归原作者所有，本仓库不包含、也不分发。
