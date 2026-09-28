# Worklog

# 2026-09-23

- 已将原型从“叙事纵切”扩展为“全故事线可走通骨架”：新增第三章公共中继、第四章锈蚀维修站、第六/七/八章路线专属行动，以及第九章赵利俄斯外环的三种终局。第 09 关口选择不再直接结算，而是进入对应中后期章节；每章均有状态、目标、保护对象或互动目标、失败重试、结果对白和下一章跳转。新增 `docs/全剧情细节完善路线图.md`，按可验证批次列出后续叙事、章节机制、人物、美术/UI、数值和回归工作。
- 更新 `剧情设计文档.md` 和 `叙事与机制审查-2026-09-21.md`，使流程映射、机制契约、当前边界和人工 QA 与九章骨架一致；同步将旧 iOS 需求/架构/背景台词文档标注为历史实现参考，防止旧第二章 `branch` 流程重新成为基线。
- 验证：提取 HTML 脚本的 Node 语法检查、46 条唯一对白 ID/叙事状态/路线静态契约、无界面九章运行时状态 smoke test、21 个第一章 PNG 文件头检查和 `git diff --check` 均通过。当前沙箱缺少 PowerShell 与 Pillow，未能运行原始 `tools/run_checks.ps1` 的完整资产校验链。

# 2026-09-21

- 已按 `docs/星火燎原-多视角剧情小说.md` 与 `docs/剧情设计文档.md` 完成 HTML 原型叙事纵切迁移：新增可跳过的赵利俄斯护航战序章、B 区黑匣闭合、锈蚀插章、第 09 隔离关口公共战斗、三项具象行动选择，以及帝国/叛军/深岩三条具有不同目标的路线战斗。B 区旧 `protection/execute` 阵营卡、分支 Boss 与最终路线写入已从运行时流移除。
- 已重写运行时对白源并把 `tools/run_checks.ps1` 的契约更新为验证序章、插章、关口、结局 ID、必要状态、三条路线以及旧 B 区分支符号已移除。新增 `docs/叙事与机制审查-2026-09-21.md` 记录剧情基线、机制审查、修复和后续 QA。
- 已完成机制复核与修正：救生舱扫描状态现在实际更新投射物并明确免疫；第一章恢复帝国/叛军混合波次；缝合航母将三次保护性转向写为证据并在战后航迹回放；Gate 09 路线提供可损毁/可回收目标、保护对象、失败重试和 Bob 对战术节点的锁定支持。

# 2026-07-29

- 已依据 `docs/星火燎原-多视角剧情小说.md` 新建 `docs/剧情设计文档.md`，将当前原型重构目标固定为“连续调查到三分支”叙事纵切：赵利俄斯序章过场、第一章救生舱、第二章检疫船调查、锈蚀插章、第 09 隔离关口三选一，以及帝国、叛军、深岩三条短终局。小说仍是剧情事实的唯一来源；本文件只定义可玩映射、对话分组、运行状态与验收标准。尚未改动原型代码或运行时对白，待设计文档审阅后进入实施计划。
- 已完成剧情与原型审核并新增 `docs/superpowers/plans/2026-07-29-narrative-vertical-slice.md`。发现 B 区过早写入最终路线、运行时缺少序章/插章/关口/终局对白、以及当前阵营二选一卡片无法呈现人物和代价。用户已选择第 09 关口采用“通讯剧场优先”UI：先呈现玛拉求救与三人争执，再展示三项行动和即时后果。待按计划执行。

## 2026-07-28

- 新增 `docs/第一章关卡设计.md`：补充驾驶员身份、任务简报、民用求救通讯、救生舱扫描、冲突命令和 Boss 伏笔的完整开篇流程。
- 新增问题管理员机制：`docs/问题追踪.md`、`docs/issues.json` 和 `tools/issue_admin.ps1`。问题必须经过复现、根因、修复、验证和回归测试才能关闭，避免同一 Bug 反复修表象。

## 2026-07-23

