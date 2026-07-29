# 第二关 V2 实施计划

**目标：** 将现有“护航后直接结算”的原型重构为选择后即时进入分支 Boss 战的完整第二关。

## 现有代码处理

保留 Markdown 对话加载、军需官转场、共通护航和扫描实体；移除 `showChapterTwoOutro()` 的直接完成调用，选择仅负责决定 Boss 类型。

## 实施顺序

1. 扩充 `docs/dialogue-story.md`：新增救援浮标、两条 Boss 的阶段与胜利台词；`tools/run_checks.ps1` 增加这些必需 ID。
2. 在 `prototype/fb.html` 定义 `PurifierBoss` 与 `RunnerBoss`：各自拥有生命、三阶段、弱点、弹幕和 Canvas 占位绘制。
3. 新增运输船状态：叛军线为三条锁定梁与跃迁进度；帝国线为封锁锚点、拖曳缆索与一次清屏拦截火力。
4. 改造 `chooseBranch()`：选择后启动相应 Boss，恢复 `CH02_PLAY`，不显示章节结算。
5. 在 CH02 循环中加入 Boss 碰撞、阶段切换、分支目标 HUD、胜利动画和对应结算；失败重试保留当前改装。
6. 逐分支手工验收：保护难民、执行净化、护航失败、Boss 失败和第一关回归；运行 `tools/run_checks.ps1`。

## 美术 Prompt

| 文件 | Prompt |
| --- | --- |
| `ch02_boss_purifier_edict.png` | `top-down 2D shooter boss, imperial purification battleship, broad armored hull, three targeting emitters, red tractor beams, cold white gunmetal and warning red, readable silhouette, transparent PNG, no text, no UI, no watermark` |
| `ch02_boss_runner_homebound.png` | `top-down 2D shooter boss, rebel boarding cruiser, battered industrial hull, grapple harpoons, orange engine overdrive, improvised armor, readable silhouette, transparent PNG, no text, no UI, no watermark` |

## 完成定义

第二关必须以 Boss 击败为结束条件；选择、Boss、胜利目标和第三关预告在两条分支上均不同。
