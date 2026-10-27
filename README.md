# Rally 3D HD — HTML5 Port

🎮 **Live Demo / 在线游玩**: [https://ezeryoung.github.io/RallyCar/](https://ezeryoung.github.io/RallyCar/)

经典 J2ME 拉力赛《Rally 3D HD》的 HTML5 玩法复刻版。

## 特性

- **12 条赛段**：青翠山林 / 沙尘满天 / 山路崎岖 / 狭关隘道 / 层峦叠嶂 / 冰冷雪山 / 夜路漫漫 / 干燥沙漠 / 青山绿野 / 大漠沙丘 / 寒冷森林 / 绿色草原
- **原版数据还原**：逐节赛道几何、金银铜奖牌时间、按名次解锁（铜开下一条，4 铜 / 6 银 / 12 金解锁车型）
- **滚动地形**：连续上下坡与越野起伏，急弯选择性锐化
- **4 款车型**：经典红车、Azure racer、Fast racer、Good oldie
- **6 语言**：中文 / English / 日本語 / Français / Deutsch / Español，热切换并持久化
- **暂停、存档导入导出、触屏操作**
- 单文件部署，零外部依赖，双击 `index.html` 即可离线游玩

## 操作

| 按键 | 功能 |
| --- | --- |
| ↑ | 油门 |
| ↓ | 刹车 |
| ← → | 转向 |
| Shift | 漂移蓄能 |
| Ctrl | 加速 |
| 空格 | 手刹 |
| P / Esc | 暂停 |
| R | 重来 |

触屏设备自动显示左右转向、漂移、刹车、加速按钮。

## 部署

本仓库通过 GitHub Actions 自动部署（`.github/workflows/deploy-pages.yml`）：
推送到 `main` 后自动将 `web/` 打包为 Pages 站点并发布，无需 `gh-pages` 分支。

## 许可

原版游戏版权归其原作者所有。本项目为个人学习用途的 HTML5 玩法复刻，不包含原版游戏的可执行代码。