- 已修复第二章 V2 Boss 复核阻塞项：目标组改用 `initializedPhases` 逐阶段只初始化一次，已摧毁的锁定节点/炮组不会在后续船体命中时重建，清空后可正常进入下一阶段与核心。保护线二阶段的过载拾取现提供 540 帧的 x2 玩家投射物/导弹伤害，并在右上通讯技能状态、能力提示和拾取 toast 中显示剩余时间。执行线二阶段的拦截拾取现可由 Space 或双击优先消耗一次，清空当前敌方子弹并显示清场数量；未持有时仍执行原驾驶员技能。第二章重试、章节启动与整局重置均清除两种临时状态。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）。

- 已完成第二章 V2 分支 Boss 接入：抉择确认后仅写入一次分支、关闭抉择层、显示对应分支通讯并立即调用 `startChapterTwoBoss` 回到 `CH02_PLAY`，不再直接进入结局。Boss 存在期间停止普通第二章波次/清场完成判定；既有玩家投射物和导弹均接入 `damageChapterTwoBoss`，Boss 敌弹同时可威胁玩家与护航船，护航船被毁仍走保留驾驶员与改装的 B 区重试。Boss 击败是唯一第二章成功出口：Protection 分支以断开的红色封锁束和货船上跃迁离场呈现，Execute 分支以 Runner 向下撤离、货船信号淡出呈现，随后一次性显示带不同第三章预告的结局页；结局按钮重开完整任务。`startChapterTwo`、`restartChapterTwo` 与 `resetRun` 均清除分支 Boss、临时拾取增益、胜利动画和结局守卫，第一章 Boss 流程未改动。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）；代码扫描确认 `showChapterTwoOutro` 只由胜利动画调用。

- 已新增第二章 V2 分支 Boss 原语，但尚未接入选择/结局或现有游戏循环：`PurifierBoss`（保护难民，12000 HP）以三枚锁定节点、三门炮组和最终锁定核心构成三阶段，并持续绘制赤红/白色牵引束；`RunnerBoss`（执行命令，11000 HP）以抓钩锚点、登船炮组和发动机核心构成三阶段，并绘制橙锈色抓钩。两者均以 `ChapterTwoBossTarget` 管理可攻击目标，二阶段分别生成一次临时过载/拦截拾取物。新增独立 API：`startChapterTwoBoss`、`updateChapterTwoBoss`、`damageChapterTwoBoss`、`isChapterTwoBossDefeated` 与 `updateChapterTwoBossObjectives`；其 HUD 只更新现有任务文本，绝不显示第一章 `#boss-frame`。登场和二阶段对白仅经一次性守卫的 `showDialogueId` 调用既有六个对话 ID。待后续任务接通分支选择、弹药命中与退出流程。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）。

- 已补齐第二章 V2 对话契约：新增救援浮标与保护难民/执行命令两条分支的 Boss 登场、二阶段、击败记录。保护难民的 `rebel_boss` 条目对应帝国封锁舰，执行命令的 `empire_boss` 条目对应叛军突击舰；台词均围绕锁定束、跃迁窗口、抓钩、封锁线和发动机核心。`tools/run_checks.ps1` 已将 7 个新 ID 加入必需对话检查，保留原有 native exit-code 中止行为。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）。

- 已完成第二章可玩 MVP：`CH02_PLAY` 现独立更新护航船、扫描信标、敌机/敌弹、玩家弹药、导弹、粒子与清理逻辑；四波按 `2/3/3/4` 生成，每波开始生成一个扫描信标（共三个）。敌机接触护航船会造成完整度伤害并爆炸，护航船损毁或玩家被击毁均进入只重试 B 区的失败界面；重试保留驾驶员、货物和已装配改装。三次扫描、四波生成与清场完成后进入抉择界面，Protection/Execute 只可写入一次分支，分别显示对应对话、结局和第三章预告。`CH02_CHOICE` 与 `CH02_OUTRO` 不更新战斗；第一章循环及其掉落逻辑保持原路径。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）；临时 Python HTTP 服务命令被环境策略在执行前拦截，确认未遗留监听进程。

- 已接通第一章至第二章连续过场：第一章战后对话继续通过 `showDialogueId('ch01.debrief')` 显示；路线图后的三张章节整备卡改为选择后进入军需官流程，不再重开第一章。`finishQuartermasterRefit` 会隐藏整备界面、切换至 `QUARTERMASTER` 状态，按 1.8 秒间隔显示军需官装甲与货单对话，同时播放 2.6 秒的“B 区紧急护航”部署转场，随后调用既有 `startChapterTwo`。`resetRun` 已重置 chapter、branch、扫描、护航船与第二章波次状态。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）。

