# 东方妖妖梦 本地双人 + P2 Bot（陪玩版）

构建日期：2026-11-07
基于：th07_multi_player（sbrik1111），VB6 反编译源码 some100/th07
工具链：VS2022 Community + MSVC v141 (14.16.27023) + Windows SDK 10.0.19041.0 + DirectX 8 SDK

## 怎么玩

- **play-auto.cmd**：一键进本地双人。P1 是你，P2 是 bot，默认 Normal、灵梦/魔理沙。
- **play-manual.cmd**：只开启动器，你自己点 “Start Game (local)”，自己选难度和机体。P2 仍然是 bot。

### 键位

- P1（你）：方向键移动，`Z` 射击，`X` Bomb，`Shift` 低速。
- P2（bot）：自动。
- 想两个座位都由 bot 控制（测试用）：启动前设 `set TH07_MP_BOT_P1=1`。

## 日志

- `mp_log.txt`：会话、关卡开始、幽灵、掉落、结算。
- `bot_log.txt`：bot 每 300 帧状态、每 1800 帧 `BOT_STATS`。
- `trace.txt`：启动阶段追踪（调试用，可删）。
- `replay/`：每局自动保存的多人 Replay（`.mpr`）。

## 实测数据（2026-11-07，N 难度）

第一关，两个座位都由 bot 控制时：

- P2：0 命中、0 Miss、0 死炸。
- P1：0 命中、0 Miss。
- 第一关 Boss 约 10200 帧（3 分钟），偏慢，原因是 bot 站位保守（y≈416，几乎不前进）。
- 规划开销：每帧约 10–20k cycles，峰值 757k；60fps 下 CPU 占用可以忽略。

P1 手动 + P2 bot 的分工已验证：P1 没人操作会变幽灵，P2 自己躲弹幕、0 Miss。

## 已知限制

- bot 站位保守，很少主动上前收点，Boss 战偏慢。
- 不主动送残 / 送 Power（源码里有 `testGive` 测试路径，但没接成常规行为）。
- L 难度未测；按代码结构，N/H 有戏，L 需要调参。
- 游戏用 DirectInput 轮询，外部 `SendInput` 注入键盘不一定生效；P1 请用真键盘。

## 改了什么

1. `prefix/msvc1410` 用 junction 指向 VS2022 的 v141 工具集。直接复制出来的 cl.exe 会报 D8050（c1.dll 无法执行）。
2. `GameErrorContext.hpp`：`Flush()` 改成先写 `log.txt` 再弹 MessageBox。否则无窗口/无交互桌面时 MessageBox 会卡死，且看不到错误。
3. `Session.cpp`：BOT 只接管 P1 以外的座位；`TH07_MP_BOT_P1=1` 可让 P1 也交给 bot。
4. `main.cpp`：加了 `trace.txt` 启动阶段日志。
5. `Session.cpp`：`SESSION` 日志增加 `bot=` 字段。

## 重新编译

```bat
cd /d <本目录上一级>
python scripts\build.py
```

需要 `prefix/msvc1410` 下的 `bin`、`include`、`lib` 三个 junction，以及 `thirdparty/dx8`。
