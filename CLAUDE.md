# Claude Code 通知系统 - 项目指南

## 项目概述
为 Claude Code CLI 提供灵活的通知系统，从简单的声音提醒到丰富的系统通知，满足不同用户的需求。

## 产品定位演进
- **原始定位**：claude-code-sound-notifications - 专注于声音通知
- **新定位**：claude-code-notifications - 多模态通知系统
- **核心理念**：简单的需求用简单的方案，复杂的需求有高级选项

## 项目进展状态

### 已完成事项 ✅
1. **产品定位决策**：从单一声音通知扩展到多模态通知系统
2. **分层架构设计**：三层方案（极简/推荐/个性化）
3. **PR #1 回复**：感谢贡献者 @Biaoo，说明重构计划
4. **Issue #2 创建**：讨论项目范围扩展（2025-08-15）
5. **Issue #3 创建**：RFC - 三层架构设计（2025-08-15）
6. **项目重命名完成**：claude-code-notifications（2025-08-15）
7. **项目描述更新**：一站式解决方案定位（2025-08-15）

### 当前状态 🔄
- **等待社区反馈**：Issue #2 和 #3 需要收集意见（预计等待 3-7 天）
- **PR #1 状态**：等待架构确定后整合

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
- **实现**：Claude Code 内置 `terminal_bell`
- **配置**：`claude config set --global preferredNotifChannel terminal_bell`
- **特点**：一行命令，零配置

### Tier 2: Recommended（推荐）⭐ 默认
- **实现**：不同事件不同声音
- **配置**：预设的 hooks 配置
- **特点**：Glass（通知）+ Tink（完成）
- **注意**：不包含系统通知（避免过于频繁）

### Tier 3: Custom（定制）
- **实现**：自定义脚本
- **功能**：系统通知、Webhook、多渠道
- **特点**：完全可定制
- **适合**：有特殊需求的用户

## 开源协作最佳实践

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