- 已新增第二章核心原语：`prototype/fb.html` 定义 `CHAPTER_TWO` 配置、章节/分支/扫描/护航状态，新增纯 Canvas 的 `ConvoyHauler` 与 `ScanBeacon`；新增 `setMission`、第二章任务 HUD、扫描收集、四波受上限约束的敌人生成和 `startChapterTwo` 重置入口。第二章 HUD 将波次/扫描进度写入波次栏，并将护航船剩余完整度写入通讯正文。此轮未改动第一章 `PLAYING` 循环、未接入章节跳转或抉择 UI；第二章尚不会从现有 UI 启动。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过（HTML 语法、对话源、19 个第一章素材）。

- 已更正 README 运行状态说明：原型现通过 HTTP `fetch` 加载 `docs/dialogue-story.md`，必须使用 `tools/serve_prototype.ps1` 启动后访问，不能通过 `file://` 直接打开 HTML。

- 已接入第一章 Markdown 对话源：`prototype/fb.html` 新增只解析现有单 YAML 围栏语法的 `parseDialogueMarkdown`、异步 `loadDialogueSource`、一次性告警及可继续开局的回退条目；部署、Boss 登场和章节战报均通过 `showDialogueId` 走原有 `showDialogue` 渲染路径。驾驶员变体键已改为与运行时 `pKey` 一致的小写。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过（HTML 语法、对话源、19 个素材）；尝试短暂启动 Python 静态 HTTP 服务并请求原型/Markdown 时，环境命令策略在启动前拦截该复合命令，因此未能完成 HTTP 实测，未遗留服务进程。

- 已建立 `docs/dialogue-story.md` 作为唯一 Markdown 对话源：单个 YAML 围栏包含第一章部署、Boss 登场、战后收束及三名驾驶员变体，并包含第二关军需官、扫描与三项抉择记录；新增 `tools/serve_prototype.ps1`，在仓库根目录启动本地 HTTP 服务并输出原型地址。Markdown 对话源与 HTTP 服务已为后续原型接入准备完毕，浏览器加载将在 Task 2 启用；README 已改为 HTTP 启动说明，避免直接打开 HTML。`tools/run_checks.ps1` 已从 3 步扩展为 4 步，新增 Node 校验 YAML 围栏数量、对话 ID 重复和必需 ID，并通过 `Invoke-Native` 在任意 Node/Python 命令失败时中止，避免错误后仍报告成功。验证：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 与 `powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1 -RegenerateAssets` 均通过，输出 `dialogue source ok`、HTML 语法和 19 个素材校验通过。
- 已完成第二关 MVP 设计确认并新增 `docs/superpowers/specs/2026-07-23-chapter-two-mvp-design.md`：确定第一关通关后经军需官整备自动接入第二关；第二关采用护航、扫描、抉择、分支结算与第三关预告的闭环；定义统一 Markdown 对话源、系统素材占位方案和正式美术生成 prompt。尚未开始实现代码。
- 已按评审意见收紧军需官台词：改为装甲擦痕、货舱耗氧和民用身份码三个可验证的后勤线索，移除抽象感叹句。
- 已新增 `docs/superpowers/plans/2026-07-23-chapter-two-mvp.md`：实现计划覆盖 Markdown 对话源、本地 HTTP 启动、第二关护航扫描、分支结算与回归验收；计划已完成占位符和需求覆盖自检。
- 第二关 V1 原型已完成护航、扫描与直接分支结算，但叙事和玩法张力不足；已按评审重构为选择后即时分支 Boss 的 V2 设计，并替换对应实施计划。现有 V1 原型待 V2 计划批准后改造。
- 第二关剧情再次重构为 V3“检疫井之前”：明确 A 区航迹矛盾、B 区护送动机、救援浮标、三次现场证据、净化倒计时和两条 Boss 的出场因果；同步更新 `docs/dialogue-story.md`、第二章设计文档和背景故事摘要，未改代码。

## 2026-07-20

