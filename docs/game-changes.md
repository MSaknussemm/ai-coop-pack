# 游戏事件补充

本次已修改本机 dsh 工作目录的游戏源码并重新编译 build/th07_multi.exe。此目录附**完整源码补丁**与**当前编译的 exe**（与 build 目录 SHA-256 一致），方便审查；仅替换游戏 exe 时须放回带有 th07.dat、thbgm.dat 的游戏目录，不能单独运行。

补丁从上游 `sbrik1111/th07_multi_player` 原始 src 树生成，覆盖 17 个文件：新增事件、`GAME_OVER`、以及下面两个本体 bug 的修复。已在干净的上游源码上 `git apply --check -p1` 验证可应用。

| exe | SHA-256 |
|---|---|
| `game-integration/th07_multi.exe`（= `build/th07_multi.exe`） | `E40338351F6C7A8EE31DDB8EED82C6C29FE699270C9D4A14FB3ED67836DDD73D` |

新增事件来源：

| 事件 | 触发位置与条件 |
|---|---|
| PLAYER_HIT | Player::Die 受击，仍处于可死炸窗口 |
| PLAYER_DIE | 死炸窗口耗尽、确认掉命；从原先的受击位置移到这里 |
| STAGE_CLEAR | MSG_STAGERESULTS 关卡结算指令 |
| SPELL_START | ECL 建立符卡状态并设置符卡编号 |
| SPELL_FAILED | 符卡仍有效且仍可收取时，由 Bomb、确认死亡、破结界或非耐久符卡超时使其失效；同一符卡只在首次失效时发出 |
| BOSS_ENTER | ECL_SET_BOSS 从非 Boss 转为 Boss |
| ITEM_LIFE / ITEM_BOMB | 实际拾取相应道具 |
| POWER_FULL | 火力从低于 128 到达 128 |
| POWER_LOW | 火力从至少 32 降至低于 32；初始低火力不重复报 |
| DIALOGUE_START | 新消息脚本的第一条实际对白，纯结算脚本不误报 |
| GAME_OVER | 全队残机耗尽、进入 continue 画面时；正常退出仍走 GAME_END 的 finished 字段 |

Power 变化在玩家更新前后和道具拾取前后检查，不添加游戏状态字段。符卡失败在原有 isCapturing 清零前检查。日志沿用现有 CoopLog 输出路径；网络回滚可能重复执行事件，桌宠仍使用现有冷却抑制。没有加入确认帧事件队列。

桌宠新增 tongue 动画，仅复制桌面的盘腿吐舌版；擦弹里程碑、满火力、单关通过使用它。道具拾取台词改成“已经捡到”的语气。

尚未改动的限制：角色座位未筛选、不同事件可能重复吐槽、无消息优先级、独占全屏未验证。

## 同批修复的两个游戏本体 bug（2026-11-07 晚）

两份都与桌宠无关，是本体/反编译自带的，顺手一起修了。

### 1. Options 菜单越界写堆（致命）

- 现象：`th07.cfg` 的 `colorMode16bit` 为 `0xFF`（255，"自动"哨兵值）。只有全屏分支会把它归一化成 0/1（`GameWindow.cpp`），窗口模式下原样留着。
- 后果：`MainMenu.cpp` 里 `i = colorMode16bit + 23` 得到 278，而 `vmHead` 只有 164 个元素，对 278 号元素读写 = 越界 114 个 `AnmVm`，Options 每帧都执行。
- 修法（两处）：
  - `GameWindow.cpp`：`memset(&presentParams…)` 之后，窗口模式且值为 255 时归一化为 0；
  - `MainMenu.cpp`：索引改成 `(colorMode16bit < 2 ? colorMode16bit : 0) + 23` 做防御。
- 实测：进入 Options 停留 8 秒以上无崩溃，Graphic 行高亮为 **32Bit**（即索引 0），退菜单、退游戏均正常。

### 2. 每次启动都判定 cfg 异常并重置（高）

- 原因：`Supervisor.cpp` 的校验要求 `colorMode16bit < 2`，而重置默认值自己写的又是 255，于是"重置 → 写 255 → 下次仍判异常"，玩家改的命数、Bomb、难度、键位每次都被清掉。
- 修法：校验改为 `colorMode16bit < 2 || colorMode16bit == 255`（把 255 当作合法的"未定"值）。
- 实测：保留 255 的 cfg 启动，`log.txt` 里"コンフィグデータが異常でしたので再初期化しました"出现 **0 次**；正常退出后 cfg 的 0x1E 自动写成 0，之后不再触发。

改动前的三个源文件与 cfg 备份在 `th07mp/th07_multi_player-main/_bugfix_backup/`。源码是 Shift-JIS，补丁用字节级替换保持编码不变；重新编译为 `python scripts/build.py`（增量，3 个文件、总计 57 个源文件）。
