--- 框架配置
--- @module Framework Global FrameworkConfig
--- @copyright Lilith Games, Avatar Team
--- @author Yuancheng Zhang
local FrameworkConfig = {
    -- Debug模式
    DebugMode = true,
    -- 启动心跳
    HeartbeatStart = true,
    -- TODO: Data Scheme配置：解决底层对逻辑层的反向引用问题
    -- 服务器配置
    Server = {
        -- 心跳包间隔时间，单位：秒
        HeartbeatDelta = 1,
        -- 心跳阈值，单位：秒，范围定义如下：
        --          0s -> threshold_1   : connected
        -- threshold_1 -> threshold_2   : disconnected, but player can reconnect
        -- threshold_2 -> longer        : disconnected, remove player
        HeartbeatThreshold1 = 9,
        HeartbeatThreshold2 = 10,
        -- 显示心跳日志
        ShowHeartbeatLog = false,
        -- 插件中需要使用声明周期的服务器模块目录
        PluginModules = {},
        -- 插件中服务器需要生成的CustomEvent, 模块中必须得有ServerEvents
        PluginEvents = {}
    },
    -- 客户端配置
    Client = {
        -- 心跳包间隔时间，单位：秒
        HeartbeatDelta = 1,
        -- 心跳阈值，单位：秒，范围定义如下：
        --          0s -> threshold_1   : connected
        -- threshold_1 -> threshold_2   : disconnected, weak network, can reconnect
        -- threshold_2 -> longer        : disconnected, quit server
        HeartbeatThreshold1 = 9,
        HeartbeatThreshold2 = 10,
        -- 显示心跳日志
        ShowHeartbeatLog = false,
        -- 插件中需要使用声明周期的客户端模块目录
        PluginModules = {},
        -- 插件中客户端需要生成的CustomEvent，模块中必须得有ClientEvents
        PluginEvents = {}
    }
}

return FrameworkConfig