- 准备检查并修复玩家战机透明问题：不再用圆形/椭圆实体阴影掩盖；检查 Alice/Bob/Charlie 三张玩家战机 PNG 的 alpha 分布和运行时绘制路径，判断是否为素材透明度问题，并修复透明素材或绘制方式。
- 已完成玩家战机透明问题修复：确认 Alice 最严重，修复前 Alice/Bob/Charlie 非透明像素平均 alpha 分别约 145/189/191；`tools/import_art_assets.py` 新增玩家战机专用 alpha 压实，并在缩放贴图后执行，保留透明背景但压实主体；重新导入三张玩家战机后平均 alpha 提升为 Alice 232、Bob 244、Charlie 243；`prototype/fb.html` 移除玩家战机运行时椭圆实体阴影，战斗阶段只绘制修复后的素材本体。验证通过：`tools/run_checks.ps1` 通过。
- 准备修复 Boss 击毁后无法结束与视觉问题：Boss 死亡分支仍调用 `maybeDrop(..., true)`，会强制进入改装选择并打断 `BOSS_CRASH`/结算链路；本次移除 Boss 死亡掉落，增加结算防重入；玩家战机改为不透明专用绘制，选人界面背景/卡片调成更分离的色彩，避免战机透明和与卡片颜色过近。
- 已完成 Boss 击毁结算与视觉修复：`prototype/fb.html` Boss 死亡分支移除 `maybeDrop(boss.x, boss.y, true)`，击毁 Boss 后不再掉落、不再弹出改装选择；新增 `endingStarted` 防止坠毁完成后重复结算；坠毁完成直接 `endRun(true)`；玩家战机改用 `drawSolidPlayerSprite` 不透明绘制并加深色实体底影；选人界面背景改为深色径向背景，卡片改为更深中性色，选中态用金色边框，战机预览加深投影以和 UI 拉开。验证通过：`tools/run_checks.ps1` 通过，代码检查确认 Boss 死亡分支无掉落调用。
- 准备执行 UI 可读性和 Boss 表现修正：取消 Boss 阶段强制对白，不再暂停战斗；阶段对白仅进入右上角通讯面板；选人界面头像和战机放大；右上角通讯面板再放大；Boss 一阶段改为专用不透明绘制路径并加实体底影，修复身体发虚/透明感。
- 已完成 UI 可读性和 Boss 表现修正：`prototype/fb.html` 移除 `BOSS_DIALOGUE` 强制暂停路径，Boss 阶段对白改为右上角通讯面板自然显示并延迟玩家回应；选人卡宽度从 220 提到 280，人物头像从 58 提到 96，战机展示从 138x96 提到 210x140；右上通讯面板从 430 提到 500，头像、字号、驾驶员状态区同步放大；新增 `drawSolidBossSprite`，Boss 使用不透明绘制、重置滤镜并添加深色实体底影，缓解一阶段身体发虚/透明问题。验证通过：`tools/run_checks.ps1` 通过，代码扫描确认无 `BOSS_DIALOGUE`/强制通讯残留。
- 准备修复 Boss 坠毁卡阶段与互动不足：Boss 坠毁完成后不再中转 `PLAYING`，直接进入章节结算；增加 Boss 对三名驾驶员的不同阶段对白和玩家回应，强制显示在右上通讯面板；Boss 体型继续放大并增加横移护航、弹幕、召入小行星等行为；击毁杂兵时增加角色短句互动。
- 已完成 Boss 与战斗互动增强：`prototype/fb.html` 中 Boss 半径提升到 110、血量提升到 32000、贴图绘制宽度提升到 `5.0r`；Boss 增加横向护航、保护弹幕、二阶段后召入小行星的行为；阶段切换使用 `bossPhaseExchange` 为 Alice/Bob/Charlie 分别生成 Boss 台词和玩家回应，进入 `BOSS_DIALOGUE` 强制通讯后再恢复；击毁杂兵通过 `maybeCombatBark` 触发角色短句并带冷却；Boss 坠毁完成后直接 `endRun(true)`，不再中转 `PLAYING`，修复结算可能卡住的问题。验证通过：`tools/run_checks.ps1` 通过；本轮 Chrome REPL 验证工具出现本地路径错误，未能完成浏览器自动化复测。
- 准备执行 UI/黄金小行星/Boss 强化：左右上角信息合并到右上通讯状态面板并整体放大美化；新增黄金小行星，击碎后提供额外改装收益；“黑匣索引”提高黄金小行星概率；Boss 血量大幅增加，阶段转换加入强制观看对白，增加保护逃生舱视觉动作，击落后播放坠毁动画再结算。
- 已完成 UI/黄金小行星/Boss 强化：左上 HUD 隐藏，右上通讯状态面板扩大到统一承载头像、对白、驾驶员、血量、技能、波次和多行改装；新增黄金小行星，基础概率 8%，黑匣索引每级 +5%、最高 30%，击碎后已有改装随机 +2 级、无改装时触发一次改装选择；Boss 血量提升到 28000，绘制逃生舱与护航弧线，定期强调保护逃生舱；阶段转换进入 `BOSS_DIALOGUE` 强制通讯暂停；击落后进入 `BOSS_CRASH` 坠毁动画，残骸下沉、连续爆炸并延迟结算。验证通过：`tools/run_checks.ps1` 通过；Chrome 自动化确认无可见 `Rogue`、左上 HUD 隐藏、右上面板宽度约 468px、黑匣索引 Lv.3 时黄金小行星概率约 23%、Boss `maxHp=28000`、阶段切换进入 `BOSS_DIALOGUE`、坠毁进入 `BOSS_CRASH`。
- 准备执行本轮叙事/UI/关卡调整：新增指挥频道头像生成 prompt；游戏内不再出现 `Rogue` 字样，统一改为“改装”，多个改装在 HUD 中多行显示；第一关移除帝国战机出场；背景 prompt 改为小行星带与黯淡恒星视角；新增小行星障碍，随机向玩家战机碰撞，敌机避让小行星，小行星离开战区后删除不返回。
- 已完成本轮叙事/UI/关卡调整：`prototype/fb.html` 右上角任务面板升级为通讯状态面板，整合头像、对白、区域、波次、驾驶员和多行改装；`showDialogue` 改为写入右上角面板，底部旧对话框不再显示；开场/中段/Boss/结算对白重写为更人性化的第一章叙事；所有可见 `Rogue` 改为“改装”；第一关普通/精英敌机固定为叛军；新增 `Asteroid` 小行星障碍，随机切入玩家附近、敌机避让、离场删除不返回；美术需求文档新增指挥频道头像 prompt、小行星背景 prompt 和小行星障碍 prompt，并标注帝国无人机不用于第一章。验证通过：`tools/run_checks.ps1` 通过；Chrome 自动化确认页面无可见 `Rogue`，改装多行显示，第一关敌机类型均为 `rebel`，小行星可生成且有离场删除逻辑，指挥频道头像路径已预留。
- 准备修复素材与 UI 融合问题：当前白边/白块主要来自 `drawReadableSprite` 的白色反相描边缓存，以及选人头像/战机/UI 面板的浅色底板；SYSTEM 对话头像仍会走 emoji fallback。本次移除白色描边，改用轻量暗投影；UI 容器改为深色半透明战术面板；SYSTEM/HUD fallback 不再显示 emoji。
- 已完成素材与 UI 融合修复：`prototype/fb.html` 移除白色反相描边缓存和 `SPRITE_CACHE`，战斗单位改为单次贴图加黑色投影；选人、HUD、任务、对话、Rogue、转场、路线图面板统一为深色半透明风格；初始 HUD/对话与 SYSTEM fallback 改为 `SYS`/角色名，删除角色数据中的 emoji 字段。验证通过：`tools/run_checks.ps1` 通过；Chrome 自动化确认页面无可见 emoji，选人战机/头像素材加载成功，HUD/任务/对话为深色面板，战斗绘制函数不再包含白色描边缓存。
- 准备修复卡顿和比例问题：上一轮 `drawReadableSprite` 在每帧对每个单位多次 `drawImage` 并使用 `ctx.filter`，敌人多时会导致严重卡顿；选人界面仍显示 emoji 是旧卡片内容未清理；本次改为预渲染描边缓存、战斗中单次绘制，并隐藏旧 emoji 节点、收敛选人和战斗单位比例。
- 已完成卡顿和比例修复：`prototype/fb.html` 将描边贴图改为 `WeakMap` 缓存的离屏预渲染，运行时每个单位只绘制一次缓存图；移除选人卡旧 emoji 节点；选人战机缩到 138x96；战斗显示比例调整为玩家约 2.7r、普通敌人 2.75r、精英 3.45r、Boss 4.0r。验证通过：`tools/run_checks.ps1` 通过；Chrome 自动化确认选人卡无 emoji、三名角色战机和头像均加载素材，22 个敌人的压力场景约 60 FPS。
- 准备修复当前视觉反馈：选人阶段接入玩家与头像素材；把 `art/` 中 UI 图标导入到 `assets/ch01/ui` 并用于升级卡/路线图；整体 UI 改为更亮、更高对比；去掉战机/敌机/Boss 外圈光晕，改用描边投影和明暗分离；增大 Boss 运行时显示尺寸，提升玩家、敌人和 Boss 的边界清晰度。
- 已完成视觉清晰度修复：`tools/import_art_assets.py` 导入 3 个 UI 素材并提高背景亮度；`prototype/fb.html` 选人阶段接入玩家战机和通讯头像，HUD/对话/升级/转场/路线图改为浅底高对比 UI，升级卡与路线图使用 UI 素材；玩家、敌人和 Boss 贴图改为轮廓描边式分离，移除敌机外圈光晕，Boss 显示尺寸增大。验证通过：`tools/run_checks.ps1` 校验 19 个素材；Chrome 自动化确认选人素材、HUD 头像、UI/Boss/玩家/敌人资源均加载成功，Boss `maxHp=9000`、运行时绘制宽度约 423px。

