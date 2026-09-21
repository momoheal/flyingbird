# 对话数据源

```yaml
dialogues:
  - id: prologue.01
    speaker: 任务回放
    default: "赵利俄斯护航战回放：一艘载有三百二十七人的难民运输艇被跃迁潮推向恒星。"
    pilots:
      alice: "那艘船里有三百二十七个人。我不接受放弃护航目标的建议。"
      bob: "反应炉过热、潮汐失稳、返航窗不存在。三个结论都需要重新计算。"
      charlie: "她又抱住一艘快散架的船。行吧，我替她挡住后面的炮火。"
  - id: prologue.02
    speaker: 任务回放
    default: "Charlie 的装甲挡开追击炮火；Alice 用牵引索拖住失速战机；Bob 正在重写跃迁引导。"
    pilots:
      alice: "查理的引擎坏了。我先把他拖出乱流，运输艇的救生舱还在前面。"
      bob: "归航窗只有六秒。Alice 向右偏十二度；Charlie 不要挣扎。"
      charlie: "我让你们先走，不是让你们回来把我也拖进潮汐里。"
  - id: prologue.03
    speaker: 任务回放
    default: "三人穿过六秒跃迁窗。Bob 的神经接口因超载开始接管肌肉稳定，他们随后被编入裁决者小队。"
    pilots:
      alice: "我们以为裁决是结束战争。现在想想，那时候我们什么都没看清。"
      bob: "接口接管记录已保存。自主意志状态：无法确认。"
      charlie: "能活着回来就先别急着给战争起好听的名字。"
  - id: ch01.deploy
    speaker: 指挥频道
    default: "战机已离港。穿过 A 区小行星带，恢复第三防线航道。"
    pilots:
      alice: "A 区的民用频道还在求救。清理航线前，别把所有信号都当成敌人。"
      bob: "收到。先建立威胁模型；未经验证的标签不进入射击优先级。"
      charlie: "旧拆船场的航标会骗人。跟着我标的安全线走。"
  - id: ch01.pilot_status
    speaker: 驾驶员状态
    default: "裁决者小队，驾驶员身份确认。A 区第三防线正在失去通讯。"
    pilots:
      alice: "边境出生，帝国精英飞行员。你仍相信保护平民是军人的职责。"
      bob: "神经链接实验体。先验证数据，再相信命令。"
      charlie: "旧边境战争老兵。你认得 A 区的救援编号。"
  - id: ch01.mission_brief
    speaker: 指挥频道
    default: "任务一：恢复 A 区第三防线航道。任务二：回收失联补给船军用物资。任务三：关闭未经授权的民用通讯。"
  - id: ch01.distress_signal
    speaker: 民用频道
    default: "这里是七号补给船……没有武器……请不要按帝国识别码开火……"
  - id: ch01.rescue_scan
    speaker: 扫描系统
    default: "救生舱为空。发现三套儿童呼吸面罩；舱门从外部强制关闭，时间早于叛军出现。"
    pilots:
      alice: "空舱不等于没人在里面活过。谁把孩子们的门焊死了？"
      bob: "人为封闭置信度百分之七十九。现有命令与现场时间戳冲突。"
      charlie: "这门是从外面焊的。我见过有人用这种办法让撤离船安静下来。"
  - id: ch01.rescue_order
    speaker: 指挥频道
    default: "忽略民用噪声。救生舱标记为叛军诱饵，立即摧毁。"
    pilots:
      alice: "我不会朝一艘空救生舱开火。它留下的东西已经够说明问题。"
      bob: "摧毁指令缺少可验证依据。记录为待复核，不执行。"
      charlie: "诱饵也许是真的，但我不想再替一句标签把救援船炸掉。"
  - id: ch01.boss_intro
    speaker: 叛军指挥官
    default: "缝合航母拒绝帝国识别协议。它的舰身由救援舰、矿船和旧军舰拼成，逃生舱正躲在它后方。"
    pilots:
      alice: "你在掩护逃生舱，也在朝我们开火。放他们走，我们就别再把谁逼进死路。"
      bob: "民用舰体与武器平台混合。攻击意图成立，保护行为也成立。"
      charlie: "我认得那副救援舰龙骨。你把人带在身后，就别把他们当炮火的借口。"
  - id: ch01.debrief
    speaker: 指挥频道
    default: "战报记录：缝合航母曾试图撞击民用设施。航迹回放显示其三次侧向转舵，全部将碎石引离逃生舱。"
    pilots:
      alice: "战报说它撞向逃生舱……可我亲眼看见它把碎石挡开。"
      bob: "航迹与战报冲突：航母三次改变航向，全部朝向逃生舱。记录已复制。"
      charlie: "那艘船不是在撞人。它是在替逃生舱挨炮。"
  - id: ch02.quartermaster.armor
    speaker: 军需官
    default: "左舷装甲擦痕全部朝外。缝合航母是在替逃生舱挡碎石，不是在撞它们。"
  - id: ch02.quartermaster.manifest
    speaker: 军需官
    default: "残骸导航缓存指向同一支转运队：名义运矿，航线却通向 B 区检疫井。货单被改过。"
  - id: ch02.rescue_float
    speaker: 护航频道
    default: "失控穿梭艇正在下坠。它发出的民用救援浮标接入了船队家属频道，而不是军方。"
  - id: ch02.scan.1
    speaker: 扫描官
    default: "扫描一：矿物舱没有矿物，货单原始标签为紧急转运。"
    pilots:
      alice: "又一份被盖住的名单。里面的人不是货物。"
      bob: "原始货单与覆盖记录不一致；篡改源来自帝国后勤节点。"
      charlie: "矿船不会把紧急转运四个字藏两层。有人怕我们看见。"
  - id: ch02.scan.2
    speaker: 扫描官
    default: "扫描二：船体内有大量生命热源，数量远超船员编制。"
    pilots:
      alice: "一万八千多个热源。他们把人塞进铁罐里，然后叫它转运。"
      bob: "生命信号十八万六千四十二。结论：货船登记信息无效。"
      charlie: "这么多呼吸挤在一艘船里，谁还敢说只是一次例行检查？"
  - id: ch02.scan.3
    speaker: 扫描官
    default: "扫描三：民用身份码被整批删除；逃生门从内部锁死。检疫井不是避难所。"
    pilots:
      alice: "他们先抹掉名字，再把门从里面锁上。"
      bob: "身份删除、内部锁门、异常热源形成完整净化链。证据阈值已满足。"
      charlie: "我听过这种门后的倒计时。别让它再响一次。"
  - id: ch02.outro.alice
    speaker: Alice
    default: "货单、生命读数和注销名单已写入离线黑匣。"
    pilots:
      alice: "我救不了所有人，但这份名单不能再被他们改成一串噪声。"
      bob: "黑匣副本完成。现在的结论不只靠感觉，也不只靠命令。"
      charlie: "把副本留三份。门要是再关上，至少有人能从另一边把它打开。"
  - id: ch02.outro.bob
    speaker: Bob
    default: "货单、生命读数和注销名单已写入离线黑匣。"
    pilots:
      alice: "我救不了所有人，但这份名单不能再被他们改成一串噪声。"
      bob: "黑匣副本完成。现在的结论不只靠感觉，也不只靠命令。"
      charlie: "把副本留三份。门要是再关上，至少有人能从另一边把它打开。"
  - id: ch02.outro.charlie
    speaker: Charlie
    default: "货单、生命读数和注销名单已写入离线黑匣。"
    pilots:
      alice: "我救不了所有人，但这份名单不能再被他们改成一串噪声。"
      bob: "黑匣副本完成。现在的结论不只靠感觉，也不只靠命令。"
      charlie: "把副本留三份。门要是再关上，至少有人能从另一边把它打开。"
  - id: interlude.rust
    speaker: 离线黑匣
    default: "锈蚀症并非谣言：它会沿纳米修补材料和神经接口扩散。帝国正在借风险扩大净化名单；余烬也在把难民船当作战争工具。"
    pilots:
      alice: "病是真的，不代表谁都能拿它给人判死刑。"
      bob: "风险存在；名单仍被伪造。这两个结论必须同时保留。"
      charlie: "封锁能救人，也能把人饿死。别拿其中一半当全部答案。"
  - id: interlude.location
    speaker: Bob
    default: "Bob 的协处理器尝试越权发送位置包。Alice 同时收到第 09 隔离关口的塌方求救。"
    pilots:
      alice: "有人正在把我们的位置交出去。第 09 关口也在求救，下面还有孩子。"
      bob: "未授权位置包已阻断。第 09 关口的结构完整度持续下降。"
      charlie: "两边都知道我们会去救人。那就别让任何一边替我们决定救谁。"
  - id: ch05.intro
    speaker: 避难所频道
    default: "第 09 隔离关口告警：帝国即将永久封门，余烬爆破船正在接近，避难所底层发生塌方。"
    pilots:
      alice: "先把求救信号稳住。下面有人，我们不能只在门外讨论他们。"
      bob: "三项风险同时升级：永久隔离、锈蚀扩散、结构坍塌。没有零伤亡解。"
      charlie: "先把撤离余量算清。谁说只要炸门或关门就能解决，谁就是在骗自己。"
  - id: ch05.mara
    speaker: 避难所频道
    default: "姐姐，下面没有灯。妈妈说别跑，可是地板一直在动。"
    pilots:
      alice: "玛拉，听着我。找到蓝色指示灯，扶着墙走，不要一个人跑。"
      bob: "玛拉，数到十，等震动变小再移动。我们正在给你开一条安全信号。"
      charlie: "小姑娘，别听外面的爆炸。看见蓝灯就停一下，救援队会去找你。"
  - id: ch05.choice.seal_gate
    speaker: Charlie
    default: "掩护医疗通道，阻止爆破船。我们能让一部分人通过，但门内其余人会被永久隔离。"
    pilots:
      alice: "我守住医疗门，但我会记住那道门关在谁身后。"
      bob: "封控路径启动。医疗通道容量不足，代价已写入风险记录。"
      charlie: "守住门，不等于说这道门是对的。医疗船还在里面。"
  - id: ch05.choice.break_blockade
    speaker: 余烬频道
    default: "破坏牵引束，为船队打开窗口。锈蚀可能进入主航道，余烬的突击艇仍在拿民船作掩护。"
    pilots:
      alice: "我打开航线，但不替任何人把民船当盾牌。"
      bob: "牵引锁可解除；传播模型会恶化。公开这个风险，不让任何人假装没看见。"
      charlie: "冲出去可以，民船得先走。拿平民挡炮的人和封门的人没什么两样。"
  - id: ch05.choice.deep_rock
    speaker: Bob
    default: "打穿塌方区外壁。我能把通风系统改成单向过滤，但我们会错过封锁线的最后窗口。"
    pilots:
      alice: "先让玛拉和塌方区的人看见灯。剩下的账，我们慢慢还。"
      bob: "建立临时隔离舱。资源不足，无法完全阻止封门或冲关。"
      charlie: "这不是赢法，只是我们决定留在塌方的人身边。护盾我来撑。"
  - id: ending.empire.intro
    speaker: 帝国医疗频道
    default: "医疗补给线仍在门外。摧毁爆破船武器节点，阻止它们冲向永久门。"
  - id: ending.empire.result
    speaker: 结果记录
    default: "安静的胜利：医疗通道保住了，永久门也合上。勋章亮在 Alice 手里，门内只剩玛拉频道被切断后的白噪。秩序维持了，它的代价没有消失。"
  - id: ending.rebel.intro
    speaker: 船队频道
    default: "解除三道牵引锁，维持难民船完整度。避开民船，余烬狂热派正在试图借它们突击。"
  - id: ending.rebel.result
    speaker: 结果记录
    default: "名字的重量：船队穿过了窗口，被注销的名单得以带走。感染风险和余烬的狂热仍未消失；自由不是免于责任，而是不能再把责任藏在别人身上。"
  - id: ending.deep_rock.intro
    speaker: 工程频道
    default: "守住临时过滤舱，回收三枚过滤核心，并将黑匣证据上传公共广播。"
  - id: ending.deep_rock.result
    speaker: 结果记录
    default: "深岩之下：工人、医生和工程师接过了临时隔离舱。局部隔绝、减毒改造和公开复核都很慢，也都需要继续承担。这里不是完美结局，只是一条没有走开的路。"
```
