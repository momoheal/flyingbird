# 对话数据源

```yaml
dialogues:
  - id: ch01.deploy
    speaker: 指挥频道
    default: "战机已离港。穿过小行星带，清除叛军拦截艇。"
    pilots:
      alice: "战机已离港。小行星带里有叛军拦截艇，先清理航线。"
      bob: "战机已离港。顶住正面火力，带队穿过小行星带。"
      charlie: "战机已离港。先标记拦截艇，航线由你打开。"
  - id: ch01.pilot_status
    speaker: 驾驶员状态
    default: "裁决者小队，驾驶员身份确认。A 区第三防线正在失去通讯。"
    pilots:
      alice: "边境出生，帝国精英飞行员。你仍相信保护平民是军人的职责。"
      bob: "神经链接实验体。先验证数据，再相信命令。"
      charlie: "旧边境战争老兵。你认得 A 区的救援编号。"
  - id: ch01.mission_brief
    speaker: 指挥频道
    default: "任务一：恢复 A 区第三防线航道。任务二：回收失联补给船的军用物资。任务三：关闭未经授权的民用通讯。"
  - id: ch01.distress_signal
    speaker: 民用频道
    default: "这里是七号补给船……没有武器……请不要按帝国识别码开火……"
  - id: ch01.rescue_scan
    speaker: 扫描系统
    default: "救生舱为空。发现三套儿童呼吸面罩。舱门从外部强制关闭，时间早于叛军出现。"
  - id: ch01.rescue_order
    speaker: 指挥频道
    default: "忽略民用噪声。救生舱标记为叛军诱饵，立即摧毁。"
  - id: ch01.boss_intro
    speaker: 叛军指挥官
    default: "你们赶得太晚。货船和航道，现在都归我。"
    pilots:
      alice: "别把火力浪费在护航艇上。你拦不住我。"
      bob: "装甲再厚也挡不住这艘航母。"
      charlie: "锁定得再快，也救不了这条航线。"
  - id: ch01.debrief
    speaker: 指挥频道
    default: "航母已失能。回收残骸，返回前进基地。战报记录：目标曾试图撞击逃生舱。"
    pilots:
      alice: "战报说它撞向逃生舱……可我亲眼看见它把碎石挡开。"
      bob: "航迹与战报冲突：航母三次改变航向，全部朝向逃生舱。记录已复制。"
      charlie: "那艘船不是在撞人。它是在替逃生舱挨炮。"
  - id: ch02.quartermaster.armor
    speaker: 军需官
    default: "左舷装甲的擦痕全朝外。缝合航母是在替逃生舱挡碎石，不是在撞它们。"
  - id: ch02.quartermaster.manifest
    speaker: 军需官
    default: "我查到一支从 A 区撤出的转运队。名义上运矿，实际航线却通向 B 区检疫井。清单被改过。"
  - id: ch02.rescue_float
    speaker: 护航频道
    default: "失控穿梭艇正在下坠。它发出民用救援浮标，呼叫对象不是军方，是船队里的家属频道。"
  - id: ch02.scan.1
    speaker: 扫描官
    default: "扫描一：矿物舱没有矿物，货单原始标签是‘紧急转运’。"
  - id: ch02.scan.2
    speaker: 扫描官
    default: "扫描二：船体里有大量生命热源，数量远超船员编制。"
  - id: ch02.scan.3
    speaker: 扫描官
    default: "扫描三：身份码被整批删除，逃生门从内部锁死。检疫井不是避难所。"
  - id: ch02.choice.order
    speaker: 指挥频道
    default: "护航任务结束。把转运队交给检疫井，净化程序会自动接管。不要打开货舱。"
  - id: ch02.choice.rebel
    speaker: 护航频道
    default: "有人打开了货舱。别问他们该不该被救，先把跃迁窗撑到最后一艘船通过。"
  - id: ch02.choice.empire
    speaker: 帝国巡逻队
    default: "叛乱确认。关闭武器系统，接受净化接管。封锁阵列将在三十秒后启动。"
  - id: ch02.rebel_boss.intro
    speaker: 帝国封锁舰
    default: "护航机拒绝移交货船。封锁舰已锁定跃迁窗口，牵引束正在收紧。"
  - id: ch02.rebel_boss.phase2
    speaker: 帝国封锁舰
    default: "外层锁定束失效，改接发动机核心。货船跳不出去。"
  - id: ch02.rebel_boss.defeat
    speaker: 护航频道
    default: "封锁舰断开牵引。最后一艘转运船通过跃迁窗，浮标把家属频道带走了。"
  - id: ch02.empire_boss.intro
    speaker: 叛军突击舰
    default: "执行队正在逼近。抓钩已扣住货船，先切断你们的封锁线。"
  - id: ch02.empire_boss.phase2
    speaker: 叛军突击舰
    default: "前方封锁加固，过载发动机核心。抓钩别松，强行拖船。"
  - id: ch02.empire_boss.defeat
    speaker: 帝国巡逻队
    default: "叛军抓钩已脱离。封锁线恢复，货船的跃迁窗口已关闭。"
```