## 2026-07-17

### 本次目标
- 记录每次修改，避免重复引入已修过的问题。
- 修复 Bob 偏弱。
- 增强激光攻击力与视觉表现。
- 章节完成后加入人物对话环节和改装路线图。
- 增加战斗进入/退出转场。

### 已知不可回归项
- Rogue 物品不能相互覆盖；同名物品应升级，不同物品应共存。
- Boss 不能被玩家等级门槛卡住；15 波完成且清场后应进入 Boss。
- 出兵节奏应从少到多，当前波次表为 `1,1,2,2,2,3,3,3,4,4,4,5,5,5,6`。
- 未击落敌人不能静默消失；越界后应重新入场。

### 修改记录
- 创建 worklog，后续每次修改先写入本文件再改代码。
- 准备修改 `fb.html`：加强 Bob 基础射速/导弹/锁定表现；增强激光伤害和绘制；章节胜利后先显示人物对话，再进入改装路线图；加入部署和章节完成转场。
- 已修改 `fb.html` 样式/结构：新增战斗转场层和路线图样式；加强 Bob 基础速度、射速和装甲，未改动 Boss 触发与 Rogue 叠级规则。
- 已修改 `fb.html` 激光表现：激光作为附加武器保留，不覆盖主炮；增强伤害倍率、宽度和长束视觉。
- 已修改 `fb.html` 命中规则：新增 `projectileHits`，激光使用竖向长条命中，避免视觉命中但没有伤害。
- 已修改 `fb.html` Bob 能力：Bob 主动技能充能更快、导弹伤害提高，锁定普通敌人时会短暂降低其推进速度。
- 已修改 `fb.html` 转场流程：新增 `showTransition`，章节胜利后先进入章节完成转场，不再直接跳改装结算。
- 已修改 `fb.html` 章节完成流程：新增人物战后对话和改装路线图，路线图之后再进入战术回收。
- 已修改 `fb.html` 战斗进入流程：点击部署后先显示部署转场，再进入 `PLAYING`，避免菜单到战斗硬切。
- 验证通过：JS 语法检查通过；Chrome 自动化确认 Bob 加强生效、Rogue 不覆盖、激光长条命中生效、15 波清场可进 Boss、章节完成后出现人物对话和 3 节点路线图。
- 准备新增第一章美术素材清单与生成 prompt 文档，包含命名规则、尺寸、透明背景要求、Prompt 和负面 Prompt。
- 已新增 `docs/第一章美术素材需求.md`：覆盖玩家战机、通讯头像、敌机、Boss、背景、UI 路线图、特效素材、命名规则、尺寸和首批最小必需素材清单。
- 创建 `assets/ch01` 目录结构，准备生成首批 12 个第一章 PNG 素材；使用可重复运行的 Pillow 脚本生成并校验尺寸/透明通道。
- 用户确认开始生成图片素材；继续执行 `tools/generate_ch01_assets.py`，生成首批 12 个第一章素材并进行尺寸、透明通道、文件完整性测试。
- 已生成首批 12 个第一章素材到 `assets/ch01`，并新增 `tools/validate_ch01_assets.py`。验证结果：12 个素材尺寸、文件存在性、透明通道要求全部通过；已生成 `assets/ch01/ch01_asset_contact_sheet.png` 并完成目视抽检。
- 记录环境问题：之前在 PowerShell 中误用 Bash heredoc（例如 `python - <<PY`、`node - <<NODE`），导致 `<` 重定向语法错误；修正方式是使用 PowerShell 原生命令、`node -e`、`python -c` 或项目内脚本文件。
- 已新增 `tools/run_checks.ps1`，封装 PowerShell 兼容检查流程：`fb.html` 脚本语法检查、可选素材重生成、第一章素材校验。验证通过：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`。
- 准备执行项目结构整理：移动 `fb.html` 到 `prototype/`，归档旧 `art/` 到 `art_source/legacy/`，移动 contact sheet 到 `assets/ch01/_previews/`，新增 `README.md` 和 `assets/ch01/assets_manifest.json`，并更新检查脚本路径。
- 已完成项目结构整理：`prototype/fb.html` 为原型入口，旧 `art/` 已归档到 `art_source/legacy/`，contact sheet 已移动到 `assets/ch01/_previews/`，新增 `README.md` 与 `assets/ch01/assets_manifest.json`，并更新 `tools/run_checks.ps1` 和相关文档入口引用。验证通过：`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1`。
- 准备修复素材接入问题：`prototype/fb.html` 目前仍使用程序化绘制，未加载 `assets/ch01` 生成素材；同时重写第一章美术 prompt 文档为“一行一个可复制 prompt”，包含文件名、尺寸、背景/透明模式和生成要求。
- 已修复素材接入：`prototype/fb.html` 新增 `ASSET_PATHS` 与 `SPRITES` 加载，背景、三名玩家战机、三类敌人、Boss 三阶段和激光特效优先使用 `assets/ch01` 图片，加载失败时保留程序绘制 fallback。
- 已重写 `docs/第一章美术素材需求.md`：改为一行一个完整 prompt，可直接复制，且每行包含文件名、尺寸、PNG/透明模式、用途、风格和禁止项。
- 验证通过：`tools/run_checks.ps1` 通过；Chrome 自动化确认 3 个玩家素材、3 个敌人素材、3 个 Boss 素材、背景和激光素材全部从 `prototype/fb.html` 成功加载，进入游戏后状态为 `PLAYING`。
- 准备替换用户生成素材：检查 `art/` 下 Gemini 默认命名图片，生成编号预览图，按第一章运行时命名规则复制/裁切/缩放/透明化到 `assets/ch01`；方向异常的敌机素材会在处理时旋转到游戏需要方向。
- 已替换用户生成素材：新增 `tools/import_art_assets.py` 将 `art/` 中匹配的用户素材处理到 `assets/ch01`，包括 Alice/Bob/Charlie、叛军小艇、Boss 三阶段、背景和激光；叛军小艇已旋转为敌机入场方向；棋盘格/白底背景已透明化。帝国无人机、精英敌人、爆炸因 `art/` 中没有更准确匹配图，保留现有运行时素材。
- 已重命名 `art/` 中 Gemini 默认文件：新增 `tools/rename_art_sources.py`，将默认文件名改为 `sf_ch01_*` 语义名，便于追踪来源素材。
- 验证通过：`python tools\import_art_assets.py` 可重复执行，`tools/run_checks.ps1` 通过，Chrome 自动化确认原型成功加载 3 个玩家、3 个敌人、3 个 Boss、背景和激光素材并进入 `PLAYING`。
- 已修复第二轮美术反馈：`sf_ch01_boss_stitched_carrier_phase03_core_source` 改作为叛军精英敌人导入；新增 `sf_ch01_enemy_empire_drone_a_source.png` 并旋转/透明化后替换帝国敌机；Boss 第三阶段改由阶段 2 航母源图派生亮核心版本；背景导入时提升亮度和对比；原型中 Boss 血量提升到 9000；HUD 和通讯框接入 Alice/Bob/Charlie/叛军指挥官头像。
- 验证通过：`python tools\import_art_assets.py` 可重复执行；`powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1` 通过并校验 16 个素材；Chrome 自动化确认 HUD 玩家头像、玩家通讯头像、叛军通讯头像均为图片，Boss `maxHp` 为 9000。

- 准备修复素材错配与可读性问题：sf_ch01_boss_stitched_carrier_phase03_core_source 实为叛军精英敌人；新增 Gemini_Generated_Image_bkxd3vbkxd3vbkxd 作为帝国战机/无人机素材；需要调整素材朝向和背景透明，调亮背景，提高敌人可读性，提升 Boss 血量，并接入玩家/敌人通讯头像。

- 准备修复玩家战机透明与违和圆圈：增强玩家运行时 PNG 的不透明度、对比和内部暗边界；移除战斗中玩家主动技能的圆形描边提示；选人/战斗改用非圆形贴图阴影和滤镜提高可读性；完成后必须由 subagent 独立验证通过再汇报。

- subagent 独立验证未通过：Alice 仍比 Bob/Charlie 更细更暗，视觉上像透明；选人卡底部 drop-shadow 仍可能形成阴影观感。继续增强 Alice 主体尺寸/亮度/边界，并移除选人阶段底部阴影式滤镜，修完后重新提交 subagent 复验。

- 已完成玩家战机透明/阴影复修：	ools/import_art_assets.py 为玩家素材增加实色 alpha、对比/饱和/亮度增强、非圆形暗轮廓和细亮边；Alice 导出占比提高到 0.98。prototype/fb.html 移除选人舰船 drop-shadow，战斗中主动技能不再画玩家圆形描边，改为机身尾焰反馈。验证通过：重导入素材后 	ools/run_checks.ps1 通过；subagent 独立复验 PASS，确认三名玩家选人/战斗阶段不再透明、无圆形/椭圆玩家阴影、Boss 击毁仍走 BOSS_CRASH -> endRun(true) 且无 Boss 掉落/改装弹窗。

- 准备修复玩家飞船素材过曝与白色色块：当前玩家导入增强过重且亮边导致白块感，Alice 选人边界仍不清楚。本次改为清理近白背景残留、降低亮度增强、取消亮色描边，使用贴合透明轮廓的深色描边和轻微色彩恢复。

- 继续修复玩家飞船白色色块：直接查看 Alice 运行时 PNG 后发现发动机尾焰仍存在高亮白色像素块。继续改导入管线，把玩家素材中的近白高亮按角色能量色压色，避免纯白块残留。

- 继续收紧白块清理：预览中 Alice 机翼内侧仍有浅白残留。将低饱和近白像素改为直接透明化，不再保留灰白细节；有色高亮尾焰仍按角色能量色压色。

- 修复选人阶段透明洞透出白底的问题：Alice 机翼内侧白块来自透明区域透出浅色卡片底，不再继续破坏素材本体，改为给选人飞船展示区设置深色底板与细边框，让透明区域显示为暗部。

- 已完成玩家素材过曝/白块修复：导入管线取消亮色描边，降低亮度增强，清理低饱和近白残留，并把有色高亮压到角色能量色；选人飞船展示区增加深色底板和轻边框，避免透明洞透出浅色卡底形成白块。验证通过：	ools/run_checks.ps1 通过；subagent 独立复验 PASS，确认选人阶段不再透白底、玩家素材无明显过曝块、Alice 边界清楚。
- 已完成第一章开场搜救流程：部署转场后进入 `CH01_BRIEFING`，依次调用 `ch01.deploy`、`ch01.pilot_status`、`ch01.mission_brief`、`ch01.distress_signal`；随后生成不可被玩家攻击的程序化 RescuePod，进入 `CH01_RESCUE`，靠近目标扫描 300 帧后调用 `ch01.rescue_scan`/`ch01.rescue_order` 并恢复 `PLAYING` 波次。开场 HUD 显示 A 区目标、扫描百分比与武器锁定状态；移动输入在开场有效、射击与波次冻结；重置会清理计时器和 RescuePod。验证通过：`tools/run_checks.ps1`（脚本语法、对白 ID、19 个素材）。
