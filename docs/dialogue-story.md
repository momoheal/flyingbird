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
  - id: prologue.01
    speaker: 轨道管制
    default: '坠毁船的求救灯还在闪，信号来自下层废料场。'
    pilots:
      alice: '求救灯每隔两秒闪一次，说明下面至少还有备用电源。'
      bob: '信号强度在下降，先在它熄灭前锁定坠毁船的位置。'
      charlie: '废料场的风把灯光吹散了，我们得贴着残骸降下去。'
  - id: prologue.02
    speaker: 船载扫描仪
    default: '扫描到一条断开的升降轨，轨道尽头有新鲜的拖痕。'
    pilots:
      alice: '拖痕压过锈层，留下它的人刚把重物拖向矿井入口。'
      bob: '轨道断口承受不了战机重量，必须在断口前弃机步行。'
      charlie: '拖痕没有回头，下面的人带着东西进去了。'
  - id: prologue.03
    speaker: 未知女孩
    default: '别开外面的门，铁壳后面有东西在撞。'
    pilots:
      alice: '撞击把门框敲弯了，先找到孩子再决定怎么挡住它。'
      bob: '门锁剩下十二秒电量，封住它比开门更符合生存概率。'
      charlie: '她躲在门后，先回答她，让她知道我们听见了。'
  - id: ch02.outro.alice
    speaker: 爱丽丝
    default: '货舱门开着，里面的人把孩子的呼吸面罩递到了走廊。'
    pilots:
      alice: '他们先递出面罩，再把自己留在烟里，这不是敌人的撤离。'
      bob: '面罩数量和热源一致，货舱里的人是在按名单转移。'
      charlie: '孩子抓着面罩不肯松手，先把走廊清出来。'
  - id: ch02.outro.bob
    speaker: 鲍勃
    default: '封锁舰的牵引束扫过货舱，逃生窗只剩一条绿色通道。'
    pilots:
      alice: '绿色通道会被碎片切断，护着货船穿过去。'
      bob: '牵引束每次扫过都缩短通道，剩余窗口不足二十秒。'
      charlie: '最慢的货船还没转正，我去把它推到通道中线。'
  - id: ch02.outro.charlie
    speaker: 查理
    default: '最后一艘货船越过跳跃窗，家属频道里的哭声停了。'
    pilots:
      alice: '频道安静下来不代表安全，确认每艘船都离开锁定区。'
      bob: '跳跃窗读数归零，最后一艘货船已脱离牵引范围。'
      charlie: '他们终于不用对着静音频道喊名字了。'
  - id: interlude.rust
    speaker: 维修记录
    default: '锈水从通风管滴到地面，滴痕一直通向封死的闸门。'
    pilots:
      alice: '滴痕没有被灰尘盖住，闸门后面的管路还在排水。'
      bob: '水样含有冷却剂，闸门后方应有仍在运转的设备。'
      charlie: '锈水流向门缝，下面有人还没放弃修这里。'
  - id: interlude.location
    speaker: 地图终端
    default: '旧矿井地图缺了一层，缺口正好落在坍塌区下方。'
    pilots:
      alice: '缺失楼层避开了所有公开路线，那里像被人刻意擦掉。'
      bob: '地图比例与地震数据不符，坍塌区下方还有一个空腔。'
      charlie: '矿工把那层从图上抹掉，大概是不想让人再下去。'
  - id: ch05.intro
    speaker: 船载扫描仪
    default: '封锁线正在合拢，塌方区外壁和旧矿井入口同时出现在雷达上。'
    pilots:
      alice: '封锁线堵住了正面航道，旧矿井入口是我们唯一能绕开的地方。'
      bob: '两条路线都在收缩：封锁线剩九十秒，外壁承压接近极限。'
      charlie: '雷达上那道矿井门还亮着，下面有人等着我们。'
  - id: ch05.mara
    speaker: 玛拉
    default: '姐姐，下面没有灯。妈妈说别跑，可是地板一直在动。'
    pilots:
      alice: '玛拉脚边的裂缝在扩大，先让她离开会下沉的地板。'
      bob: '震动频率正在升高，矿井支撑柱可能随时失效。'
      charlie: '她记得妈妈的话，先告诉她我们会牵着她走。'
  - id: ch05.choice.seal_gate
    speaker: 工程终端
    default: '封死矿井闸门能稳住支撑柱，但玛拉的母亲还在门外。'
    pilots:
      alice: '闸门落下能保住里面的人，可外面的人会被留在坍塌区。'
      bob: '支撑柱位移超限，封门是唯一能停止连锁坍塌的操作。'
      charlie: '她妈妈的定位灯就在门外，我不能假装没看见。'
  - id: ch05.choice.break_blockade
    speaker: 战术显示
    default: '冲破封锁线能带走矿井的人，但巡逻舰已把炮口转向撤离船。'
    pilots:
      alice: '炮口对着撤离船，我们冲过去才能替他们挡住第一轮火力。'
      bob: '巡逻舰转炮需要四秒，最大推力可以在它开火前越过缺口。'
      charlie: '撤离船的灯排成一线，不能让它们在这里被困住。'
  - id: ch05.choice.deep_rock
    speaker: 工程终端
    default: '打穿塌方区外壁。我能把通风系统改成单向过滤，但我们会错过封锁线的最后窗口。'
    pilots:
      alice: '外壁后面有被困者的热源，错过窗口也要把他们带出来。'
      bob: '单向过滤能挡住粉尘，但钻孔会耗尽最后一组推进剂。'
      charlie: '岩层后有求救敲击声，我不想把那声音留在黑里。'
  - id: ending.empire.intro
    speaker: 帝国巡逻队
    default: '闸门已经封死，封锁舰正在为撤离船标记安全航线。'
    pilots:
      alice: '闸门守住了矿井，先护送每艘撤离船离开火线。'
      bob: '安全航线已避开炮塔射界，按标记飞行能减少损失。'
      charlie: '门外的灯熄了，但船上的人至少还能回家。'
  - id: ending.empire.result
    speaker: 战报终端
    default: '封锁线恢复完整，矿井坍塌停止，失踪名单少了一页。'
    pilots:
      alice: '名单少了一页是因为我们守住了出口，不是因为命令干净。'
      bob: '地震曲线已平稳，封锁线和矿井都不再扩大损失。'
      charlie: '少掉的名字里有玛拉，她终于能再见到妈妈了。'
  - id: ending.rebel.intro
    speaker: 护航频道
    default: '封锁线被撕开一道口子，撤离船正从炮火间穿过。'
    pilots:
      alice: '缺口撑不了多久，我去压住追来的巡逻舰。'
      bob: '撤离船已进入缺口，敌舰炮塔还有一次齐射时间。'
      charlie: '每艘船都在朝外飞，别让最后一艘掉队。'
  - id: ending.rebel.result
    speaker: 护航频道
    default: '最后一艘撤离船越过封锁线，身后的矿井灯光留在烟里。'
    pilots:
      alice: '矿井灯光还在，说明里面的人也许还有机会。'
      bob: '所有撤离船的应答器都在封锁线外，航线任务完成。'
      charlie: '他们带着灯飞出去，里面的人不会被完全忘掉。'
  - id: ending.deep_rock.intro
    speaker: 工程终端
    default: '钻头穿透外壁，单向过滤启动，白色粉尘没有再涌进通道。'
    pilots:
      alice: '粉尘被挡在外面，立刻把通道里的人带到钻孔口。'
      bob: '过滤压差稳定，钻孔足够支撑一批人依次通过。'
      charlie: '他们从粉尘里伸出手，我们已经能把他们拉出来。'
  - id: ending.deep_rock.result
    speaker: 矿井频道
    default: '塌方区后的人全部通过钻孔，封锁线的最后窗口在身后关闭。'
    pilots:
      alice: '窗口关了，但被困的人一个不少地出来了。'
      bob: '封锁线闭合时间已过，钻孔通行人数与热源读数一致。'
      charlie: '最后一个人摸到光时，玛拉一直喊着妈妈。'
```
