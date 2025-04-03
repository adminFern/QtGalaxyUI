import QtQuick
import "../Controls"
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello ccc")
    property int name: 30
    Row{
        padding: 5
        spacing: 6
        QIcon{
            icosource: FluentIcons.q_VPN
        }
        QComboBox{
            id:bobox
            model: [
                { text: "设置", icon: FluentIcons.q_Settings },
                { text: "帮助", icon: FluentIcons.q_Help },
                { text: "退出", icon: FluentIcons.q_PowerButton },
                { text: "首页", icon: FluentIcons.q_Home },
                { text: "搜索", icon: FluentIcons.q_Search },
                { text: "下载", icon: FluentIcons.q_Download },
                { text: "上传", icon: FluentIcons.q_Upload },
                { text: "收藏", icon: FluentIcons.q_Favorite },
                { text: "历史", icon: FluentIcons.q_History },
                { text: "打印", icon: FluentIcons.q_Print },
                { text: "分享", icon: FluentIcons.q_Share },
                { text: "编辑", icon: FluentIcons.q_Edit },
                { text: "删除", icon: FluentIcons.q_Delete },
                { text: "添加", icon: FluentIcons.q_Add },
                { text: "保存", icon: FluentIcons.q_Save },
                { text: "刷新", icon: FluentIcons.q_Refresh },
                { text: "信息", icon: FluentIcons.q_Info },
                { text: "警告", icon: FluentIcons.q_Warning },
                { text: "错误", icon: FluentIcons.q_Error },
                { text: "成功", icon: FluentIcons.q_Completed },
                { text: "用户", icon: FluentIcons.q_Person },
                { text: "群组", icon: FluentIcons.q_People },
                { text: "邮件", icon: FluentIcons.q_Mail },
                { text: "日历", icon: FluentIcons.q_Calendar },
                { text: "任务", icon: FluentIcons.q_Task },
                { text: "文档", icon: FluentIcons.q_Document },
                { text: "图片", icon: FluentIcons.q_Photo },
                { text: "视频", icon: FluentIcons.q_Video },
                { text: "音乐", icon: FluentIcons.q_Music },
                { text: "文件夹", icon: FluentIcons.q_Folder },
                { text: "锁", icon: FluentIcons.q_Lock },
                { text: "解锁", icon: FluentIcons.q_Unlock },
                { text: "眼睛", icon: FluentIcons.q_View },
                { text: "隐藏", icon: FluentIcons.q_Hide },
                { text: "放大", icon: FluentIcons.q_ZoomIn },
                { text: "缩小", icon: FluentIcons.q_ZoomOut },
                { text: "全屏", icon: FluentIcons.q_FullScreen },
                { text: "退出全屏", icon: FluentIcons.q_ExitFullScreen },
                { text: "剪切", icon: FluentIcons.q_Cut },
                { text: "复制", icon: FluentIcons.q_Copy },
                { text: "粘贴", icon: FluentIcons.q_Paste },
                { text: "撤销", icon: FluentIcons.q_Undo },
                { text: "重做", icon: FluentIcons.q_Redo },
                { text: "排序", icon: FluentIcons.q_Sort },
                { text: "筛选", icon: FluentIcons.q_Filter },
                { text: "网格", icon: FluentIcons.q_Grid },
                { text: "列表", icon: FluentIcons.q_List },
                { text: "布局", icon: FluentIcons.q_Layout },
                { text: "主题", icon: FluentIcons.q_Theme },
                { text: "亮度", icon: FluentIcons.q_Brightness },
                { text: "通知", icon: FluentIcons.q_Notification },
                { text: "聊天", icon: FluentIcons.q_Chat },
                { text: "电话", icon: FluentIcons.q_Phone },
                { text: "相机", icon: FluentIcons.q_Camera },
                { text: "麦克风", icon: FluentIcons.q_Microphone },
                { text: "耳机", icon: FluentIcons.q_Headset },
                { text: "位置", icon: FluentIcons.q_Location },
                { text: "地图", icon: FluentIcons.q_Map },
                { text: "导航", icon: FluentIcons.q_Navigation },
                { text: "汽车", icon: FluentIcons.q_Car },
                { text: "飞机", icon: FluentIcons.q_Airplane },
                { text: "火车", icon: FluentIcons.q_Train },
                { text: "轮船", icon: FluentIcons.q_Ship },
                { text: "自行车", icon: FluentIcons.q_Bicycle },
                { text: "步行", icon: FluentIcons.q_Walk },
                { text: "跑步", icon: FluentIcons.q_Run },
                { text: "健身", icon: FluentIcons.q_Fitness },
                { text: "医疗", icon: FluentIcons.q_Medical },
                { text: "医院", icon: FluentIcons.q_Hospital },
                { text: "药店", icon: FluentIcons.q_Pharmacy },
                { text: "购物车", icon: FluentIcons.q_ShoppingCart },
                { text: "钱包", icon: FluentIcons.q_Wallet },
                { text: "信用卡", icon: FluentIcons.q_CreditCard },
                { text: "支付", icon: FluentIcons.q_Payment },
                { text: "礼物", icon: FluentIcons.q_Gift },
                { text: "标签", icon: FluentIcons.q_Tag },
                { text: "价格", icon: FluentIcons.q_Price },
                { text: "折扣", icon: FluentIcons.q_Discount },
                { text: "统计", icon: FluentIcons.q_Statistics },
                { text: "图表", icon: FluentIcons.q_Chart },
                { text: "仪表盘", icon: FluentIcons.q_Dashboard },
                { text: "数据库", icon: FluentIcons.q_Database },
                { text: "服务器", icon: FluentIcons.q_Server },
                { text: "网络", icon: FluentIcons.q_Network },
                { text: "云", icon: FluentIcons.q_Cloud },
                { text: "下载云", icon: FluentIcons.q_CloudDownload },
                { text: "上传云", icon: FluentIcons.q_CloudUpload },
                { text: "同步", icon: FluentIcons.q_Sync },
                { text: "连接", icon: FluentIcons.q_Connect },
                { text: "断开", icon: FluentIcons.q_Disconnect },
                { text: "电池", icon: FluentIcons.q_Battery },
                { text: "充电", icon: FluentIcons.q_Charging },
                { text: "电源", icon: FluentIcons.q_Power },
                { text: "信号", icon: FluentIcons.q_Signal },
                { text: "WIFI", icon: FluentIcons.q_Wifi },
                { text: "蓝牙", icon: FluentIcons.q_Bluetooth },
                { text: "NFC", icon: FluentIcons.q_NFC },
                { text: "USB", icon: FluentIcons.q_USB },
                { text: "HDMI", icon: FluentIcons.q_HDMI },
                { text: "设置2", icon: FluentIcons.q_Settings },
                { text: "帮助2", icon: FluentIcons.q_Help },
                { text: "退出2", icon: FluentIcons.q_PowerButton }
            ]
        }


    }
    // 随机数据生成函数
    function generateRandomData() {
        const countries = ["中国", "美国", "日本", "德国", "法国", "英国", "意大利", "加拿大", "澳大利亚", "巴西",
                           "俄罗斯", "印度", "韩国", "西班牙", "墨西哥", "阿根廷", "南非", "埃及", "瑞典", "挪威"];

        const animals = ["狮子", "老虎", "大象", "长颈鹿", "熊猫", "斑马", "犀牛", "河马", "猎豹", "袋鼠",
                         "考拉", "企鹅", "海豚", "鲸鱼", "鲨鱼", "老鹰", "孔雀", "鹦鹉", "变色龙", "蟒蛇"];

        const phrases = ["早上好", "今天天气真好", "你吃饭了吗", "周末愉快", "新年快乐",
                         "工作顺利", "学习进步", "身体健康", "万事如意", "心想事成",
                         "恭喜发财", "步步高升", "一帆风顺", "出入平安", "阖家欢乐"];

        const items = ["笔记本电脑", "智能手机", "电视机", "电冰箱", "洗衣机",
                       "空调", "微波炉", "咖啡机", "电动牙刷", "吹风机",
                       "台灯", "书架", "沙发", "餐桌", "衣柜"];

        const plants = ["玫瑰花", "向日葵", "仙人掌", "郁金香", "百合花",
                        "康乃馨", "茉莉花", "牡丹", "菊花", "梅花",
                        "橡树", "松树", "柳树", "银杏", "竹子"];

        let data = [];
        const categories = [countries, animals, phrases, items, plants];

        // 生成1万条随机数据
        for (let i = 0; i < name; i++) {
            // 随机选择一个类别
            const category = categories[Math.floor(Math.random() * categories.length)];
            // 随机选择该类别的条目
            let item = category[Math.floor(Math.random() * category.length)];

            // 确保文本长度大于5个字符（中文每个字符算1个长度）
            // 如果不够长，添加随机后缀
            if (item.length <= 5) {
                const suffixes = ["特别版", "高级版", "限量版", "豪华版", "专业版", "经典款", "2023款"];
                item += suffixes[Math.floor(Math.random() * suffixes.length)];
            }

            // 添加序号前缀
            data.push(`${i+1}. ${item}`);
        }

        return data;
    }

}
