# 星火燎原 / Flyingbird Prototype

当前仓库是《星火燎原》第一章 HTML 玩法原型与内容/素材准备区。

## 当前入口

- 可玩原型：[prototype/fb.html](D:/codexprojects/flyingbird/prototype/fb.html)
- 第一章素材：[assets/ch01](D:/codexprojects/flyingbird/assets/ch01)
- 产品与架构文档：[docs](D:/codexprojects/flyingbird/docs)

## 运行方式

启动本地 HTTP 服务：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\serve_prototype.ps1
```

在浏览器打开 [http://localhost:8080/prototype/fb.html](http://localhost:8080/prototype/fb.html)。原型通过 `fetch` 加载 `docs/dialogue-story.md`，因此必须经由此 HTTP 服务运行；不要通过 `file://` 直接打开 `prototype/fb.html`。

## 检查

运行 PowerShell 检查脚本：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1
```

检查内容：

- `prototype/fb.html` 内联脚本语法
- `docs/dialogue-story.md` 对话 YAML 围栏、ID 唯一性和必需记录
- 请求时重新生成第一章 12 个核心素材；验证 19 个运行时素材的文件、尺寸和透明通道

重新生成第一章程序化素材：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools\run_checks.ps1 -RegenerateAssets
```

## 目录说明

```text
prototype/              HTML 可玩原型
assets/                 运行时可直接使用的素材
assets/ch01/_previews/  素材预览图，不作为游戏运行素材
art_source/legacy/      旧素材或来源参考
docs/                   需求、架构、剧情、素材和 worklog
tools/                  生成、校验和项目检查脚本
```

## 注意

- 后续每次修改需要写入 [docs/worklog.md](D:/codexprojects/flyingbird/docs/worklog.md)。
- 不要在 PowerShell 中使用 Bash heredoc 写法，例如 `python - <<PY`。
- 当前 HTML 原型仍包含大量内联代码；正式 iOS 版本应按架构文档迁移到 `SwiftUI + SpriteKit`。
