# Claude Code 通知系统 - 项目指南

## 项目概述
🔔 **Never miss Claude's response!** Notification solutions for Claude Code - from terminal bells to desktop alerts.

为 Claude Code CLI 提供多种通知解决方案，从简单的终端提示音到桌面通知，让用户在其他窗口工作时也不会错过 Claude 的响应。

## 产品定位演进
- **原始定位**：claude-code-sound-notifications - 专注于声音通知
- **新定位**：claude-code-notifications - 通知解决方案集合
- **核心理念**：提供三层解决方案，用户按需选择复杂度

## 项目进展状态

### 已完成事项 ✅
1. **产品定位决策**：从单一声音通知扩展到多模态通知系统
2. **分层架构设计**：三层方案（Minimal/Recommended/Custom）
3. **PR #1 回复**：感谢贡献者 @Biaoo，说明重构计划，提供整合选项
4. **Issue #2 创建**：讨论项目范围扩展（2025-08-15）
5. **Issue #3 创建**：RFC - 三层架构设计（2025-08-15）
6. **Issue #4 创建**：统一安装脚本设计（2025-08-16）
7. **项目重命名完成**：claude-code-notifications（2025-08-15）
8. **项目描述更新**：Notification solutions 定位（2025-08-16）
9. **目录结构实施**：recommended/ 和 custom/ 目录（2025-08-16）
10. **安装脚本实现**：install.sh 支持交互式和CLI模式（2025-08-16）
11. **版本发布**：v0.1.0 到 v0.4.0，遵循 semver 规范（2025-08-16）

### 当前状态 🔄
- **核心功能完成**：三层架构和安装脚本已实施
- **PR #1 状态**：已提供整合选项，等待作者回应
- **社区反馈**：Issue #2, #3, #4 开放讨论中
- **桌面通知优化完成**：实现交互式安装引导，确保 macOS Sequoia 兼容性（2025-08-16）

### 已确定决策 ✅

1. **三层方案命名**：Minimal / Recommended / Custom
   - Minimal：极简主义设计哲学
   - Recommended：主观推荐，适合80%用户
   - Custom：定制化，无高低之分

2. **默认层级**：Recommended
   - 平衡的解决方案
   - 开箱即用

3. **目录结构**：
   ```
   ├── README.md                    # 包含 Minimal 设置
   ├── install.sh                  # 统一安装脚本
   ├── recommended/                # 推荐配置
   │   ├── recommended.macos.json
   │   ├── recommended.linux.json
   │   └── recommended.windows.json
   └── custom/                     # 自定义示例
       └── system-notify.macos.sh
   ```

4. **功能分配**：
   - 系统通知仅在 Custom 层（避免过于频繁）
   - Recommended 层只有不同声音

### 待实施事项 ⏳

#### 第二阶段：架构实施
1. **创建目录结构**
   - 实施确定的目录设计

5. **标准方案实现**
   - 跨平台通知脚本
   - 两种不同声音（info/success）

#### 第三阶段：功能整合
6. **PR #1 功能整合**
   - 提取系统通知功能
   - 放入个性化层级
   - 修复安全问题

7. **README 重构**
   - 体现新的三层结构
   - 保持快速上手体验

#### 第四阶段：发布
8. **v2.0.0 发布**
   - 编写迁移指南
   - 确保向后兼容

## 三层架构草案

### Tier 1: Minimal（极简）
- **核心价值**：Built into Claude Code（内置支持）
- **实现**：Claude Code 内置 `terminal_bell`
- **配置**：`claude config set --global preferredNotifChannel terminal_bell`
- **特点**：5秒设置，零依赖

### Tier 2: Recommended（推荐）⭐ 默认
- **核心价值**：Author's daily choice（作者日常使用）
- **实现**：精选的事件声音映射
- **配置**：预设的 hooks 配置
- **特点**：仅2个关键事件，无通知疲劳
- **声音**：Glass（需要输入）+ Tink（任务完成）

### Tier 3: Custom（定制）
- **核心价值**：Desktop notifications & more（桌面通知等高级功能）
- **实现**：自定义脚本
- **功能**：桌面通知、推送通知、Webhook、多渠道
- **特点**：完全灵活可定制
- **适合**：需要视觉提醒的用户

## 开源协作最佳实践

### 工作流程
1. **充分讨论**：先与维护者讨论，不要急于实现
2. **记录决策**：将关键问题与结论更新到 Issues
3. **原子提交**：每个功能独立提交，便于追踪
4. **测试验证**：本地测试通过后再提交
5. **版本发布**：遵循 semver 规范记录改进

### 透明的决策过程
1. **原子化推进**：每个决策都是独立的讨论和提交
2. **公开讨论**：在 Issue 或 PR 评论中讨论关键决策
3. **渐进式改进**：小步快跑，每次改动可验证

### 具体执行流程
```
1. 创建 Issue：讨论项目重命名 → 社区反馈
2. 原子 Commit：更新项目名称
3. 创建 Issue：讨论三层架构设计 → 达成共识
4. 原子 Commit：创建新目录结构
5. 创建 Draft PR：实现标准方案
6. 迭代改进：根据反馈优化
7. 最终合并：确认效果后合并
```

### Git Commit 规范
- **引用 Issue**：在 commit message 中使用 `#2` 格式自动关联
- **关闭 Issue**：使用 `fixes #2` 或 `closes #2` 自动关闭
- **部分实现**：使用 `ref #2` 或 `see #2` 仅关联不关闭

示例：
```bash
git commit -m "feat: implement project rename (#2)

- Update repository name to claude-code-notifications
- Reflect one-stop solution positioning
- Update documentation

ref #2"
```

### PR 评论模板
```markdown
## 背景
[为什么需要这个改动]

## 方案设计
[具体的技术方案]

## 影响范围
- [ ] 向后兼容性
- [ ] 文档更新
- [ ] 测试覆盖

## 讨论要点
1. [需要社区反馈的点]
2. [可能的替代方案]
```

## 开发规范

### 代码风格

- **注释**：关键逻辑必须注释
- **错误处理**：所有脚本需要优雅降级

### 测试要求

- macOS / Linux / Windows 三平台测试
- 无音频设备环境测试
- 权限受限环境测试

### 文档要求

- 每个功能都有示例
- 常见问题解答（FAQ）
- 故障排查指南

## 重要原则

- **简约但不简陋**：默认方案必须优雅且开箱即用
- **渐进式增强**：从最简单开始，按需增加复杂度
- **用户可控**：所有通知都可以关闭或自定义
- **零侵入**：失败不影响 Claude Code 核心功能

## 项目记忆更新策略

- 每次 Todo 变更时更新此文件
- 关键设计决策记录在此
- 保持上下文连续性，减少依赖聊天历史
